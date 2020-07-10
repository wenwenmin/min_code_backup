# create list of packages we need 
packages <- c("ggplot2", "dplyr", "gapminder")
# Load packages
lapply(packages, library, character.only = TRUE)
library(ggpubr)

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
