results<-read.csv("results.csv",header=T)

accuracy<-results$confidence-50


plot(results$Time,accuracy,col="gray", ylim=c(0,100), type="h", ylab="%", xlab="time", lwd=20)
lines(results$Time,results$Hillary, type="l",col="blue")
lines(results$Time,results$Trump,type="l",col="red")