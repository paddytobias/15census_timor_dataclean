##SECOND SCRIPT: Renaming and cleaning csv files

library(zoo)
dir.create("data/data_Cleaning/newName/")
rename = function(filename, output = NULL) {
  if(!is.null(output)) {
    x = read.csv(filename, header = FALSE, stringsAsFactors = FALSE)
    newname = x[1,2]
    x[3,2] <- x[1,2]
    #delete first row and first column that hold legacy names
    x=x[2:nrow(x), 2:ncol(x)]
    #delete all rows with unwanted words in the second column
    dat = x[!grepl("(1)", x$V2, fixed = TRUE),]
    dat = dat[!grepl("Based", dat$V2, fixed = FALSE),]
    dat = dat[!grepl("Special", dat$V2, fixed = FALSE),]
    #delete all 'totals' rows
    dat = dat[!grepl("TIMOR-LESTE", dat$V2, fixed = TRUE),]
    dat = dat[!grepl("TOTAL", dat$V2, fixed = TRUE),]
    #to clean all rows complete with NAs
    clean = dat[rowSums(is.na(dat)) != ncol(dat),]
    #clean up NA with value below
    #clean[is.na(clean)] <- 0
    cleanNA = t(na.locf(t(clean), fromLast = FALSE))
    #final = cleanNA[2:nrow(cleanNA),2:ncol(cleanNA)]
    #write 'clean' data with new name
    write.table(cleanNA, paste(output,newname,".csv",sep=""), col.names = FALSE, row.names = FALSE, sep=",", na="0")
  }
}

#rename("output/OldName/1_2015-V2-Population-Household-Distribution.xls2.2.b.csv", "output/OldNames/")

rename_all = function(pattern) {
  data_dir = "data/data_Cleaning/oldName/"
  #results_dir = "output/NewName/"
  filenames = list.files(path = data_dir, pattern = pattern)
  for (f in filenames) {
    rename(file.path(data_dir,f),output = "data/data_Cleaning/newName/")
  }
}

rename_all("*.csv")
