#this is a modification of the prediction model to grab the average overall words (used on election night for blog post)

library("C50", lib.loc="~/R/win-library/3.2")
library("caret", lib.loc="~/R/win-library/3.2")
library("RWeka", lib.loc="~/R/win-library/3.2")
library("partykit", lib.loc="~/R/win-library/3.2")

setwd("~/R/US election prediction")


#import list of most common words for column headers and collapse to simple list
wordnames<-read.csv("top_125.csv", sep=",", header=F)
wordnames<-as.list(levels(wordnames$V1))
wordnames<-unlist(wordnames)

#create data frame and add word names headings
input<-data.frame(matrix(nrow=189,ncol=126))
colnames(input)=wordnames

for (i in 1:189){
  daylist<-scan(paste0("C:/Users/Alex/Documents/R/US election prediction/dailywordcounts/",toString(i),".txt"), what="", sep="\n")
  daylist<-strsplit(daylist,",")
  
  for(j in 1:length(daylist[1][[1]])){
    input[i,j]<-as.numeric(daylist[1][[1]][j])
  }
}

a<-5
b<-6
saturdays<-c()
sundays<-c()
for (i in 1:27){
  saturdays[i]<-a
  sundays[i]<-b
  a<-a+7
  b<-b+7
  
}

#===================================
#generate model input

#remove weekends and bank holidays from input 
inputnoweekends<-input[-c(saturdays,sundays,158,123,60),]


#import classes to include in input data
classes<-read.csv("input_classes.csv",sep=" ",header=F)

#this is the final table of inputs (the class is bound as the final column - column 127 here)
finalinput<-cbind(inputnoweekends,classes)
finalinput[is.na(finalinput)] <- 0 #replace na with 0




#create prediction models (comment out unused modes to speed model up)
#treej48<-J48(V1~., data=finalinput)
#svector<-train(V1~., data=finalinput, method="svmRadial",trControl=trainControl(method="LOOCV"))
#tree5.0<-train(V1~., data=finalinput, method="C5.0Tree")
#treeLMT<-train(V1~., data=finalinput, method="LMT",trControl=trainControl(method="LOOCV"))
#rpart<-train(V1~., data=finalinput, method="rpart",trControl=trainControl(method="LOOCV"))
#jrip<-train(V1~., data=finalinput, method="JRip",trControl=trainControl(method="LOOCV"))
#tree5.0<-C5.0(V1~., data=finalinput, trials=100,trControl=trainControl(method="LOOCV"))
#ada<-train(V1~., data=finalinput, trControl=trainControl(method="LOOCV"), method="adaboost", metric="Accuracy")
#ada<-train(V1~., data=finalinput,method="adaboost", trControl=trainControl(method="LOOCV"))

#create data frame for predction input data
inputdata<-data.frame(matrix(nrow=1,ncol=126))
colnames(inputdata)=wordnames

#get the input data and input into data frame
inputlist<-scan("C:/Users/Alex/Documents/R/US election prediction/PREDICTION_DATA/prediction_input.txt", what="",sep=",")
inputlist<-as.numeric(inputlist)
for(i in 1:126){
  inputdata[1,i]<-inputlist[i]
}

averagewords<-c()

for (column in(1:126)){
  averagewords[column]<-mean(finalinput[,column])
}