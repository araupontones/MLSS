dir_data <- "data/imports/Baseline"
library(janitor)
library(ggplot2)
list.files(dir_data)
extrafont::loadfonts(device = 'win')
extrafont::fonts()

#Ideas UI
# Select variable
# Division ()
# Density or not
# If not -- >Aggregation (Division aggregated (by round), compare with other divisions,compare districts within division)
# Type of chart (Aggregate, Distribution)
# If compare with other divisions | compare districts [Compare across rounds (Yes/NO)] --> If yes wrap ===

school <- import(file.path(dir_data, "school.rds"))
school |> tabyl(tch_present_clas)



#Box Plot ------------------------------------------------
school %>%
  filter(district_nam == "Lilongwe Rural West") %>%
  ggplot(aes(y = tch_present_clas,
             x = round
             )) +
  #geom_col(aes(y = mean(school$enrol_lower_tot, na.rm = T))) +
  geom_boxplot(binaxis='y', stackdir='center', dotsize=1, fill = '#A8D1DF') +
  geom_jitter(shape=16, position=position_jitter(0.2)
              )

  


#aggregate chart
school %>%
  filter(district_nam == "Lilongwe Rural West") %>%
  group_by(round) %>%
  summarise(mn = mean(wall_yes, na.rm = T)) %>%
  ggplot(aes(y = mn,
             x = round)) +
  geom_col()

  

#compare across groups chart (distribution)
school %>%
  ggplot(aes(y = dr_std2_f,
             x = division_nam
  )) +
  #geom_col(aes(y = mean(school$enrol_lower_tot, na.rm = T))) +
  geom_boxplot(binaxis='y', stackdir='center', dotsize=1, fill = '#A8D1DF') +
  geom_jitter(shape=16, position=position_jitter(0.2)
  )

#compare across unit chart
school %>%
  group_by(round, division_nam) %>%
  summarise(mn = mean(wall_yes, na.rm = T)) %>%
  ggplot(aes(y = mn,
             x = division_nam)) +
  geom_col()


#Density
school %>%
  ggplot() +
  geom_density(aes(x = hc_PTR_std6),fill = "lightgray") +
  geom_vline(aes(xintercept = mean(hc_PTR_std6, na.rm = T)), 
             linetype = "dashed", size = 0.6,
             color = "#FC4E07") +
  theme(text = element_text(family = "Roboto"))
