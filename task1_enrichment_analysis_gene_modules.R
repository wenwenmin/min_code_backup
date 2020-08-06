# KEGG term中基因与被考虑的基因取交集
terms.preprocessing = function(PathwayGeneSets,genes.entrezId){
  termNum = length(PathwayGeneSets)
  index = rep(TRUE,termNum)
  for(k in 1:termNum){
    gene.set = PathwayGeneSets[[k]]
    # length(gene.set) + length(genes.entrezId) - length(unique(c(gene.set,genes.entrezId)))
    overlap.num = sum(gene.set%in%genes.entrezId)
    # Filter out functional sets with more than 300 genes or fewer than 5 genes
    # if(overlap.num<5|overlap.num>1000){index[k] = FALSE;next}
    PathwayGeneSets[[k]] = gene.set[gene.set%in%genes.entrezId]
  }
  return(PathwayGeneSets[index])
}

get.enrichment.list = function(KEGG.PathwayGeneSets2, Gene.Modules, genes.entrezId){
  table = list()
  for(kk in 1:length(Gene.Modules)){
    module.gene.set = Gene.Modules[[kk]]
    pvalues = NULL
    for(i in 1:length(KEGG.PathwayGeneSets2)){
      term.gene.set = KEGG.PathwayGeneSets2[[i]]
      k = sum(module.gene.set%in%term.gene.set)
      M = length(term.gene.set)
      N = length(genes.entrezId)
      n = length(module.gene.set)
      pvalues[i] = phyper(k-1,M, N-M, n, lower.tail=FALSE)
      # e.g. phyper(29,165,423-165,46,lower.tail=FALSE)
    }
    # Compute the q-values using R package (q-value)
    # http://svitsrv25.epfl.ch/R-doc/library/qvalue/html/qvalue.html
    # pvalues.adjust = round(p.adjust(pvalues, "BH"), 4)
    # pvalues = round(pvalues, 4)
    
    # scientific notation
    # pvalues.adjust = format(p.adjust(pvalues, "BH"), digits = 4, scientific = TRUE)
    # pvalues = format(pvalues, digits = 4, scientific = TRUE)
    
    pvalues.adjust = p.adjust(pvalues, "BH")
    pvalues = pvalues

    enrichment.score = data.frame(pvalues = pvalues, pvalues.adjust = pvalues.adjust)
    row.names(enrichment.score) = names(KEGG.PathwayGeneSets2)
    table[[kk]] = enrichment.score
  }
  return(table)
}

get.term.table = function(modules.terms){
  # Input: modules.terms = ESPCA.enrichment.result[["KEGG"]]
  Term.Table = NULL 
  for(i in 1:length(modules.terms)){
    temp = modules.terms[[i]]
    
    nn = length(which(temp$pvalues.adjust<0.05))
    if(nn==0) next
    
    Res1 = temp[which(temp$pvalues.adjust<0.05),]
    Res2 = cbind(terms=row.names(Res1), Res1)
    Res3 = cbind(PC.ID = rep(paste("module", i, sep = ""),nn), Res2)
    Res4 = Res3[order(Res3$pvalues.adjust),]
    rownames(Res4) = NULL
    
    Term.Table = rbind(Term.Table, Res4)
  }
  Term.Table$PC.ID = as.character(Term.Table$PC.ID)
  Term.Table$terms = as.character(Term.Table$terms)
  
  return(Term.Table)
}

get.Num.enriched.term = function(ESPCA.enrichment.result){
  num.modules = length(ESPCA.enrichment.result[[1]]) # 20 modules
  table = matrix(0, nrow =num.modules, ncol = length(ESPCA.enrichment.result))
  colnames(table) = names(ESPCA.enrichment.result) 
  
  for(k in 1:length(ESPCA.enrichment.result)){
    modules.terms = ESPCA.enrichment.result[[k]]
    for(i in 1:length(modules.terms)){
      temp = modules.terms[[i]]
      table[i,k] = length(which(temp$pvalues.adjust<0.05))
    }
  }
  
  table2 = cbind(Module.ID = paste("module", 1:num.modules, sep = ""), table)
  return(table2)
}

