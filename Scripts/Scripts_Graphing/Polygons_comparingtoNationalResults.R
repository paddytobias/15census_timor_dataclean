
## SCRIPT TO PRODUCE POLYGON GRAPHS FOR FIELDS IN TABLES master_review.r

#MAKE SURE YOU RUN 2.aggregateTotals.R SCRIPT FIRST (found in Scripts_DataReview folder)
## WARNING: OMITTING OECUSSI FROM GRAPH AS IT SKEWS THE GRAPH
## Shapefile used here comes from https://koordinates.com/layer/4269-timor-leste-districts/, originally from https://sites.google.com/site/gigtimorleste/data/administrative-boundaries

#start clock
startTime <- Sys.time()

dir.create("data/graphs/nationalResults/")
omissions = "SAR1 OF OECUSSE"

library(rgdal)
library(ggmap)
library(ggplot2)
library(dplyr)

master_review = read.csv("data/data_Review/master_dataReview.csv")
colnames(master_review) = gsub("\\.", " ", names(master_review))
timor <- readOGR("data/timorleste-SHP/timor-leste-districts.shp")

district_coords <- fortify(timor)

master_review$Districts <- as.character(master_review$Districts)
master_review[master_review=="LAUTÉM"] <- "LAUTEM"
master_review[master_review=="LIQUIÇA"] <- "LIQUICA"

master_review <- master_review[master_review$Districts != omissions[1],]
#master_review <- master_review[master_review$Districts != omissions[2],]
#master_review[master_review=="SAR1 OF OECUSSE"] <- "OECUSSI"


#timor@data <- timor@data[levels(timor@data$DISTRICT),]
timor$id <- row.names(timor)
district_coords <- left_join(district_coords, timor@data)
district_coords <- district_coords[district_coords$DISTRICT != "OECUSSI",]
#district_coords <- district_coords[district_coords$DISTRICT != "DILI",]


#district_coords1 <- base::merge(district_coords, master_review, by.x = "DISTRICT", by.y = "Districts")
colnames(master_review)[1] = "DISTRICT"
master_review <- right_join(district_coords, master_review)

#district_coords1[,2:8] <- district_coords[,1:7]

### A FOR LOOP TO MAP DISTRICT RESULTS FOR ALL VARIABLES OF MASTER_REVIEW
for (i in 11:ncol(master_review)){
  
var_name = colnames(master_review)[i]
  
ggplot(master_review, aes(long, lat, group = DISTRICT, fill = get(var_name))) +
  geom_polygon() + coord_equal() +
  scale_fill_gradient(low = "white", high = "black")+
  labs(title = paste0(var_name, ", excluding ", omissions[1]),
        caption = "\n Data source: 2015 Timor-Leste Population and Housing Census, General Directorate of Statistics \n \n Tobias P, 2017, “2015 Timor-Leste Census data: Data Processing and Analysis in R scriptlets”, \n https://github.com/paddytobias/15census_timor_dataclean, DOI: 10.5281/zenodo.826449",
        x= "Longitute", y = "Latitude", fill = "Count")+
  theme(plot.caption = element_text(size = 6))

ggsave(filename = paste0("data/graphs/nationalResults/",paste0(var_name, "without", omissions[1],".jpeg")), device = "jpeg", width = 10, height = 5)
#jpeg(paste("graphs/",filename,".jpeg", sep = ""), width = 1500, height = 1500)

}

endTime <- Sys.time()

timeTaken <- endTime - startTime
paste("This script took", timeTaken, "to run", sep = " ")
paste("Output found in data/graphs/nationalResults")

