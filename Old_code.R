---
  title: "Test"
author: "NSharma"
date: "01/06/2020"
output:
  word_document: default
---
  
  This is a test from Google 

This is a test from R Studio

This is a test Tuesday 

Writing the manuscript! 
  
  
  
  
  ```{r setup, include=FALSE,echo=FALSE, warning=FALSE, results='hide', message=FALSE}
knitr::opts_chunk$set(echo = TRUE)

# this script loads the packages and installing them if needed
source("scripts/load_packages.R")

# this script loads the functions into the space
source("scripts/my_scripts.R")

# Loads the local curated data if the data is not there then it will download it 
source("scripts/get_curatData.R")

# Loads Atlas dataset
data(atlas1006)
atlas.pseq <- baseline(atlas1006)
```

## R Markdown

```{r, include=FALSE,echo=FALSE, warning=FALSE, results='hide', message=FALSE}

# User defined variables

# Input the Global Burden of Disease data
data_daly <- 'data/mnd_gbd_daly_csv.csv'
data_prev <- "data/mnd_gbd_prevalence_csv.csv"
data_incid <- "data/mnd_gbd_incidence_csv.csv"

# define the year and the age
gbd.year <-"2017"
gbd.age <- "Age-standardized"

# define the labels for the graphs
mnd.prev.label <- "Prevalence \n(per 100,000)"
mnd.incid.label <- "Incidence \n(per 100,000)"
mnd.daly.label <- "DALY rate\n(per 100,000)"
grp.label <-"MND group"

daly.range <- c(0,60)
prev.range <- c(0,9)
incid.range <- c(0,9)

#### THIS IS THE HIGH AND LOW GROUPS THAT WILL BE USED THROUGHOUT THE SCRIPT If this is the first time then keep these value for the moment
atlas.low <- c("SouthEurope","CentralEurope", "Scandinavia")
atlas.high <- c("US", "UKIE") 

curat.low <- c("DEU","ESP","ITA","AUT","DNK","LUX" )
curat.high <- c("NOR","FIN","FRA","NLD","GBR","USA","CAN","SWE") 



```




```{r,include=FALSE,echo=FALSE, warning=FALSE, results='hide', message=FALSE}
# runs the country prep script 
source("scripts/country_prep.R")
# runs the pseq prep script 
source("scripts/pseq_prep.R")
```



```{r, message=FALSE, warning=FALSE, , echo=FALSE, include=FALSE, results='hide'}

# creates the data.frame from the GBD table based on year and age
# mnd.gbd.sub data is the output from the country_prep.R script 

my.table.data <- mnd.gbd.sub
my.table.data <- my.table.data[my.table.data$year == gbd.year & my.table.data$age == gbd.age , ]
my.table.data <- select (my.table.data, "Region", "location","DALY", "Prevalence", "Incidence")


library(gt)
gt_tbl <- gt(data = my.table.data,rowname_col = "location", groupname_col = "Region")

gt_tbl <- 
  gt_tbl %>%
  tab_header(
    title = "Burden of MND", subtitle = "2017") %>%
  tab_stubhead(label = "Geographical<br>Region")  %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(DALY,Prevalence,Incidence),
    fns = list( "Mean" = "mean"))  %>%
  fmt_number( columns = vars(DALY,Prevalence,Incidence),
              decimals = 2,
              use_seps = FALSE) %>%
  tab_footnote(
    footnote = "from GBD",
    locations = cells_column_labels(columns = vars(DALY,Prevalence,Incidence))
  ) %>%  opt_footnote_marks(marks = "letters") 

gt_tbl

```





