### FIRST SCRIPT TO CONVRT TO CSV


library(XLConnect)
dir.create("data/data_Cleaning/")
dir.create("data/data_Cleaning/oldName")
# Import all worksheets and names from a workbook
importWorksheets <- function(filename) {
     # filename: name of Excel file
     workbook <- loadWorkbook(filename)
     sheet_names <- getSheets(workbook)
     names(sheet_names) <- sheet_names
     sheet_list <- lapply(sheet_names, function(.sheet){
         readWorksheet(object=workbook, .sheet)})
    }



#filename = "data/1_2015-V2-Population-Household-Distribution.xls"
#output = "output/OldName/"
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
      df = wb[x]
      write.csv(df, file = paste(output,sheet_names[x], ".csv", sep = ""))
      }
    }
}
#csv("data/sourceData/1_2015-V2-Population-Household-Distribution.xls", output = "data/data_Cleaning/oldName/")

csv_all = function(pattern) {
  output = "data/data_Cleaning/oldName/"
  input = "data/sourceData/"
  filenames = list.files(path = input, pattern = pattern)
  for (f in filenames) {
      csv_name = paste(output,f,sep="")
      csv(paste(input,f,sep=""), output = csv_name)
  }
}

csv_all('*.xls')
