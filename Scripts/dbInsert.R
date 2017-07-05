
setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015")
library(RSQLite)

#filename = "X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv"
dbInsert = function(filename){
  db = dbConnect(SQLite(), dbname = "Census2015.db")
  dat = read.csv(paste("output/NewName/Final/",filename, sep = ""))
  dat2 = read.csv(paste("output/NewName/Final/",filename, sep = ""), header = FALSE)
  header = toString(dat2[1,1])
  name = sub(".Table.*", "", header)
  dbWriteTable(conn = db, name = name, dat, overwrite = T, row.names = FALSE)
}

#dbInsert("output/NewName/Final/X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv")
#dat = read.csv("X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv", header = FALSE)

dbInsert_all = function(pattern) {
  filenames = list.files(path = "output/NewName/Final/", pattern = pattern)
  for (f in filenames) {
    dbInsert(f)
  }
}

dbInsert_all("*.csv")
db = dbConnect(SQLite(), dbname = "Census2015.db")