```{r}
# plots the graphs ##
#the key inputs are; curat.combined & atlas.curat.combined
#atlas.curat.combined contains the freq for the curated data set when put into Atlas labels


############################### plots the burden over years

myfont <- 18

c1 <- ggplot(curat.combined.agestd, aes(x = year, y = DALY, colour = location)) + 
  geom_line() + 
  ylab(label=mnd.daly.label) + 
  xlab(NULL) + theme(legend.position="none") + ylim(daly.range) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        text = element_text(size = myfont))

c2 <- ggplot(curat.combined.agestd, aes(x = year, y = Prevalence, colour = location)) + 
  geom_line() + 
  ylab(label=mnd.prev.label) + 
  xlab(NULL) + theme(legend.position="none") + ylim(prev.range) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        text = element_text(size = myfont))

c3 <- ggplot(curat.combined.agestd, aes(x = year, y = Incidence, colour = location)) + 
  geom_line() + 
  ylab(label=mnd.incid.label) + 
  xlab("Year") + theme(legend.position="bottom", legend.title = element_blank(), text = element_text(size = myfont))  + ylim(incid.range)   

a1 <- ggplot(atlas.curat.combined.agestd, aes(x = year, y = DALY, colour = Region)) + 
  geom_line() + 
  ylab(label=mnd.daly.label) + 
  xlab(NULL) + theme(legend.position="none") + ylim(daly.range) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        text = element_text(size = myfont))

a2 <- ggplot(atlas.curat.combined.agestd, aes(x = year, y = Prevalence, colour = Region)) + 
  geom_line() + 
  ylab(label=mnd.prev.label) + 
  xlab(NULL) + theme(legend.position="none") + ylim(prev.range) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        text = element_text(size = myfont))

a3 <- ggplot(atlas.curat.combined.agestd, aes(x = year, y = Incidence, colour = Region)) + 
  geom_line() + 
  ylab(label=mnd.incid.label) + 
  xlab("Year") + theme(legend.position="bottom", legend.title = element_blank(), text = element_text(size = myfont))  + ylim(incid.range)

##################### Creates captions #######################
temp <- subset(atlas.curat.combined.agestd, year==gbd.year)
atlas.total.sample <- sum(temp$freq)
curat.total.sample <- sum(temp$curat.atlas.freq)

atlas.total.caption <- paste('Total no. microbiome samples =', atlas.total.sample)
curat.total.caption <- paste('Total no. microbiome samples =', curat.total.sample)
##################### DALY #######################

#Important for the scale
limit <- c(20,50)
at1 <- ggplot(subset(atlas.curat.combined.agestd, year==gbd.year ), aes( area=atlas.freq,fill=DALY, label = Region )) + geom_treemap() +
  scale_fill_scico(palette = "buda", limit = limit)  +
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) + theme(legend.position="right") + labs(fill = mnd.daly.label )

ct1 <- ggplot(subset(curat.combined, year==gbd.year & age == gbd.age ), aes( area=Freq,fill=DALY, label = curat.label )) + geom_treemap() +
  scale_fill_scico(palette = "buda", limit = limit)  +
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) + theme(legend.position="right")  + labs(fill = mnd.daly.label )

##################### Prevalence #######################

limit <- c(1,10)
at2 <- ggplot(subset(atlas.curat.combined.agestd, year==gbd.year ), aes( area=atlas.freq,fill=Prevalence, label = Region )) + geom_treemap() +
  scale_fill_scico(palette = "lapaz", limit = limit)  +
  geom_treemap_text(colour = "black", place = "centre", grow = FALSE) + theme(legend.position="right")  + labs(fill = mnd.prev.label )

ct2 <- ggplot(subset(curat.combined, year==gbd.year & age == gbd.age), aes( area=Freq,fill=Prevalence, label = curat.label )) + geom_treemap() +
  scale_fill_scico(palette = "lapaz")  +
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) + theme(legend.position="right") + labs(fill = mnd.prev.label)

##################### Incidence #######################
limit <- c(1,10)
at3 <- ggplot(subset(atlas.curat.combined.agestd, year==gbd.year ), aes( area=atlas.freq,fill=Incidence, label = Region )) + geom_treemap() +
  scale_fill_scico(palette = "vik", limit = limit)  +
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) + theme(legend.position="right")  + labs(fill = mnd.incid.label,caption = atlas.total.caption )

ct3 <- ggplot(subset(curat.combined, year==gbd.year & age == gbd.age), aes( area=Freq,fill=Incidence, label = curat.label )) + geom_treemap() +
  scale_fill_scico(palette = "vik", limit = limit)  +
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) + theme(legend.position="right") + labs(fill = mnd.incid.label, caption = curat.total.caption )

###################################### #############

curat.combined$hl.label[curat.combined$Prevalence >= 7] <- "HIGH"
curat.combined$hl.label[curat.combined$Prevalence < 7] <- "LOW"
curat.combined$hl.label <- factor(curat.combined$hl.label)

atlas.curat.combined.agestd$hl.label[atlas.curat.combined.agestd$Prevalence >= 7] <- "HIGH"
atlas.curat.combined.agestd$hl.label[atlas.curat.combined.agestd$Prevalence < 7] <- "LOW"
atlas.curat.combined.agestd$hl.label <- factor(atlas.curat.combined.agestd$hl.label)

######### k means #############
# input <- subset(atlas.curat.combined, Year==gbd.year, select = -c(Region,Year,curat.sample,hl.label,atlas.sample))
# input <- subset(atlas.curat.combined, Year==gbd.year, select = c(Prevalence))
# 
# output <- kmeans(input, centers = 2, nstart = 20)
# temp <- kmeans(temo$DALY, 2)
# temo$kmeans <- temp$cluster

##################################




at4 <- ggplot(subset(atlas.curat.combined.agestd, year==gbd.year ), aes( area=atlas.freq,fill=hl.label, label = Region )) + 
  geom_treemap() + 
  scale_color_scico(palette = "vik")+ 
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) +     theme(legend.position="bottom") + 
  labs(fill = mnd.incid.label, caption = atlas.total.caption )

ct4 <- ggplot(subset(curat.combined, year==gbd.year & age == gbd.age), aes( area=Freq,fill=hl.label, label = curat.label )) + 
  geom_treemap() + scale_color_scico(palette = "vik")  +
  geom_treemap_text( colour = "black", place = "centre", grow = FALSE) + 
  theme(legend.position="bottom") + 
  labs(fill = mnd.incid.label, caption = curat.total.caption )


figure.curat.class <- c1 + ct1 + c2 + ct2  + c3 + ct3 +  plot_spacer() + ct4 + 
  plot_layout(ncol = 2) + plot_annotation(tag_levels = 'A') 

figure.atlas.class <- a1 + at1  + a2 + at2  + a3 + at3 +  plot_spacer()+ at4 + 
  plot_layout(ncol = 2)  & 
  theme(plot.tag = element_text(size = 18))

figure.atlas.class
figure.curat.class

save_plot("figure.curat.class.png", figure.curat.class, ncol = 2,base_height = 11.69, base_width = 8.27)
save_plot("figure.atlas.class.png", figure.atlas.class, ncol = 2, base_height = 11.69, base_width = 8.27)


```




