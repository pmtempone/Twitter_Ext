----#load libraries---
library(twitteR)
library(RCurl)
# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
apiKey <-  "Y2wpWfd9K9HkdFfmDl97krZZa"
apiSecret <- "8uFpKmrWcjSrOrOBVdJ4MQZQz2pu8R49tXgtT7NICx7idm9lDg"


setup_twitter_oauth(apiKey,apiSecret, access_token = NULL,access_secret = NULL)
setup_twitter_oauth(apiKey,apiSecret, access_token =  3730603636-D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq,access_secret = lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo)
setup_twitter_oauth(apiKey,apiSecret, access_token = D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq,access_secret = lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo)
setup_twitter_oauth(apiKey,apiSecret,"3730603636-D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq","lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo")

twitCred <- OAuthFactory$new(
  consumerKey = apiKey, 
  consumerSecret = apiSecret,
  requestURL = reqURL,
  accessURL = accessURL, 
  authURL = authURL
  )

twitCred$handshake(
  cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")
  )

registerTwitterOAuth(twitCred)


library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)

 setup_twitter_oauth(apiKey,apiSecret,"3730603636-D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq","lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo")

#Collect tweets containing 'new year'
tweets = searchTwitter("new year", n=1000, lang="en")

#Extract text content of all the tweets
tweetTxt = sapply(tweets, function(x) x$getText())

#In tm package, the documents are managed by a structure called Corpus
myCorpus = Corpus(VectorSource(tweetTxt))

#Create a term-document matrix from a corpus
tdm = TermDocumentMatrix(myCorpus,control = list(removePunctuation = TRUE,stopwords = c("new", "year", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

#Convert as matrix
m = as.matrix(tdm)

#Get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 

#Create data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
dm[dm$word %in% words,]


# Pasos para nube macro

library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)

 setup_twitter_oauth(apiKey,apiSecret,"3730603636-D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq","lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo")
 
 #Collect tweets containing 'new year'
tweetsMacro = searchTwitter("#BancoMacro", n=2000)

#Extract text content of all the tweets
tweetTxt = sapply(tweetsMacro, function(x) x$getText())

#limpiar caracteres especiales
tweetsTxt2 <- sapply(tweetsTxt,function(row) iconv(row, "latin1", "ASCII", sub=""))

#In tm package, the documents are managed by a structure called Corpus
myCorpus = Corpus(VectorSource(tweetTxt))

#Create a term-document matrix from a corpus
tdm = TermDocumentMatrix(myCorpus,control = list(removePunctuation = TRUE,stopwords = c("#BancoMacro", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

#Convert as matrix
m = as.matrix(tdm)

#Get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 

#Create data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)

#Plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

#Marcamos positivos

pos <-scan('/Users/Pablo/Documents/sentiment/positive-words-es.txt', what='character',comment.char=';')

#Leemos palabras negativas

 neg <-scan('/Users/Pablo/Documents/sentiment/negative-words-es.txt', what='character',comment.char=';')
 
 #Intento de sentimiento de analisis
 
 qplot(x=analysis$score,geom="histogram")
 
 analysis = score.sentiment(dm, pos, neg)
 
 table(analysis$score)
 
 mean(analysis$score)
 
  hist(analysis$score)