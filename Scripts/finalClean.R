## FIFTH SCRIPT: the final clean

setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")

#filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
finalClean <- function(filename, output) {
  if(!is.null(output)) {
    df = read.csv(file = filename, header = FALSE, colClasses = "character")
    #df = df[!grepl("-", df[,1], fixed = TRUE),]
    #df = df[!grepl("Under", df[,1], fixed = TRUE),]
    #df = df[!grepl("Total", df[,1], fixed = TRUE),]
    #row.names(df) = df[,1]
    #df = df[2:ncol(df)]
    #getting rid of all comma separation in thousands
    headers = df[1,]
    df = cbind(df[2:nrow(df),1],data.frame(lapply(df[2:nrow(df),2:ncol(df)], function(df){as.numeric(gsub(",","",df))})))
    names(df) = headers
    write.table(df, paste("./", filename,sep=""), col.names = TRUE, row.names = FALSE, sep =",")  
  }
  
}

analyse(filename)

finalClean_all = function(pattern) {
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    finalClean(f, ".")
  }
}

finalClean_all("*.csv")
