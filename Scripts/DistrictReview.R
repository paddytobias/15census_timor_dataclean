


setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
filename = "X2..5.1i.Table.5.1i.Population.by.age.and.sex..Liquiça.csv"
filename = "X2.2.a.Table.2.a.Total.population.density.and.number.of.households.by.Municipality.csv"


TableName = ""
Above_average = ""
Below_average = ""
df = data.frame(TableName,Above_average, Below_average, stringsAsFactors = FALSE)
dir.create("Review")
write.csv(df, "Review/Aileu_Review.csv", row.names = FALSE)
districtReview = function(filename) {
  table = read.csv(filename, header = TRUE, stringsAsFactors = FALSE)
  #DistrictReview = read.csv("Review/District_Review.csv", header = TRUE, stringsAsFactors = FALSE)
  if("AILEU" %in% table[,1]){
    #row.names(df) = df[,1]
    #df = df[2:ncol(df)]
    avg = data.frame(apply(table[2:ncol(table)], 2, mean))
    #dat = dat[!grepl("Based", dat$V2, fixed = FALSE),]
    Aileu = table[grepl("AILEU", table[,1], fixed = FALSE, ignore.case = TRUE),]    
    Aileu = data.frame(t(Aileu))
    names(Aileu) = Aileu[1,]
    Aileu = Aileu[2:nrow(Aileu),]
    Aileu = data.frame(Aileu)
    Aileu <- transform(Aileu, class = as.numeric(as.character(Aileu)))
    Aileu <- Aileu[,2]
    df = data.frame(cbind(Aileu, avg))
    #compare Aileu results with national average
    AileuAboveAvg = data.frame(df[,1] > df[,2])
    df = cbind(df, AileuAboveAvg)
    #create a summary table of true/false results
    Above_average = sum(df$df...1....df...2.=="TRUE")
    Below_average = sum(df$df...1....df...2.=="FALSE")
    dat = data.frame(cbind(Above_average,Below_average))
    x  = cbind(names(table[1]), dat)
    tab = read.table("Review/Aileu_Review.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
    names(x) <- names(tab)
    x = rbind(tab, x)
    write.table(x, "Review/Aileu_Review.csv", sep = ",", row.names = FALSE, col.names = TRUE)
  } else {
    df = read.table("Review/Aileu_Review.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
    x = c(names(table[1]),c(NA, NA))
    write.csv(rbind(df, x), "Review/Aileu_Review.csv", row.names = FALSE)
  }
}
      

districtReview(filename)

districtReview_all=function(pattern){
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    districtReview(f)
  }
}

districtReview_all("*.csv")
