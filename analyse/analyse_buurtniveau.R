
data <- read.csv("index.csv", stringsAsFactors=TRUE)

buurtgegevens <- read.csv("../buurtgegevens/buurtgegevens.csv", 
  stringsAsFactors=TRUE)


# store the variables in buurtgegevens
buurtvars <- names(buurtgegevens)[-1]

# link neighbourhood variables to data
data$geoid <- as.integer(substr(data$buurt_code, 7, 9))
data <- merge(data, buurtgegevens, all.x=TRUE, by.x="geoid", by.y="GEOITEM")

add_one <- function(variable, data, predictors) {
 
  formula0 <- as.formula(paste0(variable, " ~ 1"))
  model0 <- lm(formula0, data=data)
  
  formula_to_add <- as.formula(paste0(". ~ ", paste(predictors, collapse=" + ")))
  res <- add1(model0, formula_to_add, test="Chisq")
  
  
  regression_results <- as.data.frame(res)
  regression_results$variable <- rownames(regression_results)
  
  # add variable descriptions to regression_results
  variables <- read.csv("../buurtgegevens/variabelen.csv", stringsAsFactors=TRUE)
  m <- match(regression_results$variable, variables$Onderwerpcode)
  regression_results$naam <- variables$Naam[m]
  
  # set more practical names
  names(regression_results) <- c("df", "sum_of_sq", "rss", "aic" , "p", 
    "variable", "variable_name")
  
  # order by aic: best model at top
  o <- order(regression_results$aic)
  regression_results <- regression_results[o, ]
  
  # add coefficients to table
  regression_results$a <- NA
  regression_results$b <- NA
  regression_results$rsq <- NA
  
  for (i in seq_len(nrow(regression_results))) {
    var <- regression_results$variable[i]
    if (var == "<none>") next;
    f <- as.formula(paste0(". ~ ", var))
    m <- update(model0, f)
    regression_results$a[i] <- coef(m)[1]
    regression_results$b[i] <- coef(m)[2]
    regression_results$rsq[i] <- summary(m)$r.squared
  }
  
  regression_results
}

regression_results_nodig <- add_one("index_nodig", data, buurtvars)
regression_results_krijg <- add_one("index_krijg", data, buurtvars)


write.csv(regression_results_nodig, "regression_results1_nodig.csv", row.names=FALSE,
  na="")
write.csv(regression_results_krijg, "regression_results1_krijg.csv", row.names=FALSE,
  na="")


# ==============================================================================
# stepwise regression see which combination of variables can predict index best