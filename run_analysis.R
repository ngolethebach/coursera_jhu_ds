actLab <- read.table('./UCI HAR Dataset/activity_labels.txt', 
                     col.names = c('activityLabels', 'activityName'), quote = "")

features <- read.table('./UCI HAR Dataset/features.txt', 
                       col.names = c('featureLabels', 'featureName'), quote = "")

subTest <- read.table('./UCI HAR Dataset/test/subject_test.txt', col.names = c('subjectId'))

XTest <- read.table('./UCI HAR Dataset/test/X_test.txt')

yTest <- read.table('./UCI HAR Dataset/test/y_test.txt')

colnames(XTest) <- features$featureName
colnames(yTest) <- c('activityLabels')
testData <- cbind(subTest, XTest, yTest)

subTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt', col.names = c('subjectId'))
XTrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
yTrain <- read.table('./UCI HAR Dataset/train/y_train.txt')

colnames(XTrain) <- features$featureName
colnames(yTrain) <- c('activityLabels')
trainData <- cbind(subTrain, XTrain, yTrain)

allData <- rbind(trainData, testData)

meanSdData <- allData[, c(1, grep(pattern = 'mean\\(\\)|std\\(\\)', x = names(allData)), 563)]

meanSdData$subjectId <- as.factor(meanSdData$subjectId)
meanSdData$activity <- factor(meanSdData$activityLabels,
                              levels = actLab$activityLabels,
                              labels = actLab$activityName)

meanSdData <- meanSdData[, -68]

names(meanSdData)

colnames(meanSdData) <- gsub(pattern = '\\(\\)', replacement = "", x = names(meanSdData))

meanSdData <- meanSdData[, c(1, 68, 2:67)]

write.table(meanSdData, file = 'tidyData.txt', row.names = F, quote = F, sep = "\t")

library(dplyr)
meanSdDataByIdAct <- group_by(meanSdData, subjectId, activity) %>% summarise_all(funs(mean))
write.table(meanSdDataByIdAct, file = 'tidyDataMean.txt', row.names = F, quote = F, sep = "\t")
                      
      