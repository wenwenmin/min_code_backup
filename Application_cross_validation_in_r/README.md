# 交叉验证
这个网页很详细的介绍了如何进行交叉验证
Cross-Validation for Predictive Analytics Using R


# 随机森林的交叉验证
Tuning a model is very tedious work. There are lot of combination possible between the parameters. You don't necessarily have the time to try all of them. A good alternative is to let the machine find the best combination for you. There are two methods available:

Random Search
Grid Search
RandomForest(formula, ntree=n, mtry=FALSE, maxnodes = NULL)
Arguments:
- Formula: Formula of the fitted model
- ntree: number of trees in the forest
- mtry: Number of candidates draw to feed the algorithm. By default, it is the square of the number of columns.
- maxnodes: Set the maximum amount of terminal nodes in the forest
- importance=TRUE: Whether independent variables importance in the random forest be assessed
