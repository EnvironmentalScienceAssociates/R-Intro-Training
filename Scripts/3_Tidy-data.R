library(tidyverse)

## Pivot Wider

txhousing %>% 
  filter(year %in% 2004:2012 & city == "San Antonio" & 
           month %in% 4:10) %>% 
  pivot_wider(id_cols = year, names_from = "month", 
              values_from = "median")

det <- tibble(FishID = c(rep("X1", 3), rep("X2", 4), rep("X3", 4)),
              Day = c(1, 3, 4, 1, 2, 3, 4, 1, 5, 6, 7),
              Receiver = c("A", "C", "D", "A", "D", "E", "F", 
                           "A", "B", "C", "E"))

det %>% 
  mutate(Presence = 1) %>% 
  pivot_wider(id_cols = FishID, names_from = "Receiver", 
              values_from = "Presence", values_fill = 0)

det %>% 
  mutate(Presence = 1) %>% 
  arrange(Receiver) %>% 
  pivot_wider(id_cols = FishID, names_from = "Receiver", 
              values_from = "Presence", values_fill = 0)

## Pivot Longer

det %>% 
  mutate(Presence = 1) %>% 
  arrange(Receiver) %>% 
  pivot_wider(id_cols = FishID, names_from = "Receiver", 
              values_from = "Presence", values_fill = 0) %>% 
  pivot_longer(cols = -FishID, names_to = "Receiver", 
               values_to = "Presence")

det %>% 
  mutate(Presence = 1) %>% 
  arrange(Receiver) %>% 
  pivot_wider(id_cols = c(FishID, Day), names_from = "Receiver", 
              values_from = "Presence", values_fill = 0) %>% 
  pivot_longer(cols = -c(FishID, Day), names_to = "Receiver", 
               values_to = "Presence")

## Left Join

rec <- 
  tibble(Receiver = LETTERS[1:6],
         RKM = c(33, 28, 20, 15, 9, 1))

left_join(det, rec)

left_join(det, rec) %>% 
  ggplot(aes(x = Day, y = RKM, col = FishID)) +
  geom_point(size = 3) +
  geom_line(size = 1)

## Separate

tibble(Species_Lifestage = c("Chinook_Spawning", "Chinook_Fry",
                             "Steelhead_Spawning", "Steelhead_Fry"),
       Count = c(12, 980, 17, 1234)) %>% 
  separate(col = "Species_Lifestage", 
           into = c("Species", "Lifestage"))

## Unite

tibble(Species_Lifestage = c("Chinook_Spawning", "Chinook_Fry",
                             "Steelhead_Spawning", "Steelhead_Fry"),
       Count = c(12, 980, 17, 1234)) %>% 
  separate(col = "Species_Lifestage", 
           into = c("Species", "Lifestage")) %>% 
  unite(Species_Lifestage, Species, Lifestage)

## Unite

tibble(Species_Lifestage = c("Chinook_Spawning", "Chinook_Fry",
                             "Steelhead_Spawning", "Steelhead_Fry"),
       Count = c(12, 980, 17, 1234)) %>% 
  separate(col = "Species_Lifestage", 
           into = c("Species", "Lifestage")) %>% 
  unite(Species_Lifestage, Species, Lifestage, sep = ".")




