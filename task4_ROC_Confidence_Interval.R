# 绘制ROC曲线95%置信区间
# 主要函数为ci.se，对roc进行抽样
library(pROC)
# library(ROCR)
data(aSAH)

# ------------------------------------------------------------------------------
# aSAH$outcom
# Good Good Good Good Poor Poor Good Poor ...
# aSAH$s100b
# [1] 0.13 0.14 0.10 0.04 0.13 0.10 0.47 ...

## 1 给出ROC和AUC值95% CI
rocobj <- plot.roc(aSAH$outcome, 
                   aSAH$s100b,
                   main="Confidence intervals", 
                   percent=T,
                   ci=TRUE, # compute AUC (of AUC by default)
                   print.auc=TRUE) # print the AUC (will contain the CI)

# AUC值95% CI
auc <- auc(rocobj)[1]
auc_low <- ci(rocobj,of="auc")[1]
auc_high <- ci(rocobj,of="auc")[3]
auc_full <- paste("AUC:",round(auc,digits = 3),"(", round(auc_low,digits = 3),",",round(auc_high,digits = 3),")",sep = "")
print(auc_full)

# ------------------------------------------------------------------------------
## 2 思考：如何才能计算AUC的置信区间呢？通过bootstrap方法
# 2000 stratified bootstrap replicates
rocobj <- plot.roc(aSAH$outcome, 
                   aSAH$s100b,
                   main="Confidence intervals", 
                   percent=T, # 
                   ci=TRUE, # compute AUC (of AUC by default)
                   print.auc=TRUE) # print the AUC (will contain the CI)

# 只有当percent=T才可正确执行下面语句
ciobj <- ci.se(rocobj, # CI of sensitivity
               specificities = seq(0, 100, 5)) # over a select set of specificities

plot(ciobj, type="shape", col="#1c61b6AA") # plot as a blue shape
#plot(ci(rocobj, of="thresholds", thresholds="best")) # add one threshold

# ------------------------------------------------------------------------------
## 3 用ggplot2画ROC曲线
library(ggplot2)
ggroc(rocobj, color="red",size=1) + theme_bw() +
  geom_segment(aes(x = 1, y = 0, xend = 0, yend = 1), colour='grey', linetype = 'dotdash') +
  theme(plot.title = element_text(hjust = 0.5),
        legend.justification=c(1, 0), legend.position=c(.95, .05),
        #legend.title=title,
        legend.background = element_rect(fill=NULL, size=0.5, linetype="solid", colour ="black")) +
  labs(x="Specificity",y="Sensitivity")

# ------------------------------------------------------------------------------
## 在一个图上画多个ROC曲线
library(pROC)
library(ggplot2)

roc.list <- roc(outcome ~ s100b + ndka + wfns, data = aSAH)
g.list <- ggroc(roc.list)

ggroc(roc.list, aes = c("linetype"), legacy.axes = TRUE)+ 
  labs(x = "1 - Specificity", y = "Sensitivity", linetype="XX") + 
  scale_linetype_discrete(labels=c("Mean Gonial","Gonial Angle Left","Gonial Angle Right")) 
# ------------------------------------------------------------------------------