setwd("~/ownCloud/Timor-Leste/Data/Population/Census_2015/V4")
library(XLConnect)
# Import all worksheets and names from a workbook
importWorksheets <- function(filename) {
  # filename: name of Excel file
  workbook <- loadWorkbook(filename)
  sheet_names <- getSheets(workbook)
  names(sheet_names) <- sheet_names
  sheet_list <- lapply(sheet_names, function(.sheet){
    readWorksheet(object=workbook, .sheet)})
}
# wb = importWorksheets("1_2015-V2-Population-Household-Distribution.xls")

#working on reading in multiple files
# wbs = list.files(pattern = "*.xls")



# creating a function to get sheet names
#  newfilename = function(filename) {
# workbook <- loadWorkbook(filename)
# sheet_names <- getSheets(workbook)  
# }



# write csv for second sheet with sheet name
# write.csv(wb[2], sheet_names[2])

# and third
# write.csv(wb[3], sheet_names[3])



#writting csv files from one Excel workbook
csv = function(filename, output = NULL) {
  #input: 
  # filename: character string of a xls file name
  # output: character string of the saved csv
  wb = importWorksheets(filename)
  if(!is.null(output)) {
    for (x in seq_along(wb)) {
      # getting sheet names (to write csv with sheet name)
      workbook <- loadWorkbook(filename)
      sheet_names <- getSheets(workbook)
      #writing csv with sheet names as filename
      write.csv(wb[x], file = paste(output,sheet_names[x], ".csv", sep = ""))
    }
  }
  #if(!is.null(output)) {
  #dev.off()
  #}
}


csv_all = function(pattern) {
  dir = "V4_csvoutput/"
  filenames = list.files(pattern = pattern)
  for (f in filenames) {
    csv_name = paste(dir,f,sep="")
    csv(f, output = csv_name)
  }
}

csv_all('*.xls')
