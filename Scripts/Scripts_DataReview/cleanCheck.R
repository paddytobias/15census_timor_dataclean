#check datasets to see if headers have been collapsed into one heading (and there is no '0' in the cell[2,1])


setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
df = data.frame("Sheet has 0 in cell[2,1]" = character(), stringsAsFactors = FALSE)
write.csv(df, "FinalClean")
cleanCheck = function(filename) {
  dat = read.csv(filename, header = FALSE, stringsAsFactors = FALSE)
  dat[is.na(dat)] <-0
  FinalClean = read.csv("FinalClean", header = TRUE, stringsAsFactors = FALSE)
  if(dat[2,1] == 0){
    write.csv(rbind(FinalClean,"TRUE"), "FinalClean", row.names = FALSE)
  } else {
    write.csv(rbind(FinalClean,"FALSE"), "FinalClean", row.names = FALSE)
  }
}

#cleanCheck(filename)

cleanCheck_all = function(pattern) {
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    cleanCheck(f)
  }
}

cleanCheck_all("*.csv")
