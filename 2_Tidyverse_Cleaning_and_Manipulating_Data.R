## Special Topic | Data Analysis and Visualization with R | Part II  ---------------------

# Matt Steele, Government Information Librarian, West Virginia University 

# R download and documentation - https://cran.r-project.org/
# RStudio download and documentation - https://rstudio.com
# This workshop was developed using the O'Reilly Platform Lesson video - R Programming for Statistics and Data Science  
# https://libwvu.on.worldcat.org/oclc/1062397089
# For more in-depth information and practical exercises on using R for Data science, I highly suggest using this resource

#Loading the Packages that we need ________________________________________

  install.packages("tidyverse")
  install.packages("foreign")
  install.packages("Hmisc")
  install.packages("descr")
  install.packages("glue")
  install.packages("skimr")

  library(tidyverse)
  library(foreign)
  library(Hmisc)
  library(descr)
  library(glue)
  library(skimr)
  

## Tidyverse ----------------------------------------------------------------
  
  # collection of packages for data analysis and data visualizations
  
  ## ggplot2 - data visualization - https://ggplot2.tidyverse.org/
  
  ## tibble - lighter and more user-friendly version of data.frame() - https://tibble.tidyverse.org/
  
  ## tidyr - create tidy and meaningfully arranged data - https://tidyr.tidyverse.org/
  
  ## readr - sidesteps the limitations of the R functions when importing data into R - https://readr.tidyverse.org/
  
  ## purrr - better functional programming = https://purrr.tidyverse.org/
  
  ## dplyr - data manipulation tools - https://dplyr.tidyverse.org/

  
#Working Directory ----------------------------------------------------------
  
  getwd()
  setwd()  

  
#Importing data -----------------------------------------------------------
  
  #Import SPSS data with value labels
  
  spssDemo <- read.spss("demo.sav", use.value.labels = T)

    # read.table allows you to do unique arguments while read_table will load the date frame as a tibble
    # you can still create a tibble data drame using as_tibble

  spssDemo <- as_tibble(spssDemo)
  spssDemo
  
  
  # Import SPSS data with numeric values
   
  spssDemo_num <- read.spss("demo.sav", use.value.labels = F)
  spssDemo_num <- as_tibble(spssDemo_num)
  
  spssDemo_num
  
  # Export SPSS file as a CSV file
  
  quickSave <- write_csv(spssDemo, file = "Demographic_data.csv")
  
  

## Dplyr Package ---------------------------------------------------------------
  
  #Dplyr allows you to use it's built-in functions to manipulate data
  
  
# Computing and Re-coding Variables ----------------------------------------
  
#To duplicate an existing variable,
  
  spssDemo$age_up = spssDemo$age
  
  View(spssDemo)
  
  quickSave
  
#To compute a new variable from a mathematical transformation:
  
  spssDemo$age_up = spssDemo$age*2
  
  summary(spssDemo$age)
  summary(spssDemo$age_up)
  
#Recoding variables makes new variables out of existing variables.
  
  # Adding a numeric value to an categorical variable
  
  freq(spssDemo$inccat)
  
  # Use the structure function to recode variables
  
    summary(spssDemo$inccat)
    spssDemo <- mutate(spssDemo, inccat_num = recode_factor(inccat, "Under $25" = 1, "$25 - $49" = 2, "$50 - $74" = 3, "$75+" = 4, .ordered = T, ))
    
    quickSave
    
    # see the result 
    
    view(spssDemo)
  
  
    freq(spssDemo$inccat_num)
    summary(spssDemo$inccat_num)
    str(spssDemo$inccat_num)
    
# Recoding a numerical variabe //age/// into Age Groups <30=1, 30-40=2, >40=3
  
  spssDemo$age_cat[spssDemo$age<30]=1
  spssDemo$age_cat[spssDemo$age>=30 & spssDemo$age<=40]=2
  spssDemo$age_cat[spssDemo$age>40]=3
  
  view(spssDemo)

# Remove or recode absent data --------------------------------------------------------
  
  #We can remove absent data using the mutate function from Dplyr. However the data value must match current contents of the 
  
  #Some packages have datasets included in the package that you can load and practice on. 
  
  view(starwars)
  starwars
  
  #replace a column
  

  help("replace_na")
  
  starwars <- starwars %>% mutate(height = ifelse(is.na(height), 999, height))
  view(starwars)
  
  #remove NA values
  
  #Some packages have datasets included in the package that you can load and practice on. 
  
  view(starwars)
  
  starwars_removedNA <- na.omit(starwars)
  starwars_removedNA  

