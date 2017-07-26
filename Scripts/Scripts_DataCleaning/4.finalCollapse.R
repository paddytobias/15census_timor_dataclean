## FOURTH SCRIPT: using collapseHeader to do a final 2 heading collapse for datasets that still have two headings

#filename = "X2.16j.Table.16.j.Age.at.first.marriage.of.persons.aged.over.nine.years.by.age.and.sex..Manatuto.csv"

setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")

finalCollapse = function(filename, output) {
  if(!is.null(output)) {
    df = read.csv(filename, header = TRUE, stringsAsFactors = FALSE)
    #write.csv(dat, filename)
    #dat = read.csv(filename, header = FALSE)
    #FinalClean = read.csv("FinalClean", header = TRUE, stringsAsFactors = FALSE)
    if(df[1,1] == 0){
      df = read.table(filename, skip = 2, sep=",")
      labels = read.table(filename, nrows = 2, stringsAsFactors = FALSE, fill = TRUE, sep = ",")
      names(df) = sapply(labels, paste, collapse = "_")
      write.table(df, paste("./", filename,sep=""), col.names = TRUE, row.names = FALSE, sep =",")
    }
  }
}
#finalCollapse(filename)

finalCollapse_all = function(pattern) {
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    finalCollapse(f, ".")
  }
}

finalCollapse_all("*.csv")
