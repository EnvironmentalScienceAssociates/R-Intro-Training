## This script contains the code described in these slides:
## https://www.travishinkelman.com/r-intro-training/r-basics/

library(tidyverse)

## R Documentation
  
?mean
help("mean")

## Vectors

c(1, 2, 3)
c("a", "b", "c")
c(TRUE, FALSE, TRUE)
1:5
seq(from = 1, to = 5, by = 1)
seq(3, 1, -0.5)
2:-3

## Vector operations

seq(2, 10, 2) / 2
sqrt(c(1, 4, 9, 16))
c(1, 2, 3) * c(10, 11, 12)
paste0(c("flood", "dragon"), c("plain", "fly"))

## Type coercion

c(1, 2, "a", "b")
c(1, 2, TRUE, FALSE)
c("a", "b", TRUE, FALSE)

## Data Frames

data.frame(Integer = 1L:3L,
           Double = c(1, 2.5, 3),
           Logical = c(TRUE, FALSE, TRUE),
           Character = c("strings", "better", "name"),
           Factor = as.factor(c("factors", "are", "special")))

d <- data.frame(Integer = 1L:3L,
                Double = c(1, 2.5, 3),
                Logical = c(TRUE, FALSE, TRUE),
                Character = c("strings", "better", "name"),
                Factor = as.factor(c("factors", "are", "special")))
glimpse(d)

data.frame(Length4 = 1:4,
           Length2 = 1:2,
           Length1 = 1)

data.frame(Length4 = 1:4,
           Length3 = 1:3)

head(data.frame(x = 1:100, y = sample(1:100), z = rnorm(100)), n = 10)


## Tibbles

data.frame(Number = 1:2,
           Times2 = Number*2)

tibble::tibble(Number = 1:2,
               Times2 = Number*2)

data.frame(Length4 = 1:4,
           Length2 = 1:2)

tibble(Length4 = 1:4,
       Length2 = 1:2)

data.frame(x = 1:500, y = sample(1:500), z = rnorm(500))

tibble::tibble(x = 1:500, y = sample(1:500), z = rnorm(500))

## Working Directory

getwd()

## Writing Data

remotes::install_github("EnvironmentalScienceAssociates/esaRmisc")
library(esaRmisc)
tail(water_year_type)

write_csv(water_year_type, "WaterYearType.csv")
writexl::write_xlsx(water_year_type, "WaterYearType.xlsx")

## Reading Data

wyt_csv <- read_csv("WaterYearType.csv")
wyt_xlsx <- readxl::read_xlsx("WaterYearType.xlsx")
