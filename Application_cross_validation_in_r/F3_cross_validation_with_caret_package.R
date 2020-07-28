require(RCurl)
require(prettyR)

url <- "https://raw.githubusercontent.com/gastonstat/CreditScoring/master/CleanCreditScoring.csv"
cs_data <- getURL(url)
cs_data <- read.csv(textConnection(cs_data))
# describe(cs_data)


require(caret)

classes <- cs_data[, "Status"]
predictors <- cs_data[, -match(c("Status", "Seniority", "Time", "Age", "Expenses", 
                                 "Income", "Assets", "Debt", "Amount", "Price", "Finrat", "Savings"), colnames(cs_data))]

set.seed(123)
train_set <- createDataPartition(classes, p = 0.8, list = FALSE); train_set[1:5]
str(train_set)

# 拆分出训练样本
train_predictors <- predictors[train_set, ]
train_classes <- classes[train_set]
test_predictors <- predictors[-train_set, ]
test_classes <- classes[-train_set]

# 10折交叉验证的样本索引
set.seed(123)
cv_splits <- createFolds(classes, k = 10, returnTrain = TRUE)
str(cv_splits)

require(glmnet)
require(e1071)


set.seed(123)
cs_data_train <- cs_data[train_set, ]
cs_data_test <- cs_data[-train_set, ]

glmnet_grid <- expand.grid(alpha = c(0,  .1,  .2, .4, .6, .8, 1), lambda = seq(.01, .2, length = 20))
glmnet_ctrl <- trainControl(method = "cv", number = 10)
glmnet_fit <- train(Status ~ ., data = cs_data_train,
                    method = "glmnet",
                    preProcess = c("center", "scale"),
                    tuneGrid = glmnet_grid,
                    trControl = glmnet_ctrl)
glmnet_fit

## Accuracy was used to select the optimal model using  the largest value.
## The final values used for the model were alpha = 0 and lambda = 0.01.

trellis.par.set(caretTheme())
plot(glmnet_fit, scales = list(x = list(log = 2)))
# ------------------------------------------------------------------------------