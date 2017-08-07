## THIRD SCRIPT: collapse first two rows  into one and designate as header




dir.create("data/data_Cleaning/finalData/")
collapseHead=function(filename, output = NULL) {
  if(!is.null(output)) {
    dataSource = "data/data_Cleaning/newName/"
    #check DFs to see if they have more than 3 rows (in order to eliminate tables with no data). if they do, do the following
    checkdf = read.table(paste0(dataSource,filename), sep = ",")
    if (nrow(checkdf) > 3) {
        #collapsing first two rows
        data = read.table(paste0(dataSource,filename), skip = 2, sep=",")
        labels = read.table(paste0(dataSource,filename), nrows = 2, stringsAsFactors = FALSE, fill = TRUE, sep = ",")
        header = sapply(labels, paste, collapse = "_")
        names(data) = header
        x = data[!grepl("TIMOR-LESTE", data[,1]),]
        #y = x[!grepl("Total", x[,1]),]
        df = x[!grepl("TOTAL", x[,1]),]
        df[is.na(df)] <-0
        dat = df[rowSums(df != 0) != 0, ]
        #write csv
        write.table(dat,paste0(output, filename), col.names = TRUE, row.names = FALSE, sep =",") 
      } 
  }
}

#collapseHead(filename, ".")
#collapseHead("X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv", "Final/")
#collapseHead("X4.11.1.Table.11.1.Number.of.rooms.in.residences.of.private.households..Administrative.Post.and.Suco..Aileu.csv", "Final/")


collapseHead_all = function(pattern) {
  filenames = list.files(path = "data/data_Cleaning/newName/", pattern = pattern)
  for (f in filenames) {
    collapseHead(f,output = "data/data_Cleaning/finalData/")
  }
}

collapseHead_all('*.csv')
