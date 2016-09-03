----#carga de librerias-----

library(twitteR)
library(tm)
library(SnowballC)   
library(RCurl)
library(rvest)
library(dplyr)
library(XML)

---#auth-----------

# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

#set api_key
apiKey <-  "Y2wpWfd9K9HkdFfmDl97krZZa"
apiSecret <- "8uFpKmrWcjSrOrOBVdJ4MQZQz2pu8R49tXgtT7NICx7idm9lDg"

setup_twitter_oauth(apiKey,apiSecret,access_token="3730603636-D0zq4tV6C2Ghsuz9kC60iR0YrT665lPbzT915fq",access_secret="lnuJellbHLatl8vVSSwDOqSOBSu25X9fQD6aELxEIe3bo")

#PRESS 2

----#inputs----

#dates
#If not NULL, restricts tweets to those since the given date. Date is to be formatted as YYYY-MM-DD
date_since <- Sys.Date()-7

#If not NULL, restricts tweets to those up until the given date. Date is to be formatted as YYYY-MM-DD
date_until <- Sys.Date()

#states

url <- "http://www.state.gov/s/inr/rls/4250.htm"
states <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="centerblock"]/table[1]') %>%
  html_table()
states <- states[[1]]

colnames(states) = states[1, ] # the first row will be the header
states = states[-1, ]          # removing the first row.
states <- as.data.frame(apply(states,2,function (x) gsub("[^0-9A-Za-z///' ]", "",x)))

#list of words

words <- c('war','elections','god','crisis','pretoleum','sport','holiday')

#words <- paste(words,collapse="+")

----#search tweets----

mybiglist <- list()
for(i in 1:length(words)){
  a <- searchTwitter(words[i], n=1000,geocode = '-34,-64,40000km', since = as.character(date_since),until = as.character(date_until))
  mybiglist <- append(mybiglist,a)
}


---#Extract text content of all the tweets----

#Extract text content of all the tweets
tweetTxt = sapply(mybiglist, function(x) x$getText())
tweetTxt <- iconv(tweetTxt,to="utf-8")
#In tm package, the documents are managed by a structure called Corpus
myCorpus = Corpus(VectorSource(tweetTxt))
#Create a term-document matrix from a corpus
tdm = TermDocumentMatrix(myCorpus,control = list(removePunctuation = TRUE,stopwords = c(words, stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

#Convert as matrix
m = as.matrix(tdm)

#Get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE)

#Create data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
dm[dm$word %in% words,]