```{r}
curat.pseq.subset <- subset_samples(curat.pseq, !is.na(curat.mnd.class) & disease == "healthy" & age_category != "child" & age_category != "newborn" & age_category != "schoolage" & antibiotics_current_use != "yes" )

```





```{r, test_chunk, echo=FALSE, out.height= "20%", dpi=300}

# ATLAS data set
# Generates the meta data
atlas.meta <- alpha_d_atlas(atlas.pseq)

glob_theme <- "Moonrise3"

# generates the country alpha diversity
alpha.p1.at <-ggviolin(atlas.meta, x = "country", y = "Shannon",
                       add = "boxplot", fill = "country", palette = "paired") +
  theme(axis.text.x = element_blank(),axis.ticks = element_blank()) + 
  theme(legend.position="bottom",legend.title = element_blank()) + 
  xlab("") 
# the number in the palettes must equal the number of groups in bmi.pairs

alpha.p2.at <- ggviolin(data=subset(atlas.meta, !is.na(atlas.mnd.class)), x = "atlas.mnd.class", y = "Shannon", add = "boxplot", fill = "atlas.mnd.class", na.rm = TRUE, palette = wes_palette(glob_theme)) 

alpha.p2.at <<- alpha.p2.at + stat_compare_means(comparisons = mnd.pairs) + 
  xlab(grp.label) + 
  theme(legend.position="bottom", axis.text.x = element_blank(),axis.ticks = element_blank()) +
  guides(fill=guide_legend(title=grp.label))

fig.alpha.atlas <- (alpha.p1.at| alpha.p2.at)
save_plot("fig.alpha.atlas.png", fig.alpha.atlas, ncol = 2, base_height = 12, base_width = 4)  


# CURAT data set
curat.meta <- alpha_d_curat(curat.pseq)

# generates the country alpha diversity
alpha.p1.curat <-ggviolin(curat.meta, x = "country", y = "Shannon",
                          add = "boxplot", fill = "country", palette = "paired") +
  theme(axis.text.x = element_blank(),axis.ticks = element_blank()) + 
  theme(legend.position="bottom",legend.title = element_blank()) + 
  xlab("") 
# the number in the palettes must equal the number of groups in bmi.pairs

alpha.p2.curat <- ggviolin(data=subset(curat.meta, !is.na(curat.mnd.class)), x = "curat.mnd.class", y = "Shannon", add = "boxplot", fill = "curat.mnd.class", na.rm = TRUE, palette = wes_palette(glob_theme)) 

alpha.p2.curat <<- alpha.p2.curat + stat_compare_means(comparisons = mnd.pairs) + 
  xlab(grp.label) + 
  theme(legend.position="bottom", axis.text.x = element_blank(),axis.ticks = element_blank()) +
  guides(fill=guide_legend(title=grp.label))

fig.alpha.curat <- (alpha.p1.curat/ alpha.p2.curat)

save_plot("fig.alpha.curat.png", fig.alpha.curat, ncol = 1, base_height = 11.69, base_width = 8.2)  







```