## Manipulate Data ----------------------------------------------------------------
  
  #filter(data, criterion) - subsets data according to criteria
  
  spssDemo_genderMale <- filter(spssDemo, gender == "Male") 
  spssDemo_genderMale
  
  spssDemo_genderMale_over50 <- spssDemo %>% filter(gender == "Male") %>% filter(age >= 50) 
  spssDemo_genderMale_over50
  
  skim(spssDemo_genderMale_over50$income)
  mean(spssDemo_genderMale_over50$income)
  
  #select(data) - keeps the variables you mention
  
  spssDemo_technology <- select(spssDemo_num, wireless:response)
  spssDemo_technology
  
  
  crosstab(spssDemo_technology$wireless, spssDemo_technology$response, chisq = T)
    
  
  
  #mutate(...) - adds a new variable and preserves the rest
  
  spssDemo_technology_totals <- mutate(spssDemo_technology, "total_technology" = wireless + multline + voice + pager + internet + callid + callwait + owntv + ownvcr +owncd + ownpda + ownpc + ownfax + news + response)
  spssDemo_technology_totals
  
  mean(spssDemo_technology_totals$total_technology)
  
  
  #transmutate(...) adds a new variable and drops the rest
  
  spssDemo_technology_totals_alone <- transmute(spssDemo_technology, "total_technology" = wireless + multline + voice + pager + internet + callid + callwait + owntv + ownvcr +owncd + ownpda + ownpc + ownfax + news + response)
  spssDemo_technology_totals_alone
  
  skim(spssDemo_technology_totals_alone)
  
  spssDemo$total_technology <- spssDemo_technology_totals_alone
  view(spssDemo)
  
  
  #arrage(...) allows you to sort your data
  
  help("arrange")
  
  
  arrange(spssDemo_technology_totals, desc(total_technology))
  
  
  spssDemoArrange <- arrange(spssDemo, +age)
  arrange(spssDemo, -age)
  

  #summarize(...) summarizes a data frame in a single result
  
  spssDemo_meanTechnology <- dplyr::summarise(spssDemo, avgTechnology = mean(age)) 
  spssDemo_meanTechnology
  
  
  starwarsMeanBmi <- dplyr::summarize(starwars, avg.BMI = mean(BMI))
  starwarsMeanBmi
  
  starwarsAvgBirthYear <- dplyr::summarize(starwars, avg.birth_year = median(birth_year))
  starwarsAvgBirthYear
  
  
  #group_by(...) - splits the dataset into groups
  
  starwarsEyeColor <- group_by(starwars, eye_color)
  
  summarize(starwarsEyeColor, avg.BMI = mean(BMI))
  
 
  #Sampling Data
  
  #sample(...)
  
  #sample_n(...) extracts a random sample of a fixed number of rows
  sample_n(starwars, 10, replace = T)
  
  #sample_fract(...) extracts a random sample of a fixed percentage of rows
  sample_frac(starwars, .2, replace = T)
  
  starwars.sample <- sample_n(starwars, 10, replace = F)
  starwars.sample
  mean(starwars.sample$BMI)
  
 ## Tidyr ---------------------------------------------------------------------
  
  # Package for tidying data in R
  
  # Gather(...) ## is the function that reorganizes data that have values as column names
  
  help("gather")
  
  covid19.us <- read.csv("time_series_covid19_confirmed_US.csv", stringsAsFactors = F)
  covid19.us <- as_tibble(covid19.us)
  covid19.us
  
  # gather(data, col.m:col.n, key, value)
  # key # is the name of the new variable that will hold the values that are currently column names
  # value # is the name of the new variable that will hold the values previously help by the columns
  
  covid.gathered <- covid19.us %>% gather(January.22..2020:October.19..2020, key = "Date", value = "Cases", na.rm = T) %>% arrange(-Cases)
  
  covid.gathered
  
  # Separate(column name, sep ="", into = "") ## breaks values in one column into multiple columns
  
  help("separate")
  
  covid.separate <- covid.gathered %>% separate(Combined_Key, sep = ", ", into = c("City", "State", "Country"))
  covid.separate
  
  # What about the date
  
  covid.separate$Date <- as.Date(x = covid.separate$Date, tryFormats = c("%B.%d..%Y"))
  covid.separate
  
  # Unite(...) ## combine two or more columns
  
  help("unite")
  
  covid.united <- covid.separate.date %>% unite("Date", sep = "-", c("Year", "Month", 'Day'))
  covid.united$Date <- as.Date(covid.united$Date)
  covid.united
  
  #spread(...) help to tidy data of one observation in multiple rows
  
  weather <- read.csv("weather.csv")
  weather <- as_tibble(weather)
  weather
  
  weather.spread <- spread(weather, key = element, value = value)
  weather.spread
  
  
