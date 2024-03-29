# Lesson 5: Loops and functions
# 2_if_else.R
# Created by: Emily Markowitz
# Contact: Emily.Markowitz@noaa.gov
# Created: 2020-12-18
# Modified: 2021-02-08


# packages ----------------------------------------------------------------

library(tidyverse)
library(here)
library(data.table)


# directories --------------------------------------------------------------------
# 
# source(here("functions", "file_folders.R")) (already done in script 1_*.R)
# 
# download data --------------------------------------------------------------------
# EBS_haul_table<-read_csv(here::here("data", "ebs_2017-2018.csv"))
# 
# look at your data -------------------------------------------------------
# 
# str(EBS_haul_table)


# What is a if-else statement? -------------------------------------------------------

# ***if(){}else if(){}  statements ----------------------------------------------

# ******if()  statement ---------------------------------------------
x <- 7
y <- 5

if(x > y) {
  print("x is greater")
}
# This is a true statement, so it returns something!

if(x < y) {
  print("x is less than")
}
# This is a false statement, so it returns nothing! Nothing in the body was run.


# ******if(){}else{} statement ---------------------------------------------

x <- 7
y <- 5
# now we can combine the two previous statements into the same statement by:
if(x > y) {
  print("x is greater")
} else {
  print("y is greater")
}

# *********One Line If () Else---------------
# If Statement Without Curly Braces: 
# If you have only one statement to execute, one for if, and one for else, 
# you can put it all on the same line and skip curly braces. 

x <- 7
y <- 5
if (x > y) print("x is greater")

if (x > y) print("x is greater") else print("y is greater")
# This returns the same as above

# ******if(){}else if(){}else{} statement -----------------------------

x <- 5
y <- 5

if(x > y) {
  print("x is greater")
} else if(x < y) {
  print("y is greater")
} else {
  print("x and y are equal")
}

# ******Nested if() Statement ------------------------------------

# You can write one if statement inside another if statement to test more than one condition and return different results.

x <- 7
y <- 5
z <- 2
if(x > y) {
  print("x is greater than y")
  if(x > z) { 
    # Nest a specific instance of when x is greater than y 
    # (specifically when x is also greater than z)
    print("x is greater than y and z")
  }
}

# ******Multiple conditions -------------------------------------------------------

x <- 7
y <- 5
z <- 2
if(x > y && x > z) {
  print("x is greater than y and z")
}

# ***ifelse() statement function ---------------------------------------

# In R, conditional statements are not vector (c(1,2,3)) operations. 
# They deal only with a single value (1).
# If you pass in, for example, a vector, the if statement will only check the 
# very first element and issue a warning.

v <- 1:6

if(2 > v) { # if 2 is greater than the items in v
  print(paste0("2 is greater"))
} else {
  print(paste0("2 is less"))
} # Whoops, error!

# The solution to this is to use the ifelse() function. 
# The ifelse() function checks the condition for every element of a vector 
# and selects elements from the specified vector depending upon the result.

# Here’s the syntax for the ifelse() function.
v <- 1:6

ifelse(2 > v, 
       paste0("2 is greater"), 
       paste0("2 is less"))

# Let's see this in action for modifying a data table

# create example data
dt <- data.table(
  grp = factor(sample(1L:3L, 1e6, replace = TRUE)),
  x = rnorm(1e6))
dt
str(dt)

# Note that since ifelse() is from base R, we can't use tidy piping %>% here

dt$x_cat<-""
dt$x_cat<-ifelse(2 > dt$x, 
         paste0("2 is greater"), 
         paste0("2 is less"))

dt

# ***dplyr::if_else-------------------------------

# Let's take that last example and use it for dplyr::if_else()

# create example data
dt <- data.table(
  grp = factor(sample(1L:3L, 1e6, replace = TRUE)),
  x = rnorm(1e6))
dt
str(dt)

# Since this is from the tidyverse, we can use piping!
# single if_else
dt %>% 
  mutate(x_cat = if_else(2 > x, "2 is greater", "2 is lower"))

# nested if_else()
# This is a little hard to read and a bit overwhelming, 
# so bear with me because my point in the next script is that this can be better!
a<-dt %>% 
  dplyr::mutate(x_cat = 
                  dplyr::if_else(2 > x, # condition 1
                                 "2 is greater", # statement 1 TRUE
                                 dplyr::if_else( # statement 1 FALSE (nested if_else)
                                   4 > x , # condition 2
                                   "between 2 and 4", # statement 2 TRUE
                                   "2 is lower"))) # statement 2 FALSE
