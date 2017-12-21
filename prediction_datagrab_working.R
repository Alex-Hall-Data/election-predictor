#this takes the wordcound from TODAYS new york times to allow for prediction
#the saved output file is the frequency of the top 125 words and is used as input for the prediction model

# NOTE, this now takes news from the past 5 days and weights the results per day (more recent having higher weightings)

#the values in lines 40, 61 and 62 (in the strings) must be changed to make sure the correct date is used abdthe correct filename is written to

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
  #save 2 files for each date - one with word count and one with words in descending frequency (saved in respective folders)
  write(tb,paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/1.txt"))
  write(tbwords,paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/1.txt"))
  
  #do the above for the previous 4 days:
  
  for(i in (5:2)){
    
    url<-paste0("http://www.nytimes.com/indexes/2016/11/0",i,"/todayspaper/index.html")
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
    #save 2 files for each date - one with word count and one with words in descending frequency (saved in respective folders)
    write(tb,paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/",abs(i-7),".txt"))
    write(tbwords,paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/",abs(i-7),".txt"))
    
  }
  
  
  
  #this returns a list of the number of times each of the top words is used that day (in order as given in top 125 file)
  
  top_125<-read.csv("top_125.csv", sep=",", header=F)
  top_125<-as.list(levels(top_125$V1))
  
  
    day_1<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/1.txt"), what="", sep="\n")
    day_1_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/1.txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_1_count<-day_1_count[-1]
    
    day_2<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/2.txt"), what="", sep="\n")
    day_2_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/2.txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_2_count<-day_2_count[-1]
    
    day_3<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/3.txt"), what="", sep="\n")
    day_3_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/3.txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_3_count<-day_3_count[-1]
    
    day_4<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/4.txt"), what="", sep="\n")
    day_4_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/4.txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_4_count<-day_4_count[-1]
    
    day_5<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_words/5.txt"), what="", sep="\n")
    day_5_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/5_day_counts/5.txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_5_count<-day_5_count[-1]
    
    #initialise list of counts for each top word for that day (corresponds to indexlist)
    countlist1<-list()
    countlist2<-list()
    countlist3<-list()
    countlist4<-list()
    countlist5<-list()
    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
      wordposition<-(match(top_125[i][[1]],day_1))
      countlist1[i]<-day_1_count[wordposition]
    }
    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
      wordposition<-(match(top_125[i][[1]],day_2))
      countlist2[i]<-day_2_count[wordposition]
    }
    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
      wordposition<-(match(top_125[i][[1]],day_3))
      countlist3[i]<-day_3_count[wordposition]
    }
    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
      wordposition<-(match(top_125[i][[1]],day_4))
      countlist4[i]<-day_4_count[wordposition]
    }
    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
      wordposition<-(match(top_125[i][[1]],day_5))
      countlist5[i]<-day_5_count[wordposition]
    }
    
    #replace nas
    countlist1[is.na(countlist1)]<-0
    countlist2[is.na(countlist2)]<-0
    countlist3[is.na(countlist3)]<-0
    countlist4[is.na(countlist4)]<-0
    countlist5[is.na(countlist5)]<-0
    
    countlist1<-as.numeric(countlist1)
    countlist2<-as.numeric(countlist2)
    countlist3<-as.numeric(countlist3)
    countlist4<-as.numeric(countlist4)
    countlist5<-as.numeric(countlist5)
    
    #combine these lists into a sigle list, with weights decreasing by day.
    #apply weights
    countlist1<-0.5*countlist1
    countlist2<-0.25*countlist2
    countlist3<-0.15*countlist3
    countlist4<-0.07*countlist4
    countlist5<-0.04*countlist5
    
    #add together to make weighted list for last 5 days
    countlist<-countlist1+countlist2+countlist3+countlist4+countlist5
    
    #write the list of word frequencies to file
    write(toString(countlist),paste0("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/prediction_input.txt"))

  
