# 交叉验证
这个网页很详细的介绍了如何进行交叉验证
Cross-Validation for Predictive Analytics Using R
http://www.milanor.net/blog/cross-validation-for-predictive-analytics-using-r/


# 随机森林的交叉验证
https://www.guru99.com/r-random-forest-tutorial.html
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

## 直接通过包完成
方式1
rgcv: Cross validation, n-fold for random forest in ranger (RG)

方式2
The caret Package
在caret这个包中，包含非常多的模型，大约有200个模型用于分类和回归
The aim of the caret package (acronym of classification and regression training) is to provide a very general and efficient suite of commands for building and assessing predictive models. It allows to compare the predictive accuracy of a multitude of models (currently more than 200), including the most recent ones from machine learning. The comparison of different models can be done using cross-validation as well as with other approaches. The package also provides many options for data pre-processing.
http://topepo.github.io/caret/available-models.html 该网页展示caret可以嵌套进去的所有包。。。。

https://github.com/gastonstat/CreditScoring
这里例子分析的也非常精彩

## 能否写成一个一般的模式