```{r}
mnd_siamcat_gen(atlas.pseq)

#input is siamcat 
siamcat.p <- pseq2siamcat(pseq)
siamcat.tr <- pseq2siamcat(atlas.pseq)

comp <- mnd_siamcat_pred(siamcat.tr,siamcat.p)
#include_graphics("figure1.png")
print(figure)

```




```{r}
source("pre_perma_d_two.R") # I dont think this is required. 
source("perma_d_two.R") 
#pre_perma_d_two(atlas.pseq)
perma_d_two(atlas.pseq)

```




```{r}
# Limit the analysis on core taxa and specific sample group
library(hrbrthemes)
library(gcookbook)
library(tidyverse)
p <- plot_composition(atlas.pseq,
                      taxonomic.level = "Genus",
                      sample.sort = "mnd",
                      x.label = "mnd") +
  guides(fill = guide_legend(ncol = 1)) +
  scale_y_percent() +
  labs(x = "Samples", y = "Relative abundance (%)",
       title = "Relative abundance data",
       subtitle = "Subtitle",
       caption = "Caption text.") + 
  theme_ipsum(grid="Y")
print(p)  




# Averaged by group
p <- plot_composition(atlas.pseq,
                      average_by = "bmi_group", transform = "compositional")
print(p)
```





```{r}
detections <- 10^seq(log10(1), log10(max(abundances(atlas.pseq))/10), length = 10)

library(RColorBrewer)
p <- plot_core(atlas.pseq, plot.type = "heatmap", 
               prevalences = prevalences,
               detections = detections,
               colours = rev(brewer.pal(5, "Spectral")),
               min.prevalence = .2, horizontal = TRUE) 
print(p)
```




```{r}




atlas.pseq.c <- core(atlas.pseq, detection = 0.1/100, prevalence = 50/100)
#pseq.subset <- subset_samples(pseq.c, !is.na(mnd) & disease == "healthy" & age_category != "child" & age_category != "newborn" & age_category != "schoolage" & antibiotics_current_use != "yes")
#pseq.subset <- subset_samples(pseq.c, disease == "healthy" & age_category != "child" & age_category != "newborn" & age_category != "schoolage" )
atlas.pseq.c <- microbiome::transform(atlas.pseq.c, "compositional")

feat=otu_table(atlas.pseq.c)
meta=sample_data(atlas.pseq.c)
#Two ways to create siamcat object:
label <- create.label(meta=sample_data(atlas.pseq.c),
                      label = "mnd",
                      case = c("HIGH"), control = "LOW")
#FRIST WAY
# siamcat <- siamcat(phyloseq=phyloseq, label=label)
siamcat <- siamcat(phyloseq=atlas.pseq.c, label=label)
#SECOND WAY:
# siamcat <- siamcat(feat=feat, label=label, meta=meta)
# siamcat <- siamcat(feat=otu_table, label=label, meta=sample_data(pseq))
# Error in validObject(.Object) : invalid class “phyloseq” object: 
# An otu_table is required for most analysis / graphics in the phyloseq-package

phyloseq <- physeq(siamcat)
otu_tab <- otu_table(phyloseq)
head(otu_tab)




```
## Feature Filtering
Now, we can filter feature with low overall abundance and prevalence.
Since we have quite a lot of microbial species in the dataset at the moment, we can perform unsupervised feature selection using the function filter.features.
```{r}
siamcat <- filter.features(siamcat, cutoff=1e-04, filter.method = 'abundance')
siamcat <- filter.features(siamcat, cutoff=0.05,
                           filter.method='prevalence',
                           feature.type = 'filtered')
```
#### Association Testing ####
Checks for associations of single species with disease suing nonparametric Wilcoxon test.

