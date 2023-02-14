Week 6 Notes
================
Kline DuBose

# Overview

Two maybe three things about High-Performance computing 1) Big data 2)
Parallel computing 3) Compiled code

# Vocab

Supercomputer High Performance Computing (HPC): Multiple machines within
a single network. High Throughput Computing (HTC): Multiple machines
across multiple networks.

# Cores

How many cores do you have?

``` r
parallel::detectCores()
```

    [1] 20

How many cores does the machine have? that helps with parrallel
computing

# What is parallel computing?

``` r
f <- function(n) n*2
f(1:4)
```

    [1] 2 4 6 8

Just uses a single core, so it goes f(1) then f(2), etc….

If we do it with other cores, then it can run four times as fast. Not
always the best idea to always run parallel computing stuff

# When is it a good time to use the parallel computing power?

When it’s vectorized and not dependent on other processes.

# Example 1: Hello world!

``` r
library(parallel)
cores <- parallel::detectCores()
cl <- parallel::makePSOCKcluster(cores)
x <- 20

# 2 Preparing the cluster
parallel::clusterSetRNGStream(cl, 123) # Equivalent to 'set.seed(123)'
parallel::clusterExport(cl, "x")

# 3 do the call
parallel::clusterEvalQ(cl, {paste0("Hello from process #", Sys.getpid(), ". I see x and it is equal to ", x)})
```

    [[1]]
    [1] "Hello from process #43580. I see x and it is equal to 20"

    [[2]]
    [1] "Hello from process #41148. I see x and it is equal to 20"

    [[3]]
    [1] "Hello from process #53932. I see x and it is equal to 20"

    [[4]]
    [1] "Hello from process #19256. I see x and it is equal to 20"

    [[5]]
    [1] "Hello from process #47732. I see x and it is equal to 20"

    [[6]]
    [1] "Hello from process #16960. I see x and it is equal to 20"

    [[7]]
    [1] "Hello from process #41252. I see x and it is equal to 20"

    [[8]]
    [1] "Hello from process #46580. I see x and it is equal to 20"

    [[9]]
    [1] "Hello from process #15472. I see x and it is equal to 20"

    [[10]]
    [1] "Hello from process #51236. I see x and it is equal to 20"

    [[11]]
    [1] "Hello from process #42632. I see x and it is equal to 20"

    [[12]]
    [1] "Hello from process #53188. I see x and it is equal to 20"

    [[13]]
    [1] "Hello from process #54320. I see x and it is equal to 20"

    [[14]]
    [1] "Hello from process #12792. I see x and it is equal to 20"

    [[15]]
    [1] "Hello from process #23916. I see x and it is equal to 20"

    [[16]]
    [1] "Hello from process #34104. I see x and it is equal to 20"

    [[17]]
    [1] "Hello from process #9008. I see x and it is equal to 20"

    [[18]]
    [1] "Hello from process #45776. I see x and it is equal to 20"

    [[19]]
    [1] "Hello from process #44868. I see x and it is equal to 20"

    [[20]]
    [1] "Hello from process #48096. I see x and it is equal to 20"

*Note*: This outputs in a list so that is something to consider when you
are working with this package

# Example 2: Parallel regressions

*Problem*: Run multiple regressions for each column of a very wide
dataset. Report the coefficients from fitting the following regression
models: $$
y = \textbf{X}_i \beta_i + \varepsilon_i, \quad \varepsilon_i \sim N(0, \sigma^2_i)
$$

$$
\quad\forall \text{ columns } i \in \{1, ..., 999\}
$$

``` r
set.seed(131)
y <- rnorm(500)
X <- matrix(rnorm(500*999), nrow = 500, dimnames = list(1:500, sprintf("x%03d", 1:999)))
```

``` r
dim(X)
```

    [1] 500 999

``` r
X[1:6, 1:5]
```

            x001       x002       x003       x004       x005
    1  0.5983806 -1.2920114  0.7317368 -1.0184339 -0.6186080
    2 -0.3607890  1.4456891 -0.8507421  0.8934013 -0.2774105
    3 -1.3510075 -1.5761328  0.4741303  0.8043521  0.4770461
    4 -0.3662285  1.5853490 -0.2184903 -2.1488158 -1.2233995
    5 -1.2363653  0.6228042 -0.7436500  1.1997468  0.1943254
    6 -0.6751276  0.6775012  0.9102290 -0.8985802 -1.4500698

``` r
str(y)
```

     num [1:500] -0.205 -0.636 -0.827 -0.75 0.598 ...

``` r
ans.stuff <- apply(X = X,
                   MARGIN = 2, 
                   FUN = function(x, y) coef(lm(y ~ x)), 
                   y = y)

ans.stuff[,1:5]
```

                       x001        x002        x003        x004         x005
    (Intercept) -0.02094065 -0.01630664 -0.01565541 -0.01848773 -0.015305816
    x            0.09269758 -0.05233096  0.02893588  0.02404687  0.009151671

Now let’s try doing the parallel things:

``` r
library(parallel)
cores <- parallel::detectCores()
cl <- parallel::makePSOCKcluster(cores)
# parallel::clusterExport(cl, "X", "y")


ans.stuff.par <- parApply(cl = cl, 
                          X = X, 
                          MARGIN = 2, 
                          FUN = function(x,y) coef(lm(y~x)),
                          y = y
                          )
ans.stuff.par[, 1:5]
```

                       x001        x002        x003        x004         x005
    (Intercept) -0.02094065 -0.01630664 -0.01565541 -0.01848773 -0.015305816
    x            0.09269758 -0.05233096  0.02893588  0.02404687  0.009151671

Bench mark this stuff:

``` r
library(bench)
mark(
  parallel = parApply(cl = cl, 
                          X = X, 
                          MARGIN = 2, 
                          FUN = function(x,y) coef(lm(y~x)),
                          y = y
                          ),
  serial = apply(X = X,
                   MARGIN = 2, 
                   FUN = function(x, y) coef(lm(y ~ x)), 
                   y = y)
  
)
```

    Warning: Some expressions had a GC in every iteration; so filtering is
    disabled.

    # A tibble: 2 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 parallel     54.4ms    337ms      3.99    12.1MB     1.33
    2 serial        299ms    303ms      3.30    98.8MB    36.3 
