setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/V4/V4_csvnewname/")

## collapse first two rows  into one and designate as header

collapseHead=function(filename, output = NULL) {
  if(!is.null(output)) {
    
    #collapsing first two rows
    data = read.table(filename, skip = 2, sep=",")
    labels = read.table(filename, nrows = 2, stringsAsFactors = FALSE, fill = TRUE, sep = ",")
    names(data) = sapply(labels, paste, collapse = "_")
    x = data[!grepl("TIMOR-LESTE", data[,1]),]
    #y = x[!grepl("Total", x[,1]),]
    z = x[!grepl("TOTAL", x[,1]),]
    #write csv
    write.table(z,paste(output,filename,sep=""), col.names = TRUE, row.names = FALSE, sep =",")
  }
}

#collapseHead("X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv", "Final/")


collapseHead_all = function(pattern) {
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    collapseHead(file.path(".",f),output = "V4_Final/")
  }
}

collapseHead_all('*.csv')
