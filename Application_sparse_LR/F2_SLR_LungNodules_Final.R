library(tidyverse)
library(glmnet)
library(caret)
library(cvAUC)
library(plotROC)
library(ggplot2)
# ------------------------------------------------------------------------------
load("../Data/LungNoduleData.RData")

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
# Find the best lambda using cross-validation
set.seed(123) 
# alpha=1 is the lasso penalty, and alpha=0 the ridge penalty.
cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
plot(cv.lasso)

# ------------------------------------------------------------------------------
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 1, family = "binomial", lambda = cv.lasso$lambda.min)

# Display regression coefficients
est_beta = coef(model); f_name = row.names(est_beta)
nonzero_beta = data.frame(f_name=f_name[which(est_beta!=0)], 
                          beta = as.matrix(est_beta[which(est_beta!=0)]))
nonzero_beta$beta2 = round(nonzero_beta$beta,5)

# ------------------------------------------------------------------------------
# Make predictions on the test data
x.test <- model.matrix(y ~., test.data)[,-1]
# predict probabilities
pre_p = predict(model, newx = x.test, type="response")
test_y = ifelse(test.data$y == "1", 1, 0)
auc = AUC(pre_p, test_y) # 0.7676951

# ------------------------------------------------------------------------------
# 画AUC曲线
test_res = data.frame(test_y = test_y, pre_p = pre_p, stringsAsFactors = FALSE)
basicplot = ggplot(test_res, aes(d = test_y, m = pre_p)) + geom_roc(n.cuts = 0) + style_roc(theme = theme_grey)
fig = basicplot +  annotate("text", x = .9, y = .1, label = paste("AUC =", round(calc_auc(basicplot)$AUC, 4))) 
fig 
# ------------------------------------------------------------------------------
