## Script name: Bayesian plots for two tests
##
## Author: Leonardo Cañete Sifuentes
##
## Date Created: 2021/05/31
##
## Copyright (c) Leonardo Cañete Sifuentes, 2021

library(dplyr) 
library(tidyr)
library(ggrepel)
library(viridis)

# First experiment -------------------------------------------------------------------------

# Here you should read the results of the Bayesian signed-rank test, which should
# have the same format of the example data frame. Each row shows the probability
# of the classifier in column c1 wining (column pwin) and losing (column plose)
# against the classifier in column c2.

# At this moment, if you have a row with c1 = A and c2 = B, you also need to add
# a row with c2 = B and c1 = B.

classifiers <- LETTERS[1:5]   # We compare five classifiers A - E.
combs <- combn(classifiers,2)

pwin <- runif(ncol(combs), 0, 1)
plose <- runif(ncol(combs), 0, 1-pwin)
probs <- data.frame(c1 = c(combs[1,], combs[2,]), c2=c(combs[2,], combs[1,]), pwin=pwin, plose=plose)

# If your column names do not match, remember to rename them.
# names(probs) <- c("c1", "c2", "pwin", "plose")

# Here you may read the AUCs of the classifiers for each dataset. Each column
# corresponds to a classifier and each row to a dataset. The names of the columns
# should be the name of the classifiers and match the ones in the dataframe probs.
aucs <- data.frame(A=runif(20, 0.5, 1),
                   B=runif(20, 0.5, 1),
                   C=runif(20, 0.5, 1),
                   D=runif(20, 0.5, 1),
                   E=runif(20, 0.5, 1))

# Here we obtain the median AUC of each classifier. You may calculate a different 
# measure or read the measures from a file, as long as the dataframe format matches
# the example. 

median_auc <- apply(aucs, 2, median) %>%
  bind_rows() %>%
  pivot_longer(everything(), names_to = "classifier", values_to = "AUC")

# Even if you use a different measure, keep the same colnames. The labels of the
# plot will not be affected.
# names(median_auc) <- c("classifier", "AUC")


# This dataframe has all the data needed for plotting the first experiment,
# so give it a unique name.
aucs1 <- probs %>% 
  group_by(c1) %>% 
  summarise(pwin=median(pwin), plose = median(plose)) %>%
  rename(classifier = c1) %>%
  left_join(median_auc, by="classifier")

# Second experiment -------------------------------------------------------------------------

# Since the code is the same as in the first experiment, we omit most comments.

# You do not need to have the same classifiers in different experiments.
# In this example, we only generate results for four classifiers.

classifiers <- LETTERS[1:4]   # We compare only four classifiers A - D.
combs <- combn(classifiers,2)

pwin <- runif(ncol(combs), 0, 1)
plose <- runif(ncol(combs), 0, 1-pwin)

probs <- data.frame(c1 = c(combs[1,], combs[2,]), c2=c(combs[2,], combs[1,]), pwin=pwin, plose=plose)

aucs <- data.frame(A=runif(20, 0.5, 1),
                   B=runif(20, 0.5, 1),
                   C=runif(20, 0.5, 1),
                   D=runif(20, 0.5, 1))

median_auc <- apply(aucs, 2, median) %>%
  bind_rows() %>%
  pivot_longer(everything(), names_to = "classifier", values_to = "AUC")

# Remember to give a unique name to this dataframe.
aucs2 <- probs %>% 
  group_by(c1) %>% 
  summarise(pwin=median(pwin), plose = median(plose)) %>%
  rename(classifier = c1) %>%
  left_join(median_auc, by="classifier")

# Join experiment data -------------------------------------------------------------------------

# Here we use the resulting dataframes for each experiment.
dat <- bind_rows("Experiment 1" = aucs1, "Experiment 2" = aucs2, .id = "type")

# You can plot a single experiment.
# dat <- bind_rows("Experiment 1" = aucs1, .id = "type")

# You can add more than two experiments 
#dat <- bind_rows("Experiment 1" = aucs1, "Experiment 2" = aucs2, 
# "Experiment 3" = aucs3,"Experiment 4" = aucs4, .id = "type")

# Plots -------------------------------------------------------------------------
# The x axis limits [-0.05, 1.05] give more space for long classifier names.

# To use a measure different from AUC, you may wish to change the scale limits,
# this should be changed both in scale_color_viridis and scale_size with the
# same values. You should also change the labels color and size in labs, both 
# must have the same values.


ggplot(dat, aes(x=pwin, y = plose, color = AUC, size = AUC)) +
  geom_point()+
  scale_x_continuous(limits = c(-0.05, 1.05), breaks = seq(0, 1, by = 0.2)) + 
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) + 
  scale_color_viridis(limits = c(0.5, 1)) +
  scale_size(limits=c(0.5, 1)) +
  facet_wrap(~type, dir="v", scales='free_x') + 
  geom_text_repel(mapping=aes(x=pwin,y=plose,label=classifier),
                  size = 3, color="black") +
  guides(color=guide_legend(), size = guide_legend()) +
  labs(x = "Median p(win)", y = "Median p(lose)", color="Median AUC", size = "Median AUC") +
  theme_bw()

# ggrepel may give warnings about too many overlaps and some points may be shown
# as unlabeled in the RStudio plot pane. However, when saving the image, the 
# labels will be shown if there is enough space. If there is not enough space,
# consider modifying width and height, or modifying the parementer of geom_text_repel.
ggsave("pwinlose.eps", width=11, height=11)
