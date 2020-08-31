############################################################
#########                                       ############
#########    ESA's Intro to R: ggplot basics    ############
#########                                       ############
############################################################

# The following script is designed to introduce users to the 
# basics of ggplot

library(ggplot2)

# first load in the data from a basic R dataset "iris" which 
# compares flower parts of different species of iris
 
iris <- iris

# examine the data

str(iris)
head(iris)

# writing a simple ggplot object

sepL_vs_petL <- ggplot(data = iris, #where is the data stored
                       mapping = aes(x = Sepal.Length, #define the x variable
                                     y = Petal.Length)) #define the y variable

# Examine the gg object, why no "data"?
sepL_vs_petL

range(iris$Sepal.Length)
range(iris$Petal.Length)

