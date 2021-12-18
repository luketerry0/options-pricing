#compile the tickers
amex <- tq_exchange("AMEX")
nasdaq <- tq_exchange("NASDAQ")
nyse <- tq_exchange("NYSE")

#allSymbols <- sort(c(amex$symbol, nasdaq$symbol, nyse$symbol))
allSymbols <- c("AAPL", "POOL", "SPY")

#get various statistics for the tickers
prices <- tq_get(allSymbols, get="stock.prices")
dividends <- tq_get(allSymbols, get="dividends")

