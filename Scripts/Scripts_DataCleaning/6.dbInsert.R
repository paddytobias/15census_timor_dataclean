## FIFTH SCRIPT (OPTIONAL): Insert all tables from Final/ directory and inserting it into a SQLite database called Census2015.db



library(RSQLite)

dir.create("data/data_Cleaning/database")
#filename = "X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv"
dbInsert = function(filename){
  db = dbConnect(SQLite(), dbname = "data/data_Cleaning/database/Census2015.db")
  dat = read.csv(paste("data/data_Cleaning/finalData/",filename, sep = ""))
  dat2 = read.csv(paste("data/data_Cleaning/finalData/",filename, sep = ""), header = FALSE)
  header = toString(dat2[1,1])
  name = sub(".Table.*", "", header)
  dbWriteTable(conn = db, name = name, dat, overwrite = T, row.names = FALSE)
}

#dbInsert("output/NewName/Final/X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv")
#dat = read.csv("X2.1.b.Table.1.b.Urban.population.and.household.type.by.sex.and.Municipality.csv", header = FALSE)

dbInsert_all = function(pattern) {
  filenames = list.files(path = "data/data_Cleaning/finalData/", pattern = pattern)
  for (f in filenames) {
    dbInsert(f)
  }
}

dbInsert_all("*.csv")
#db = dbConnect(SQLite(), dbname = "Census2015.db")