a %>% 
  dplyr::group_by(x_cat) %>% 
  dplyr::count(x_cat)
  

# Asssign multiple changes based on case_when()
# (case_when is secretly a fancy if else statement!)
dt %>% 
  mutate(x_cat = case_when(2 > x ~ "2 is greater",
                           4 > x ~ "between 2 and 4",
                           TRUE ~ "2 is lower")) # all other cases
# Wasn't that so much easier and nicer to read? 
# This is how we avoid nested if else!
a %>% 
  dplyr::group_by(x_cat) %>% 
  dplyr::count(x_cat)
# same result

# ***Compare-contrast - How to best write if-else -------------------------------------------------------

# ******Example 1 (EASY)------------------
x <- 5

if(x > 0){
  print("Positive number")
} else {
  print("Negative number or 0")
}

# Alternatively...
if(x > 0){
  print("Positive number")
} else if (x <= 0) { 
  # effectively the same thing as above (this is the mutual exclusive), but I'm explicit for this example 
  print("Negative number or 0")
}

# Alternatively...
ifelse(x > 0, # This also works with vectorized data
       "Positive number" ,
       "Negative number or 0")

# Alternatively...
dplyr::if_else(x > 0, # This also works with vectorized data
        "Positive number", 
        "Negative number or 0")

# Alternatively...
dplyr::case_when(# This also works with vectorized data
  x > 0 ~ "Positive number", 
  TRUE ~ "Negative number or 0")


#******Example 2 - (MEDIUM)----------------

# Let's say that you work at a company and you charge a different markup 
# depending on who is asking for the service. 

# For a private client, there is a 1.12 (12% markup) and those accounts are managed by Ms. Jones
# For a public client, there is a 1.06 (6% markup) and those accounts are managed by Mr. Wilson
# For an internal client, there is a 1 (0% markup) and those accounts are managed by 

# For a private client who is asking for a service worth $100, 
# what is the total cost?
client <- 'private'
net_price <- 100

if(client=='private'){
  tot_price <- net_price * 1.12      # 12% markup
} else {
  if(client=='public'){
    tot_price <- net_price * 1.06    # 6% markup
  } else {
    tot_price <- net_price * 1    # 0% markup
  }
}
tot_price

# Luckily, R allows you to write all that code a bit more clearly. 
# You can chain the if…else statements as follows:

if(client=='private'){
  tot_price <- net_price * 1.12
} else if(client=='public'){
  tot_price <- net_price * 1.06
} else {
  tot_price <- net_price
}
tot_price

# In this example, the chaining makes a difference of only two braces, 
# but when you have more possibilities, it makes code readable. Note, that you 
# don’t have to test whether the argument client is equal to ‘abroad’ 
# (although it wouldn’t be wrong to do that). You just assume that if client 
# doesn’t have any of the two other values, it has to be ‘abroad’.

net_price * ifelse(client=='private', 1.12, 
                   ifelse(client == 'public', 1.06, 1))

# We can also use the dplyr functions!
# if_else()
net_price * 
  dplyr::if_else(client == "private", 
                 1.12, 
                 dplyr::if_else(client == 'public', 
                                1.06, 
                                1)) 
# case_when()
net_price * 
  dplyr::case_when(client == "private" ~ 1.12, 
                   client == 'public' ~ 1.06, 
                   TRUE ~ 1) 


# ******Example 3 (HARD)------------------

# Below is the EBS trawl data from 2016 and 2017. 

EBS_haul_table<-read_csv(here::here("data", "ebs_2017-2018.csv"))

# Lets say that for a species in a year we want to assess: 
# 1. for stratum under 50 m (10 and 20), 
#    we want to calculate the **sum of WTCPUE**
#    caught at each station, 
# 2. for stratum from 50-100 m (82, 43, 41, 42, 32, and 31),
#    we want to calculate the **mean of NUMCPUE** 
#    at each station or,
# 3. for stratum from 100-200 m (90, 62, 61, and 50), 
#    we want to calculate the **sum of WTCPUE AND mean of NUMCPUE** 
#    at each station.
# 4. For any data out of this stratum, do nothing. They're not in the EBS!

# Why? Why not. 

# and let's say that we are going to test this ifelse for 
yr <- 2016
common <- "walleye pollock"
# notice I used the variables here instead of writing it out. 
# Could be useful in the future if you need to change anything and 
# don't want to change it at each step...

