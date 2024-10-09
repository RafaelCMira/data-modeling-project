package md.project.mySql;

import com.github.javafaker.Faker;
import md.project.mySql.models.*;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.stream.IntStream;


@Component
public class DataGenerator implements CommandLineRunner {

    private static final Faker faker = new Faker();

    final Date from = Date.from(LocalDateTime.now().minusYears(20).atZone(ZoneId.systemDefault()).toInstant());
    final Date to = Date.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant());

    @Value("${app.properties.constants.number_of_persons}")
    private int nPersons;

    @Value("${app.properties.constants.batchSize}")
    private int batchSize;

    @Value("${app.properties.path.my_sql_dir}")
    private String mySqlDir;

    @Value("${app.properties.path.countries}")
    private String countriesPath;

    @Value("${app.properties.path.districts}")
    private String districtsPath;

    @Value("${app.properties.path.cities}")
    private String citiesPath;

    @Override
    public void run(String... args) throws ExecutionException, InterruptedException, IOException {
        final int N_PERSONS = nPersons;
        final int N_POSTS = N_PERSONS * 10;
        final int N_COMMENTS = (int) (N_POSTS * 0.5);
        final int N_TAGS = 20;

        final int N_FOLLOWS = N_PERSONS * 5;
        final int N_POST_LIKES = (int) (N_POSTS * 0.5);
        final int N_COMMENT_LIKES = (int) (N_COMMENTS * 0.5);
        final int N_COMMENT_PARENTS = (int) (N_COMMENTS * 0.25);
        final int N_POST_TAGS = (int) (N_POSTS * 0.3);

        final var startTime = System.currentTimeMillis();

        ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();

        final City[] cities = readCitiesFromCsv();

        final int nCountries = numberOfCountries();

        final Future<Void> personsFuture = executor.submit(() -> {
            Person[] persons = generatePersons(N_PERSONS, cities, nCountries);
            writeToFile(persons, "person.csv");
            writeCities_District_Countries();
            return null;
        });

        final Future<Void> postsFuture = executor.submit(() -> {
            Post[] posts = generatePosts(N_POSTS, N_PERSONS);
            writeToFile(posts, "post.csv");
            return null;
        });

        final Future<Void> commentsFuture = executor.submit(() -> {
            Comment[] comments = generateComments(N_COMMENTS, N_POSTS, N_PERSONS);
            writeToFile(comments, "comment.csv");
            return null;
        });

        final Future<Void> tagsFuture = executor.submit(() -> {
            Tag[] tags = generateTags();
            writeToFile(tags, "tag.csv");
            return null;
        });

        final Future<Void> followsFuture = executor.submit(() -> {
            Follow[] follows = generateFollows(N_FOLLOWS, N_PERSONS);
            writeToFile(follows, "follow.csv");
            return null;
        });

        final Future<Void> postLikesFuture = executor.submit(() -> {
            PostLike[] postLikes = generatePostLikes(N_POST_LIKES, N_POSTS, N_PERSONS);
            writeToFile(postLikes, "post_like.csv");
            return null;
        });

        final Future<Void> commentLikesFuture = executor.submit(() -> {
            CommentLike[] commentLikes = generateCommentLikes(N_COMMENT_LIKES, N_COMMENTS, N_PERSONS);
            writeToFile(commentLikes, "comment_like.csv");
            return null;
        });

        final Future<Void> commentParentsFuture = executor.submit(() -> {
            CommentParent[] commentParents = generateCommentParents(N_COMMENT_PARENTS, N_COMMENTS);
            writeToFile(commentParents, "comment_parent.csv");
            return null;
        });

        final Future<Void> postTagsFuture = executor.submit(() -> {
            PostTag[] postTags = generatePostTags(N_POST_TAGS, N_POSTS, N_TAGS);
            writeToFile(postTags, "post_tag.csv");
            return null;
        });

        // Wait for all tasks to complete
        personsFuture.get();
        postsFuture.get();
        commentsFuture.get();
        tagsFuture.get();
        followsFuture.get();
        postLikesFuture.get();
        commentLikesFuture.get();
        commentParentsFuture.get();
        postTagsFuture.get();

        executor.shutdown();

        final var endTime = System.currentTimeMillis();
        var total_time = endTime - startTime;
        if (total_time < 1000) {
            System.out.println("Total time: " + total_time + " ms");
        } else if (total_time < 60000) {
            System.out.printf("Total time: %.3f s%n", total_time / 1000.0);
        } else {
            long minutes = (total_time / 60000);
            long seconds = (total_time % 60000) / 1000;
            System.out.printf("Total time: %02d:%02d m%n", minutes, seconds);
        }
    }

    private static int generateNumberWithProbability(final int moreProbability, final int max, final int min) {
        var random = faker.random();

        int weightRange = random.nextInt(100);

        if (weightRange < moreProbability) {
            return max / 2 + random.nextInt(max / 2 + 1);
        } else {
            return min + random.nextInt(max / 2 - 1);
        }
    }

    private static boolean liveInTheSameCountry(final int probability) {
        var random = faker.random();
        int weightRange = random.nextInt(100);
        return weightRange < probability;
    }

    private int numberOfCountries() throws IOException {
        Path path = Paths.get(countriesPath).toAbsolutePath();

        try (CSVParser parser = CSVParser.parse(path, java.nio.charset.StandardCharsets.UTF_8,
                CSVFormat.DEFAULT.withDelimiter('$').withFirstRecordAsHeader())
        ) {
            return parser.getRecords().size();
        }
    }

    private City[] readCitiesFromCsv() throws IOException {
        Path path = Paths.get(citiesPath).toAbsolutePath();

        try (CSVParser parser = CSVParser.parse(path, java.nio.charset.StandardCharsets.UTF_8,  
                CSVFormat.DEFAULT.withDelimiter('$').withFirstRecordAsHeader())
        ) {
            List<City> cities = parser.getRecords().stream()
                    .map(record -> new City(
                            record.get("city_name").trim(),
                            record.get("district_name").trim(),
                            Integer.parseInt(record.get("country_id").trim())
                    ))
                    .toList();

            return cities.toArray(new City[0]);
        }
    }

    private Person[] generatePersons(final int nPersons, final City[] cities, final int nCountries) {
        final Person[] persons = new Person[nPersons];

        final LocalDate fromDate = LocalDate.now().minusYears(90);
        final LocalDate toDate = LocalDate.now().minusYears(18);

        final java.sql.Date birth_from = java.sql.Date.valueOf(fromDate);
        final java.sql.Date birth_to = java.sql.Date.valueOf(toDate);

        IntStream.range(0, nPersons).parallel().forEach(i -> {
            final City city = cities[faker.number().numberBetween(0, cities.length)];

            final int born_country_id = liveInTheSameCountry(80) ? city.country_id() : faker.number().numberBetween(1, nCountries);

            final Person p = new Person(
                    i + 1,
                    faker.name().username() + i,
                    faker.name().firstName().replace("'", ""),
                    faker.name().lastName().replace("'", ""),
                    faker.internet().emailAddress() + i,
                    faker.internet().password(),
                    new java.sql.Date(faker.date().between(birth_from, birth_to).getTime()),
                    Timestamp.from(faker.date().between(from, to).toInstant()),
                    born_country_id,
                    city.city_name(),
                    city.district_name(),
                    city.country_id()
            );

            persons[i] = p;
        });

        return persons;
    }

    private Post[] generatePosts(final int nPosts, final int nPersons) {
        final Post[] posts = new Post[nPosts];

        IntStream.range(0, nPosts).parallel().forEach(i -> {
            final Post p = new Post(
                    i + 1,
                    faker.lorem().paragraph(),
                    Timestamp.from(faker.date().between(from, to).toInstant()),
                    faker.number().numberBetween(1, nPersons)
            );

            posts[i] = p;
        });

        return posts;
    }

    private Comment[] generateComments(final int nComments, final int nPosts, final int nPersons) {
        final Comment[] comments = new Comment[nComments];

        IntStream.range(0, nComments).parallel().forEach(i -> {
            final Comment c = new Comment(
                    i + 1,
                    faker.lorem().sentence(),
                    Timestamp.from(faker.date().between(from, to).toInstant()),
                    faker.number().numberBetween(1, nPersons),
                    faker.number().numberBetween(1, nPosts)
            );

            comments[i] = c;
        });

        return comments;
    }

    private Tag[] generateTags() {
        String[] tagNames = {"food", "travel", "music", "fashion", "fitness", "photography", "art", "technology", "sports", "books",
                "movies", "gaming", "nature", "animals", "cars", "architecture", "design", "education", "health", "beauty"};

        final Tag[] tags = new Tag[tagNames.length];

        for (int i = 0; i < tagNames.length; i++) {
            final Tag t = new Tag(i + 1, tagNames[i]);
            tags[i] = t;
        }

        return tags;
    }

    private Follow[] generateFollows(final int nFollows, final int nPersons) {
        final Follow[] follows = new Follow[nFollows];

        IntStream.range(0, nFollows).parallel().forEach(i -> {
            final int userId = faker.number().numberBetween(1, nPersons);

            int followerId = faker.number().numberBetween(1, nPersons);
            while (followerId == userId) {
                followerId = faker.number().numberBetween(1, nPersons);
            }

            final Follow f = new Follow(
                    userId,
                    followerId,
                    Timestamp.from(faker.date().between(from, to).toInstant())
            );

            follows[i] = f;
        });

        return follows;
    }

    private PostLike[] generatePostLikes(final int nPostLikes, final int nPosts, final int nPersons) {
        final PostLike[] postLikes = new PostLike[nPostLikes];

        IntStream.range(0, nPostLikes).parallel().forEach(i -> {
            final PostLike pl = new PostLike(
                    faker.number().numberBetween(1, nPosts),
                    faker.number().numberBetween(1, nPersons),
                    Timestamp.from(faker.date().between(from, to).toInstant())
            );

            postLikes[i] = pl;
        });

        return postLikes;
    }

    private CommentLike[] generateCommentLikes(final int nCommentLikes, final int nComments, final int nPersons) {
        final CommentLike[] commentLikes = new CommentLike[nCommentLikes];

        IntStream.range(0, nCommentLikes).parallel().forEach(i -> {
            final CommentLike cl = new CommentLike(
                    faker.number().numberBetween(1, nComments),
                    faker.number().numberBetween(1, nPersons),
                    Timestamp.from(faker.date().between(from, to).toInstant())
            );

            commentLikes[i] = cl;
        });

        return commentLikes;
    }

    private CommentParent[] generateCommentParents(final int nCommentParents, final int nComments) {
        final CommentParent[] commentParents = new CommentParent[nCommentParents];

        IntStream.range(0, nCommentParents).parallel().forEach(i -> {
            final CommentParent cp = new CommentParent(
                    faker.number().numberBetween(1, nComments),
                    faker.number().numberBetween(1, nComments)
            );

            commentParents[i] = cp;
        });

        return commentParents;
    }

    private PostTag[] generatePostTags(final int nPostTags, final int nPosts, final int nTags) {
        final PostTag[] postTags = new PostTag[nPostTags];

        IntStream.range(0, nPostTags).parallel().forEach(i -> {
            final PostTag pt = new PostTag(
                    faker.number().numberBetween(1, nPosts),
                    faker.number().numberBetween(1, nTags)
            );

            postTags[i] = pt;
        });

        return postTags;
    }


    private <T extends CsvConvertible> void writeToFile(T[] items, String filePath) throws IOException {
        Path path = Paths.get(mySqlDir, filePath);

        if (Files.notExists(path)) {
            Files.createFile(path);
            System.out.println("SQL file created: " + path.getFileName());
        } else {
            System.out.println("SQL file already exists. Contents will be appended.");
        }

        StringBuilder sb = new StringBuilder();

        try (BufferedWriter writer = Files.newBufferedWriter(path, StandardOpenOption.APPEND)) {
            int count = 0;

            sb.append(items[0].csvHeader()).append("\n");

            for (T item : items) {
                sb.append(item).append("\n");
                count++;

                if (count % batchSize == 0) {
                    writer.write(sb.toString());
                    sb.setLength(0); // Clear the StringBuilder
                }
            }

            // Write any remaining data
            if (sb.length() > 0) {
                writer.write(sb.toString());
            }
        }
    }

    private void writeCities_District_Countries() throws IOException {
        Path cities = Paths.get(mySqlDir, "cities.csv");
        Path districts = Paths.get(mySqlDir, "districts.csv");
        Path countries = Paths.get(mySqlDir, "countries.csv");

        if (Files.notExists(cities)) {
            Files.createFile(cities);
            System.out.println("File created: " + cities.getFileName());
        }

        if (Files.notExists(districts)) {
            Files.createFile(districts);
            System.out.println("File created: " + districts.getFileName());
        }

        if (Files.notExists(countries)) {
            Files.createFile(countries);
            System.out.println("File created: " + countries.getFileName());
        }
    }


}
