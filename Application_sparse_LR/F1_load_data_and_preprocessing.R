library(openxlsx) 

lung_nodules_raw_data = read.xlsx("../Data/LungNoduleData.xlsx")
                  
original_features = which(lung_nodules_raw_data[2, ] == "original")

per_features = c(7, 9:12)

lung_data = lung_nodules_raw_data[,c(per_features,original_features)]
lung_data = lung_data[-c(1,2),]

y = lung_data$benign_malignant # "0" = benign (良性) and "1" = Malignant (恶性)
X = lung_data; X$benign_malignant = NULL
  
# ------------------------------------------------------------------------------
# Convert all variable types to numeric
X <- as.data.frame(apply(X, 2, as.numeric))  
# Print classes of all colums
# sapply(X, class)                                
# ------------------------------------------------------------------------------
data = cbind(y,X)
data$y = factor(y)
# ------------------------------------------------------------------------------
# 有不少年龄是零的情况，填充用平均值
data$age[which(data$age==0)] = mean(data$age[which(data$age!=0)]) # 54.8
save(lung_nodules_raw_data, data, file = "../Data/LungNoduleData.RData")
# ------------------------------------------------------------------------------

