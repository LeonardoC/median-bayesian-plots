# median-bayesian-plots
Plots for comparing multiple classifiers through a performance measure (AUC) and the results of the Bayesian signed-rank test.

In this repository, we provide a sample R script for visualizing a summary statistic (median) on the performance (AUC) of more than two classifiers, and a summary of the results of the Bayesian signed-rank test. The axes show the median probability of a classifier "wining" and "losing" against the others, as shown in the example figure. We show the median AUC both with color and size (this could be easily changed to average accuracy or other measure).

The code allows to plot one or more experiments in the same figure. We have used this to compare the performance of classifiers in subsets of databases. For example, you may compare the performance of the classifiers in datasets with two classes, against datasets with multiple classes. Notice that the upper plot has five classifiers and the lower one only four; you could use this if you lack results for one or more classifiers, maybe those classifiers cannot work with multiple classes.

The script ![bayesian_plots.R](https://github.com/LeonardoC/median-bayesian-plots/blob/main/bayesian_plots.R) contains the code to generate the figure below. The comments contain instructions for modifying the script, inlcuding where you would normally read your data, and how to plot only one experiment or more than two.

The current example randomly generates the data for AUC and the probabilities independently, so the actual values of median probability of wining/losing and median AUC may not make sense.

![bayesian](https://user-images.githubusercontent.com/4117123/120241881-490d7b00-c229-11eb-91a6-328d82f8142d.png)

A detailed description of the Bayesian signed rank test is given in ![Time for a Change: a Tutorial for Comparing Multiple Classifiers Through Bayesian Analysis](http://jmlr.org/papers/volume18/16-305/16-305.pdf), Alessio Benavoli, Giorgio Corani, Janez Demšar, Marco Zaffalon. Journal of Machine Learning Research, 18 (2017) 1-36.
