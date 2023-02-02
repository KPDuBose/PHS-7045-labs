Lab 03 - Functions and data.table
================

# Learning goals

- Used advanced features of functions in R.
- Use the `merge()` function to join two datasets.
- Deal with missings and data imputation data.
- Identify relevant observations using `quantile()`.
- Practice your GitHub skills.

# Lab description

For this lab, we will deal with the meteorological dataset downloaded
from the NOAA, the `met`. We will use `data.table` to answer some
questions regarding the `met` data set, and practice our Git+GitHub
skills.

This markdown document should be rendered using `gfm` document.

# Part 1: Setup the Git project and the GitHub repository

1.  Go to your documents (or wherever you are planning to store the
    data) in your computer, and create a folder for this project, for
    example, “PHS7045-labs”

2.  In that folder, save [this
    template](https://raw.githubusercontent.com/UofUEpiBio/PHS7045-advanced-programming/main/labs/03-functions-and-datatable/03-functions-and-datatable.qmd)
    as “README.Rmd”. This will be the markdown file where all the magic
    will happen.

3.  Go to your GitHub account and create a new repository, hopefully of
    the same name this folder has, i.e., “PHS7045-labs”.

4.  Initialize the Git project, add the “README.qmd” file, and make your
    first commit.

5.  Add the repo you just created on GitHub.com to the list of remotes,
    and push your commit to origin while setting the upstream.

Most of the steps can be done using the command line:

``` sh
# Step 1
cd ~/Documents
mkdir PHS7045-labs
cd PHS7045-labs

# Step 2
wget https://raw.githubusercontent.com/UofUEpiBio/PHS7045-advanced-programming/main/labs/03-functions-and-datatable/03-functions-and-datatable.qmd
mv 03-functions-and-datatable.qmd README.qmd

# Step 3
# Happens on github

# Step 4
git init
git add README.Rmd
git commit -m "First commit"

# Step 5
git remote add origin git@github.com:[username]/PHS7045
git push -u origin master
```

You can also complete the steps in R (replace with your paths/username
when needed)

``` r
# Step 1
setwd("~/Documents")
dir.create("PHS7045-labs")
setwd("PHS7045-labs")

# Step 2
download.file(
  "https://raw.githubusercontent.com/UofUEpiBio/PHS7045-advanced-programming/main/labs/03-functions-and-datatable/03-functions-and-datatable.qmd",
  destfile = "README.qmd"
  )

# Step 3: Happens on Github

# Step 4
system("git init && git add README.Rmd")
system('git commit -m "First commit"')

# Step 5
system("git remote add origin git@github.com:[username]/PHS7045-labs")
system("git push -u origin master")
```

Once you are done setting up the project, you can now start working on
the lab.

# Part 2: Advanced functions

## Question 1: **Ellipsis**

Write a function using the ellipsis argument (`...`) with the goal of
(i) retrieving the list of arguments passed to it, (ii) printing
information about them using `str()`, and (iii) printing the environment
where they belong and the address of the object in memory using
`data.table::address()`.

``` r
newFunction <- function(...){
  # retrieve the list of arguments
  val <- list(...)
  
  # print information about them
  lapply(val, str)
  
  #print environment
  lapply(val, environment)
  
  #print address
  lapply(val, \(x){data.table::address(x)})|>print()
  
  invisible()
}

newFunction(1, pi = pi)
```

     num 1
     num 3.14
    [[1]]
    [1] "00000224fcfd3fa8"

    $pi
    [1] "00000224fd29f948"

Knit the document, commit your changes, and push them to GitHub.

## Question 2: **Lazy evaluation**

A concept we did not review was lazy evaluation. Write a function with
two arguments (`a` and `b`) that only uses one of them as an integer,
and then call the function passing the following arguments
`(1, this_stuff)`

``` r
lazyFunction <- function(a, b) {
  print(a)
}

lazyFunction(1, this_stuff)
```

    [1] 1

Knit the document, commit your changes, and push them to GitHub.

## Question 3: **Putting all together**

Write a function that fits a linear regression model and saves the
result to the global environment using the `assign()` function. The name
of the output must be passed as a symbol using lazy evaluation.

``` r
# Create the function
set.seed(1134)
linearModelFunction <- function(x, y, name.of = "defaultName") {
  assign(name.of, lm(y~x), envir = .GlobalEnv)
}

# Generate random data to do a linear regression on
x <- runif(15, min = 1, max = 15)
y <- runif(15, min = 1, max = 15)

# Check to make sure everything ran alright
linearModelFunction(x, y)
defaultName
```


    Call:
    lm(formula = y ~ x)

    Coefficients:
    (Intercept)            x  
        7.01215      0.08741  

Knit the document, commit your changes, and push them to GitHub.

# Part 3: Data.table

## Setup in R

1.  Load the `data.table` (and the `dtplyr` and `dplyr` packages if you
    plan to work with those).

``` r
library(data.table)
```

2.  Load the met data from
    https://raw.githubusercontent.com/USCbiostats/data-science-data/master/02_met/met_all.gz,
    and the station data. For the latter, you can use the code we used
    during the lecture to pre-process the stations’ data:

``` r
# Where are we getting the data from
met_url <- "https://github.com/USCbiostats/data-science-data/raw/master/02_met/met_all.gz"

# Downloading the data to a tempfile (so it is destroyed afterwards)
# you can replace this with, for example, your own data:
# tmp <- tempfile(fileext = ".gz")
tmp <- "met.gz"

# We sould be downloading this, ONLY IF this was not downloaded already.
# otherwise is just a waste of time.
if (!file.exists(tmp)) {
  download.file(
    url      = met_url,
    destfile = tmp,
    # method   = "libcurl", timeout = 1000 (you may need this option)
  )
}

# Reading the data
dat <- fread(tmp)
head(dat)
```

       USAFID  WBAN year month day hour min  lat      lon elev wind.dir wind.dir.qc
    1: 690150 93121 2019     8   1    0  56 34.3 -116.166  696      220           5
    2: 690150 93121 2019     8   1    1  56 34.3 -116.166  696      230           5
    3: 690150 93121 2019     8   1    2  56 34.3 -116.166  696      230           5
    4: 690150 93121 2019     8   1    3  56 34.3 -116.166  696      210           5
    5: 690150 93121 2019     8   1    4  56 34.3 -116.166  696      120           5
    6: 690150 93121 2019     8   1    5  56 34.3 -116.166  696       NA           9
       wind.type.code wind.sp wind.sp.qc ceiling.ht ceiling.ht.qc ceiling.ht.method
    1:              N     5.7          5      22000             5                 9
    2:              N     8.2          5      22000             5                 9
    3:              N     6.7          5      22000             5                 9
    4:              N     5.1          5      22000             5                 9
    5:              N     2.1          5      22000             5                 9
    6:              C     0.0          5      22000             5                 9
       sky.cond vis.dist vis.dist.qc vis.var vis.var.qc temp temp.qc dew.point
    1:        N    16093           5       N          5 37.2       5      10.6
    2:        N    16093           5       N          5 35.6       5      10.6
    3:        N    16093           5       N          5 34.4       5       7.2
    4:        N    16093           5       N          5 33.3       5       5.0
    5:        N    16093           5       N          5 32.8       5       5.0
    6:        N    16093           5       N          5 31.1       5       5.6
       dew.point.qc atm.press atm.press.qc       rh
    1:            5    1009.9            5 19.88127
    2:            5    1010.3            5 21.76098
    3:            5    1010.6            5 18.48212
    4:            5    1011.6            5 16.88862
    5:            5    1012.7            5 17.38410
    6:            5    1012.7            5 20.01540

``` r
# Download the data
stations <- fread("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv")
stations[, USAF := as.integer(USAF)]
```

    Warning in eval(jsub, SDenv, parent.frame()): NAs introduced by coercion

``` r
# Dealing with NAs and 999999
stations[, USAF   := fifelse(USAF == 999999, NA_integer_, USAF)]
stations[, CTRY   := fifelse(CTRY == "", NA_character_, CTRY)]
stations[, STATE  := fifelse(STATE == "", NA_character_, STATE)]

# Selecting the three relevant columns, and keeping unique records
stations <- unique(stations[, list(USAF, CTRY, STATE)])

# Dropping NAs
stations <- stations[!is.na(USAF)]

# Removing duplicates
stations[, n := 1:.N, by = .(USAF)]
stations <- stations[n == 1,][, n := NULL]
```

3.  Merge the data as we did during the lecture.

``` r
dat <- merge(
  # Data
  x     = dat,      
  y     = stations, 
  # List of variables to match
  by.x  = "USAFID",
  by.y  = "USAF", 
  # Which obs to keep?
  all.x = TRUE,      
  all.y = FALSE
  )

# head(dat[, list(USAFID, WBAN, STATE)], n = 4)
```

## Question 1: Representative station for the US

What is the median station in terms of temperature, wind speed, and
atmospheric pressure? Look for the three weather stations that best
represent the continental US using the `quantile()` function. Do these
three coincide?

``` r
dat[temp == quantile(temp, probs = 0.50, na.rm = TRUE) & wind.sp == quantile(wind.sp, probs = 0.50, na.rm = TRUE) & atm.press == quantile(atm.press, probs = 0.50, na.rm = TRUE), .(USAFID, STATE, temp, atm.press, wind.sp)]
```

       USAFID STATE temp atm.press wind.sp
    1: 722246    FL 23.5    1014.1     2.1

Knit the document, commit your changes, and Save it on GitHub. Don’t
forget to add `README.md` to the tree, the first time you render it.

## Question 2: Representative station per state

Identify what the most representative (the median) station per state is.
Instead of looking at one variable at a time, look at the euclidean
distance. If multiple stations show in the median, select the one at the
lowest latitude.

Knit the doc and save it on GitHub.

## (optional) Question 3: In the middle?

For each state, identify the closest station to the mid-point of the
state. Combining these with the stations you identified in the previous
question, use `leaflet()` to visualize all \~100 points in the same
figure, applying different colors for those identified in this question.

Knit the doc and save it on GitHub.

## (optional) Question 4: Means of means

Using the `quantile()` function, generate a summary table that shows the
number of states included, average temperature, wind speed, and
atmospheric pressure by the variable “average temperature level,” which
you’ll need to create.

Start by computing the states’ average temperature. Use that measurement
to classify them according to the following criteria:

- low: temp \< 20
- Mid: temp \>= 20 and temp \< 25
- High: temp \>= 25

Once you are done with that, you can compute the following:

- Number of entries (records),
- Number of NA entries,
- Number of stations,
- Number of states included, and
- Mean temperature, wind speed, and atmospheric pressure.

All by the levels described before.

Knit the document, commit your changes, and push them to GitHub. If
you’d like, you can take this time to include the link of [the issue of
the
week](https://github.com/UofUEpiBio/PHS7045-advanced-programming/issues/5)
so that you let us know when you are done, e.g.,

``` bash
git commit -a -m "Finalizing lab 3 https://github.com/UofUEpiBio/PHS7045-advanced-programming/issues/5"
```
