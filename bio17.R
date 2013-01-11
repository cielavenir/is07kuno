#bio17.R
#To draw graphs...

pdf("bio17.pdf", family="Japan1") #family modifier is required!

#ExpA
b17a <- read.table(file="bio17a.csv",header=T,sep=",")
Deg1=b17a$Deg[1:7];f1=b17a$f[1:7];F1=b17a$F[1:7];L1=b17a$L[1:7]
Deg2=b17a$Deg[8:14];f2=b17a$f[8:14];F2=b17a$F[8:14];L2=b17a$L[8:14]
Deg3=b17a$Deg[15:20];f3=b17a$f[15:20];F3=b17a$F[15:20];L3=b17a$L[15:20]
layout(matrix(c(1,2,3,4),nrow=2,ncol=2,byrow=T))
plot(c(Deg1,Deg2),c(f1,f2),xlab="肘関節角度(deg)",ylab="力(P/P0)",main="角度-力(f)",col=c(rep("black",7),rep("red",7)))
lines(f3 ~ Deg3,col="black")
plot(c(Deg1,Deg2),c(F1,F2),xlab="肘関節角度(deg)",ylab="力",main="角度-力(F)",col=c(rep("black",7),rep("red",7)))
lines(F3 ~ Deg3,col="black")
plot(c(L1,L2),c(F1,F2),xlab="筋長",ylab="力",main="長さ-力(F)",col=c(rep("black",7),rep("red",7)))
lines(F3 ~ L3,col="black")
#ExpB
#a/P0=0.360, b=539.4 these are from Analysis software; you cannot use them as your data.

b17b <- read.table(file="bio17b.csv",header=T,sep=",")
P1=b17b$P[1:9];V1=b17b$V[1:9];W1=b17b$W[1:9]
P2=b17b$P[10:17];V2=b17b$V[10:17];W2=b17b$W[10:17]

#init
x<-seq(0,1,length=1001)
plot(c(P1,P2),c(V1,V2),xlim=c(0,1),ylim=c(0,1500),xlab="力(P/P0)",ylab="角速度(x100deg/s)",main="力-角速度, 力-仕事率",col=c(rep("black",9),rep("red",8)))
par(new=T)
plot(x,539.4*(1-x)/(x+0.360),xlim=c(0,1),ylim=c(0,1500),type="l",xlab="",ylab="",axes=F)
par(new=T)
plot(c(P1,P2),c(W1,W2),xlim=c(0,1),ylim=c(0,300),xlab="",ylab="",col=c(rep("green",9),rep("blue",8)),axes=F)
axis(4)
par(new=T)
plot(x,539.4*x*(1-x)/(x+0.360),xlim=c(0,1),ylim=c(0,300),type="l",xlab="",ylab="",col="pink",axes=F)
dev.off()
