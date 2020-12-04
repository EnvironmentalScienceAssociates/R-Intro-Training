## This script contains the code described in these slides:
## https://www.travishinkelman.com/r-intro-training/data-transformation/

library(tidyverse)

## Texas Housing Dataset

?txhousing
dim(txhousing)
nrow(txhousing)
names(txhousing)
head(txhousing, 5)
txhousing[106:110, ]
unique(txhousing$year)

## Filter
  
filter(txhousing, year == 2008)
filter(txhousing, year == 2008 & city == "Lubbock")
filter(txhousing, year == 2008 | city == "Lubbock")

df1 <- filter(txhousing, year > 2005 & year <= 2010)
unique(df1$year)

df2 <- filter(txhousing, year %in% 2006:2010)
unique(df2$year)

df3 <- filter(txhousing, city != "Lubbock")
"Lubbock" %in% df3$city

df4 <- filter(txhousing, !(year %in% 2006:2010))
unique(df4$year)

filter(txhousing, is.na(median))
nrow(filter(txhousing, median > 0))
nrow(filter(txhousing, !is.na(median)))
nrow(filter(txhousing, is.na(median) | median > 0))

## Arrange
  
arrange(txhousing, median)
arrange(txhousing, desc(median))
arrange(txhousing, desc(city), median)

df5 <- tibble(Col1 = c(2, NA, 1), Col2 = c("A", "T", "R"))
arrange(df5, Col1)
arrange(df5, desc(Col1))

## Select
  
select(txhousing, date, city, median)
select(txhousing, -city, -year, -month)
select(txhousing, -c(city, year, month))
select(txhousing, sales:date)
select(txhousing, -(sales:date))
select(txhousing, contains("e"))
select(txhousing, city, year, month, median_sale_price = median)

## Rename
  
rename(txhousing, median_sale_price = median)

## Pipe Operator
  
lubbock1 <- filter(txhousing, city == "Lubbock")
lubbock2 <- arrange(lubbock1, desc(year))
lubbock3 <- select(lubbock2, city, year, month, median)

lubbock <- 
  select(
    arrange(
      filter(txhousing, city == "Lubbock"), 
      desc(year)), 
    city, year, month, median)

lubbock <- txhousing %>% 
  filter(city == "Lubbock") %>% 
  arrange(desc(year)) %>% 
  select(city, year, month, median)

## Mutate
  
txhousing %>% 
  mutate(city = toupper(city),        
         avg_sale = volume/sales) %>% 
  select(city, year, month, volume, sales, median, avg_sale)

## Group By and Summarize
  
txhousing %>% 
  filter(city == "Dallas" & year > 2004) %>% 
  group_by(year) %>% 
  summarize(avg_median = mean(median, na.rm = TRUE)) 

## Group By and Summarize
  
txhousing %>% 
  filter(city %in% c("Dallas", "Houston") & year %in% 2006:2010) %>% 
  group_by(city, year) %>% 
  summarize(avg_median = mean(median, na.rm = TRUE))

## Group By and Filter
  
txhousing %>% 
  group_by(city) %>% 
  filter(median > quantile(median, probs = 0.9, na.rm = TRUE))

## Group By and Mutate
  
txhousing %>% 
  group_by(year) %>% 
  mutate(prop_max = median/max(median, na.rm = TRUE)) %>% 
  select(city, year, month, median, prop_max)

