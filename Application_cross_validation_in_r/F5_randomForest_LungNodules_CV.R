library(tidyverse)
library(glmnet)
library(caret)
library(cvAUC)
library(plotROC)
library(ggplot2)
# library("ggpubr")
# ------------------------------------------------------------------------------
load("../Data/LungNoduleData.RData")

data$sex = factor(data$sex)
data$density = factor(data$density)
# ------------------------------------------------------------------------------
# Split the data into training and test set
set.seed(123)
training.samples <- data$y %>% 
  createDataPartition(p = 0.7, list = FALSE)
train.data  <- data[training.samples, ]
test.data <- data[-training.samples, ]

# ------------------------------------------------------------------------------
# 得到训练数据
# Dumy code categorical predictor variables
x <- model.matrix(y~., train.data)[,-1]
# Convert the outcome (class) to a numerical variable
y <- ifelse(train.data$y == "1", 1, 0)
# ------------------------------------------------------------------------------
# Make predictions on the test data
x.test <- model.matrix(y ~., test.data)[,-1]
test_y = ifelse(test.data$y == "1", 1, 0)
# ------------------------------------------------------------------------------
#使用交叉验证选择参数mtry
# Number of variables randomly sampled as candidates at each split. 
library(randomForest)
my_mtry = c(10:30)
n_folds <- 10
folds_i <- sample(rep(1:n_folds, length.out = length(y)))
cv_tmp <- matrix(NA, nrow = n_folds, ncol = length(my_mtry))
for (k in 1:n_folds) {
  test_i <- which(folds_i == k)
  
  kfold_train_x = x[-test_i, ]
  kfold_train_y = y[-test_i]
  
  kfold_test_x = x[test_i, ]
  kfold_test_y = y[test_i]
  
  for(j in 1:length(my_mtry)){
    set.seed(123)
    RFS.fit = randomForest(kfold_train_x, factor(kfold_train_y), mtry = my_mtry[j],
                           importance=TRUE, prox=TRUE, ntree=500) 
    # predict probabilities
    pre.out = predict(RFS.fit, newdata=kfold_test_x, type="prob")
    RF_pre_p = pre.out[,2]
    
    cv_tmp[k,j] = AUC(RF_pre_p, kfold_test_y) 
    print(cv_tmp)
  }
}
# ------------------------------------------------------------------------------
# 选择最好的参数，在所有训练样本上训练RF模型
boxplot(cv_tmp)
cv <- colMeans(cv_tmp)
set.seed(123)
RFS.fit = randomForest(x, factor(y), mtry = my_mtry[which.max(cv)], importance=TRUE, prox=TRUE, ntree=500) 
varImpPlot(RFS.fit, type=2, n.var=20, scale=FALSE, main="important_features")
# ------------------------------------------------------------------------------
# Make predictions on the test data
x.test <- model.matrix(y ~., test.data)[,-1]
test_y = ifelse(test.data$y == "1", 1, 0)
# predict probabilities
pre.out = predict(RFS.fit, newdata=x.test, type="prob")
RF_pre_p = pre.out[,2]
auc = AUC(RF_pre_p, test_y);print(auc)
# ------------------------------------------------------------------------------
# 画AUC曲线
test_res = data.frame(test_y = test_y, pre_p = RF_pre_p, stringsAsFactors = FALSE)
basicplot = ggplot(test_res, aes(d = test_y, m = pre_p)) + geom_roc(n.cuts = 0) + style_roc(theme = theme_grey)
fig = basicplot +  annotate("text", x = .9, y = .1, label = paste("AUC =", round(calc_auc(basicplot)$AUC, 4)))
ggsave("Fig_7.png", width = 8, height = 8, units = "in")
# ------------------------------------------------------------------------------
colnames(cv_tmp) =factor(my_mtry)
# boxplot
dat <- stack(as.data.frame(cv_tmp))
dat$ind = factor(dat$ind, levels=row.names(ResMat))
fig2 = ggplot(dat, aes(x=ind, y=values, color=ind)) +
  geom_boxplot(size=1.2) +
  theme(axis.line=element_line(size=rel(2)),
        axis.ticks=element_line(size=rel(2)),
        axis.title = element_text(size = rel(1.3)),
        axis.text = element_text(colour = "black",size=rel(1.2)),
        axis.text.x = element_text(angle = 30, hjust = 1),
        legend.position = "none",
        legend.title =element_text(size=1, colour="white"),
        legend.text=element_text(size=rel(1.3), colour="black")) +
  labs(title = NULL, x = "mtry: number of variables at each split", y = "AUC")
fig2
ggsave("Fig_8.png", width = 8, height = 8, units = "in")
# ------------------------------------------------------------------------------