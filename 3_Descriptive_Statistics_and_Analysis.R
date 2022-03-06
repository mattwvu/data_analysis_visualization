## Special Topic | Data Analysis and Visualization with R | Part III  ---------------------

# Matt Steele, Government Information Librarian, West Virginia University 

# R download and documentation - https://cran.r-project.org/
# RStudio download and documentation - https://rstudio.com
# This workshop was developed using the O'Reilly Platform Lesson video - R Programming for Statistics and Data Science  
# https://libwvu.on.worldcat.org/oclc/1062397089
# For more in-depth information and practical exercises on using R for Data science, I highly suggest using this resource


#Loading the Packages that we need ----------------------------------------

install.packages("tidyverse")
install.packages("foreign")
install.packages("Hmisc")
install.packages("descr")
install.packages("glue")
install.packages("magrittr")
install.packages("car")
install.packages("skimr")
install.packages("gplots")


library(tidyverse)
library(foreign)
library(Hmisc)
library(descr)
library(glue)
library(magrittr)
library(car)
library(skimr)
library(gplots)


#Working Directory ----------------------------------------------------------

getwd()
setwd()

#Load dataset from SPSS file ------------------------------------------------

  spssDemo_num <- read.spss("demo.sav", use.value.labels = F)
  spssDemo_num %>% mutate(across(.cols = jobsat:news, .fns = factor(.)))
  spssDemo_num <- as_tibble(spssDemo_num)
  
  spssDemo_num
  
  spssDemo <- read.spss("demo.sav", use.value.labels = T)
  
  spssDemo <- as_tibble(spssDemo)
  view(spssDemo)
  spssDemo <- as_tibble(spssDemo)
  spssDemo
  
 
  
## Descriptive Statistics ---------------------------------------------------- 

# The Skimr package allows you to get an overview of your data  
  
  skim(spssDemo)
  skim(spssDemo_num)
  
  
  
# Dummy Variables -----------------------------------------------------------
  
  spssDemo_income25 <-  filter(spssDemo, inccat == "Under $25")
  
  view(spssDemo_income25)
  skim(spssDemo_income25)
  
  
  
# Descriptive variables ---------------------------------------------------------
  
  summary(spssDemo) # descriptive statistics for numeric /// frequency for factors and characters 
  summary(spssDemo$income)
  
  describe(spssDemo) # more in-depth look at variable descriptive statistics
  describe(spssDemo$income)
  
  mean(spssDemo$income) #average of observed cases
  median(spssDemo$income) #the middle number(s) of observed cases
  mode(spssDemo$income) # most commonly occurring number of observed cases
  
  min(spssDemo$income) # lowest number in observed cases
  max(spssDemo$income) # highest number in observed cases
  range(spssDemo$income) # highest and lowest number in observed cases
  
  quantile(spssDemo$income, .25) #1st
  quantile(spssDemo$income, .75) #2nd
  fivenum(spssDemo$income) # vector of length 5 with the minimum, 25th percentile, median, 75th percentile, maximum values

  sd(spssDemo$income) #standard deviation
  
  coEffVar_income <-   sd(spssDemo$income) /  mean(spssDemo$income)
  coEffVar_income


  
  # Categorical/Factor Values --- descr package ---------------------------------------
  
  freq(spssDemo$inccat)
  
  abs(spssDemo$age)
  
  mean(spssDemo_num$inccat)
  
  
  
  # Contingency table
  
  table(spssDemo$inccat)
  table(spssDemo$inccat, spssDemo$marital)
  
  prop.table(table(spssDemo$inccat, spssDemo$marital)) #get % instead on freq
  round(prop.table(table(spssDemo$inccat, spssDemo$marital), 1), 2) # round to 2 digits with round()
    
  # Degrees of Freedom
  
  df(spssDemo$inccat, df = 1, df = 2, )
  df


# Chi Square Test ---------------------------------------------------------

  # The chi-square test contrasts observed with expected cell counts for two categorical variables.
  # The null hypothesis is that the two variables are independent.
  
  crosstab(spssDemo$inccat, spssDemo$marital)
  
  crosstab(spssDemo$inccat, spssDemo$marital, chisq = TRUE)
  
  #From the p value, we can reject the null and support the alternative.

  
## Correlation Coefficient ------------------------------------------------------- 

  # covariance is subject to the scale being measured thus can only be evaluated in that context. 
  # The Correlation Coefficient adjust from that and allows it to measured against other observations. It can never be more than 1 or less than -1
  
  cor(spssDemo$car, spssDemo$income)
  cor.test(spssDemo$car, spssDemo$income)
  cor.test(spssDemo$car, spssDemo_num$inccat)
  
  
  
  
## Scatterplots and Bivariate Correlation ------------------------------------------
  
  #to do a scatterplot of two continuous variables,
  
  plot(spssDemo$age, spssDemo$income)
  
  #for a better version,
  
  plot(spssDemo$age, spssDemo$income, cex=.5, pch=19)
  
  #to assess if there is a linear relationship, you can do a bivariate correlation:
  
  # From the package (Hmisc)
  
  rcorr(spssDemo$age, spssDemo$income)
  
  #There is a weak positive linear relationship between the two variables.  

  
  
## Independent Samples T-Test ----------------------------------------------
  
  #The independent-samples t test is a means comparison test that compares the means between two groups to see if the difference is meaningful at the population level.
  
  #First, we must do the Levene's test for homogeneity of variances.
  
    #From the package (car)
    
  #the null hypothesis is that the variances are equal.;
  
  view(gss)
  
  leveneresults = leveneTest(spssDemo$age, spssDemo$inccat)
  
  leveneresults
  
  #The test is significant, so we reject the null and support the idea that the variances are unequal.
  
  #With equal variances assumed, we do var.equal=TRUE for the assumption in the code. With not assumed, we do var.equal=FALSE.
  
  #With var-equal=FALSE, we do a Welch's t-test.
  
  t.test(spssDemo$age ~ spssDemo$marital, var.equal=FALSE)
  
  #the test is significant, letting us reject the  null and support the alternative.

    
  
## One-Way ANOVA -----------------------------------------------------------
  
  #When you are dealing with an independent categorical variable of >2
  #categories, assuming the assumptions are met, you can do a one-way
  #ANOVA to compare means for a continuous dependent variable.
  
  #Two visualizations
  
  boxplot(age ~ inccat, data = spssDemo,
          xlab = "Income", ylab = "Age",
          frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))
  
  # Mean plots with GPLots
  
  plotmeans(age ~ inccat, data = spssDemo, frame = FALSE,
            xlab = "Marital Status", ylab = "Income",
            main="Mean Plot with 95% CI") 
  
  
  #First, we like to do a Levene's Test for Homogeneity of Variance
  
  
  leveneTest(age ~ inccat, data=spssDemo)
  
  #if the assumption is not rejected:
  
  anova1 = aov(age ~ inccat, data=spssDemo)
  
  summary(anova1)
  
  #if the assumption is rejected:
  
  oneway.test(age ~ inccat, data=spssDemo, var.equal=FALSE)
  
  #at this point you would do pairwise post hoc comparisons
  
  pairwise.t.test(spssDemo$age, spssDemo$inccat, p.adj = "bonf")
  
