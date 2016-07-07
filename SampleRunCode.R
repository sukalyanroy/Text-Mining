##================================================================================================================
 CorrectData <- read.csv("Z:/CorrectData.csv")
 View(CorrectData)
 library(NLP)
 library(tm)

library("reshape2")
 library("dplyr")
 library("stringr")
 library("RWeka")
##================================================================================================================ 
## Loading Data
  
 View(CorrectData)
 textsamples <- Corpus(VectorSource(CorrectData$comment))
##================================================================================================================
## PreProcessing the text comments
 textsamples <- tm_map(textsamples, PlainTextDocument)
 textsamples <- tm_map(textsamples, removePunctuation)
 textsamples <- tm_map(textsamples, removeNumbers)
 textsamples <- tm_map(textsamples, content_transformer(tolower))
 textsamples <- tm_map(textsamples, stemDocument)
 textsamples <- tm_map(textsamples, removeWords, stopwords("english"))
 textsamples <- tm_map(textsamples, removeWords, stopwords("SMART"))
 textsamples <- tm_map(textsamples, removeWords, c("the","they","i","then","when","this","and","but","also","got","one","two","car","hire","rental", "rent","compani"))
 textsamples <- tm_map(textsamples, stripWhitespace)
 ##textsamples
 textsamples[[1]]$content
 textsamples[[7]]$content
 textsamples[[14565]]$content
##================================================================================================================
## Stage the Data
 
 dtm <- DocumentTermMatrix(textsamples)
 dtm
 inspect(dtm[1:5, 1000:1005])
 class(dtm)
 dim (dtm)
 tdm <- TermDocumentMatrix(textsamples)
 tdm
 freq <- colSums(as.matrix(dtm))
##================================================================================================================
##Remove Sparse Terms - reduces the size of bag of words
 dtms <- removeSparseTerms(dtm, .9989845)
 dim(dtms)
 inspect(dtms)
  
##================================================================================================================
## Word frequency and its association
 
 freq <- colSums(as.matrix(dtms))
 freq
 findFreqTerms(dtms, lowfreq=1000)
 findFreqTerms(dtms, lowfreq=10000)
 findFreqTerms(dtms, lowfreq= 5000)
##================================================================================================================
##Order the freq of words
 ord <- order(freq)
 freq[head(ord)]
 freq[tail(ord)]
 
##================================================================================================================
 ##Frequency of frequencies.
 head(table(freq), 15)
 tail(table(freq), 15)
##================================================================================================================
 ##Word Cloud Presentation
 library(RColorBrewer)
 library(wordcloud)
 set.seed(142)
 wordcloud(names(freq), freq, min.freq=100, max.words=200, scale=c(5, 1), colors=brewer.pal(8, "Dark2"))
 
 ##================================================================================================================
 ##Find Association
 library(ggplot2)
 a1 <- findAssocs(dtms2, "holiday auto", 0.5)
 corr <- a1[[1]]
 corr <- cbind (read.table(text = names(corr), stringsAsFactors = TRUE), corr)
 xx <- paste(corr$V1,corr$V2)
 ggplot(corr, aes(x = xx, y = corr) ) +
   geom_bar(colour="black", fill="lightgreen", width=.4, stat="identity") +
         xlab(paste0("Correlation with the terms **Customer Service**"))  +
         theme_bw() +
         theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
 ##================================================================================================================
 ##################################################################################################################
 ##################################################################################################################
 
 BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
 dtm2 <- DocumentTermMatrix(textsamples, control = list(tokenize = BigramTokenizer))
 dim(dtm2)
 dtms2 <- removeSparseTerms(dtm2, .998735)
 dim(dtms2)
 freq2 <- colSums(as.matrix(dtms2))
 ord2 <- order(freq2)
 set.seed(142)
 wordcloud(names(freq2), freq2, min.freq=100, max.words=200, scale=c(3, 1), colors=brewer.pal(8, "Dark2"))
 
 ##################################################################################################################
 
 TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
 dtm3 <- DocumentTermMatrix(textsamples, control = list(tokenize = TrigramTokenizer))
 dim(dtm3)
 dtms3 <- removeSparseTerms(dtm3, .998735)
 dim(dtms3)
 freq3 <- colSums(as.matrix(dtms3))
 ord3 <- order(freq3)
 set.seed(142)
 wordcloud(names(freq3), freq3, min.freq=20, max.words=200, scale=c(5, 1), colors=brewer.pal(8, "Dark2"))
 
 ##================================================================================================================
 ## HClust
 distMatrix <- dist(scale(dtms))
 
 ##================================================================================================================
 ##Polarity
 SampleData <- head(CorrectData, n=200)
 library(qdap)
 
 SampleData <- cbind(SampleData, PolarityScore)
 SampleData$PolarityScore <- apply(SampleData, 2, function(x) {x = counts(polarity(strip(SampleData$comment)))[,"polarity"]})
 ##================================================================================================================
 ##k-means
 
 
 temp1<-cbind(as.data.frame(freq3,row.names = NULL),names(freq3))
 names(temp1)<-c("freq","words")
 temp2<- temp1%>% mutate(wordscar=as.character(words))
 temp3<-temp2 %>% mutate(word1=word(wordscar,1),word2=word(wordscar,2),word3=word(wordscar,3))
 temp3$ID<-seq.int(nrow(temp3))
 temp4<-temp3 %>%  select(ID,words,freq,word1,word2,word3) 
 temp5 <- temp4 %>% melt(id=c("ID","freq","words"))
 temp6<- temp5 %>% arrange(ID,freq,words,value)
 temp6$variable <- rep(c("word1","word2","word3"),nrow(temp6)/3)
 temp7<-temp6 %>% dcast(ID+freq+words~variable) %>%
   group_by(words,word1,word2,word3) %>% summarize(freq=sum(freq))%>%
   mutate(sentence=paste(word1,word2,word3))
 
 
 
 temp1<-cbind(as.data.frame(freq2,row.names = NULL),names(freq2))
 names(temp1)<-c("freq","words")
 temp2<- temp1%>% mutate(wordscar=as.character(words))
 temp3<-temp2 %>% mutate(wordsort=as.character(sort(c(word(wordscar,1),word(wordscar,2)))))
 
 #,word2=unlist(strsplit(words," "))[2])
 glimpse(temp1)
 class(dtms2)
 