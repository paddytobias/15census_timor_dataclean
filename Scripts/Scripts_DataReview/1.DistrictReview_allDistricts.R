
### Script to create 13 datasheets for each of the 13 districts showing above and below national average counts
#---------------------------


#filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
#filename = "X2..5.1i.Table.5.1i.Population.by.age.and.sex..Liquiça.csv"
#filename = "X2.2.a.Table.2.a.Total.population.density.and.number.of.households.by.Municipality.csv"
#filename = "X2.21d.Table.21.d.Former.members.of.private.households.living.in.Australia..New.Zealand..or.Other.Pacific.Countries..by.sex..Municipality.and.Administrative.Post.of.household.csv"
#district = "BOBONARO"
#filename = "X2.5.1.Table.5.1.Population.by.age.and.sex.csv"


#GET ALL DISTRICT NAMES IN ONE VECTOR, TAKING IT FROM TABLE 2.1.a
districts <- read.csv("data/data_Cleaning/finalData/X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv", stringsAsFactors = FALSE)
districts <- as.character(districts[,1])
dir.create("data/data_Review")

#district = "AILEU"
districtReview = function(filename, district = NULL) {
  if(!is.null(district)) {
    table = read.csv(paste0("data/data_Cleaning/finalData/",filename), header = TRUE, stringsAsFactors = FALSE)
    ## clean up some tables with have whitespace in the first column  
    table[,1] = trimws(table[,1])
    ## check to see if the district exists in the first column. If it does perform the "if" statement, if not perform "else" 
    if(district %in% table[,1]) {
      ##calculate the national average for each variable of a table
      avg = data.frame(apply(table[2:ncol(table)], 2, mean))
      min = data.frame(apply(table[2:ncol(table)], 2, min))
      max = data.frame(apply(table[2:ncol(table)], 2, max))
      #sd = data.frame(apply(table[2:ncol(table)], 2, function(x){sqrt(sum((x - mean(x))^2)/(nrow(table)))}))
      
      ##build district review tables to then output into a district folder of its own.
      df = table[grepl(district, table[,1], fixed = FALSE, ignore.case = TRUE),]    
      df = data.frame(t(df[1,]))
      district = as.character(df[1,1])
      df = data.frame(df[2:nrow(df),])
      names(df) = district
      ## make sure column values are numeric, sometimes stored as factors
      df[,1] <- as.numeric(as.character(df[,1]))
      ## combine district and national averages
      df = data.frame(cbind(df, avg, min, max))
      #logical comparison between district results with national average
      districtAboveAvg = data.frame(df[,1] > df[,2])
      districtIsMin = data.frame(df[,1] == df[,3])
      districtIsMax = data.frame(df[,1] == df[,4])
      df = cbind(df, districtAboveAvg, districtIsMin, districtIsMax)
      names(df) <- c(district, "National_Avg", "National_Min", "National_Max", "District above National Average?", "District is National Min?", "District is National Max?")
      write.csv(df, paste("data/data_Review",district,filename, sep = "/"))
      
      ##create a summary table of true/false results and put these results in a meta-summary for a district across all data tables
      Above_average = sum(df$`District above National Average?` =="TRUE")
      Below_average = sum(df$`District above National Average?`=="FALSE")
      IsMin = sum(df$`District is National Min?` == "TRUE")
      IsMax = sum(df$`District is National Max?` == "TRUE")
      dat = data.frame(cbind(Above_average, Below_average, IsMin, IsMax))
      names(dat) = c(paste(district,"above average", sep = " "),paste(district, "below average", sep = " "), paste(district, "is Min", sep = " "), paste(district, "is Max", sep = " "))
      x  = cbind(names(table[1]), dat)
      tab = read.table(paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), header = TRUE, sep = ",", stringsAsFactors = FALSE)
      names(x) <- names(tab)
      tab = rbind(tab,x)
      write.table(tab, paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
    } else {
      df = read.table(paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), header = TRUE, sep = ",", stringsAsFactors = FALSE)
      x = c(names(table[1]),c(NA, NA, NA, NA))
      write.table(rbind(df, x), paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
    }
  }
}


#districtReview(filename, district = "AILEU")

districtReview_all=function(pattern, district){
  #district = district
  filenames = list.files(path = "data/data_Cleaning/finalData/", pattern = pattern)
  for (f in filenames) {
      districtReview(f, district = district)
  }
}

#districtReview_all("*.csv", i)
#i = "VIQUEQUE"
for (i in districts) {
  dir.create(paste0("data/data_Review/",i))
  df = data.frame("TableName" = as.character(),"Above_average" = as.character(), "Below_average" = as.character(), "IsMin" = as.character(), "IsMax" = as.character(), stringsAsFactors = FALSE)
  write.table(df, file = paste0(paste0("data/data_Review/",i,"/"),"Review",i,".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
  districtReview_all("*.csv", i)
  #apply names to the columns in the tables
  df = read.table(paste0(paste0("data/data_Review/",i,"/"),"Review",i,".csv"), sep = ",", header = TRUE)
  names(df) = c("TableName", "District above National Average", "District below National Average", "District is National Minimum", "District is National Maximum")
  write.table(df, file = paste0(paste0("data/data_Review/",i,"/"),"Review",i,".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
}




