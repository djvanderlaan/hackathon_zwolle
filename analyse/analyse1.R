
data <- read.csv("../data_prep/bvb.csv")

data$ondersteuning_nodig <- data$onderst_fam | data$onderst_beroep | 
  data$onderst_vrijw | data$onderst_part | data$onderst_geen

data$ondersteuning_krijg <- data$onderst_fam | data$onderst_beroep | 
  data$onderst_vrijw | data$onderst_part 




data$etn <- data$landgeb
data$etn[data$landgeb_vader == "westers" | data$landgeb_moeder == "westers"] <- "westers"
data$etn[data$landgeb_vader == "nietwesters" | data$landgeb_moeder == "nietwesters"] <- "nietwesters"

data$generatie <- ifelse(data$etn == "nederland", 0, 2)
data$generatie <- ifelse(data$landgeb != "nederland" & data$etn != 0, 1, data$generatie)
data$generatie[data$etn == "onbekend"] <- 9




variables <- c("leeft", "geslacht", "oplniv", "werk", "hh", "etn", "generatie")

formula <- as.formula(paste0("ondersteuning_nodig ~ ", paste(variables, collapse=" + ")))
model1 <- glm(formula, data=data, family=binomial())

# library(rms)
# 
# model1 <- lrm(formula, data=data)
