Week 10 Notes
================
Kline DuBose

# Introduction

The purpose of this set of notes is to review and expand our knowledge
and understanding of slurm functions withing HPC.

Further information on the subject can be found
[here](https://book-hpc.ggvy.cl/slurm-fundamentals.html). The full
[book](https://book-hpc.ggvy.cl/) is also very helpful.

``` r
# Model parameters
nsims <- 1e3
n     <- 1e4

# Function to simulate pi
simpi <- function(i) {
  
  p <- matrix(runif(n*2, -1, 1), ncol = 2)
  mean(sqrt(rowSums(p^2)) <= 1) * 4
  
}

# Approximation
set.seed(12322)
ans <- sapply(1:nsims, simpi)

message("Pi: ", mean(ans))
```

    Pi: 3.1416308

``` r
saveRDS(ans, "01-sapply.rds")
```
