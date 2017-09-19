
## SCRIPT TO PRODUCE POLYGON GRAPHS FOR FIELDS IN TABLES WITH ONLY DISTRCT DATA
#MAKE SURE YOU RUN THE DISTRICTONLYCHECK.R SCRIPT FIRST
## WARNING: OMITTING OECUSSI FROM GRAPH AS IT SKEWS THE GRAPH
## Shapefile used here comes from https://koordinates.com/layer/4269-timor-leste-districts/, originally from https://sites.google.com/site/gigtimorleste/data/administrative-boundaries


#start clock
startTime <- Sys.time()

#load relevant packages
library(rgdal)
library(ggmap)
library(ggplot2)
library(dplyr)

dir.create("data/graphs/districtOnly")

df = read.csv("data/data_check/districtOnlyCheck.csv")

#create table of filenames for tables holding only whole-of-district data.
names(df) = c("Table Names", "Only districts in this table")
x = df[df$`Only districts in this table` == "TRUE",]

#i = 1
#for loop to merge geospatial data with district data. preparing for graphing
for (i in 1:nrow(x)){
  filename = x$`Table Names`[i]
  df = read.csv(paste0("data/data_Cleaning/finalData/", filename), stringsAsFactors = FALSE)
  #read in polygon data for Timor-Leste
  timor <- readOGR("data/timorleste-SHP/timor-leste-districts.shp")
  #extract district coordinates
  district_coords <- fortify(timor)
  timor$id <- row.names(timor)
  #join tables holding district coords
  district_coords <- left_join(district_coords, timor@data)
  
  #correct some of the spelling ahead of the right_join function
  df[df=="LAUTÉM"] <- "LAUTEM"
  df[df=="LIQUIÇA"] <- "LIQUICA"
  
  #pretty-up table name, used latter in graph title and filename
  TabNam <- colnames(df)[1]
  TabNam = gsub("\\.", " ", TabNam)
  TabNam = gsub("_0","", TabNam)
  TabNam = gsub("X","",TabNam)
  TabNam = gsub("(Table) ([0-9]) ([[:alpha:]]) ", "", TabNam)
  TabNam = gsub("([0-9]) ([0-9]) ([[:alpha:]]) ", "\\1\\.\\2\\.\\3\\. ", TabNam)
  
  
  colnames(df)[1] <- "DISTRICT"
  df <- right_join(district_coords, df)
  
  #i = 11
  
  for (i in 11:ncol(df)){
    #grab the variable name, used later in the graph title and filename
    variable = colnames(df)[i]
    var_name = gsub("\\.", " ", variable)
    var_name = gsub("_0", "", var_name)
    var_name = gsub("_", " ", var_name)
    var_name = gsub("X", "", var_name)
    
    ggplot(df, aes(long, lat, group = DISTRICT, fill = get(variable))) +
      geom_polygon() + coord_equal() +
      scale_fill_gradient(low = "light grey", high = "blue")+
      labs(title = TabNam,
          subtitle = var_name,
           caption = "\n Data source: 2015 Timor-Leste Population and Housing Census, General Directorate of Statistics \n \n Tobias P, 2017, “2015 Timor-Leste Census data: Data Processing and Analysis in R scriptlets”, \n https://github.com/paddytobias/15census_timor_dataclean, DOI: 10.5281/zenodo.826449",
           x= "Longitute", y = "Latitude", fill = "Count")+
      theme(plot.caption = element_text(size = 6), plot.subtitle = element_text(size = 12))
      #annotate("text", x = 127, y = -9.4) +
      #ggtitle(paste(TabNam,var_name, sep = ", "))
    
    #print(p)
    
    #jpeg(paste("graphs/",filename,".jpeg", sep = ""), width = 1500, height = 1500)
    #dev.copy(jpeg, paste0("data/graphs/districtOnly/",paste(TabNam, var_name, sep = "_"), ".jpeg"), width = 1000, height = 500)
    #dev.off()
    ggsave(filename = paste0("data/graphs/districtOnly/",paste(TabNam, var_name, sep = "_"), ".jpeg"), device = "jpeg", width = 10, height = 5)
  }
}

endTime <- Sys.time()
 
timeTaken <- endTime - startTime
paste("This script took", timeTaken, "to run", sep = " ")
paste("Output found in data/graphs/districtOnly/")
