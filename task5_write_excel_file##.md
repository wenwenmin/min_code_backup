task5_write_excel_file
参考网站 https://www.jianshu.com/p/78ada01a3b65
就是一对三个在键盘上的esc键下的那个键

# 案例 1 
注释符号-就是一对三个在键盘上的esc键下的那个键
```
library(openxlsx)
write.xlsx(iris, file = "writeXLSX3.xlsx", colNames = TRUE, sheetName ="AAA")

### Easily Make Multi-tabbed .xlsx Files with openxlsx
### Example 1
Dat1 = iris
Dat2 = iris
# Create a blank workbook
wb <- createWorkbook()
addWorksheet(wb, "AAA")
addWorksheet(wb, "BBB")

writeData(wb, sheet = "AAA", x = Dat1)
writeData(wb, sheet = "BBB", x = Dat2)
saveWorkbook(OUT,"writeXLSX4.xlsx",overwrite=T)

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
``` 

# 案例 2
```
library(openxlsx) 
write.xlsx(iris, file = "writeXLSX3.xlsx", colNames = TRUE, sheetName ="AAA")

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

# Example 3
##Load dependencies
if (!require('openxlsx')) install.packages('openxlsx')
library('openxlsx')

##Split data apart by a grouping variable;
##makes a named list of tables
dat <- split(mtcars, mtcars$cyl)
dat


##Create a blank workbook
wb <- createWorkbook()

##Loop through the list of split tables as well as their names
##and add each one as a sheet to the workbook
Map(function(data, name){
  
  addWorksheet(wb, name)
  writeData(wb, name, data)
  
}, dat, names(dat))

##Save workbook to working directory
saveWorkbook(wb, file = "example.xlsx", overwrite = TRUE)
```
