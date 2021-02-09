############################################################
#########                                       ############
#########   ESA's Intro to R: advanced ggplot   ############
#########                                       ############
############################################################

# The following script is designed to introduce users to more 
# advanced aspects of ggplot

library(tidyverse)

# first load in the Pokemon dataset. 
poke <- read.csv("~/R/R-Intro-Training/Data/Pokemon.csv")

poke <- poke %>%
  mutate_if(., is.factor, as.character)

poke_mod <- poke %>%
  filter(Type.1 %in% c("Grass","Water","Fire")) #filter for just those with these types

str(poke_mod)

#Load a basic plot

ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point()

# Facetting
# Facetting can be used to help distinguish groups when plots
# become too cluttered

# first lets facet into columns
ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point() +
  facet_grid(. ~ Type.1) # grammar here is [rows] ~ [columns], a period denotes empty

# we can also facet by row
ggplot(data = poke_mod, mapping = aes(x = Attack, fill = Type.1)) +
  geom_histogram() +
  facet_grid(Type.1 ~ .) # facet by rows

# What about when one group is more abundant than another
# lets change the data to make water type six times more abundant

poke_mod %>%
  base::split(., .$Type.1) %>% # Split the dataset by type
  purrr::map(~ dplyr::filter(., Type.1 == "Water")) %>% # Filter the dataset for only water pokemon
  base::Filter(function(x) dim(x)[1] > 1, .) %>%
  base::rep(., 5) %>% # Repeat the entire data set 5 times for 6 records
  base::do.call(rbind, .) %>% #bind all the rows together into a single table
  base::rbind(., poke_mod) -> six_times_water # Bind the new table to the old

# Plot historgams as before
ggplot(data = six_times_water, mapping = aes(x = Attack, fill = Type.1)) +
  geom_histogram(binwidth = 5) +
  facet_wrap(~Type.1, ncol = 1 , scales = "free_y")
# Hard to read Fire and Grass, y-axis scale determined by Water-Type

# Fix this by allowing the y-scales to be free
ggplot(data = six_times_water, mapping = aes(x = Attack, fill = Type.1)) +
  geom_histogram() +
  facet_grid(Type.1 ~ . , scales = "free_y")
# much better

# Can include Facets for both rows and columns to further 
# separate data
ggplot(data = poke_mod, mapping = aes(x = Attack, fill = Type.1)) +
  geom_histogram() +
  facet_grid(Type.2 ~ Type.1,)

ggplot(data = poke_mod, mapping = aes(x = Attack, fill = Type.1)) +
  geom_histogram() +
  facet_grid(Legendary ~ Type.1,)


#### Statistics

#Smoothers 
# Smoothers turn point data into a smoothed curve
ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, col = Type.1)) +
  geom_point() +
  geom_smooth(se = TRUE, span = 0.2)
# se = FALSE turns off the standard error ribbon
# span = 0.7 determines the "wiggliness" of the curve try other combos, higher = less squiggle

# geom_histogram is another stat we've already used
ggplot(data = poke_mod, mapping = aes(x = Attack)) +
  geom_histogram()

# can also make a histogram using geom_bar and stat = "bin"
# geom_histogram is just a wrapper

# Plotting statistical functions and distributions
# create x-values for distribution
x <- data.frame(x = seq(-4, 4, length = 1000))

# plotting normal distribution with ggplot
ggplot(data = x, mapping = aes(x = x)) +
  stat_function(fun = dnorm)

# plotting t-distribution with ggplot
t_distribution <- ggplot(data = x, mapping = aes(x = x)) +
  stat_function(fun = dt, args = list(df = 20))

# get y-values for corresponding x-values for t-distribution
data <- data.frame(x = x, y = dt(x$x, df = 20))

# get two-tailed critical value for t-distribution
# with 20 degrees of freedom and alpha = 0.05
critical_value <- qt(0.025, 20)

