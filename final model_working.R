#this builds out input data from the collected text (run 'prediction_datagrab' first to get prediction input)
#each row of the data frame is a day (most recent being first - so row 1 is the most recent day)
#the column names are the most common words (for all text over 6 months)
#each cell gives the number of instances of the corresponding word for that day

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

#generate input for each day by including eighted input from previous days (don't do for first 4 days as no prior days for weighting)
for(i in (1:128)){
  inputnoweekends[i,]<-(0.5*inputnoweekends[i,])+(0.25*inputnoweekends[i+1,])+(0.14*inputnoweekends[i+2,])+(0.07*inputnoweekends[i+3,])+(0.04*inputnoweekends[i+4,])
}
#delete final 4 days (they do not have 5 previous days to include as input)


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
ada<-train(V1~., data=finalinput, trControl=trainControl(method="LOOCV"), method="adaboost", metric="Accuracy")
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

predictionJ48<-predict(treej48, newdata=inputdata,type="probability")
svmprediction<-predict(svector,newdata=inputdata,type="prob")
predictionC5.0<-predict(tree5.0, newdata=inputdata,type="prob")
predictionLMT<-predict(treeLMT, newdata=inputdata,type="prob")
predictionrpart<-predict(rpart, newdata=inputdata,type="prob")
predictionjrip<-predict(jrip, newdata=inputdata,type="prob")
predictionada<-predict(ada,newdata=inputdata,type="prob")