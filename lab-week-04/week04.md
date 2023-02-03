Week 4 Lab
================
Kline DuBose

# Description

Since we didn’t have time to finish the week 2 lab, we are going to work
on it again

# Design 1

``` r
library(data.table)
# set.seed(1134)

design1.fun <- function(sampleSize, alpha, beta, effective){
  
  delta <- 0.9912
  
  equalArm <- sampleSize / 4
  subjects <- rbinom(sampleSize, 1, effective)
  f <- 0:3
  allocation <- data.table::as.data.table(split(subjects, f))
  
  y_0 <- allocation$'0'
  y_1 <- allocation$'1'
  y_2 <- allocation$'2'
  y_3 <- allocation$'3'
  
  # Distribution of each thing
  p_0 <- rbeta(1000, shape1 = alpha + sum(y_0), shape2 = beta + equalArm - sum(y_0))
  p_1 <- rbeta(1000, shape1 = alpha + sum(y_1), shape2 = beta + equalArm - sum(y_1))
  p_2 <- rbeta(1000, shape1 = alpha + sum(y_2), shape2 = beta + equalArm - sum(y_2))
  p_3 <- rbeta(1000, shape1 = alpha + sum(y_3), shape2 = beta + equalArm - sum(y_3))
  
  v_1 <- mean(p_1 > p_0)
  
  v_2 <- mean(p_2 > p_0)
  
  v_3 <- mean(p_3 > p_0)
  
  if(max(v_1, v_2, v_3) > delta){
    print("Successful trial")
    print(max(v_1, v_2, v_3))
    print("Number of patients per arm")
    print(equalArm)
    
  }
  else{
    print("Unsuccessful trial")
    print(max(v_1, v_2, v_3))
    print("Number of patients per arm")
    print(equalArm)

  
}}

design1.fun(228, 0.35, 0.65, 0.35)
```

    [1] "Unsuccessful trial"
    [1] 0.483
    [1] "Number of patients per arm"
    [1] 57

# Design 2

``` r
design2.fun <- function(){
  
}
```