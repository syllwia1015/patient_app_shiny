# load needed packages
packages <- c('shinydashboard', 'shinyWidgets','dashboardthemes', 'tidyverse', 'data.table', 'DT', 'plotly')

for(package in packages){
  if(!require(package, character.only = T, quietly = T)){
    install.packages(package, repos="http://cran.us.r-project.org")
    library(package, character.only = T)
  }
  library(package, character.only = T)
}


Random_LabValuesInfo_2020 <- read.table("../ShinyProgrammingExercise_2020-04//Random_LabValuesInfo_2020.tsv",  sep = '\t', header = TRUE)
Random_PatientLevelInfo_2020 <- read.csv("../ShinyProgrammingExercise_2020-04/Random_PatientLevelInfo_2020.tsv",  sep = '\t', header = TRUE)


data <- data.table(merge(Random_PatientLevelInfo_2020, Random_LabValuesInfo_2020, by = c('STUDYID', 'USUBJID')))
data[SEX == 'M', SEX := 'Male']
data[SEX == 'F', SEX := 'Female']
data[SEX == 'U', SEX := 'Undifferentiated']
data[SEX == 'UNDIFFERENTIATED', SEX := 'Undifferentiated']
