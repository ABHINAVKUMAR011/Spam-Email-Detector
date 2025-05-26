library(caret)
library(e1071)
library(tm)
library(wordcloud)
library(shiny)

dataset <- read.csv("C:\\Users\\HP\\OneDrive\\Desktop\\archive\\spam_ham_dataset.csv", stringsAsFactors = FALSE)
str(dataset)
dataset$label <- as.factor(dataset$label)
dataset$text <- tolower(dataset$text)
corpus <- Corpus(VectorSource(dataset$text))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)
dtm <- DocumentTermMatrix(corpus)
set.seed(123)
trainIndex <- createDataPartition(dataset$label, p = 0.8, list = FALSE)
trainData <- dataset[trainIndex, ]
testData <- dataset[-trainIndex, ]

trainDTM <- dtm[trainIndex, ]
testDTM <- dtm[-trainIndex, ]

trainLabels <- trainData$label
testLabels <- testData$label
trainDTM <- removeSparseTerms(trainDTM, 0.95)
testDTM <- testDTM[, colnames(trainDTM)]
trainDF <- as.data.frame(as.matrix(trainDTM))
testDF <- as.data.frame(as.matrix(testDTM))
trainDF$label <- trainLabels
testDF$label <- testLabels
model <- naiveBayes(label ~ ., data = trainDF)
predictions <- predict(model, newdata = testDF)
confMatrix <- confusionMatrix(predictions, testDF$label)
print(confMatrix)


spamText <- subset(dataset, label == "spam")$text
spamCorpus <- Corpus(VectorSource(spamText))
spamCorpus <- tm_map(spamCorpus, removeNumbers)
spamCorpus <- tm_map(spamCorpus, removePunctuation)
spamCorpus <- tm_map(spamCorpus, removeWords, stopwords("english"))
spamCorpus <- tm_map(spamCorpus, stripWhitespace)


wordcloud(spamCorpus, max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))