Associations between microbial species and the label can be tested with the check.associations function. The function computes for each species the significance using a non-parametric Wilcoxon test and different effect sizes for the association (e.g. AUC or fold change).

The check.assocation function calculates the significance of enrichment and metrics of association (such as generalized fold change and single-feautre AUROC).

The function produces a pdf file as output, since the plot is optimized for a landscape DIN-A4 layout, but can also used to plot on an active graphic device, e.g. in RStudio. The resulting plot then looks like that:
  ```{r}
library(progress)
library(pROC)
library(RColorBrewer)
siamcat <- check.associations(
  siamcat,
  sort.by = 'fc',
  fn.plot = NULL, #    fn.plot = 'assocMND_healthy_low_high.pdf',
  alpha = 0.1,
  max.show = 50,
  mult.corr = "fdr",
  detect.lim = 10 ^-6,
  plot.type = "quantile.box",
  panels = c("fc", "prevalence", "auroc"))
```

Confounders are checked with the function check.confounders, which produces a plot for each possible confounder in the metadata and diverts the output into a pdf-file.

```{r}
#check.confounders(siamcat,
#    fn.plot = 'conf_checkMND_healthy.pdf', meta.in = c("mnd", "gender", "age_category"))
check.confounders(siamcat,
                  fn.plot = 'conf_checkMND_healthy_low_high.pdf')
#check.confounders(siamcat,
#  fn.plot = 'conf_checkMND_healthy_app.pdf', meta.in = c("mnd", "age_category"))
```
#### Data Normalization

Data normalization is performed with the normalize.features function. Here, we use the log.unit method, but several other methods and customization options are available (please check the documentation).

