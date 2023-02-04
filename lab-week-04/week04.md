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
    [1] 0.782
    [1] "Number of patients per arm"
    [1] 57

# Design 2

``` r
design2.fun <- function(popSize, alpha, beta, effective, interim){
  
  numbIter <- popSize %/% interim + 1
  
  # Randomly assign subjects
  subjects <- rbinom(popSize, 1, effective)
  
  iter <- rep(1:6, each = 40, length.out = 228)
  iter <- sample(iter)
  
  subjects <- data.table::as.data.table(cbind(subjects, iter))
  
  # Initial Distribution to interim
  equal.dist(length(subjects[iter == 1, subjects]), alpha, beta, subjects[iter == 1, subjects])
  
  # Readjust "v"
  update.v(v_1, v_2, v_3, length(y_0), length(y_1), length(y_2), length(y_3))
  
  # Run the analysis for the remaining arms
  
  for (i in 2:numbIter) {
    # Run to get new numbers for the different arms
    vari.dist(length(subjects[iter == i, subjects]), alpha, beta, subjects[iter == i, subjects])
    
    # recalculate v for the next round of information
    update.v(v_1, v_2, v_3, length(y2_0), length(y2_1), length(y2_2), length(y2_3))
  }
  
  print(paste("V_1:", fv_1))
  print(paste("V_2:", fv_2))
  print(paste("V_3:", fv_3))
  print(paste0("Number of subjects in control ", length(y_0)))
  print(paste0("Number of subjects in arm 1 ", length(y_1)))
  print(paste0("Number of subjects in arm 2 ", length(y_2)))
  print(paste0("Number of subjects in arm 3 ", length(y_3)))
}

update.v <- function(v1, v2, v3, n0, n1, n2, n3){
  
  fv_1 <<- v1
  fv_2 <<- v2
  fv_3 <<- v3
  
  v0 <- min(sum((v1)*((n1 + 1)/(n0 + 1)),(v2)*((n2 + 1)/(n0 + 1)),(v3)*((n3 + 1)/(n0 + 1))), max(v1, v2, v3))
  
  v_0 <<- (v0)/sum(v0, v1, v2, v3)
  v_1 <<- (v1)/sum(v0, v1, v2, v3)
  v_2 <<- (v2)/sum(v0, v1, v2, v3)
  v_3 <<- (v3)/sum(v0, v1, v2, v3)
}

equal.dist <- function(sampleSize, alpha, beta, subjectVector){
  equalArm <- sampleSize / 4
  group <- rep_len(0:3, sampleSize)
  # group <- sample(group, sampleSize)
  allocation <- data.table::as.data.table(cbind(subjectVector, group))
  
  y_0 <<- (allocation[group == 0, .(subjectVector)])$subjectVector
  y_1 <<- (allocation[group == 1, .(subjectVector)])$subjectVector
  y_2 <<- (allocation[group == 2, .(subjectVector)])$subjectVector
  y_3 <<- (allocation[group == 3, .(subjectVector)])$subjectVector
  
  # Distribution of each thing
  p_0 <- rbeta(1000, shape1 = alpha + sum(y_0), shape2 = beta + equalArm - sum(y_0))
  p_1 <- rbeta(1000, shape1 = alpha + sum(y_1), shape2 = beta + equalArm - sum(y_1))
  p_2 <- rbeta(1000, shape1 = alpha + sum(y_2), shape2 = beta + equalArm - sum(y_2))
  p_3 <- rbeta(1000, shape1 = alpha + sum(y_3), shape2 = beta + equalArm - sum(y_3))
  
  v_1 <<- mean(p_1 > p_0)
  v_2 <<- mean(p_2 > p_0)
  v_3 <<- mean(p_3 > p_0)
}

vari.dist <- function(sampleSize, alpha, beta, subjectVector){
  group <- sample(0:3, sampleSize, replace = TRUE, prob = c(v_0, v_1, v_2, v_3))
  allocation <- data.table::as.data.table(cbind(subjectVector, group))
  
  y2_0 <<- as.vector(allocation[group == 0, .(subjectVector)])$subjectVector
  y2_1 <<- as.vector(allocation[group == 1, .(subjectVector)])$subjectVector
  y2_2 <<- as.vector(allocation[group == 2, .(subjectVector)])$subjectVector
  y2_3 <<- as.vector(allocation[group == 3, .(subjectVector)])$subjectVector
  
  # append the new values in each arm to the existing ones
  y_0 <<- append(y_0, y2_0); y_1 <<- append(y_1, y2_1); y_2 <<- append(y_2, y2_2); y_3 <<- append(y_3, y2_3)
  
  p_0 <- rbeta(1000, shape1 = alpha + sum(y_0), shape2 = beta + length(y_0) - sum(y_0))
  p_1 <- rbeta(1000, shape1 = alpha + sum(y_1), shape2 = beta + length(y_1) - sum(y_1))
  p_2 <- rbeta(1000, shape1 = alpha + sum(y_2), shape2 = beta + length(y_2) - sum(y_2))
  p_3 <- rbeta(1000, shape1 = alpha + sum(y_3), shape2 = beta + length(y_3) - sum(y_3))
  
  v_1 <<- mean(p_1 > p_0)
  v_2 <<- mean(p_2 > p_0)
  v_3 <<- mean(p_3 > p_0)
}

design2.fun(228, 0.35, 0.65, 0.35, 40)
```

    [1] "V_1: 0.137"
    [1] "V_2: 0.191"
    [1] "V_3: 0.102"
    [1] "Number of subjects in control 82"
    [1] "Number of subjects in arm 1 79"
    [1] "Number of subjects in arm 2 41"
    [1] "Number of subjects in arm 3 26"
