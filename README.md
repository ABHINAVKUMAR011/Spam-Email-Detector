📊 Spam Email Detection Dashboard (R + Shiny):-
This project is a Spam Email Detection Dashboard built using R and Shiny, designed to classify emails as spam or ham using Natural Language Processing (NLP) techniques and a Naive Bayes machine learning model. The dashboard allows users to manually test email content, upload datasets, visualize word frequency via word clouds, and view model performance — all through an interactive web interface.

✨ Features:-
🔍 Spam Prediction: Enter email content and get instant prediction using a trained Naive Bayes classifier.

📤 Bulk Classification: Upload a .csv file of emails and classify them in bulk.

☁️ Word Cloud Visualization: Generate dynamic word clouds from input email content.

📈 Performance Metrics: View basic model metrics such as accuracy, precision, and recall.

📊 Interactive UI: Built using Shiny for a responsive and interactive user experience.

🧠 Model & Methodology:-
Algorithm: Naive Bayes

Preprocessing:

Lowercasing, removing numbers/punctuation

Stop word removal

Whitespace stripping

Feature Extraction: Document-Term Matrix (DTM) with sparsity reduction

Training Dataset: spam_ham_dataset.csv

🛠️ Tech Stack:-
Component	Tool/Library
Language	R
UI Framework	Shiny
ML Algorithm	Naive Bayes (e1071)
NLP Tools	tm, wordcloud
Dataset Format	CSV


🚀 How to Run
Install Required Packages:

install.packages(c("shiny", "tm", "wordcloud", "e1071", "caret"))

Run the App:
shiny::runApp("path_to_your_script")


📈 Model Performance:-
(Based on test data – can be improved by tuning preprocessing or model parameters)

Metric	Value:-
Accuracy	95%
Precision	93%
Recall	92%

📌 Notes:-
The uploaded dataset must contain a text column for successful classification.

The word cloud is dynamically generated from the text entered in the prediction tab.

Word cloud size can be controlled using a slider in the UI.

🧪 Example Use Case:-
A student or researcher exploring spam detection using classical ML in R.

A quick tool to test spam classification logic for email-based datasets.

A hands-on project for understanding how text preprocessing and feature extraction affect model performance.




![Screenshot (132)](https://github.com/user-attachments/assets/9fd37e86-c61d-423e-bb4c-43ee45d5712f)
![Screenshot (133)](https://github.com/user-attachments/assets/6e387707-9606-4fc6-95be-e2d18acc7a45)
![Screenshot (134)](https://github.com/user-attachments/assets/e16147ea-0df7-4425-a11c-0c8edc19dc8e)
![Screenshot (135)](https://github.com/user-attachments/assets/c66d3851-1729-4924-9a37-337c602fe3fd)
![Screenshot (136)](https://github.com/user-attachments/assets/d1440782-2228-4fed-a31a-958e84e30917)
![Screenshot (137)](https://github.com/user-attachments/assets/b9c12004-2950-41ba-8414-fcc60a275ffa)
![Screenshot (138)](https://github.com/user-attachments/assets/ef54cd47-3f25-4e37-b29c-21f2e1fca5a0)
![Screenshot (139)](https://github.com/user-attachments/assets/2c531461-bc29-44a8-b91e-73abd3ea7d9c)
![Screenshot 2024-11-18 005417](https://github.com/user-attachments/assets/0ebcea9b-0688-4f2f-aea9-ea547194a0f7)






