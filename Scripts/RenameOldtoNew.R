##Renaming and cleaning csv files

setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015")
library(zoo)
rename = function(filename, output = NULL) {
  if(!is.null(output)) {
    x = read.csv(filename, header = FALSE, stringsAsFactors = FALSE)
    newname = x[1,2]
    x[3,2] <- x[1,2]
    #delete first row and first column that hold legacy names
    y=x[2:nrow(x), 2:ncol(x)]
    #delete all rows with unwanted words in the second column
    dat = y[!grepl("(1)", y$V2, fixed = TRUE),]
    dat2 = dat[!grepl("Based", dat$V2, fixed = FALSE),]
    dat3 = dat2[!grepl("Special", dat2$V2, fixed = FALSE),]
    #delete all 'totals' rows
    dat4 = dat3[!grepl("TIMOR-LESTE", dat3$V2, fixed = TRUE),]
    dat5 = dat4[!grepl("TOTAL", dat4$V2, fixed = TRUE),]
    #to clean all rows complete with NAs
    clean = dat5[rowSums(is.na(dat5)) != ncol(dat5),]
    #clean up NA with value below
    #clean[is.na(clean)] <- 0
    cleanNA = t(na.locf(t(clean), fromLast = FALSE))
    #final = cleanNA[2:nrow(cleanNA),2:ncol(cleanNA)]
    #write 'clean' data with new name
    write.table(cleanNA, paste(output,newname,".csv",sep=""), col.names = FALSE, row.names = FALSE, sep=",", na="0")
  }
}

#rename("output/OldName/1_2015-V2-Population-Household-Distribution.xls2.2.b.csv", "output/test/")

rename_all = function(pattern) {
  data_dir = "output/OldName/"
  #results_dir = "output/NewName/"
  filenames = list.files(path = data_dir, pattern = pattern)
  for (f in filenames) {
    rename(file.path(data_dir,f),output = "output/NewName/")
  }
}

rename_all("*.csv")
