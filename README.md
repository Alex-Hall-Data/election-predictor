# election-predictor
Scripts for predicting results of elections. Uses ensemble learning methods

Relativley large project involving grabbing days of text data from the new york times and correlating to stock prices for certain selected stocks.
The 'prediction datagrab' file will scrape, process and save the raw data. The 'final model' file uses the fast AdaBoost algorithm to predict the election.

The final result predicted the wrong candidate but the vote share was within 0.1% of the actual results (would have predicted correct candidate if the candidate with the majority of votes was the winner).
