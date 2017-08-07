
### Script to create 13 datasheets for each of the 13 districts showing above and below national average counts
#---------------------------


filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
#filename = "X2..5.1i.Table.5.1i.Population.by.age.and.sex..Liquiça.csv"
#filename = "X2.2.a.Table.2.a.Total.population.density.and.number.of.households.by.Municipality.csv"
#filename = "X2.21d.Table.21.d.Former.members.of.private.households.living.in.Australia..New.Zealand..or.Other.Pacific.Countries..by.sex..Municipality.and.Administrative.Post.of.household.csv"
district = "BOBONARO"
filename = "X2.5.1.Table.5.1.Population.by.age.and.sex.csv"


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
      
      ##build district review tables to then output into a district folder of it's own.
      df = table[grepl(district, table[,1], fixed = FALSE, ignore.case = TRUE),]    
      df = data.frame(t(df[1,]))
      district = as.character(df[1,1])
      df = data.frame(df[2:nrow(df),])
      names(df) = district
      ## make sure column values are numeric, sometimes stored as factors
      df[,1] <- as.numeric(as.character(df[,1]))
      ## combine district and national averages
      df = data.frame(cbind(df, avg))
      #logical comparison between district results with national average
      districtAboveAvg = data.frame(df[,1] > df[,2])
      df = cbind(df, districtAboveAvg)
      names(df) <- c(district, "National_Avg", "Is the district above the national average?")
      write.csv(df, paste("data/data_Review",district,filename, sep = "/"))
      
      ##create a summary table of true/false results and put these results in a meta-summary for a district across all data tables
      Above_average = sum(df$`Is the district above the national average?`=="TRUE")
      Below_average = sum(df$`Is the district above the national average?`=="FALSE")
      dat = data.frame(cbind(Above_average, Below_average))
      names(dat) = c(paste(district,"Above_average", sep = "_"),paste(district, "Below_average", sep = "_"))
      x  = cbind(names(table[1]), dat)
      tab = read.table(paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), header = TRUE, sep = ",", stringsAsFactors = FALSE)
      names(x) <- names(tab)
      tab = rbind(tab,x)
      write.table(tab, paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
    } else {
      df = read.table(paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), header = TRUE, sep = ",", stringsAsFactors = FALSE)
      x = c(names(table[1]),c(NA, NA))
      write.table(rbind(df, x), paste0(paste0("data/data_Review/",district, "/"), "Review", district, ".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
    }
  }
}


#districtReview(filename, district = "AILEU")

districtReview_all=function(pattern, district){
  #district = district
  filenames = list.files(path = "data/data_Cleaning/finalData/", pattern = pattern)
    for (f in filenames) {
      districtReview(f, district = x)
    }
}

#districtReview_all("*.csv")

for (x in districts) {
  dir.create(paste0("data/data_Review/",x))
  df = data.frame(TableName = character(),Above_average= character(), Below_average = character(), stringsAsFactors = FALSE)
  write.table(df, file = paste0(paste0("data/data_Review/",x,"/"),"Review",x,".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
  districtReview_all("*.csv", x)
  #apply names to the columns in the tables
  df = read.table(paste0(paste0("data/data_Review/",x,"/"),"Review",x,".csv"), sep = ",", header = FALSE)
  names(df) = c("TableName", "Above_average", "Below_average")
  write.table(df, file = paste0(paste0("data/data_Review/",x,"/"),"Review",x,".csv"), sep = ",", row.names = FALSE, col.names = TRUE)
}




