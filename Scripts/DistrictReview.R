


setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
filename = "X2..5.1i.Table.5.1i.Population.by.age.and.sex..Liquiça.csv"
filename = "X2.2.a.Table.2.a.Total.population.density.and.number.of.households.by.Municipality.csv"
filename = "X2.21d.Table.21.d.Former.members.of.private.households.living.in.Australia..New.Zealand..or.Other.Pacific.Countries..by.sex..Municipality.and.Administrative.Post.of.household.csv"

TableName = ""
Above_average = ""
Below_average = ""
df = data.frame(TableName,Above_average, Below_average, stringsAsFactors = FALSE)
dir.create("Review")
write.csv(df, "Review/Aileu_Review.csv", row.names = FALSE)
districtReview = function(filename) {
  table = read.csv(filename, header = TRUE, stringsAsFactors = FALSE)
## clean up some tables with have whitespace in the first column  
  table[,1] = trimws(table[,1])
## check to see if Aileu exists in the first column. If it does perform the "if" statement, if not perform "else" 
  if("AILEU" %in% table[,1]){
    avg = data.frame(apply(table[2:ncol(table)], 2, mean))
#create Aileu tables
## future plan to make this more dynamic so it isn't just searching for Aileu
    Aileu = table[grepl("AILEU", table[,1], fixed = FALSE, ignore.case = TRUE),]    
    Aileu = data.frame(t(Aileu[1,]))
    Aileu = data.frame(Aileu[2:nrow(Aileu),])
    #row.names(Aileu) = rownames[2:nrow(Aileu)]
    #Aileu = data.frame(Aileu)
    names(Aileu) = "Aileu"
## make sure column values are numeric, sometimes stored as factors
    Aileu <- transform(Aileu, Aileu = as.numeric(as.character(Aileu)))
## combine Aileu and national averages
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

