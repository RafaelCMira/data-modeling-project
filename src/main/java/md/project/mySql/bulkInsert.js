const files = [
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\countries.csv', table: 'country'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\districts.csv', table: 'district'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\cities.csv', table: 'city'},

    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\person.csv', table: 'person'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\post.csv', table: 'post'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\comment.csv', table: 'comment'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\tag.csv', table: 'tag'},

    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\follow.csv', table: 'follow'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\post_like.csv', table: 'post_like'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\comment_like.csv', table: 'comment_like'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\comment_parent.csv', table: 'comment_parent'},
    {file: 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\data_modeling\\post_tag.csv', table: 'post_tag'},
];

const options = {
    skipRows: '1',
    schema: 'data_modeling',
    dialect: 'csv',
    replaceDuplicates: false,
    fieldsOptionallyEnclosed: false,
    fieldsTerminatedBy: '$',
    linesTerminatedBy: '\n',
    bytesPerChunk: '2M',
    threads: '10',
    maxRate: '0',
    showProgress: true
};


util.importTable(files[0].file, {...options, table: files[0].table});
util.importTable(files[1].file, {...options, table: files[1].table});
util.importTable(files[2].file, {...options, table: files[2].table});

util.importTable(files[3].file, {...options, table: files[3].table});
util.importTable(files[4].file, {...options, table: files[4].table});
util.importTable(files[5].file, {...options, table: files[5].table});
util.importTable(files[6].file, {...options, table: files[6].table});

util.importTable(files[7].file, {...options, table: files[7].table});
util.importTable(files[8].file, {...options, table: files[8].table});
util.importTable(files[9].file, {...options, table: files[9].table});
util.importTable(files[10].file, {...options, table: files[10].table});
util.importTable(files[11].file, {...options, table: files[11].table});


