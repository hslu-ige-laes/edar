library(imputeTS)
library(lubridate)
library(dplyr)
library(zoo)
library(tsbox)

df <- read.csv("https://github.com/hslu-ige-laes/edar/raw/master/sampleData/centralOutsideTemp.csv",
               stringsAsFactors=FALSE,
               sep =";")


df$time <- parse_date_time(df$time, "YmdHMS", tz = "Europe/Zurich")
df <- df %>% na.omit()

# tsbox package
df <- ts_regular(df)
rownames(df) <- df$time
df <- df %>% select(-time)

# what we finally want to do
p <- ggplot_na_distribution(df)

plotly::ggplotly(p) %>%
  plotly::config(displayModeBar = FALSE, displaylogo = FALSE)

# other approach when the steps are regular and only missing data
grid.df <- data.frame(time = seq(df[1, 1], df[nrow(df), 1], by = "hour"))
merge(df, grid.df)

df <- df %>% na.omit()

# =============================

df <- read.csv("sampleData/test.csv")
df$time <- parse_date_time(df$time, "YmdHMS", tz = "Europe/Zurich")
df <- ts_regular(df)
plot(df)

df <- na.omit(df)

xts <- as.xts(df, order.by = df$time)
periodicity(xts)
ggplot_na_distribution(df$centralOutsideTemp, x_axis_labels = df$time)
ggplot_na_intervals(df$centralOutsideTemp)

