
todo <- c( "use ggplot2 library for plotting"
         , "test plotly library for interactive plots"
         , "there is a gapminder library, what is this providing to us?"
         , "quantify similarity between countries"
         ) 

writeLines(
"Visualisation of CoViD-19 time series
-------------------------------------
  
ToDo:
")
writeLines(paste("- ", todo, collapse="\n"))


read_covid19_ts <- function(directory="./COVID-19/csse_covid_19_data/csse_covid_19_time_series") {
  deaths <- read.csv(
              file.path(directory, "time_series_covid19_deaths_global.csv"), 
              sep=",", header=TRUE, as.is=TRUE)
  infected <- read.csv(
                 file.path(directory, "time_series_covid19_confirmed_global.csv"), 
                 sep=",", header=TRUE, as.is=TRUE)
  recovered <- read.csv(
                 file.path(directory, "time_series_covid19_recovered_global.csv"), 
                 sep=",", header=TRUE, as.is=TRUE)
  list(Deaths=deaths, Infected=infected, Recovered=recovered)
}

##################################################################
## helpers

# Vector of Booleans, true for the columns containing time series data
get_ts_data_columns <- function(ts) {
    startsWith(names(ts), "X")
}

# get the dates of a time series data frame
get_ts_dates <- function(ts) {
  as.Date(names(ts)[ts_data_columns(ts)], format="X%m.%d.%y")
}

# Difference of offset copy of the time series (normally offset should
# be 1 to calculate increase/decrease between time series steps)
diff_offset <- function(ts, offset=1) {
    ts[-offset]-ts[(offset+1):length(ts)-offset]
}

# Get the sliding average of a time series.
filter_sliding_avrg <- function(ts, width=7) {
    f <- rep(1/width, width)
    filter(ts, f, sides="1")
}

# Main plotting function for a single time series 
# @param data List of time series (data frames)
# @param country String identifiing the rows by the Country.Region column (some countries are divided into multiple rows)
# @param series String identifying the series in the data list
plot_daily <- function(data, country="Germany", series="Deaths",...) {
    df <- data[[series]] # get the right data frame
    x_labels <- names(df)[ts_data_columns(df)]  
    ts <- colSums(subset(df, Country.Region==country)[x_labels])
    x <- seq(ts)
    #deaths <- as.numeric(data$Deaths[line,5:ncol(data$Deaths)])
    #country <- data$Deaths$Country.Region[line]
    # todo use variable deaths 

    ts_per_day <- diff_offset(ts)
    sliding_avrg <- filter_sliding_avrg(ts_per_day)

    plot(x[-1], ts_per_day, 
         main=paste(series, "/Day", "(", country,")"), 
         pch=0, xlab="t", ylab="cases/day", 
         type="b", xaxt="n",...)
    axis(1, at=x, labels=ts_dates(df), col=1, las=3);
    lines(x[-1], sliding_avrg, col="red")
}


#########################################################################
## Code Storage (deprecated stuff)

plot_deaths <- function(line) {
     plot(seq(data$Deaths[0,5:length(data$Deaths[0,])]), 
              c(data$Deaths[line,5:length(data$Deaths[1,])]), 
              main=paste(c("CoVid-19 Deaths,", as.character(data$Deaths[line,2]), "cumulative"), collapse=" "), 
              xlab="t",ylab="deaths cumulative", 
              lty=1, lwd=1, xaxt="n")

     axis(1, 
          at=seq(6,ncol(data$Deaths))-5, 
          labels=names(data$Deaths[0,-(0:5)]), 
          col=1, las=3);
}

# main template for plotting function
plot_daily_death <- function(country="Germany") {
    deaths <- colSums(subset(data$Deaths, Country.Region==country)[,6:ncol(data$Deaths)])
    #deaths <- as.numeric(data$Deaths[line,5:ncol(data$Deaths)])
    #country <- data$Deaths$Country.Region[line]
    # todo use variable deaths 
    x_labels <- names(deaths)
    x_times <- seq(deaths)

    deaths_per_day <- deaths[-1]-deaths[2:length(deaths)-1]
    f7 <- rep(1/7, 7)
    sliding_deaths <- filter(deaths_per_day, f7, sides="1")
    print(x_times)

    plot(x_times[-1], deaths_per_day, 
         main=paste(c("Death/Day", country), collapse=" "), 
         pch=0, xlab="t", ylab="deaths/day", 
         type="b", xaxt="n")
    axis(1, at=x_times, labels=x_labels, col=1, las=3);
    lines(x_times[-1], sliding_deaths, col="red")
}
