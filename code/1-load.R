### Kaggle Restaurant Revenue Challenge 
# ----------------------------Data Cleaning and EDA---------------------------------
setwd("D:/Datascience/Kaggle/restaurants")

library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(ggplot2)

# ----------------------Read Files-----------------------------------
train <- read_csv("data/train.csv")
test <- read_csv("data/test.csv")
glimpse(train)
glimpse(test)

train.x <- select(train, -revenue)
train.y <- select(train, revenue)

# ----------------------Recode Variables-----------------------------
#train
names(train.x) <- gsub(" ", "_", names(train.x))
train.x$Open_Date <- strptime(train.x$Open_Date, "%m/%d/%Y")

train.x <- mutate(train.x, age=ymd("2016-07-01")-Open_Date) %>% select(-Open_Date)
train.x <- mutate(train.x, age=age/356)
train.x <- select(train.x,-Id)

train.x$City <- as.factor(x = train.x$City)
train.x$City_Group <- as.factor(train.x$City_Group)
train.x$Type <- as.factor(train.x$Type)

#test
names(test) <- gsub(" ", "_", names(test))
test$Open_Date <- strptime(test$Open_Date, "%m/%d/%Y")

test <- mutate(test, age=ymd("2016-07-01")-Open_Date) %>% select(-Open_Date)
test <- mutate(test, age=age/356)
test <- select(test, -Id)

test$City <- as.factor(x = test$City)
test$City_Group <- as.factor(test$City_Group)
test$Type <- as.factor(test$Type)

# ----------------------save-----------------------------------------
save(train.x, train.y, test, file="data/restaurants_recoded.rda")
