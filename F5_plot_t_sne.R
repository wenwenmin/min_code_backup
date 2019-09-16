library(ggplot2)
library(dplyr)
library(magrittr)
library(ggrepel)
library(Rtsne)
library(ggpubr)
# generate data
set.seed(123456)
N = 5000
D = 100
data.norm = matrix(rnorm(N * D, 2), N)
groups.probs = runif(10)
groups = sample(1:10, N, TRUE, groups.probs/sum(groups.probs))
for (gp in unique(groups)) {
  dev = rep(1, D)
  dev[sample.int(D, 3)] = runif(3, -10, 10)
  data.norm[which(groups == gp), ] = data.norm[which(groups == gp), ] %*% diag(dev)
}
info.norm = tibble(truth = factor(groups)) # a data.frame

# PCA analysis
pca.norm = prcomp(data.norm)
info.norm %<>% cbind(pca.norm$x[, 1:4]) # info.norm = cbind(info.norm,pca.norm$x[, 1:4])

# PCA results
p1 = ggplot(info.norm, aes(x = PC1, y = PC2, colour = truth)) + 
  geom_point(alpha = 0.3) + theme_bw()
p2 = ggplot(info.norm, aes(x = PC3, y = PC4, colour = truth)) + 
  geom_point(alpha = 0.3) + theme_bw()

# T-SNE
tsne.norm = Rtsne(pca.norm$x, pca = FALSE)
# --------------------------------------------------
# tsne_out <- Rtsne(
#   pca.norm$x,
#   dims = 2,
#   pca = FALSE,
#   perplexity = 10,
#   theta = 0.0,
#   max_iter = 1000
# )
# --------------------------------------------------
info.norm %<>% mutate(tsne1 = tsne.norm$Y[, 1], tsne2 = tsne.norm$Y[, 2])
p3 = ggplot(info.norm, aes(x = tsne1, y = tsne2, colour = truth)) + geom_point(alpha = 0.3) + theme_bw()

ggarrange(p1, p2, p3, labels = c("A", "B", "C"), ncol = 2, nrow = 2)

ggsave("F5_tsne_example.png", width = 20, height = 15, units = "cm")