t_distribution +
  geom_area(data = subset(data, x <= critical_value), 
            mapping = aes(x = x, y = y), fill = "red") +
  geom_area(data = subset(data, x >= abs(critical_value)), 
            mapping = aes(x = x, y = y), fill = "red") +
  geom_vline(xintercept = c(critical_value, abs(critical_value))) +
  annotate("text", x = -3.5, y = 0.375, 
           label = "alpha = 0.05") +
  annotate("text", x = -3.25, y = 0.05, 
           label = paste("critical value = ", round(critical_value, digits = 3)), col = "red") +
  annotate("text", x = 3.25, y = 0.05, 
           label = paste("critical value = ", round(abs(critical_value), digits = 3)), col = "red")

# Summarizing y-values at an X
ggplot(data = poke_mod, mapping = aes(x = Type.1, y = Speed)) +
  geom_jitter(width = 0.1) + # geom_jitter creates point geometries which are separated randomly
  stat_summary(geom = "point", fun.y = "median", size = 5, aes(colour = Type.1)) # here we find the median y-value


# can also find the mean
ggplot(data = poke_mod, mapping = aes(x = Type.1, y = Speed)) +
  geom_jitter(width = 0.1) + # geom_jitter creates point geometries which are separated randomly
  stat_summary(geom = "point", fun.y = "mean", size = 5, aes(colour = Type.1)) # here we find the mean y-value

#### Coordinates and Scales
# We've already seen how we can assign x and y coordinates, but
# we can also use the coordinate system to display better

# lets recorder the count data by type for all pokemon types
highest_to_lowest <- poke %>%
  dplyr::group_by(., Type.1) %>%
  dplyr::summarise(n = n()) %>%
  dplyr::arrange(., n) %>%
  dplyr::pull(., Type.1) %>%
  base::unique(.)
poke$Type.1 <- factor(poke$Type.1, levels = highest_to_lowest)

# plot the standard way
ggplot(data = poke, mapping = aes(x = Type.1)) +
  geom_bar()
# x-axis is cluttered! Can we switch x and y?
ggplot(data = poke, mapping = aes(y = Type.1)) +
  geom_bar()
#Nope! so what can we do?
ggplot(data = poke, mapping = aes(x = Attack)) +
  geom_bar()+
  coord_fixed(ratio = 2) # add in the coord_flip() call

# Scaling Axes
# Adjusting the axes to represent different scales/information is done through a simple call:

# scale_x_[function]() or scale_y_[function]()

# built in scale functions are: continuous, discrete, log10, sqrt, and reverse
# discrete scale only works for categorical variables (text, factor, integer)
# all other scales only work for continuous numeric variables


ggplot(data = mtcars)+ 
  geom_point(aes(x = mpg, y = qsec))+
  scale_x_continuous()+ #This is where we can scale the x-axis
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

ggplot(data = mtcars)+ 
  geom_point(aes(x = mpg, y = qsec))+
  scale_x_continuous(breaks = c(10,20,30))+ #change the "breaks" (labels)
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

ggplot(data = mtcars)+ 
  geom_point(aes(x = mpg, y = qsec))+
  scale_x_reverse()+ #change the scale to reverse?
  labs(title = "Miles per Gallon vs. Cylinder Count",
       subtitle = "V-Shaped vs. Flat",
       x = "Quarter Mile Time (seconds)",
       y = "Miles per Gallon (mpg)")

# what about zooming into specific parts of the data?
ggplot(data = mtcars, aes(x = mpg))+
  geom_histogram()

# lets focus on cars above 25 mpg
# use scale_x_continuous and set limits, and make new breaks
ggplot(data = mtcars, aes(x = mpg))+
  geom_histogram()+
  scale_x_continuous(limits = c(25, 35), breaks = seq(25,35,2))

# We can also use scales to plot non-normal data using transformations
library(gapminder)

ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ log(x))
# This doesn't look very good, and clearly log scale would do better

ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_log10()
# Now we have a linear plot which shows a better relationship

#### Themes
# Themes allow us to change the appearance of ggplots
# ggplot contains a number of native themes some better than others

#minimal
ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point() +
  labs(title = "Defending/Attacking Scatter Plot By Pokemon Type") +
  theme_minimal()

