setwd("~/R/US election prediction")

#get list of dates
dates<-read.csv("dates.csv")
dates<-dates[[1]]
dates<-as.list(levels(dates))

dates<-gsub("-","/",dates)


#function to remove all non alphanumeric characters and split by space
cleanFun <- function(htmlString) {
  return(gsub("[^a-zA-Z]"," ", htmlString))
}

fulllist<-list()

#for every date, grab and parse text (save as text file in reverse order of date, so '1' is most recent)
for (i in 1:length(dates)){
  
  #grab text data
  url<-paste0("http://www.nytimes.com/indexes/",dates[i], "/todayspaper/index.html")
  page<-readLines(url)
  
  #collapse into string
  page<-paste(page,collapse=',')
  
  
  #apply cleaning function to page to split into wordsand change to lowecase
  page<-cleanFun(page)
  page<-tolower(page)
  
  #split into list of words and convert to factor
  pagewords<-strsplit(page," ")
  
  #add to list
  fulllist[i]<-pagewords
  

  print(i)
}

#collapse list of all words (from all days) into single list
fullstring<-paste(fulllist,collapse=',')
fulllist<-strsplit(fullstring, " ")


#list most common words by order
tb <- sort(table(fulllist), decreasing=TRUE) 
tbwords<-names(tb)