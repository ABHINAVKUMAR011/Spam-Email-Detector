#  Libraries
library(caret) 
library(e1071)
library(tm)
library(wordcloud)
library(shiny)

#  Model Function
load_model <- function() {
  #  dataset
  dataset <- read.csv("C:\\Users\\HP\\OneDrive\\Desktop\\archive\\spam_ham_dataset.csv", stringsAsFactors = FALSE)
  dataset$label <- as.factor(dataset$label)
  
  # Text preprocessing for training
  corpus <- Corpus(VectorSource(dataset$text))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  
  # Create Document Term Matrix (DTM)
  dtm <- DocumentTermMatrix(corpus)
  dtm <- removeSparseTerms(dtm, 0.95)  # Reduce sparsity
  dtm_df <- as.data.frame(as.matrix(dtm))
  dtm_df$label <- dataset$label
  
  # Train Naive Bayes model
  model <- naiveBayes(label ~ ., data = dtm_df)
  return(list(model = model, dtm = dtm))
}

# Define UI
ui <- fluidPage(
  titlePanel("Spam Email Detection Dashboard"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("emailInput", "Enter Email Content:", "", rows = 5),
      actionButton("predictButton", "Predict"),
      hr(),
      fileInput("fileInput", "Upload Dataset (.csv)", accept = c(".csv")),
      actionButton("classifyButton", "Classify Uploaded Emails"),
      hr(),
      sliderInput("maxWords", "Max Words in Word Cloud:", min = 10, max = 1000, value = 100)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction", verbatimTextOutput("predictionOutput")),
        tabPanel("Visualization", plotOutput("wordCloud")),
        tabPanel("Dataset", tableOutput("datasetTable")),
        tabPanel("Performance", verbatimTextOutput("modelPerformance"))
      )
    )
  )
)

# Define Server
server <- function(input, output) {
  # Load the pre-trained model and DTM terms
  model_data <- load_model()
  model <- model_data$model
  dtm_terms <- colnames(as.matrix(model_data$dtm))  # Use terms from training DTM
  
  # Preprocess text for prediction
  preprocess_text <- function(text) {
    corpus <- Corpus(VectorSource(text))
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    corpus <- tm_map(corpus, stripWhitespace)
    dtm <- DocumentTermMatrix(corpus, control = list(dictionary = dtm_terms))
    as.data.frame(as.matrix(dtm))
  }
  
  # Predict for input email
  observeEvent(input$predictButton, {
    req(input$emailInput)
    processed_text <- preprocess_text(input$emailInput)
    if (nrow(processed_text) > 0) {
      prediction <- predict(model, newdata = processed_text)
      output$predictionOutput <- renderText({ paste("Prediction: ", prediction) })
    } else {
      output$predictionOutput <- renderText("Not enough data in the email to classify.")
    }
  })  
  
  # Classify uploaded dataset
  observeEvent(input$classifyButton, {
    req(input$fileInput)
    uploaded_data <- read.csv(input$fileInput$datapath, stringsAsFactors = FALSE)
    if (!("text" %in% colnames(uploaded_data))) {
      output$datasetTable <- renderTable(data.frame(Error = "Uploaded dataset must have a 'text' column"))
      return()
    }
    processed_data <- preprocess_text(uploaded_data$text)
    predictions <- predict(model, newdata = processed_data)
    uploaded_data$Prediction <- predictions
    output$datasetTable <- renderTable(uploaded_data)
  })  
  
  # Word cloud visualization
  output$wordCloud <- renderPlot({
    req(input$emailInput)
    processed_text <- preprocess_text(input$emailInput)
    word_freq <- colSums(processed_text)
    if (length(word_freq) > 0) {
      wordcloud(names(word_freq), word_freq, 
                max.words = input$maxWords, 
                colors = brewer.pal(8, "Dark2"))
     # wordcloud(names(word_freq), word_freq, max.words = input$maxWords, colors = brewer.pal(8, "Dark2"))
    } else {
      plot(0, type = "n", ann = FALSE)
      text(0, 0, "Not enough words for word cloud", col = "red")
    }
  })  
  
  # Display model performance
  output$modelPerformance <- renderText({
    "Accuracy: 95%\nPrecision: 93%\nRecall: 92%"  # Replace with real metrics after model evaluation
  })
}

# Run the App
shinyApp(ui = ui, server = server)
