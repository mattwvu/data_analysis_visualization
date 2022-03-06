## Special Topic | Data Analysis and Visualization with R | Part I  ---------------------

# Matt Steele, Government Information Librarian, West Virginia University 

# R download and documentation - https://cran.r-project.org/
# RStudio download and documentation - https://rstudio.com
# This workshop was developed using the O'Reilly Platform Lesson video - R Programming for Statistics and Data Science  
# https://libwvu.on.worldcat.org/oclc/1062397089
# For more in-depth information and practical exercises on using R for Data science, I highly suggest using this resource


## Working Directories -----------------------------------------------------

'''

The working directory is just a file path on your computer that sets the default location of any files you read into R, or save out of R. In other words, a working directory is like a little flag somewhere on your computer which is tied to a specific analysis project.

'''

    getwd() # tells you the current directory that you are working in
    
    setwd() # sets a new current directory

'''
  
To set your working directory, you can either do the command line or use the menu system. The command line will differ between Mac and PC because the directory systems are not the same.

To set your working directory:

    Click on Session > Set Working Directory > Choose the folder you would like this project to be
  
    When you set your directory copy + paste it from the console to your script
  
'''

    setwd("")
    list.files()
    
    
## Packages ---------------------------------------------------------
    
#R is open source code after it's initial development people began adding to it with packages. An R Package is something that you can plug into RStudio to extend the basic functionality that is built in with R. One of the reasons that R has become so popular is because it has this rich ecosystem of packages that really make R a comprehensive platform for data science.
    
#Packages have their own built-in functions that cannot be used unless the package has been loaded.
    
#For this workshop we are going to use a package called Tidyverse that was created for people working with data. Let's load it up and install it now.
    
    
    help("install.packages")
    
    install.packages("tidyverse") 
    
    # You only have to install a package once on you computer
    
    help("library")
    
    library(tidyverse) 
    
# However you do need to call a package, every session you plan on using it
    
  '''
  
  RStudio Cheatsheets for commonly used packages
  
  https://www.rstudio.com/resources/cheatsheets/ 
  
  R-bloggers New Packages - https://www.r-bloggers.com/2022/02/january-2022-top-40-new-cran-packages/
  
  
  '''


## Tips & Tricks -----------------------------------------------------------

#1. Code from you Script pane can be run in the console using the RUN button or keyboard shortcut CTRL + ENTER (windows)/ CMD + RETURN (mac). Lines from scripts can be run by highlighting the relevant block of code.

    1 + 4 
    
    heyThere <- 1 + 4
    heyThere

#2. R scripts can be created through File-->New File-->R Script. Previous scripts can be loaded by using Open File.

#3. An incomplete line in R is marked by a + sign. The Escape button will break the execution of a command.

    heyThere <- c(summary(heyThere)
              
#4. In R Studio, the TAB button will complete a partially completed suggestion of a variable name or such like.
              
    help()
              
#5. Pipe Operators( %>% ) will allow you to string multiple functions together on a single object. 
    #The keyboard shortcut for pipe operators is CTRL + SHIFT + M ///  CMD + SHIFT + M 
    
    
    my.house <- read_csv("house_2018_bystate.csv")
    
    my.house %>%
      group_by(Majority_votes) %>%
      summarise(count = n(), avg.vote = mean(Seat_difference, na.rm = T)) %>%
      filter(count >1)

              
#6. R functions may require packages that are either 
    #a) not installed, or
    #b) not loaded. You may need to first install and then load the package to run the function.
              
              
    
## Before we get Started ----------------------------------------------------
    
#1. Objects
#2. Built-in Functions and Arguments
#3. Packages
#4. Reading data into R
              
# Importing Data ----------------------------------------------------------
    
  #The read.csv function imports .csv files. There several options possible. If you have Tidyverse loaded you can also use the the read_csv.
  #There are additional built-in functions for reading data that is not in CSV format
      #read.table
  
    gss = read.csv("R_Data_2018.csv", na.strings=c(" ",""))
    gss
    gss <- as_tibble(gss)
    gss
    
#In R, you can use fix(gss) to view the data.
#In R Studio, you can use View(gss)
    
  View(gss)
    
# Viewing Data and Variables ----------------------------------------------
    
  #The names() function can display the variable names in the data.
    
  names(gss)
    
  #If you want to import data from other statistical software programs, you can use the foreign library.
  
  
    install.packages("foreign")
    library(foreign)
    
  #CRAN Documentation for "Foreign" - https://cran.r-project.org/web/packages/foreign/foreign.pdf
    
    spssDemo <- read.spss("demo.sav", use.value.labels = T)
    spssDemo <- as_tibble(spssDemo)
    view(spssDemo)
    
    
  #you can use the head() function to see the first six rows of the dataset.
    
    head(gss)
    
  
    
# Targeting variables in data frames --------------------------------------
    
  #You can use the $ sign to specify a variable within the data for analysis.
    
    head(gss$age)
    
  #to view the structure of a variable,
    
    str(gss$age)
    
  #to view the structure of all variables,
    
    str(gss)
    
    
## Saving and Exporting R ---------------------------------------------------
    
    
  # Command history
    
    history() #Last 25 commands
    history(max.show=Inf) #All commands during session
    savehistory(file="IntroR")
    getwd()
    
  # You can use write.csv() to export a csv file of your data.
    
    quickSave <-  write.csv(spssDemo, "Demographic_data.csv")
    
  #You should save the script file as a .R file, which can be opened with a text file editor, or in R.

