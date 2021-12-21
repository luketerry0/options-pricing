#relevant libraries
library("tidyquant")
library("stringi")
library("DescTools")

#compile the tickers
amex <- tq_exchange("AMEX")
nasdaq <- tq_exchange("NASDAQ")
nyse <- tq_exchange("NYSE")

#allSymbols <- sort(c(amex$symbol, nasdaq$symbol, nyse$symbol))
allSymbols <- c("POOL", "SPY", "AAPL")

#get various statistics for the tickers
prices <- tq_get(allSymbols, get="stock.prices")
dividends <- tq_get(allSymbols, get="dividends")
options <- as.data.frame(matrix(ncol = 4))

#more formatting required for options chain
colnames(options) <- c("symbol", "strike.price", "exp.date")
options <- options[-1,]

for (i in 1:length(allSymbols)){
  op <- quantmod::getOptionChain(allSymbols[i])
  
  #get the symbol
  str <- row.names(op$calls)
  digindex <- strtoi(StrPos(str,stri_extract_first(str, regex = "\\d")))
  opsym <- substring(row.names(op$calls),1,digindex - 1)
  
  #get the strike price
  opstrprice <- op$calls$Strike
  
  #get the exp date
  opexpdate <- substring(row.names(op$calls), digindex, 10)
  # opexyr <- substring(opexpdate, 1, 2)
  # opexmonth <- substring(opexpdate, 3, 4)
  # opexday <- substring(opexpdate, 5, 6)
  
  specop <- data.frame(opsym, opstrprice, opexpdate)
  colnames(specop) <- c("symbol", "strike.price", "exp.date")
  options <- rbind(options, specop)
}