#-----------------------------------------------------------------------------------------------------------------------------

##LOAD LIBRARIES
library(tidyr)
library(syuzhet)
library(qdap)
library(dplyr)

#-----------------------------------------------------------------------------------------------------------------------------
## LOAD FILE AND SELECT NEEDED COLUMNS

load(file.choose())
sample <- subset(res_data, BookingLanguage == "EN")
sample1 <- subset(sample, select = c(Reservation_ID,res_year,res_month,residency,destination,location,rental_days,supplier,NPS_1To10,CES_1To5,CSTAT_0To100,CSTAT_Car_Desk_DropO_Price_PickU,comment))
sample1 <- sample1 %>% separate(CSTAT_Car_Desk_DropO_Price_PickU, c('CSAT_Car', 'CSAT_Desk','CSAT_Drop','CSAT_Price','CSAT_PickUp'), "-")

#-----------------------------------------------------------------------------------------------------------------------------
##NRC ANALYSIS OF POSITIVE COMMENT
###################################

sample1$comment[7520]
sentiScore_bing <- get_sentiment(as.character(sample1$comment),method = "bing", path_to_tagger = NULL)
sentiScore_bing[7520]
sentiScore_afinn <- get_sentiment(as.character(sample1$comment),method = "afinn", path_to_tagger = NULL)
sentiScore_afinn[7520]
sentiScore_nrc <- get_sentiment(as.character(sample1$comment),method = "nrc", path_to_tagger = NULL)
sentiScore_nrc[7520]
sentiScore_syuzhet<- get_sentiment(as.character(sample1$comment),method = "syuzhet", path_to_tagger = NULL)
sentiScore_syuzhet[7520]
##NRC ANALYSIS OF NEGATIVE COMMENT
###################################

sample1$comment[2948]

sentiScore_bing[2948]
sentiScore_afinn[2948]
sentiScore_nrc[2948]
sentiScore_syuzhet[2948]

# Evaluate 4 types of sentiment scores from syuzhet package
###########################################
PolarityScore_nbing <- 0
sample1 <- cbind(sample1, PolarityScore_nbing)
sample1$PolarityScore_nbing <- get_sentiment(as.character(sample1$comment),method = "bing", path_to_tagger = NULL)

PolarityScore_afinn <- 0
sample1 <- cbind(sample1, PolarityScore_afinn)
sample1$PolarityScore_afinn <- get_sentiment(as.character(sample1$comment),method = "afinn", path_to_tagger = NULL)


PolarityScore_nrc <- 0
sample1 <- cbind(sample1, PolarityScore_nrc)
sample1$PolarityScore_nrc <- get_sentiment(as.character(sample1$comment),method = "nrc", path_to_tagger = NULL)

PolarityScore_syuzhet <- 0
sample1 <- cbind(sample1, PolarityScore_syuzhet)
sample1$PolarityScore_syuzhet <- get_sentiment(as.character(sample1$comment),method = "syuzhet", path_to_tagger = NULL)

# Top 10 frequent suppliers
############################

top10_freq <- aggregate(x = sample1$supplier, by = list(unique.values = sample1$supplier), FUN = length)
top10_freq<-top10_freq[with(top10_freq, order(-x)), ]
names(top10_freq) <- c("Supllier", "frequency")

#RATIO
#############

Dollar<- subset(res_data, supplier == "DOLLAR")
sum(!is.na(Dollar$comment))/nrow(Dollar)


#-------------------------------------------------------------------------------------------------------------------

#HISTOGRAM POLARITYSCORE FREQUENCY FOR EACH SUPPLIER

filter(sample1$PolarityScore_nbing, supplier=="GOLDCAR")
hist(x= filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_nbing')])

 plot_ly(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_nbing')], type = "histogram")
 plot_ly(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_nrc')], type = "histogram")
 plot_ly(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_afinn')], type = "histogram")
 plot_ly(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_syuzhet')], type = "histogram")

 plot_ly(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_nbing')], opacity = 0.6, type = "histogram",name = 'BING') %>%
   add_trace(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_nrc')], opacity = 0.6, type = "histogram", name = 'NRC') %>%
   add_trace(x = filter(sample1, supplier=="GOLDCAR")[,c('PolarityScore_afinn')], opacity = 0.6, type = "histogram", name = 'AFINN') %>%
   layout(barmode="overlay")
