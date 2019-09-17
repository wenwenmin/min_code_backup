第一步：在网站HGNC下载所有基因名称
注意： NCBI ID 就是 Entrez ID

第二步：读入数据
HGNC_geneNames = read.csv("C:/Users/linjh/Desktop/AGSVD/my_code_Exp_scRNA/HGNC_geneNames.txt",sep="\t", header=F)
# NCBI = Entrez ID
HGNC_geneNames = HGNC_geneNames[,c(1,4)]
names(HGNC_geneNames) = c("approved.symbol","NCBI.EntrezID")

HGNC_geneNames$approved.symbol=as.character(HGNC_geneNames$approved.symbol)
HGNC_geneNames$NCBI.EntrezID=as.character(HGNC_geneNames$NCBI.EntrezID)
save(HGNC_geneNames, file = "HGNC_geneNames.RData")