Getting all data on the same scale: if the scales for different features are wildly different, this can have a knock-on effect on your ability to learn (depending on what methods you're using to do it). Ensuring standardised feature values implicitly weights all features equally in their representation.

```{r}
siamcat <- normalize.features(
    siamcat,
    norm.method = "log.unit",
    norm.param = list(
        log.n0 = 1e-06,
        n.p = 2,
        norm.margin = 1
    )
)
siamcat <- normalize.features(siamcat, norm.method = 'log.std', norm.param = list(log.n0=1e-06, sd.min.q=0))
```
#### Perpare Cross-Validation

https://www.youtube.com/watch?v=fSytzGwwBVw

Cross-Validation is basically how we decide which machine learning method would be best for our data set. CV allows us to compare different machine learning methods and get a sense of how well they will work in practice.

Examples of machine learning methods:
1. Logistic Regression
2. K-nearest neighbours
3. Support Vector Machines (SVM) ...etc.

Need to do 2 things with collected data:
1. Estimate parameters for machine learning methods. (training algorithm)
2. Evaluate how well the machine learning method works. (testing algorithm)

Terrible approach to use ALL the data to train algorithm bc wouldn't have any data left to test algorithm. - Data separated into blocks, different block combinations used to train model.




Preparation of the cross-validation fold is a crucial step in machine learning. SIAMCAT greatly simplifies the set-up of cross-validation schemes, including stratification of samples or keeping samples inseperable based on metadata. For this small example, we choose a twice-repeated 5-fold (no. of blocks) cross-validation scheme. The data-split will be saved in the data_split slot of the siamcat object.
```{r}
siamcat <-  create.data.split(
  siamcat,
  num.folds = 10,
  num.resample = 10
)
```
#### Model Training

The actual model training is performed using the function train.model. Again, multiple options for customization are available, ranging from the machine learning method to the measure for model selection or customizable parameter set for hyperparameter tuning.
```{r}
#library(randomForest)
siamcat <- train.model(
  siamcat,
  method = "lasso"
)
#siamcat <- train.model(
#    siamcat,
#    method = "enet"
#)
#siamcat <- train.model(
#    siamcat,
#    method = "ridge"
#)
#siamcat <- train.model(
#    siamcat,
#    method = "lasso_ll"
#)
#siamcat <- train.model(
#    siamcat,
#    method = "ridge_ll"
#)
#siamcat <- train.model(
#    siamcat,
#    method = "randomForest"
#)
```

The models are saved in the model_list slot of the siamcat object. The model building is performed using the mlr R package. All models can easily be accessed.
```{r}
# get information about the model type
model_type(siamcat)
# access the models
models <- models(siamcat)
models[[1]]
```

#### Make Predicitions

Using the data-split and the models trained in previous step, we can use the function make.predictions in order to apply the models on the test instances in the data-split. The predictions will be saved in the pred_matrix slot of the siamcat object.

```{r}
siamcat <- make.predictions(siamcat)
pred_matrix <- pred_matrix(siamcat)
head(pred_matrix)
```

#### MODEL Evaluation and Interpretation ####

In the final part, we want to find out how well the model performed and which microbial species had been selected in the model. In order to do so, we first calculate how well the predictions fit the real data using the function evaluate.predictions. This function calculates the Area Under the Receiver Operating Characteristic (ROC) Curve (AU-ROC) and the Precision Recall (PR) Curve for each resampled cross-validation run.

```{r}
siamcat <-  evaluate.predictions(siamcat)
```
#### Evaluation Plot

To plot the results of the evaluation, we can use the function model.evaluation.plot, which produces a pdf-file showing the ROC and PR Curves for the different resamples runs as well as the mean ROC and PR Curve.

```{r}
model.evaluation.plot(siamcat, fn.plot = 'eval_plot.pdf')
```

#### Interpretation Plot
Displays importance of individual features in the classification model

The final plot produced by SIAMCAT is the model interpretation plot, created by the model.interpretation.plot function. The plot shows for the top selected features the:
  
  - model weights (and how robust they are, i.e. in what proportion of models have they been incorporated) as a barplot

- a heatmap with the z-scores or fold changes for the top selected features

- a boxplot showing the proportions of weight per model which is captured by the top selected features.

Additionally, the distribution of metadata is shown in a heatmap below.

The function again produces a pdf-file optimized for a landscape DIN-A4 plotting region.

```{r}
# max.show = maximum number of features to be shown in the model interpretation plot, defaults to 50
model.interpretation.plot(
  siamcat, 
  fn.plot = 'interpretationMND_healthy_lowvhigh.pdf',
  color.scheme = "BrBG",
  consens.thres = 0.5,
  heatmap.type = "zscore",
  limits = c(-3, 3), detect.lim = 1e-09,
  max.show = 50, prompt=TRUE, verbose = 1)
#Doesn't work when trying to specify variables included
#model.interpretation.plot(
#    siamcat, 
#    meta.in = c("mnd", "gender", "age_category"),
#    fn.plot = 'interpretationMND_test.pdf',
#   color.scheme = "BrBG",
#    consens.thres = 0.5,
#    heatmap.type = "zscore",
#    limits = c(-3, 3), detect.lim = 1e-06,
#    max.show = 50, prompt=TRUE, verbose = 3)
```





#### More association testing
Confounders can lead to biases in association testing. We can extract the association metrics to compare in scatter plot
```{r}
siamcat.lasso <- train.model(
  siamcat,
  method = "lasso"
)
siamcat.lasso <- make.predictions(siamcat.lasso)
siamcat.lasso <- evaluate.predictions(siamcat.lasso)
siamcat.enet <- train.model(
  siamcat,
  method = "enet"
)
siamcat.enet <- make.predictions(siamcat.enet)
siamcat.enet <- evaluate.predictions(siamcat.enet)
siamcat.ridge <- train.model(
  siamcat,
  method = "ridge"
)
siamcat.ridge <- make.predictions(siamcat.ridge)
siamcat.ridge <- evaluate.predictions(siamcat.ridge)
siamcat.lll <- train.model(
  siamcat,
  method = "lasso_ll"
)
siamcat.lll <- make.predictions(siamcat.lll)
siamcat.lll <- evaluate.predictions(siamcat.lll)
siamcat.rl <- train.model(
  siamcat,
  method = "ridge_ll"
)
siamcat.rl <- make.predictions(siamcat.rl)
siamcat.rl <- evaluate.predictions(siamcat.rl)
siamcat.rf <- train.model(
  siamcat,
  method = "randomForest"
)
siamcat.rf <- make.predictions(siamcat.rf)
siamcat.rf <- evaluate.predictions(siamcat.rf)
model.evaluation.plot("lasso"=siamcat.lasso,
                      "enet"=siamcat.enet, "ridge"=siamcat.ridge, "lasso_ll"=siamcat.lll, "ride_ll"=siamcat.rl, fn.plot = "eval_plot_all.pdf")
```