GeneModules.EnrichmentAnalysis = function(modules_information,known_functional_sets){
  
  Gene.Modules = modules_information$Gene.Modules
  genes.entrezId = modules_information$AllConsideredGenes.entrezId #ESPCA identified modules with 10399
  KEGG.PathwayGeneSets = known_functional_sets$KEGG.PathwayGeneSets
  GOBP.PathwayGeneSets = known_functional_sets$GOBP.PathwayGeneSets
  reactome.PathwayGeneSets = known_functional_sets$reactome.PathwayGeneSets
  
  
  Pathway.terms.final = list()
  Pathway.terms.final[["KEGG.terms"]] = terms.preprocessing(KEGG.PathwayGeneSets,genes.entrezId) # genes.entrezId 10399
  Pathway.terms.final[["GOBP.terms"]] = terms.preprocessing(GOBP.PathwayGeneSets,genes.entrezId)
  Pathway.terms.final[["reactome.terms"]] = terms.preprocessing(reactome.PathwayGeneSets,genes.entrezId)
  
  
  enrichment.result = list() 
  enrichment.result[["KEGG"]] = get.enrichment.list(Pathway.terms.final[["KEGG.terms"]], Gene.Modules, genes.entrezId)
  enrichment.result[["GOBP"]] = get.enrichment.list(Pathway.terms.final[["GOBP.terms"]], Gene.Modules, genes.entrezId)
  enrichment.result[["reactome"]] = get.enrichment.list(Pathway.terms.final[["reactome.terms"]], Gene.Modules, genes.entrezId)
  
  
  KEGGTerm.Table = get.term.table(enrichment.result[["KEGG"]])
  GOBPTerm.Table = get.term.table(enrichment.result[["GOBP"]])
  reactomeTerm.Table = get.term.table(enrichment.result[["reactome"]])
  modules.StatisticalResults = get.Num.enriched.term(enrichment.result)
  
  Res = list(KEGGTerm.Table=KEGGTerm.Table,
             GOBPTerm.Table=GOBPTerm.Table,
             reactomeTerm.Table=reactomeTerm.Table,
             modules.StatisticalResults=modules.StatisticalResults)
  return(Res)
}

############################################################################
print("Enrichment analysis of gene modules")
setwd("C:/Users/闵老师/Desktop/TCGA/Result_EnrichmentAnalysis/")
load("task1_InputData_EnrichmentAnalysis.RData")
# known_functional_sets = list(KEGG.PathwayGeneSets=KEGG.PathwayGeneSets,
#                              GOBP.PathwayGeneSets=GOBP.PathwayGeneSets,
#                              reactome.PathwayGeneSets=reactome.PathwayGeneSets)
# 
# modules_information.ToyExample = list(Gene.Modules=ESPCA_Gene.Modules,
#                                       AllConsideredGenes.entrezId=ESPCA_AllConsideredGenes.entrezId)
# save(modules_information.ToyExample, known_functional_sets, file = "InputData_EnrichmentAnalysis.RData")

Res = GeneModules.EnrichmentAnalysis(modules_information.ToyExample,known_functional_sets)

write.csv(Res$KEGGTerm.Table[,c(1,2,4)], file = "Table of KEGG Terms from all modules.csv", row.names = F, quote = F)
write.csv(Res$GOBPTerm.Table[,c(1,2,4)], file = "Table of GOBP Terms from all modules.csv", row.names = F, quote = F)
write.csv(Res$reactomeTerm.Table[,c(1,2,4)], file = "Table of reactome Terms from all modules.csv", row.names = F, quote = F)
write.csv(Res$modules.StatisticalResults, file = "Table of Number_of_Enriched_terms from all modules.csv", row.names = F, quote = TRUE)










