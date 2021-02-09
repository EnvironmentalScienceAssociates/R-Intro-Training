############################################################
#########                                       ############
#########      ESA's Intro to R: gridEXTRA      ############
#########                                       ############
############################################################

# The following script is designed to introduce users to more 
# advanced aspects of gridEXTRA

library(tidyverse)
library(ggplot2)
library(gridExtra)

# Simple tasks with gridExtra

# Arranging multiple plots on a single page
# first load in the Pokemon dataset. 
poke <- read_csv(file.path("Data", "Pokemon.csv"))

poke_mod <- poke %>%
  filter(., stringr::str_detect("(Grass|Water|Fire)", `Type 1`)) #filter for just those with these types

poke_mod <- poke_mod %>%
  mutate(`Type 1` = factor(Type.1, levels = c("Fire","Water","Grass")))

str(poke_mod)

# build a few basic plots

atk_def <- ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = `Type 1`)) +
  geom_point() + theme(legend.position="bottom")

atk_hp <- ggplot(data = poke_mod, mapping = aes(x = Attack, y = HP, color = `Type 1`)) +
  geom_point() + theme(legend.position="bottom")

spd_hp <- ggplot(data = poke_mod, mapping = aes(x = Speed, y = HP, color = `Type 1`)) +
  geom_point() + theme(legend.position="bottom")

spatk_spdef <- ggplot(data = poke_mod, mapping = aes(x = `Sp. Atk`, y = `Sp. Def`, color = `Type 1`))+ 
  geom_point() + theme(legend.position="bottom")

# arrange in a 2x2 grid
grid.arrange(atk_def, atk_hp, spd_hp, spatk_spdef, ncol = 2, nrow = 2)

# Four legends are too much, can we make a common legend?

# Write a function to extrant the legend
g_legend<-function(plot){
  tmp <- ggplot_gtable(ggplot_build(plot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

# Use the function to extract the legend from a single plot
mylegend<-g_legend(atk_def)


# Complicated Grob arrangement 2 rows, row 1 is a 2x2 matrix
grid.arrange(arrangeGrob(atk_def + theme(legend.position = "none"), # Nested arrangeGrob allows for a
             atk_hp + theme(legend.position = "none"),              # nested matrix of plots as a single
             spd_hp + theme(legend.position = "none"),              # grob
             spatk_spdef + theme(legend.position = "none"),         # Back in the main arrangement, the first grob is the matrix
             ncol = 2, nrow = 2),                                   # second grob is the legend
             mylegend, nrow = 2, heights = c(30, 1))                 # Set the height of the rows (trial and error)

# What about if we have common variable on a single axis?
# common axis labels

atk_def <- ggplot(data = poke_mod, mapping = aes(x = Attack, y = Defense, color = Type.1)) +
  geom_point()+ 
  labs(x = "")+
  theme(legend.position="bottom")

atk_hp <- ggplot(data = poke_mod, mapping = aes(x = Attack, y = HP, color = Type.1)) +
  geom_point()+ 
  labs(x = "")+ 
  theme(legend.position="bottom")

atk_spd <- ggplot(data = poke_mod, mapping = aes(x = Attack, y = Speed, color = Type.1)) +
  geom_point()+ 
  labs(x = "")+
  theme(legend.position="bottom")

atk_spatk <- ggplot(data = poke_mod, mapping = aes(x = Attack, y = Sp..Atk, color = Type.1)) +
  geom_point()+ 
  labs(x = "")+ 
  theme(legend.position="bottom")

grid.arrange(mylegend, arrangeGrob(atk_def + theme(legend.position = "none"), #Do some rearranging to 
                         atk_hp + theme(legend.position = "none"),             
                         atk_spd + theme(legend.position = "none"),              
                         atk_spatk + theme(legend.position = "none"),
                         ncol = 2, nrow = 2),                         
             nrow = 2, heights = c(1, 30),
             bottom = "Attack")

# Opportunities here are endless

# Complicated/ Interesting plots using custom matrix layouts

layout = rbind(c(1,1,1,1,1,NA),
               c(2,2,2,2,2,3),
               c(2,2,2,2,2,3),
               c(2,2,2,2,2,3),
               c(2,2,2,2,2,3),
               c(2,2,2,2,2,3))

atk_histo <- ggplot(data = poke_mod, mapping = aes(x = Attack, fill = `Type 1`))+
  geom_histogram()+
  theme(
    legend.position = "bottom",
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title.x = element_blank()
  )

def_histo <- ggplot(data = poke_mod, mapping = aes(x = Defense, fill = `Type.1`))+
  geom_histogram()+
  theme(
    legend.position = "none",
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.y = element_blank()
  )+
  coord_flip()

mylegend<-g_legend(atk_histo)

grid.arrange(arrangeGrob(atk_histo + theme(legend.position = "none"), 
                         atk_def + theme(legend.position = "none") + labs(x = "Attack"), 
                         def_histo, 
                         layout_matrix = layout),
             mylegend, 
             nrow = 2, heights = c(30,1))
