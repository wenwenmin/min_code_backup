# 这是一个详细的案例，采用稀疏逻辑回归做分类问题
# http://www.sthda.com/english/articles/36-classification-methods-essentials/149-penalized-logistic-regression-essentials-in-r-ridge-lasso-and-elastic-net/

library(tidyverse)
library(caret)
library(glmnet)
library(mlbench)

# ------------------------------------------------------------------------------
# Load the data and remove NAs
data("PimaIndiansDiabetes2", package = "mlbench")
PimaIndiansDiabetes2 <- na.omit(PimaIndiansDiabetes2)
# Inspect the data
sample_n(PimaIndiansDiabetes2, 3)

# Split the data into training and test set
set.seed(123)
training.samples <- PimaIndiansDiabetes2$diabetes %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- PimaIndiansDiabetes2[training.samples, ]
test.data <- PimaIndiansDiabetes2[-training.samples, ]


# Dumy code categorical predictor variables
x <- model.matrix(diabetes~., train.data)[,-1]
# Convert the outcome (class) to a numerical variable
y <- ifelse(train.data$diabetes == "pos", 1, 0)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Find the best lambda using cross-validation
set.seed(123) 
cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")

# Fit the final model on the training data
model <- glmnet(x, y, alpha = 1, family = "binomial", lambda = cv.lasso$lambda.min)
# Display regression coefficients
coef(model)
# Make predictions on the test data
x.test <- model.matrix(diabetes ~., test.data)[,-1]
probabilities <- model %>% predict(newx = x.test)
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy
observed.classes <- test.data$diabetes
mean(predicted.classes == observed.classes)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 参数选择的可视化
# Find the optimal value of lambda that minimizes the cross-validation error
# library(glmnet)
# set.seed(123)
# cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
plot(cv.lasso)
cv.lasso$lambda.min

# 该参数一般会比cv.lasso$lambda.min大一些，得到模型更加简洁一些
cv.lasso$lambda.1se
coef(cv.lasso, cv.lasso$lambda.1se)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
## Compute the final model using lambda.min:
# Final model with lambda.min
lasso.model <- glmnet(x, y, alpha = 1, family = "binomial", lambda = cv.lasso$lambda.min)

# Make prediction on test data
x.test <- model.matrix(diabetes ~., test.data)[,-1]
probabilities <- lasso.model %>% predict(newx = x.test)
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy
observed.classes <- test.data$diabetes
mean(predicted.classes == observed.classes)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Compute the final model using lambda.1se:
# Final model with lambda.1se
lasso.model <- glmnet(x, y, alpha = 1, family = "binomial", lambda = cv.lasso$lambda.1se)
# Make prediction on test data
x.test <- model.matrix(diabetes ~., test.data)[,-1]
probabilities <- lasso.model %>% predict(newx = x.test)
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy rate
observed.classes <- test.data$diabetes
mean(predicted.classes == observed.classes)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Compute the full logistic model
# In the next sections, we’ll compare the accuracy obtained with lasso regression 
# against the one obtained using the full logistic regression model (including all predictors).
# Fit the model
full.model <- glm(diabetes ~., data = train.data, family = binomial)
# Make predictions
probabilities <- full.model %>% predict(test.data, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, "pos", "neg")
# Model accuracy
observed.classes <- test.data$diabetes
mean(predicted.classes == observed.classes)
# ------------------------------------------------------------------------------
