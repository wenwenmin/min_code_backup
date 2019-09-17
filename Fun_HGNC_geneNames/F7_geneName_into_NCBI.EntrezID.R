load("InputData.RData")
# geneNames 8058
geneNames.EntrezID = rep("",length(geneNames))
############################################################
############################################################
HGNC_geneNames = HGNC_geneNames[which(is.na(HGNC_geneNames$approved.symbol)==F),]
for(i in 1:length(geneNames)){
  flg1 = which(HGNC_geneNames$approved.symbol==geneNames[i])
  flg2 = which(HGNC_geneNames$previous.symbols==geneNames[i])
  if(length(flg1)>0){
    geneNames.EntrezID[i] = HGNC_geneNames$NCBI.EntrezID[flg1[1]] 
    next
  }
  if(length(flg2)>0){
    print(i)
    geneNames.EntrezID[i] = HGNC_geneNames$NCBI.EntrezID[flg2[1]]  
    next
  }
}
############################################################
############################################################
HGNC_geneNames2 = HGNC_geneNames[which(HGNC_geneNames$previous.symbols!=""),]
# previous.symbols = ACTD, DDDC, SSSS
IDs = which(geneNames.EntrezID=="")
for(i in 1:length(IDs)){
  print(i)
  gene = geneNames[IDs[i]]
  for(j in 1:nrow(HGNC_geneNames2)){
    temp = unlist(strsplit(HGNC_geneNames2$previous.symbols[j], split=", "))
    if(gene%in%temp){geneNames.EntrezID[IDs[i]] = HGNC_geneNames2$NCBI.EntrezID[j];break}
  }
}
# IDs
# [1]  6  370  478  555  556  557  562  567  829  863  962 1893 2172 2278 2323 2329 2330 2331 2335 2348 2594 2870 2872
# [24] 2876 2878 2889 2969 2970 2971 2972 2973 2974 2975 2976 2977 2978 2980 2981 3299 3363 3721 3723 3724 3829 3889 4942
# [47] 5165 5717 5781 5940 5941 5943 6066 6800 6893 6942 7122 7464 7530 7636 8051
############################################################
############################################################
# One is empty
# which(geneNames.EntrezID=="") 196
geneNames.EntrezID[196] =  445815
geneNames.symbols.entrezID = data.frame(symbols=geneNames,NCBI.entrezID=geneNames.EntrezID, stringsAsFactors=F)
save(geneNames.symbols.entrezID, file = "Result_camp1Data_geneNames2.RData")
############################################################
############################################################
