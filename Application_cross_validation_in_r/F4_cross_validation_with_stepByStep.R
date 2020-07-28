# Cross-Validation for Predictive Analytics Using R
# ------------------------------------------------------------------------------
# Generate the training and test samples
seed <- 1809
set.seed(seed)
gen_data <- function(n, beta, sigma_eps) {
  eps <- rnorm(n, 0, sigma_eps)
  x <- sort(runif(n, 0, 100))
  X <- cbind(1, poly(x, degree = (length(beta) - 1), raw = TRUE))
  y <- as.numeric(X %*% beta + eps)
  
  return(data.frame(x = x, y = y))
}

# Fit the models
require(splines)
n_rep <- 100
n_df <- 30
df <- 1:n_df
beta <- c(5, -0.1, 0.004, -3e-05)
n_test <- 10000
sigma_eps <- 0.5

# 得到训练样本100
n_train <- 100
xy <- gen_data(n_train, beta, sigma_eps)
x <- xy$x
y <- xy$y

# ------------------------------------------------------------------------------
fitted_models <- apply(t(df), 2, function(degf) lm(y ~ ns(x, df = degf)))
mse <- sapply(fitted_models, function(obj) deviance(obj)/nobs(obj))

n_test <- 10000
xy_test <- gen_data(n_test, beta, sigma_eps)
pred <- mapply(function(obj, degf) predict(obj, data.frame(x = xy_test$x)), fitted_models, df)
te <- sapply(as.list(data.frame(pred)), function(y_hat) mean((xy_test$y - y_hat)^2))

n_folds <- 10
folds_i <- sample(rep(1:n_folds, length.out = n_train))
cv_tmp <- matrix(NA, nrow = n_folds, ncol = length(df))
## 又把训练集合分成10折来处理
for (k in 1:n_folds) {
  test_i <- which(folds_i == k)
  train_xy <- xy[-test_i, ]
  test_xy <- xy[test_i, ]
  x <- train_xy$x
  y <- train_xy$y
  fitted_models <- apply(t(df), 2, function(degf) lm(y ~ ns(x, df = degf)))
 
  x <- test_xy$x
  y <- test_xy$y
  pred <- mapply(function(obj, degf) predict(obj, data.frame(ns(x, df = degf))), 
                 fitted_models, df)
  
  cv_tmp[k, ] <- sapply(as.list(data.frame(pred)), function(y_hat) mean((y - y_hat)^2))
}
cv <- colMeans(cv_tmp)
# 说明：cv_tmp是一个10行30列的矩阵，10代表是10折，30对应的是多项式的度从1到30

# ------------------------------------------------------------------------------
# 画图
require(Hmisc)

plot(df, mse, type = "l", lwd = 2, col = gray(0.4), ylab = "Prediction error", 
     xlab = "Flexibilty (spline's degrees of freedom [log scaled])", 
     main = paste0(n_folds, "-fold Cross-Validation"), ylim = c(0.1, 0.8), log = "x")

lines(df, te, lwd = 2, col = "darkred", lty = 2)

cv_sd <- apply(cv_tmp, 2, sd)/sqrt(n_folds)
errbar(df, cv, cv + cv_sd, cv - cv_sd, add = TRUE, col = "steelblue2", pch = 19, lwd = 0.5)

lines(df, cv, lwd = 2, col = "steelblue2")
points(df, cv, col = "steelblue2", pch = 19)
legend(x = "topright", legend = c("Training error", "Test error", "Cross-validation error"), 
       lty = c(1, 2, 1), lwd = rep(2, 3), col = c(gray(0.4), "darkred", "steelblue2"), 
       text.width = 0.4, cex = 0.85)
# ------------------------------------------------------------------------------
