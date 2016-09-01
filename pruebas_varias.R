----#load libraries---
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(SnowballC)   

----#download tweets---

#setup auth
setup_twitter_oauth(apiKey,apiSecret,"3730603636-D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq","lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo")

#Collect tweets containing 'new year'
tweets = searchTwitter("war", n=1000,resultType="popular")
tweets = searchTwitter("brasil",n=1000,geocode = '-58.3918617027,-34.5916734896,100mi')

tweets <- searchTwitter('war', geocode='42.375,-71.1061111,10mi')

37.7821120598956

#Extract text content of all the tweets
tweetTxt = sapply(tweets, function(x) x$getText())

#In tm package, the documents are managed by a structure called Corpus
myCorpus = Corpus(VectorSource(tweetTxt))

#Create a term-document matrix from a corpus
tdm = TermDocumentMatrix(myCorpus,control = list(removePunctuation = TRUE,stopwords = c("war", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))


docs <- tm_map(myCorpus, removePunctuation)   
for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
}   
# inspect(docs[1]) # You can check a document (in this case the first) to see if it worked.

docs <- tm_map(docs, removeNumbers)   

docs <- tm_map(docs, tolower)   


docs <- tm_map(docs, removeWords, stopwords("english"))   

docs <- tm_map(docs, stemDocument)   

docs <- tm_map(docs, stripWhitespace)   

docs <- tm_map(docs, PlainTextDocument)   


dtm <- DocumentTermMatrix(docs)   
dtm   

tdm <- TermDocumentMatrix(docs)   
tdm   
freq <- colSums(as.matrix(dtm))   
length(freq)  


#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
inspect(dtms)  

freq[head(dtms)]   
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
findFreqTerms(dtm, lowfreq=50)   # Change "50" to whatever is most appropriate for your text data.


wf <- data.frame(word=names(freq), freq=freq)   


p <- ggplot(subset(wf, freq>50), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p
