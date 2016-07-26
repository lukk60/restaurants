#### Kaggle Restaurant Revenue Challenge 
# ----------------------------Modelling---------------------------------
setwd("D:/Datascience/Kaggle/restaurants")

library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(ggplot2)
library(caret)
library(vtreat)

load("data/restaurants_recoded.rda")
test_raw <- read_csv("data/test.csv")
#-----------------------------simple rf model without City and Type Vars----------------------------------
set.seed(1)
ctrl <- trainControl(method = "repeatedcv", number = 10,repeats = 10)
tune_grid <- expand.grid(mtry=c(1,2,3,4,5,6,7,10,20))
system.time({
  rf.fit <- train(x=select(train.x,-Type,-City), y=train.y$revenue, method="rf", trControl = ctrl, tuneGrid = tune_grid)
})
rf.fit

apred.rf <- predict(rf.fit, newdata=test)
pred.rf <- data.frame(Id=test_raw$Id, Prediction=pred.rf)

write.table(pred.rf, "submit/simple_rf.csv", sep=",", row.names=F)
# RMSE 1831633.95143 | Rank: 602

# ----------------------------prepare data with vtreat----------------------------------------------------
treatments <- designTreatmentsN(cbind(train.y,train.x), names(train.x), "revenue")

train_prep <- prepare(treatments, dframe = cbind(train.x, train.y), pruneSig = 0.1)
test_prep <- prepare(treatments, dframe = test, pruneSig=0.1)

# ----------------------------apply rf model again -------------------------------------------------------
ctrl <- trainControl(method = "repeatedcv", number = 5,repeats = 10)
tune_grid <- expand.grid(mtry=c(1:12))
system.time({
  rf.fit2 <- train(x=select(train_prep, -revenue), y=train_prep$revenue, method="rf", trControl = ctrl, tuneGrid = tune_grid)
})
rf.fit2

pred.rf2 <- predict(rf.fit2, newdata=test_prep)
pred.rf2 <- data.frame(Id=test_raw$Id, Prediction=pred.rf2)

write.table(pred.rf2, "submit/vtreat_rf.csv", sep=",", row.names=F)
#TrainCV: RMSE 2223317
#Test: RMSE 2024381.51834 | Rank: 1875

