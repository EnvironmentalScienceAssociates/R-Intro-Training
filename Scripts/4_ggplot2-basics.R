############################################################
#########                                       ############
#########    ESA's Intro to R: ggplot basics    ############
#########                                       ############
############################################################

# The following script is designed to introduce users to the 
# basics of ggplot

library(ggplot2)
library(dplyr)

# first load in the data from a basic R dataset "iris" which 
# compares flower parts of different species of iris
 
iris <- iris

# examine the data

str(iris)
head(iris)

#### THE BASIC PLOT

# writing a simple ggplot object

sepL_vs_petL <- ggplot(data = iris, #where is the data stored
                       mapping = aes(x = Sepal.Length, #define the x variable
                                     y = Petal.Length)) #define the y variable

# Examine the gg object, why no "data"?
sepL_vs_petL

# What are the ranges of these data, and do they match the axes?
range(iris$Sepal.Length)
range(iris$Petal.Length)

# Tell ggplot what kind of geometry to show, lets start with points
sepL_vs_petL + geom_point()

#### AESTHETICS 
# aesthetics control the size, shape, and color of our geometries

# setting aesthetics for all points
sepL_vs_petL+
  geom_point(color = "black", #outline is black
             fill = "red", #fill is red
             shape = 21, #shape is a circle with an outline
             size = 1) #size = 1 pixel

# setting aesthetics for grouping on categorical variables
sepL_vs_petL+
  geom_point(mapping = aes(color = Species, # different color for each species
                            fill = Species, # different fill for each species
                            size = Species), # different size for each species
             shape = 21)
# why do we get a warning about size?
# Notice that the fill and outline color are the same color, why? How do we know?

# Specifying the "name" of each aesthetics scale separately shows each legend separately
# We will go over scales a bit later.
sepL_vs_petL+
  geom_point(mapping = aes(color = Species, # different color for each species
                           fill = Species, # different fill for each species
                           size = Species), # different size for each species
             shape = 21)+
  scale_color_discrete(name = "Species Outline")+
  scale_fill_discrete(name = "Species Fill")+
  scale_size_discrete(name = "Species Size")

# setting aesthetics for continuous variables
sepL_vs_petL+
  geom_point(mapping = aes(color = Petal.Length, # different color for each species
                           fill = Petal.Length), # different fill for each species
             shape = 21, size = 3)

#### GEOMETRIES

# Lines
sepL_vs_petL + geom_line()

# how does geom_line work?
# what happens if we arrange data based on smallest to largest

iris <- iris %>%
  arrange(Sepal.Length, Petal.Length)

sepL_vs_petL <- ggplot(data = iris, #where is the data stored
                       mapping = aes(x = Sepal.Length, #define the x variable
                                     y = Petal.Length)) #define the y variable
sepL_vs_petL + geom_line()



# Bar Charts
sepL_vs_petL + geom_bar()
# why doesn't this work?

# what is stat_count and how do we use it?

# read in data with more categories for subsetting
mtcars <- mtcars

#make some variables factors
mtcars_factor <- mtcars %>%
  mutate(cyl = factor(cyl, levels = c(2,4,6,8)),
         vs = factor(vs, levels = c(0,1), labels = c("V-Shaped","Flat")),
         am = factor(am, levels = c(0,1), labels = c("Automatic","Manual")))

# Basic Histogram
ggplot(data = mtcars_factor)+ #set the data here, but lets not add aesthetics, this is faster for tweaking
  geom_bar(aes(x = cyl))


# Histogram with additional grouping
ggplot(data = mtcars_factor)+ 
  geom_bar(aes(x = cyl, fill = vs))

# Histogram as percentages, rather than counts
ggplot(data = mtcars_factor)+ 
  geom_bar(aes(x = cyl, fill = vs), position = "fill")

# Histogram as counts, but to each side (dodged), making it easier to read
ggplot(data = mtcars_factor)+ 
  geom_bar(aes(x = cyl, fill = vs), position = "dodge")


# Box and Whisker
ggplot(data = mtcars_factor)+ 
  geom_boxplot(aes(x = cyl, y = mpg))

# Box and Whisker with a second level
ggplot(data = mtcars_factor)+ 
  geom_boxplot(aes(x = cyl, y = mpg, fill = vs))


#### Labeling 

# Labels help define the axes, titles, and legend

# Title and subtitle
ggplot(data = mtcars_factor)+ 
  geom_boxplot(aes(x = cyl, y = mpg, fill = vs))+
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat")

# Axes
ggplot(data = mtcars_factor)+ 
  geom_boxplot(aes(x = cyl, y = mpg, fill = vs))+
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Number of Cylinders",
       y = "Miles per Gallon (mpg)")

# Legend
# Labeling the legend is accomplished by naming the legend's scale
ggplot(data = mtcars_factor)+ 
  geom_boxplot(aes(x = cyl, y = mpg, fill = vs))+
  scale_fill_discrete(name = "Engine Shape")+ #We add in this line to define the "scale" for the fill
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Number of Cylinders",
       y = "Miles per Gallon (mpg)")


#### Scales
# Scales are important to help us see trends AND to help us define our legend components
# Two properties of graphs can be scaled: Aesthetics and Axes (covered in part 2)

# Scaling Aesthetics
# Scaling aesthetics can be done to adjust the colors, shapes, and sizes of geometries
# usually done using scale_[aesthetic]_manual to supply manual values, breaks, and labels

ggplot(data = mtcars_factor)+ 
  geom_point(aes(x = mpg, y = qsec, color = vs))+
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

ggplot(data = mtcars_factor)+ 
  geom_point(aes(x = mpg, y = qsec, color = vs))+
  scale_color_manual(name = "Engine Shape", values = c("blue","red"))+ # Change the colors to blue and red
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

ggplot(data = mtcars_factor)+ 
  geom_point(aes(x = mpg, y = qsec, shape = vs), size = 3)+
  scale_shape_manual(name = "Engine Shape", values = c(15,16))+ # Change the shape
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

ggplot(data = mtcars_factor)+ 
  geom_point(aes(x = mpg, y = qsec, size = vs))+
  scale_size_manual(name = "Engine Shape", values = c(2,4))+ # Change the size
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

ggplot(data = mtcars_factor)+ 
  geom_point(aes(x = mpg, y = qsec, size = vs))+
  scale_size_manual(name = "Engine Shape", # Define the legend name
                    breaks = c("V-Shaped","Flat"), # Define the break values (categories)
                    labels = c("OPTION 1","OPTION 2"), # Change the Legend Labels
                    values = c(2,4))+ # Define the Sizes of each category
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")