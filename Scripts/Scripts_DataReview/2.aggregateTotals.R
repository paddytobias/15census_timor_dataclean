##AGGREGATE TOTAL REVIEW DATA for national average, national minimums and national maximums. Outputted into a .csv called "master_dataReview

#district = "AILEU"
dir.create("data/data_Review/")

#get district names
districts <- read.csv("data/data_Cleaning/finalData/X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv", stringsAsFactors = FALSE)
districts <- as.character(districts[,1])


master_review = data.frame("Districts" = as.character(), "Sum of Above national mean results" = as.numeric(), "Sum of Below national mean results" = as.numeric(), "Sum of national minimums" = as.numeric(), "Sum of national maximums" = as.numeric(), stringsAsFactors = FALSE)

for (district in districts) {
  df = read.csv(paste0("data/data_Review/",district,"/Review", district,".csv"))
  #names(df) <- c("TableName", "Above_average", "Below_average")
  df <- na.omit(df)

  sumAbove <- sum(as.numeric(df$District.above.National.Average))
  sumBelow <- sum(as.numeric(df$District.below.National.Average))
  sumMin <- sum(as.numeric(df$District.is.National.Minimum))
  sumMax <- sum(as.numeric(df$District.is.National.Maximum))
  
  master_review <- rbind(master_review, c(as.character(district), as.numeric(sumAbove), as.numeric(sumBelow), as.numeric(sumMin), as.numeric(sumMax)), stringsAsFactors = FALSE)
}

names(master_review) <- c("Districts", "Above the national average", "Below the national average", "National minimums", "National maximums")
write.table(master_review, "data/data_Review/master_dataReview.csv", sep = ",", row.names = FALSE, col.names = TRUE)

