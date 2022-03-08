## Special Topic | Data Analysis and Visualization with R | Part IV ---------------------

# Matt Steele, Government Information Librarian, West Virginia University 

# R download and documentation - https://cran.r-project.org/
# RStudio download and documentation - https://rstudio.com
# This workshop was developed using the O'Reilly Platform Lesson video - R Programming for Statistics and Data Science  
# https://libwvu.on.worldcat.org/oclc/1062397089
# For more in-depth information and practical exercises on using R for Data science, I highly suggest using this resource


#Loading the Packages that we need ----------------------------------------

  install.packages("tidyverse")
  install.packages("foreign")
  install.packages("skimr")

  library(tidyverse)
  library(foreign)
  library(skimr)


#Working Directory ----------------------------------------------------------

  getwd()
  setwd()


## How plot ----------------------------------------------------------------

  # Basic steps:
  # set the data (main function)
  # choose a shape layer
  # map variables to aesthetics using aes() -> start with x and y in main function
  
  # Structure of Plots
  # Data - data you plotting
  # Aesthetics - what you map on x and y axis
  # Geometries - how your data will be represented visually

# First three are mandatory to create a plot. The following four are for flourish

  # Facets - discrete subplots that you graph can be split into 
  # Stats - statistical transformations you may choose to use
  # Coordinates - where data is plotted
  # Themes - non-data related information (fonts, colors)



# Step I | Getting that Data -----------------------------------------------

# Create an object that contains elements that your would like to plot
  
  bidenApproval <- read.csv("approval_topline_biden_2022.csv", stringsAsFactors = T)
  bidenApproval <- as_tibble(bidenApproval)
  bidenApproval 

  
  # Quick clean up
  
    str(bidenApproval)
  
  #Fix Date
  
    bidenApproval$modeldate <- as.Date(bidenApproval$modeldate, tryFormats = c("%m/%d/%Y"))
    bidenApproval
  
  #Fix name of president variable 
  
    bidenApproval <- mutate(bidenApproval, president = recode_factor(president, "Joe Biden" = "Joe Biden", 'Joseph R. Biden Jr.' = "Joe Biden" ))
    str(bidenApproval)
  
    skim(bidenApproval)

    
    
## Setting the Parameters with Aesthetics aes(x = ... , y = ...) --------------------------------------------------    

  bidenApproval.scatter <- ggplot(bidenApproval, aes(modeldate, approve_estimate))
  bidenApproval.scatter
  
  
## Setting the type of plot with Geometries -------------------------------------------------------------
  
  bidenApproval.scatter + geom_point()
  
  bidenApproval.scatter <- ggplot(bidenApproval, aes(modeldate, approve_estimate, color = subgroup))
  
  idenApproval.scatter + geom_point()

## Subsetting Factors with Facets ----------------------------------------------------------
  
    
  bidenApproval.scatter + geom_point() + facet_grid(subgroup ~.)
  

# Add a Statistics
  
  bidenApproval.scatter + geom_point() + facet_grid(subgroup ~.) + stat_smooth()
  

# Zoom in on a particular range using with Coordinates
  
  bidenApproval.scatter + geom_point() + stat_smooth() + scale_x_date(date_labels = '%m/%d/%Y', limits = as.Date(c("2021-04-01", "2021-04-30")))
  
  #This is a unique instance because the x value is a date. Typically you would use the function coord_cartesian(10,50) for integers and doubles.
      #For more information
  
      help("coord_cartesian")
  

# Change the look of the plot using Theme ## You can also change lables using labs()
  
  bidenApproval.scatter <- ggplot(bidenApproval, aes(modeldate, approve_estimate))
  
  bidenApproval.scatter + geom_line(color = "red") + geom_point(color = "gold") + theme_classic() + geom_smooth(color="green") + labs(y="Approval", x = "Date", title = "Joe Biden Presidential Approval")
  
  
  
  
## Histogram ----------------------------------------------------------------------------------------
  
  
  spssDemo <- read.spss("demo.sav", use.value.labels = T)
  spssDemo <- as_tibble(spssDemo)
  spssDemo
 
 
  spssDemo_hist <- ggplot(data = spssDemo, aes(x = age))
  
  spssDemo_hist + geom_histogram(binwidth = 5)
  
  #bins tie a range of numbers together, in this example we are tying 0-5, 5-10, etc. So what would happen if we made the bin 15
  
  spssDemo_hist + geom_histogram(binwidth = 15)
  
  #see the difference
  
  #Give it some color
  
  spssDemo_hist + geom_histogram(binwidth = 5, color = "darkslategray", fill = "darkslategray4", alpha = 0.5)
  
  #Give in a Title
  spssDemo_hist + geom_histogram(binwidth = 5, color = "darkslategray", fill = "darkslategray4", alpha = 0.5) +
    ggtitle("Age Distribution on the Titanic")
  
  #Give the x and y axis some labels
  spssDemo_hist + geom_histogram(binwidth = 5, color = "darkslategray", fill = "darkslategray4", alpha = 0.5) +
    ggtitle("Age Distribution on the Titanic") +
    labs(y = "Number of Passangers", x = "Age")
  
  #Give it a new theme
  spssDemo_hist + geom_histogram(binwidth = 5, color = "darkslategray", fill = "darkslategray4", alpha = 0.5) +
    ggtitle("Age Distribution on the Titanic") +
    labs(y = "Number of Passangers", x = "Age") +
    theme_minimal()
  
## Bar graph ----------------------------------------------------------------------------------
  
  spssDemo_bar <- ggplot(spssDemo, aes(x = inccat,  fill = age_cat)) #binds the variable Income Category and Marital Status
 
   spssDemo_bar + geom_bar() + theme_light() +
    labs(y = "Count",
         x = "Income Category",
         title = "Income and Marital Status")
    # Subsets the graph by gender and education level
   
   
   
   spssDemo_bar + geom_bar() + theme_light() +
     labs(y = "Count",
          x = "Income Category",
          title = "Income and Age Group by Gender", 
          fill = "Age") + facet_wrap(~gender)
   # Add another layer by subsetting the plot gender
   
   
# You can export graphs to image or pdf using the export button in the bottom right pane.
  
# You can create a publishing report which can be exported as a PDF or HTML using File > RMarkdown  