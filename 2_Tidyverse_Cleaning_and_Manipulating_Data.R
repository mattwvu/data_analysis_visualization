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
  
  # If you want to import data from other statistical software programs, you can use the foreign library.
  
  # CRAN Documentation for "Foreign" - https://cran.r-project.org/web/packages/foreign/foreign.pdf
  
  # Import SPSS data with value labels
    
    spssDemo <- read.spss("demo.sav", use.value.labels = T)
    view(spssDemo)
  
    # read.table allows you to do unique arguments while read_table will load the date frame as a tibble
    # you can still create a tibble data drame using as_tibble

    spssDemo <- as_tibble(spssDemo)
    spssDemo
    view(spssDemo)
  
  # Import SPSS data with numeric values
   
    spssDemo_num <- read.spss("demo.sav", use.value.labels = F)
    spssDemo_num <- as_tibble(spssDemo_num)
    spssDemo_num
  
  # Export SPSS file as a CSV file
  
    write_csv(spssDemo, file = "demo_20220309.csv")
  
  
## Dplyr Package ---------------------------------------------------------------
  
  #Dplyr allows you to use it's built-in functions to manipulate data
  
  
# Computing and Re-coding Variables ----------------------------------------
  
  # To duplicate an existing variable,
  
    spssDemo$age_up = spssDemo$age
    
    View(spssDemo)
    
  # To compute a new variable from a mathematical transformation:
  
    spssDemo$age_up = spssDemo$age*2
    
    summary(spssDemo$age)
    summary(spssDemo$age_up)
    
    write_csv(spssDemo, file = "demo_20220309.csv")
    
    #Saves the file
  
# Re-coding variables  --------------------------------------------------
  
  # Adding a numeric value to an categorical variable
  
    freq(spssDemo$inccat)
  
    summary(spssDemo$inccat) # Use the summary or str function to see a variable's value label 
    
    spssDemo <- mutate(spssDemo, inccat_num = recode_factor(inccat, "Under $25" = 1, "$25 - $49" = 2, "$50 - $74" = 3, "$75+" = 4, .ordered = T, ))
    
    view(spssDemo) # see the result
    
    write_csv(spssDemo, file = "demo_20220309.csv")
  
  
  # Re-coding a numerical variable //age/// into Age Groups <30=1, 30-40=2, >40=3
  
    spssDemo$age_cat_num[spssDemo$age<30]=1
    spssDemo$age_cat_num[spssDemo$age>=30 & spssDemo$age<=60]=2
    spssDemo$age_cat_num[spssDemo$age>60]=3
  
    spssDemo <- mutate(spssDemo, age_cat = recode_factor(age_cat_num, "1" = "Under 30", "2" = " 30 to 60", "3" = "Over 60", .ordered = T ))
  
    view(spssDemo)
    
    write_csv(spssDemo, file = "demo_20220309.csv")

  # Remove or re-code absent data
  
    #We can remove absent data using the mutate function from Dplyr. 
    #Some packages have data sets included in the package that you can load and practice on. 
  
    view(starwars)
    starwars
  
  # Replace missing variable in a column
  
    help("replace_na")
    
    starwars <- starwars %>% mutate(height = ifelse(is.na(height), 999, height_na))
    view(starwars)
  
  #Remove NA values
  
    starwars_removedNA <- na.omit(starwars)
    starwars_removedNA  

## Manipulate Data ----------------------------------------------------------------
  
  #filter(data, criterion) - subsets data according to criteria
    
    help("filter")
    spssDemo
    
    spssDemo_genderMarried <- filter(spssDemo, marital == "Married") 
    view(spssDemo_genderMarried)
    spssDemo_genderMarried
    
    spssDemo_genderMale_over50 <- spssDemo %>% filter(gender == "Male") %>% filter(age >= 50) 
    spssDemo_genderMale_over50
    
    skim(spssDemo_genderMale_over50$income)
    mean(spssDemo_genderMale_over50$income)
  
  
  #select(data) - keeps the variables you mention
  
    help("select")
    
    spssDemo_technology <- select(spssDemo_num, wireless:response)
    
    spssDemo_technology
  
  #mutate(...) - adds a new variable and preserves the rest
  
    help("mutate")
    
    spssDemo_technology_totals <- mutate(spssDemo_technology, "total_technology" = wireless + multline + voice + pager + internet + callid + callwait + owntv + ownvcr +owncd + ownpda + ownpc + ownfax + news + response)
    
      #add up all of the observations for a variable and create a new variable from that
    
    view(spssDemo_technology_totals)
    
    mean(spssDemo_technology_totals$total_technology)
  
  
  #transmute(...) adds a new variable and drops the rest
  
    help("transmute")
    
    spssDemo_technology_totals_alone <- transmute(spssDemo_technology, "total_technology" = wireless + multline + voice + pager + internet + callid + callwait + owntv + ownvcr +owncd + ownpda + ownpc + ownfax + news + response)
    
    spssDemo_technology_totals_alone
    
    skim(spssDemo_technology_totals_alone)
    
    spssDemo$total_technology <- spssDemo_technology_totals_alone 
    
    # use the vector created when we tranmute to add it to our dataset
    
    spssDemo$total_technology <- as.numeric(unlist(spssDemo$total_technology))
    
    #changes the variable from a list to a vector
    
    view(spssDemo)
    
    write_csv(spssDemo, file = "demo_20220309.csv")

  
  #arrange(...) allows you to sort your data
  
    help("arrange")
    
    spssDemoArrange <- arrange(spssDemo, +age)
    spssDemoArrange
    spssDemoArrange <- arrange(spssDemo, -age)
    spssDemoArrange
  

  #summarize(...) summarizes a data frame in a single result
  
    dplyr::summarise(spssDemo, avgAge = mean(age)) 
    spssDemo_meanAge
    
    spssDemo_meanIncome <- dplyr::summarise(spssDemo, avgIncome = sum(income)/6400)
    spssDemo_meanIncome <= 100 #you can then run computations or logical tests on this number
  
  
  #group_by(...) - splits the dataset into groups
    
    #Summarize and group by work together to allow you to analyze individual categories
  
    spssDemo_groups <- group_by(spssDemo, marital, carcat, empcat, age_cat)
    spssDemo_groups <- spssDemo_groups %>% dplyr::summarize(avgIncome = mean(income)) %>% arrange(+avgIncome)
    
    
    view(spssDemo_groups)
    
    
## Sampling Data -------------------------------------------------------------
  
  #sample_n(...) extracts a random sample of a fixed number of rows
  
    spssDemo_sample <- sample_n(spssDemo, 10, replace = T)
    spssDemo_sample
    
    
  #sample_fract(...) extracts a random sample of a fixed percentage of rows
    
    spssDemo_sampleFrac <- sample_frac(spssDemo, .2, replace = T)
    spssDemo_sampleFrac
    
    mean(spssDemo_sampleFrac$total_technology)
  
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
    
    covide.separate <- covide.separate %>% separate(Date, sep = "-", into = c("Year", "Month", "Day"))
  
  # Unite(...) ## combine two or more columns
  
  help("unite")
  
    covid.united <- covid.separate %>% unite("Location", sep = ", " , c("City", "State", 'Country'))
    covid.united
  
  #spread(...) help to tidy data of one observation in multiple rows
  
    weather <- read.csv("weather.csv")
    weather <- as_tibble(weather)
    weather
    
    weather.spread <- spread(weather, key = element, value = value)
    weather.spread
  
  
