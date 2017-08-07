## THIRD SCRIPT: collapse first two rows  into one and designate as header

setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName")
dir.create("Final/")
collapseHead=function(filename, output = NULL) {
  if(!is.null(output)) {
    #collapsing first two rows
    data = read.table(filename, skip = 2, sep=",")
    labels = read.table(filename, nrows = 2, stringsAsFactors = FALSE, fill = TRUE, sep = ",")
    names(data) = sapply(labels, paste, collapse = "_")
    x = data[!grepl("TIMOR-LESTE", data[,1]),]
    #y = x[!grepl("Total", x[,1]),]
    df = x[!grepl("TOTAL", x[,1]),]
    df[is.na(df)] <-0
    dat = df[rowSums(df != 0) != 0, ]
    #write csv
    write.table(dat,paste(output, filename,sep=""), col.names = TRUE, row.names = FALSE, sep =",")
  }
}

#collapseHead(filename, ".")
#collapseHead("X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv", "Final/")
#collapseHead("X4.11.1.Table.11.1.Number.of.rooms.in.residences.of.private.households..Administrative.Post.and.Suco..Aileu.csv", "Final/")


collapseHead_all = function(pattern) {
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    collapseHead(file.path(".",f),output = "Final/")
  }
}

collapseHead_all('*.csv')


