#this takes the wordcound from TODAYS new york times to allow for prediction


setwd("~/R/US election prediction")


#function to remove all non alphanumeric characters and split by space
cleanFun <- function(htmlString) {
  return(gsub("[^a-zA-Z]"," ", htmlString))
}

  url<-paste0("http://www.nytimes.com/pages/todayspaper/index.html")
  page<-readLines(url)

  #collapse into string
  page<-paste(page,collapse=',')


  #apply cleaning function to page to split into wordsand change to lowecase
  page<-cleanFun(page)
  page<-tolower(page)

  #split into list of words and convert to factor
  pagewords<-strsplit(page," ")
  #pagewords<-as.factor(pagewords[[1]])

  #list most common words by order
  tb <- sort(table(pagewords), decreasing=TRUE) 
  tbwords<-names(tb)
 
  
  #this returns a list of the number of times each of the top words is used that day (in order as given in top 125 file)
  
  top_125<-read.csv("top_125.csv", sep=",", header=F)
  top_125<-as.list(levels(top_125$V1))
  
  
    day_1<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/1.txt"), what="", sep="\n")
    day_1_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/1.txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_1_count<-day_1_count[-1]
    
    
    #initialise list of counts for each top word for that day (corresponds to indexlist)
    countlist1<-list()

    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
      wordposition<-(match(top_125[i][[1]],day_1))
      countlist1[i]<-day_1_count[wordposition]
    }
   
    countlist1<-as.numeric(countlist1)
  countlist1[is.na(countlist1)]<-0
  