---
title: Getting Census Data with Tidycensus for R Beginners
author: Heather Johnston
date: '2021-01-12'
slug: intro-to-tidycensus
categories: []
tags: []
---

## Introduction to Tidycensus

[Tidycensus](https://walker-data.com/tidycensus/index.html) is an R package developed by Kyle Walker and Matt Herman. It is designed for accessing U.S. Census data through the Census API. An API, or Application Programming Interface, is simply a way of accessing data from a website without having to navigate to a web browser, select the relevant datasets, and download the files. Tidycensus currently supports U.S. Census and American Community Survey datasets.

# Getting R Ready

Like any R package, the first step is to download the package. This means that you will need to run the command 'install.packages("tidycensus")'. You will only need to run this once.

The second step will be to get and set an API key. Most website with APIs like to distinguish users with API keys. They use this to set limits if users are accessing so much data that they are slowing the system down. To get a Census API key, visit https://api.census.gov/data/key_signup.html. You will be emailed a key, which is a string of characters.

Then you will run this line of code, inserting your key into the quotation marks where I have put the alphabet. You only need to run this line of code once. Note that I recommend setting 'install = TRUE', which saves the key for future use.


```r
tidycensus::census_api_key("abcdefghijklmnopqrstuvwxyz", install = TRUE)
```

Now you will need to restart R in order for the API key to work.

Then, everytime you start a new R session with the intention of accessing Census data, you will need to load the package using the 'library' function. For this project, we will also use the packages dplyr and ggplot2. If you have never used those packages before, you can install them using 'install.packages("dplyr")' and 'install.packages("ggplot2")'.


```r
library(tidycensus)
library(dplyr)
library(stringr)
library(ggplot2)
```


## Finding the variables of interest

Now that we've set up our R session for accessing Tidycensus, the next step is to actually get some data. However, the Census Bureau produces a ton of data, and the Census and API datasets are enormous. Therefore, we will want to be selective about which variables we access. The first step in doing so is to call the list of variables.

In the following line of code, we will call the variables for the 2010 Census's Summary File 1. This may take a minute to run.


```r
variables <- load_variables(2010, "sf1")
```

Now we need to explore the variables a little bit to find what we're interested in. Notice that the three columns are "name", "label", and "concept". Since the interesting information will be in the "concept" column, I find it easiest to make a new set of variables which summarizes the concepts.


```r
concepts = data.frame(x = unique(variables$concept))
```

Now we have a list of 316 concepts. Assuming you are using RStudio, you can open the list in the viewer pane and scroll through.


```r
concepts %>% view()
```

You may notice that some of these apply to the household, while some apply to individuals within the household. For more information, read the Census Bureau's [Summary File 1 documentation](https://www.census.gov/prod/cen2010/doc/sf1.pdf). Let's say for this example that I simply want race and sex estimates. I notice that there is a "RACE" concept listed. Excellent! However, there is no concept listed which is just "SEX" alone without any other qualifiers. Therefore, I will choose the simplest, which is "SEX BY AGE". Now I need to find the variable names for these. For this, I will use dplyr's "filter" function to list all the relevant variables. Again, I'll use the viewer pane.


```r
variables %>% filter(concept == "RACE") %>% view()
```

There are a lot of options here. In order to keep my analysis manageable, I'll have to consider only a few racial categories. Luckily, there is a pattern. The first few are a shortened list of race categories, and all their names begin with the prefix "P003". This makes my job easier. I can just select those variables with prefix "P003". In order to select those with only a prefix, I'll use the "str_detect" function from the stringr package. This checks the name "column" to see whether the prefix matches.


```r
race_variable_names = variables %>% filter(concept == "RACE" & str_detect(name, "^P003")) %>% select(-concept)
```

Now I want to choose my sex variable names.


```r
variables %>% filter(concept == "SEX BY AGE") %>% view()
```

I can see by looking in the viewer pane that there are two I need. Although I could use regular expression again, I actually think this is a time when copying-and-pasting is acceptable. Those are the sex total:male and sex total:female.


```r
sex_variable_names = variables %>% filter(name == "P012002" | name == "P012026") %>% select(-concept)
```

This gives me two data frames. In order to make handling the data a little easier, I'm going to make these data frames into a named character sting. I'll do this step-by-step.


```r
# First, use "rbind" to combine our data frames with variable names and labels
all_vars_with_labs = rbind(race_variable_names, sex_variable_names)

# Next, replace spaces with underscores in the labels
all_vars_with_labs$label = str_replace_all(all_vars_with_labs$label, " ", "_")

# Now, get rid of exclamation points in the labels
all_vars_with_labs$label = str_replace_all(all_vars_with_labs$label, "!", "")

# Make a new character string with the names
all_vars = as.character(all_vars_with_labs$name)

# Name the character string with the labels
names(all_vars) = all_vars_with_labs$label
```


Now all I need to do is get the actual census data.

## Retrieving the Census Data

Because this call needs to access the internet, it make take a minute.


```r
populations_2010 = get_decennial(geography = "county",
                                variable = all_vars,
                     sumfile = "sf1",
                     year = 2010,
                     output = "wide")
```

```
## Getting data from the 2010 decennial Census
```

```
## Using Census Summary File 1
```
This gives us a neat list of all our variables of interest. In the next tutorial, we'll talk about how to visualize this data.
