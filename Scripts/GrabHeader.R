## create csv with the volume and table title of each dataset

#need to fix this code, wanting to create a table with two field, one field for Volume headings and the other field for Table headings

#filename = "X2.1.a.Table.1.a.Total.population.and.household.type.by.sex.and.Municipality.csv"
#grab Volume heading and enter into a table of its own called "TableNames"

setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
df = data.frame("TableNames" = character(), stringsAsFactors = FALSE)
write.csv(df,"VolumeNames.csv")
grabHeader= function(filename){
  dat = read.csv(filename, header = FALSE)
  #dat = read.csv("X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv", header = FALSE)
  header = toString(dat[1,1])
  volume = gsub(".Table.*", "", header)
  #pattern = ".*.Table"
  #header = gsub(pattern, "Table", header)
  VolNam = read.csv("VolumeNames.csv", header = TRUE, stringsAsFactors = FALSE)
  write.csv(rbind(VolNam, volume), "VolumeNames.csv", row.names = FALSE)
}

grabHeader_all= function(pattern){
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    grabHeader(f)
  }
}

grabHeader_all("*.csv")

################

#grab Table names and enter into a table of its own called "TableNames"


setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/output/NewName/Final")
df = data.frame("TableNames" = character(), stringsAsFactors = FALSE)
write.csv(df,"TableNames.csv")
grabHeader= function(filename){
  dat = read.csv(filename, header = FALSE)
  #dat = read.csv("X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv", header = FALSE)
  header = toString(dat[1,1])
  #volume = sub(".Table.*", "", header)
  pattern = ".*.Table"
  header = gsub(pattern, "Table", header)
  TabNam = read.csv("TableNames.csv", header = TRUE, stringsAsFactors = FALSE)
  write.csv(rbind(TabNam, header), "TableNames.csv", row.names = FALSE)
}

grabHeader_all= function(pattern){
  filenames = list.files(path = ".", pattern = pattern)
  for (f in filenames) {
    grabHeader(f)
  }
}

grabHeader_all("*.csv")

x = cbind(read.csv("VolumeNames.csv"),read.csv("TableNames.csv"))
write.csv(x, "VolTabNames.csv")
