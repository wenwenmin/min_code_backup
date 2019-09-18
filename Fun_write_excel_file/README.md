library(openxlsx)

write.xlsx(iris, file = "writeXLSX3.xlsx", colNames = TRUE, sheetName ="AAA")
###############################################################################
###############################################################################
# Easily Make Multi-tabbed .xlsx Files with openxlsx
# Example 1
Dat1 = iris
Dat2 = iris
# Create a blank workbook
wb <- createWorkbook()
addWorksheet(wb, "AAA")
addWorksheet(wb, "BBB")

writeData(wb, sheet = "AAA", x = Dat1)
writeData(wb, sheet = "BBB", x = Dat2)
saveWorkbook(OUT,"writeXLSX4.xlsx",overwrite=T)
###############################################################################
###############################################################################
# Example 2
OUT <- createWorkbook()
start_time <- Sys.time()
of="example_1.xlsx"
OUT <- createWorkbook()
for(aaa in 1:20)
{
  mdf<-data.frame(matrix(runif(n=1000),ncol=10,nrow=100))
  sname<-paste("Worksheet_",aaa,sep="")
  addWorksheet(OUT, sname)
  writeData(OUT, sheet = sname, x = mdf)
}
saveWorkbook(OUT,of)
end_time <- Sys.time()
end_time-start_time
###############################################################################
###############################################################################
