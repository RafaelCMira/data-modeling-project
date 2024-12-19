import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.lines as mlines

visible_experiments = [
    "default",
    "1GB",
    "2GB",
    "4GB",
    "8GB",
]

colors = {
    "default": "#287db7",
    "1GB": "#ff993f",
    "2GB": "#53b153",
    "4GB": "#976bbf",
    "8GB": "#d73031",
}


def get_file_path(user: str, dbms: str, dataset: str, file_name: str):
    if user not in ["rafael", "jose"]:
        raise ValueError(f"Invalid user '{user}'")

    if dbms not in ["postgres", "neo4j"]:
        raise ValueError(f"Invalid DBMS '{dbms}'")

    if dataset not in ["0.3", "1", "3"]:
        raise ValueError(f"Invalid dataset '{dataset}'")

    # Define the path to the samples directory
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    samples_dir = os.path.join(
        base_dir,
        "csv_results",
        user,
        dbms,
        f"dataset {dataset}",
        "samples for individual graphs",
    )

    # Define the file to process
    file_path = os.path.join(samples_dir, file_name)

    # Check if the file exists, if not return None
    if not os.path.exists(file_path):
        return None  # Return None instead of raising an exception

    return file_path


def generate_graph(
    file_name: str,
    dbms: str,
    dataset: str,
    user: str,
    yMin: int = None,
    yMax: int = None,
    yMinus: int = 0,
    units: str = "ms",
):
    # Get the file path
    file_path = get_file_path(user, dbms, dataset, file_name)

    # If the file path is None, do not proceed with graph generation
    if file_path is None:
        print(f"File '{file_name}' not found. Skipping graph generation.")
        return

    # Read the CSV file
    df = pd.read_csv(file_path)

    # Filter the dataframe based on visible experiments
    df_filtered = df[df["experiment"].isin(visible_experiments)]

    # Convert time based on units
    if units == "min":
        df_filtered["elapsed"] = df_filtered["elapsed"] / 60000  # Convert ms to minutes
        y_axis_label = "Response time (minutes)"
    elif units == "s":
        df_filtered["elapsed"] = df_filtered["elapsed"] / 1000  # Convert ms to seconds
        y_axis_label = "Response time (seconds)"
    else:
        y_axis_label = "Response time (ms)"  # Default to milliseconds

    # Define optional axis limits
    y_axis_min = yMin  # Set to None for auto-scaling
    y_axis_max = yMax  # Set to None for auto-scaling

    # Generate the graph
    plt.figure(figsize=(10, 6))  # se nao funcnonar bem usar 7,4

    for experiment in visible_experiments:
        experiment_df = df_filtered[df_filtered["experiment"] == experiment]

        x_axis = experiment_df["experiment_index"]
        y_axis = experiment_df["elapsed"]

        # Plot dots for each experiment
        plt.scatter(
            x_axis,
            y_axis,
            label=experiment,
            color=colors.get(experiment, "black"),
            marker="o",
        )

        # Connect dots in groups of 4
        for i in range(0, len(x_axis), 4):
            plt.plot(
                x_axis[i : i + 4],
                y_axis.iloc[i : i + 4],
                color=colors.get(experiment, "black"),
            )

    # Add a title and labels
    # plt.title(f"{file_name} - {dbms} - {dataset}")

    # Add axis labels
    plt.xlabel("Experiments")
    plt.ylabel(y_axis_label)

    global_avg = df_filtered["elapsed"].mean()
    global_p99 = df_filtered["elapsed"].quantile(0.99)
    global_p95 = df_filtered["elapsed"].quantile(0.95)

    # Config para 190 no eixo Y
    # text_y = y_axis_max - 35

    # Config para 3500 no eixo Y
    text_x = 14.4
    text_y = 0
    if y_axis_max is None:
        text_y = df["elapsed"].max()
    else:
        text_y = y_axis_max - yMinus

    avg_string = ""
    p95_string = ""

    if len(str(int(global_avg))) < len(str(int(global_p95))):
        avg_string = f"Avg:   {global_avg:>8.0f} {units}\n"
    elif (
        len(str(int(global_avg))) == len(str(int(global_p99)))
        and len(str(int(global_avg))) != 3
    ):
        avg_string = f"Avg:   {global_avg:>8.0f} {units}\n"
    elif (
        len(str(int(global_avg))) == len(str(int(global_p99)))
        and len(str(int(global_avg))) == 4
    ):
        avg_string = f"Avg:     {global_avg:>8.0f} {units}\n"
    else:
        avg_string = f"Avg:  {global_avg:>8.0f} {units}\n"

    if len(str(int(global_p95))) < len(str(int(global_p99))):
        p95_string = f"P95:   {global_p95:>8.0f} {units}\n"
    else:
        p95_string = f"P95:  {global_p95:>8.0f} {units}\n"

    stats_text = avg_string + p95_string + f"P99:  {global_p99:>8.0f} {units}"

    plt.text(
        text_x,
        text_y,
        stats_text,
        fontsize=10,
        color="black",
        bbox=dict(facecolor="white", edgecolor="gray", alpha=0.8),
        ha="left",  # Align text block to the left (values inside align right)
    )

    plt.legend(
        title="Configuration",
        loc="upper center",
        bbox_to_anchor=(0.5, -0.15),
        ncol=5,
        fancybox=True,
        shadow=True,
    )

    # Add a grid
    plt.xticks(range(1, 17))

    # Apply axis limits
    plt.ylim(y_axis_min, y_axis_max)

    # Show the graph
    plt.tight_layout()
    # plt.show()

    plt.savefig(
        file_name.replace(" - ", " - ")[0].replace(".csv", "")
        + f" - {dbms} - dataset {dataset} - {user}.pdf",
        format="pdf",
    )


def iterate_and_generate_graphs(
    file_names, dbms_list, datasets, user, yMin, yMax, yMinus
):
    for file_name in file_names:
        for dataset in datasets:
            for dbms in dbms_list:
                generate_graph(file_name, dbms, dataset, user, yMin, yMax, yMinus)


user = "rafael"
# file = "10 - Friends recommendation.csv"
file = "10 - Replies of a message.csv"
yMin = 0
yMax = 300
scale = 50

system = "postgres"

generate_graph(
    file,
    system,
    "0.3",
    user,
    yMin,
    yMax,
    scale,
)

generate_graph(
    file,
    system,
    "1",
    user,
    yMin,
    yMax,
    scale,
)

generate_graph(
    file,
    system,
    "3",
    user,
    yMin,
    yMax,
    scale,
)

system = "neo4j"


generate_graph(
    file,
    system,
    "0.3",
    user,
    yMin,
    yMax,
    scale,
)

generate_graph(
    file,
    system,
    "1",
    user,
    yMin,
    yMax,
    scale,
)

generate_graph(
    file,
    system,
    "3",
    user,
    yMin,
    yMax,
    scale,
)
