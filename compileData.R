compileData <- function(allSymbols){
  #relevant libraries
  library("tidyquant")
  library("stringi")
  library("DescTools")
  
  #compile the tickers
  # amex <- tq_exchange("AMEX")
  # nasdaq <- tq_exchange("NASDAQ")
  # nyse <- tq_exchange("NYSE")
  
  #allSymbols <- sort(c(amex$symbol, nasdaq$symbol, nyse$symbol))
  #allSymbols <- c("POOL", "SPY", "AAPL") #test mode
  
  #get various statistics for the tickers
  prices <- tq_get(allSymbols, get="stock.prices")
  dividends <- tq_get(allSymbols, get="dividends")
  options <- as.data.frame(matrix(ncol = 10))
  
  #more formatting required for options chain
  colnames(options) <- c("Strike","Last","Chg","Bid","Ask","Vol","OI","LastTradeTime","IV","ITM")
  options <- options[-1,]

  for (i in 1:length(allSymbols)){
    op <- quantmod::getOptionChain(allSymbols[i])$calls

    options <- rbind(options, op)
  }
  
  list(prices, options, dividends)
}

getSymbol <- function(x){
  #gets the symbol of the underlying stock given a string of the options name
  digindex <- strtoi(StrPos(x,stri_extract_first(x, regex = "\\d")))
  opsym <- substring(x,1,digindex - 1)
  opsym
}

getUpcomingDividendSymbols <- function(days=30){
  #returns a vector of stock tickers with an upcoming dividend within the variable days
  library("tidyquant")
  
  da <- read.csv("da.csv")
  div <- tq_get(da$Ticker, "dividends")
  
  library(lubridate)
  #get data 

  daysPerYear = 365
  if (leap_year(today())){
    daysPerYear = 366
  }
  daysUntilYearEnds = daysPerYear - yday(today())
  
  if (daysUntilYearEnds < days){
    
    div_a <- subset(div, (yday(div[2]$date) >=  (days - daysUntilYearEnds)))
    div_b <- subset(div, (yday(div[2]$date) - yday(today())) > 0)
    div <- merge(div_a, div_b)
    
  }else{
    
    div <- subset(div, (yday(div[2]$date) - yday(today())) > 0)
    div <- subset(div, (yday(div[2]$date) - yday(today())) <= days)
  }
  unique(div$symbol)
}