# *********Long way--------------------------

# First, let's write this out the long way for each example instance:

# for condition 1 (stratums under 50 m (10 and 20)), 
# here is how we would find the **sum of WTCPUE**
strat <- 10 # or 20

EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::filter(COMMON == common, 
                YEAR == yr, 
                STRATUM == strat) %>%
  dplyr::group_by(YEAR, STRATUM, STATION, COMMON) %>% # Group by YEAR, STRATUM, STATION, COMMON for next command
  dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above

EBS_summary

# for condition 2 (stratums from 50-100 m (82, 43, 41, 42, 32, and 31)), 
# here is how we would find the **median of WTCPUE AND sum of NUMCPUE**  
strat <- 82 # or 43, 41, 42, 32, and 31

EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::filter(COMMON == common, 
                YEAR == yr, 
                STRATUM == strat) %>%
  dplyr::group_by(YEAR, STRATUM, STATION, COMMON) %>% # Group by YEAR, STRATUM, STATION, COMMON for next command
  dplyr::summarise(NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above

EBS_summary

# for condition 3 (stratums from 100-200 m (90, 62, 61, and 50)), 
# here is how we would find the **mean of NUMCPUE** 
strat <- 90 # or 62, 61, and 50


EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::filter(COMMON == common, 
                YEAR == yr, 
                STRATUM == strat) %>%
  dplyr::group_by(YEAR, STRATUM, STATION, COMMON) %>% # Group by YEAR, STRATUM, STATION, COMMON for next command
  dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE),  # sum WTCPUE across grouped items above
                   NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above


EBS_summary


# *********If-Else way--------------------------


# 1. for stratums under 50 m (10 and 20), 
#    we want to calculate the **sum of WTCPUE**
#    caught at each station, 
# 2. for stratums from 50-100 m (82, 43, 41, 42, 32, and 31),
#    we want to calculate the **mean of NUMCPUE** 
#    at each station or,
# 3. for stratum from 100-200 m (90, 62, 61, and 50), 
#    we want to calculate the **sum of WTCPUE AND mean of NUMCPUE** 
#    at each station.

# We can start off with the top of the piping because that is the same for each condition...
EBS_summary<-EBS_haul_table %>% # use EBS data to create object "EBS_summary"
  dplyr::filter(COMMON == common, 
                YEAR == yr, 
                STRATUM == strat) %>%
  dplyr::group_by(YEAR, STRATUM, STATION, COMMON) # Group by YEAR, STRATUM, STATION, COMMON for next command
  # Notice I removed the pipe at the end ^

# Let condition 1 be true
strat <- 10 # or 20
# stratum under 50 m

if (strat %in% c(10, 20)){ # stratum under 50 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above
} else if (strat %in% c(82, 43, 41, 42, 32, 31)) { # stratum between 50-100 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above
} else if (strat %in% c(90, 62, 61, 50)) { # stratum between 100-200 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE),  # sum WTCPUE across grouped items above
                     NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above
}

EBS

# Let condition 2 be true
strat <- 82 # or 43, 41, 42, 32, and 31
# stratum between 50-100 m

if (strat %in% c(10, 20)){ # stratum under 50 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above
} else if (strat %in% c(82, 43, 41, 42, 32, 31)) { # stratum between 50-100 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above
} else if (strat %in% c(90, 62, 61, 50)) { # stratum between 100-200 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE),  # sum WTCPUE across grouped items above
                     NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above
}

EBS

# Let condition 3 be true
strat <- 90 # or 62, 61, and 50
# stratum under 100-200 m

if (strat %in% c(10, 20)){ # stratum under 50 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE)) # sum WTCPUE across grouped items above
} else if (strat %in% c(82, 43, 41, 42, 32, 31)) { # stratum between 50-100 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above
} else if (strat %in% c(90, 62, 61, 50)) { # stratum between 100-200 m
  EBS <- EBS_summary %>% 
    dplyr::summarise(WTCPUE_sum = sum(WTCPUE, na.rm = TRUE),  # sum WTCPUE across grouped items above
                     NUMCPUE_mean = mean(NUMCPUE, na.rm = TRUE)) # mean NUMCPUE across grouped items above
}

EBS

# That was a bit long winded and verbose, but good! Everything works as planned. 
# Now, let's make this code even better!

# Think about it: How woud you do this with ifelse(), if_else(), case_when()?
