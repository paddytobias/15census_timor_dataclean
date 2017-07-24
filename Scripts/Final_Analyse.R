
setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
library(ggplot2)
library(plotly)
filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
analyse <- function(filename) {
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
  #analysis
  #avg = apply(df[,2:ncol(df)], 2, mean)
  p = ggplot(df, aes(x=df[,1], y = df[,2])) + 
           geom_point()
  ggplotly(p)
  }

analyse(filename)
