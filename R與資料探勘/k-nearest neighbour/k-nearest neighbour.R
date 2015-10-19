install.packages("class")
library("class")

# training data
trainingfile <- read.csv(file.choose())
trainingdata <- subset(trainingfile, select = -Species)
trainingtarget <- trainingfile$Species

