


setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
#filename = "X2..5.1i.Table.5.1i.Population.by.age.and.sex..Liquiça.csv"
#filename = "X2.2.a.Table.2.a.Total.population.density.and.number.of.households.by.Municipality.csv"
#filename = "X2.21d.Table.21.d.Former.members.of.private.households.living.in.Australia..New.Zealand..or.Other.Pacific.Countries..by.sex..Municipality.and.Administrative.Post.of.household.csv"
district = "AILEU"


TableName = ""
Above_average = ""
Below_average = ""
df = data.frame(TableName,Above_average, Below_average, stringsAsFactors = FALSE)
dir.create("Review")
write.csv(df, "Review/district_Review.csv", row.names = FALSE)


districtReview = function(filename, district = NULL) {
  if(!is.null(district)) {
    table = read.csv(filename, header = TRUE, stringsAsFactors = FALSE)
    ## clean up some tables with have whitespace in the first column  
    table[,1] = trimws(table[,1])
    ## check to see if Aileu exists in the first column. If it does perform the "if" statement, if not perform "else" 
    if(district %in% table[,1]) {
      avg = data.frame(apply(table[2:ncol(table)], 2, mean))
      #create Aileu tables
      ## future plan to make this more dynamic so it isn't just searching for Aileu
      district = table[grepl(district, table[,1], fixed = FALSE, ignore.case = TRUE),]    
      district = data.frame(t(district[1,]))
      districtName = district[1,1]
      district = data.frame(district[2:nrow(district),])
      #row.names(Aileu) = rownames[2:nrow(Aileu)]
      #Aileu = data.frame(Aileu)
      names(district) = districtName
      ## make sure column values are numeric, sometimes stored as factors

      district[,1] <- as.numeric(as.character(district[,1]))
      ## combine Aileu and national averages
      df = data.frame(cbind(district, avg))
      #compare district results with national average
      districtAboveAvg = data.frame(df[,1] > df[,2])
      df = cbind(df, districtAboveAvg)
      #create a summary table of true/false results
      Above_average = sum(df$df...1....df...2.=="TRUE")
      Below_average = sum(df$df...1....df...2.=="FALSE")
      dat = data.frame(cbind(Above_average, Below_average))
      names(dat) = c(paste(districtName,"Above_average", sep = "_"),paste(districtName, "Below_average", sep = "_"))
      
      ## commented the below out because not sure about combining at this early stage
      #x  = cbind(names(table[1]), dat)
      tab = read.table("Review/district_Review.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
      
      ## currently not working. Trying to insert name of the table in the first column of tab
      tab = rbind(tab$TableName,table[1])
      names(x) <- names(tab)
      x = rbind(tab, x)
      write.table(x, "Review/district_Review.csv", sep = ",", row.names = FALSE, col.names = TRUE)
      } else {
      df = read.table("Review/district_Review.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
      x = c(names(table[1]),c(NA, NA))
      write.csv(rbind(df, x), "Review/district_Review.csv", row.names = FALSE)
    }
  }
}


districtReview(filename, district = "Aileu")

districtReview_all=function(pattern){
  district = district
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    districtReview(f, district = district)
  }
}

districtReview_all("*.csv")

