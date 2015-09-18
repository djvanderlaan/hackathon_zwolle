
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

data$generatie <- as.factor(data$generatie)


variables <- c("leeft", "geslacht", "oplniv", "werk", "hh", "etn", "generatie")

formula <- as.formula(paste0("ondersteuning_nodig ~ ", paste(variables, collapse=" + ")))
model1 <- glm(formula, data=data, family=binomial())

# formula2 <- as.formula(paste0(".  ~ (", paste(variables, collapse=" + "), ")^2"))
# model2 <- step(model1, formula2)

p <- predict(model1, type="response")

data$p_ondersteuning_nodig <- predict(model1, newdata=data, type="response")

# library(rms)
# 
# model1 <- lrm(formula, data=data)

library(dplyr)

res <- group_by(data, buurt) %>% summarise(ondersteuning_nodig = sum(ondersteuning_nodig, na.rm=TRUE),
  expected_nodig = sum(p_ondersteuning_nodig, na.rm=TRUE)) %>% 
  mutate(index_nodig = ondersteuning_nodig/expected_nodig) %>% 
  filter(ondersteuning_nodig > 10)

write.csv(res, "index.csv", row.names=FALSE)


data_zorg <- data %>% filter(ondersteuning_nodig == 1)

variables <- c("leeft", "geslacht", "oplniv", "werk", "hh", "generatie")

formula <- as.formula(paste0("ondersteuning_krijg ~ ", paste(variables, collapse=" + ")))
model_nodig <- glm(formula, data=data_zorg, family=binomial())


lrm(formula, data=data_zorg)

data_zorg$p_ondersteuning_krijg <- predict(model_nodig, newdata=data_zorg, type="response")

res2 <- group_by(data_zorg, buurt) %>% summarise(ondersteuning_krijg = sum(ondersteuning_krijg, na.rm=TRUE),
  expected_krijg = sum(p_ondersteuning_krijg, na.rm=TRUE)) %>% 
  mutate(index_krijg = ondersteuning_krijg/expected_krijg) %>% 
  filter(ondersteuning_krijg > 10)


res <- full_join(res, res2)

# Add buurt codes
buurt <- read.csv("index_codes.csv", stringsAsFactors=FALSE)
m <- match(res$buurt, buurt$buurt)
res$buurt_code <- buurt$Codering_3[m]

write.csv(res, "index.csv", row.names=FALSE, na = "")

symbols(res$index_nodig, res$index_krijg, res$ondersteuning_nodig, inches = 0.3,
  bg=rgb(150/255, 20/255, 50/255, 0.6))


