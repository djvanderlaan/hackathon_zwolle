

variables <- read.csv("variabelen.csv", stringsAsFactors=FALSE)
variables$select[is.na(variables$select)] <- 0

selected_variables <- variables$Onderwerpcode[variables$select > 0.5]

period <- 2014

path <- "../../_zwolle/Zebra/"
files <- list.files(path, pattern = "*.csv")

buurtgegevens <- NULL

for (file in files) {
  data <- read.csv(file.path(path, file), stringsAsFactors=FALSE)
  data <- data[data$PERIOD == period, ]
  vars <- c("GEOITEM", names(data)[names(data) %in% selected_variables])
  data <- data[vars]
  
  buurtgegevens <-if (is.null(buurtgegevens)) {
    data
  } else {
    merge(buurtgegevens, data, all=TRUE, by="GEOITEM")
  }
}

for (col in names(buurtgegevens)) {
  buurtgegevens[[col]][buurtgegevens[[col]] < -99990] <- NA
  if (all(is.na(buurtgegevens[[col]]))) buurtgegevens[[col]] <- NULL
}

write.csv(buurtgegevens, "buurtgegevens.csv", row.names=FALSE)
