#Inspect data students
library(dplyr)
library(tidyr)
library(janitor)

infile_students <- "data/imports/Baseline/student.rds"
infile_teachers <- "data/imports/Baseline/teacher.rds"
infile_schools <- "data/imports/Baseline/school.rds"

students <- rio::import(infile_students)
teacher <- rio::import(infile_teachers)
school <- rio::import(infile_schools)




print_tabyl <- function(database){
  
  indicators <- names(database)
  
  for(i in 1:length(indicators)){
    message(indicators[i])
    print(database %>% tabyl(indicators[i]))
    
  }
  
  
}

#print variables of students
print_tabyl(students)

#print variables of teacher 
print_tabyl(teacher)

#print variables of teacher 
print_tabyl(school_yes)


school_yes <- school %>% select(contains("yes"))

atrr(school$electricity_yes)
attributes(school$electricity_yes)

school