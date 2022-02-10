siamcat_modelbuilder <- function(siamcat) {
# Model Building
# Normalise Features
siamcat <- normalize.features(
  siamcat,
  norm.method = "log.unit",
  norm.param = list(
    log.n0 = 1e-06,
    n.p = 2,
    norm.margin = 1
  )
)

siamcat <-  create.data.split(
  siamcat,
  num.folds = 10,
  num.resample = 10
)

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


# Highest ROC value
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


# Doesn't work
# siamcat.rl <- train.model(
#     siamcat,
#     method = "ridge_ll"
# )
# siamcat.rl <- make.predictions(siamcat.rl)
# siamcat.rl <- evaluate.predictions(siamcat.rl)



# siamcat.rf <- train.model(
#     siamcat,
#     method = "randomForest"
# )
# siamcat.rf <- make.predictions(siamcat.rf)
# siamcat.rf <- evaluate.predictions(siamcat.rf)


# this plot helps us evaluate which ML method is best suited for this data
model.evaluation.plot("lasso"=siamcat.lasso,
                      "enet"=siamcat.enet, "ridge"=siamcat.ridge, "lasso_ll"=siamcat.lll, fn.plot = "output/SIAMCAT_allmodels_eval_plot_all_cur_19.pdf")

}