# create list of packages we need 
packages <- c("ggplot2", "dplyr", "gapminder")
# Load packages
lapply(packages, library, character.only = TRUE)
library(ggpubr)

# ggplot(dat1, aes(x=iter, y=obj)) + geom_line(colour = "black") + geom_point(shape = 21, colour = "black", fill = "gray", size = 1) + 
  labs(title = "Module 1", x = "iteration ", y = "Obj") + mytheme 

get_modularity_bar_fig = function(modularity_dat){
  # ggaplot画图的基本框架，先确定画图的X轴和Y轴分别是什么变量
  fig = ggplot(modularity_dat, mapping=aes(x=cancer,modulariy)) + theme_classic() + xlab(NULL)+
    # 柱状图；aes(fill = method)两种柱关于method设定不同类型；position ="dodge"两个柱并排放
    geom_bar(stat="identity",width=0.9, aes(fill=method), position ="dodge") + 
    #柱状图的两个颜色的设定；expand=c(0,0)使得图和x轴的距离gap为零
    scale_fill_manual(values = c("blue", "gray")) + scale_y_continuous(expand = c(0, 0))+ 
    # X和Y轴的线设置；坐标轴上的小线设置
    theme(axis.line=element_line(size=rel(2)),axis.ticks=element_line(size=rel(2)),
          axis.title = element_text(size = rel(1.3)),
          axis.text = element_text(colour = "black",size=rel(1.2)),
          axis.text.x = element_text(angle = 60, hjust = 1),
          legend.position = c(.8, .9),
          legend.title =element_text(size=1, colour="white"), 
          legend.text=element_text(size=rel(1.3), colour="black"))  +
    labs(size= "Nitrogen",
       x = "My x label",
       y = "My y label",
       title = "Weighted Scatterplot of Watershed Area vs. Discharge and Nitrogen Levels (PPM)")
  return(fig)
}

getEnrichmentBar = function(df,mycolor="green"){
  ###可预先设定因子(展示在X的上的名称)的排序，否则它会按照字母排序
  ###一般R语言会默认安装字母排序展示在图中，而有时候不是我们想要的
  df$method <- factor(df$method, levels = c(as.character(df$method[1]),as.character(df$method[2])))
  # 画一个柱状图，其中参数width=0.6调整柱子粗细，fill=mycolor设定填充的颜色
  p2 = ggplot(data=df, mapping=aes(x=method, y=rat)) + geom_bar(stat="identity",width=0.6,fill=mycolor)
  # expand=c(0,0)使得图和x轴的距离gap为零
  p2 = p2 + theme_classic() + scale_y_continuous(expand = c(0,0))+
    # X,Y轴 以及轴上的小点线的粗细设置
    theme(axis.line=element_line(size=rel(2)))+theme(axis.ticks=element_line(size=rel(2))) + 
    # X,Y轴刻度文字格式设置
    theme(axis.text = element_text(colour = "black",size=rel(1.2)))
  # theme(axis.title = element_text(size = rel(1.3)))
  # 为画柱状图的比较p-value值做准备
  ymax0 = max(df$rat)
  # coord_cartesian坐标轴范围的设定
  p2 = p2 + coord_cartesian(ylim = c(0,ymax0*1.1))
  p2 = p2 + annotate("rect", xmin = 1, xmax = 2, ymin = ymax0*1.1, ymax =ymax0*1.1, alpha=.10,colour = "black",size=rel(1.2))+
    annotate("rect", xmin = 1, xmax = 1, ymin = min(df$rat)+ymax0*0.02, ymax =ymax0*1.1, alpha=.10, colour = "black",size=rel(1.2))+
    annotate("rect", xmin = 2, xmax = 2, ymin = ymax0*1.02, ymax =ymax0*1.1, alpha=.10, colour = "black",size=rel(1.2))
  # 在图上添加文字说明
  # + geom_text(x=1.5, y=560, size=rel(6), label="p<0.001")
  # xlab设定x坐标轴的名称
  p2 = p2 + xlab(NULL) + ylab(NULL)
}

######################################################################
######################################################################
# 例1：bar图的第一个例子---画GOBP的富集分析
# make the base plot and save it in the object "p1"
p1 = ggplot(data=data_graph, mapping=aes(x=country, y=lifeExp, fill="red"))
# width=0.7调整bar宽度
p1 = p1 + geom_bar(stat="identity",width=0.7) + theme_classic()
#去除图和坐标的空虚
p1 = p1 + scale_y_continuous(expand = c(0, 0))
# x和y轴对调
p1 = p1 + coord_flip()
p1 = p1 + theme(axis.text = element_text(colour = "red", size = rel(1.5)))+
  theme(axis.title.x = element_text(size = rel(2))) + 
  theme(axis.title.y = element_text(size = rel(2))) +
  # X和Y轴的线设置
  theme(axis.line  = element_line(size = rel(2),colour = "red")) +
  # 坐标轴上的小线设置
  theme(axis.ticks = element_line(size = 2,colour = "blue"))+
  theme(legend.position = "none")
######################################################################
######################################################################
# 例2：模块中PPI边与随机模块的PPI比较Bar图
df = data.frame(dose=c("Random", "Gene set"),len=c(100, 500))
# 自己设定一个因子的排序，否则它会按照字母排序
df$dose <- factor(df$dose, levels = c("Random","Gene set"))
p2 = ggplot(data=df, aes(x=dose, y=len)) + geom_bar(stat="identity", fill="blue")
p2 = p2 + theme_classic() + scale_y_continuous(expand = c(0, 0))
p2 = p2 + theme(axis.line=element_line(size=rel(2))) + theme(axis.ticks=element_line(size=rel(2)))
p2 = p2 + theme(axis.text = element_text(colour = "black",size=rel(1.2)))
p2 = p2 + theme(axis.title = element_text(size = rel(1.3)))
p2 = p2 + annotate("rect", xmin = 1, xmax = 2, ymin = 530, ymax =530, alpha=.10,colour = "black",size=rel(1.2))+
  annotate("rect", xmin = 1, xmax = 1, ymin = 110, ymax =530, alpha=.10, colour = "black",size=rel(1.2))+
  annotate("rect", xmin = 2, xmax = 2, ymin = 510, ymax =530, alpha=.10, colour = "black",size=rel(1.2))

p2 = p2 +  coord_cartesian(ylim = c(0,600)) + geom_text(x=1.5, y=560, size=rel(6), label="p<0.001")
p2
######################################################################
######################################################################
# 例3：模块的modularity和随机模块的对比bar图
p3 = ggplot(data=data_graph, mapping=aes(x=country, y=lifeExp))
p3 = p3 + geom_bar(stat = "identity", aes(fill = year),position = "dodge") 
p3 = p3 + scale_fill_manual(values = c("blue", "red"))
p3 = p3 + theme_classic() + scale_y_continuous(expand = c(0, 0))
p3 = p3 + theme(axis.line=element_line(size=rel(2))) + theme(axis.ticks=element_line(size=rel(2)))
p3 = p3 + theme(axis.text = element_text(colour = "black",size=rel(1.2)))
p3 = p3 + theme(axis.title = element_text(size = rel(1.3)))
p3 = p3 + theme(axis.text.x = element_text(angle = 60, hjust = 1))
p3 
# display the plot object
######################################################################
######################################################################
ggarrange(p1, p2, p3, labels = c("A", "B", "C"), ncol = 1, nrow = 3)
ggsave("Fun14_figs.png", width = 15, height = 30, units = "cm")
