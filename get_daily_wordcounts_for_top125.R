#this returns a list of the number of times each of the top words is used that day (in order as given in top 125 file)

top_125<-read.csv("top_125.csv", sep=",", header=F)
top_125<-as.list(levels(top_125$V1))

for (j in 1:189){
    day_1<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/words/",toString(j),".txt"), what="", sep="\n")
    day_1_count<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/counts/",toString(j),".txt"), what="", sep=" ")
    #delete first count as this referes to 'space', which is not included in the words as it was the delimiter
    day_1_count<-day_1_count[-1]


    #initialise list of counts for each top word for that day (corresponds to indexlist)
    countlist<-list()
    
    #build list of word frequencies for that day
    for (i in 1:length(top_125)){
      #prints index at which word is found in counts for the day
     wordposition<-(match(top_125[i][[1]],day_1))
     countlist[i]<-day_1_count[wordposition]
    }
  #write the list of word frequencies to file
  write(toString(countlist),paste0("C:/Users/Alex/Documents/R/US election prediction/dailywordcounts/",toString(j),".txt"))
}