# the theme() command helps us to get more control
ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point() +
  labs(title = "Defending/Attacking Scatter Plot By Pokemon Type") +
  theme_minimal()+
  theme(
    plot.title = element_text(hjust = 0.5) # hjust 0 = left, 0.5 = center, 1 = right
  )

# how much can we change? everything!!
ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point() +
  labs(title = "Defending/Attacking Scatter Plot By Pokemon Type",
       x = "Base Attacking Skills",
       y = "Base Defending Skills") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 20), # adjust the centering and size of title
        legend.position = "bottom", # positions the legend on the bottom
        legend.title = element_text(size = 15), # change the legend title font size
        legend.text = element_text(size = 12), # change the legend label font size
        axis.title.x = element_text(size = 15), # change the axis title font size
        axis.text.x = element_text(size = 15), # change the axis label font size
        axis.title.y = element_text(size = 15), # change the axis title font size
        axis.text.y = element_text(size = 15)) + # change the axis label font size
  scale_color_discrete(name = "Pokemon Type", # make some fancy names in the legend using aesthetic scale
                       labels = c("Fire Pokemon",
                                  "Grass Pokemon",
                                  "Water Pokemon"))

# This is pretty intense, can you make it easier? 
# Use the ESA Template!! Simply copy and paste from lines 260 to 287 at the top of your script

library(ggthemr)

# Create a palette of the ESA brand colors, alternating between each color and shade
esa_colours <- c('#F9A134', '#699CC6', '#A0CF67', '#9370B1', '#F26531', '#72CCD2', '#098A5B', '#781D7E','#B12533', '#004261', '#015E44', '#421953', '#DCDDDE', '#ADAFB2', '#6D6E71')
esa_colours <- c('#000000', esa_colours) #Add black as the "initial" color (outlining boxes, and plain plots)

esa_theme <- define_palette(
  swatch = esa_colours, # colors for plotting points
  gradient = c(lower = esa_colours[7L], upper = esa_colours[11L]), # upper and lower colors for continuous colors
  background = '#FFFFFF' # White background
)

# Apply create this as a "theme" in ggthemr
ggthemr(esa_theme, type = "outer", layout = "minimal", spacing = 3)

# Finally we create a theme which we can call in ggplot!
theme_esa <- function(base_size = 11, base_family = "", base_line_size = base_size/22, base_rect_size = base_size/22){
  theme_bw(base_size = base_size, base_family = base_family,
           base_line_size = base_line_size, base_rect_size = base_rect_size) %+replace%
    theme(panel.border =element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.line = element_line(color = '#000000', size = rel(1)),
          legend.key = element_blank(),
          plot.title = element_text(size = 18, face = 'bold'),
          plot.subtitle = element_text(size = 12, face = 'italic', color = 'grey40'),
          plot.caption = element_text(hjust = 0, size = 9, color = 'grey30'),
          strip.background = element_rect(fill = '#FFFFFF', color = "#000000", size = rel(2)), complete = TRUE)
}

# Test it out
ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point() +
  labs(title = "Defending/Attacking Scatter Plot By Pokemon Type",
       x = "Base Attacking Skills",
       y = "Base Defending Skills") +
  theme_esa() + # THEME IS HERE
   scale_color_manual(name = "Pokemon Type", # make some fancy names in the legend using aesthetic scale
                      labels = c("Fire Pokemon",
                                 "Grass Pokemon",
                                 "Water Pokemon"),
                      values = c(esa_colours[2], esa_colours[4], esa_colours[3])) # scale the colors manually to ensure they match (can we do this another way?)

# alternate
poke_mod <- poke_mod %>%
  mutate(Type.1 = factor(Type.1, levels = c("Fire","Water","Grass")))

ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point() +
  labs(title = "Defending/Attacking Scatter Plot By Pokemon Type",
       x = "Base Attacking Skills",
       y = "Base Defending Skills") +
  theme_esa() + # THEME IS HERE
  scale_color_discrete(name = "Pokemon Type", # make some fancy names in the legend using aesthetic scale
                     labels = c("Fire Pokemon",
                                "Water Pokemon",
                                "Grass Pokemon"))
