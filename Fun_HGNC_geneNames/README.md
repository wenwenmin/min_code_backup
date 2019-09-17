## 获取基因名称数据

- 第一步：在网站HGNC下载所有基因名称
注意： NCBI ID 就是 Entrez ID (NCBI = Entrez ID)

- 第二步：读入数据

- 映射不同的基因name，注意有很多基因名称发生了变化。一个基因可能先前有多个基因名称。

### R code
HGNC_geneNames = read.csv("C:/Users/linjh/Desktop/AGSVD/my_code_Exp_scRNA/HGNC_geneNames.txt",sep="\t", header=F) 

HGNC_geneNames = HGNC_geneNames[,c(1,2, 4)] 

names(HGNC_geneNames) = c("approved.symbol","previous.symbols", "NCBI.EntrezID")

HGNC_geneNames$approved.symbol=as.character(HGNC_geneNames$approved.symbol) 

HGNC_geneNames$previous.symbols=as.character(HGNC_geneNames$previous.symbols) 

HGNC_geneNames$NCBI.EntrezID=as.character(HGNC_geneNames$NCBI.EntrezID) 

save(HGNC_geneNames, file = "C:/Users/linjh/Desktop/AGSVD/my_code_Exp_scRNA/HGNC_geneNames.RData")
