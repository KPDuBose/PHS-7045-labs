Week 6 lab
================
Kline DuBose

# Part 1

1.  Define the sample
2.  Design 1

<!-- -->

1)  call postDraws 1) Figure out which arm has the highest from beta
    distribution 2) Get probability that one arm is the best 3)
    Standardize 4) Probability that arm is greater than control 5) get
    max probability that an arm is greater than control 6) return needed
    output

<!-- -->

3.  Design 2

<!-- -->

1)  Define arms and looks
2)  set initial sample to have same size each arm
3)  account for residual in number of interim breaks
4)  Update allocation probabilities and nt for each look iteration and
    call post draws
5)  get the final probabilities and return the necessary output.

# Part 2

I’ll revisit this part later at home a little bit more

# Part 3

``` r
N <- 228
arms <- 4
h0 <- 0.35
h1 <- 0.35
h2 <- 0.35
h3 <- 0.35



# Generate draws from posterior and calculate pmax
postDraws <- function(y,nMcmc,h0,h1,h2,h3,n0,n1,n2,n3){
  
  #------------------------------
  # Generate draws from posterior
  #------------------------------
  postDraws0 <- rbeta(n=nMcmc, shape1 = h0 + sum(y[1:n0,"0"]==1), shape2 = (1-h0) + n0 - sum(y[1:n0,"0"]==0))
  postDraws1 <- rbeta(n=nMcmc, shape1 = h1 + sum(y[1:n1,"1"]==1), shape2 = (1-h1) + n1 - sum(y[1:n1,"1"]==0))
  postDraws2 <- rbeta(n=nMcmc, shape1 = h2 + sum(y[1:n2,"2"]==1), shape2 = (1-h2) + n2 - sum(y[1:n2,"2"]==0))
  postDraws3 <- rbeta(n=nMcmc, shape1 = h3 + sum(y[1:n3,"3"]==1), shape2 = (1-h3) + n3 - sum(y[1:n3,"3"]==0))
  
  #-----------------------------------
  # Calculate allocation probabilities
  #-----------------------------------
  # v1-v3 probability each arm is best
  # v0 see RMatch Viele et al. 2020
  pBest <- pmax(postDraws0,postDraws1,postDraws2,postDraws3)
  
  v1 <- mean(pBest==postDraws1)
  v2 <- mean(pBest==postDraws2)
  v3 <- mean(pBest==postDraws3)
  
  v0 <- min(sum( c(v1,v2,v3) * (c( n1, n2, n3) + 1) / (n0 + 1), max(v1, v2, v3)) )
  
  # Standardize
  V0 <- v0 / (sum(v0,v1,v2,v3))
  V1 <- v1 / (sum(v0,v1,v2,v3))
  V2 <- v2 / (sum(v0,v1,v2,v3))
  V3 <- v3 / (sum(v0,v1,v2,v3))
  
  # Calculate probability each arm is greater than control
  p1 <- mean(postDraws1 > postDraws0)
  p2 <- mean(postDraws2 > postDraws0)
  p3 <- mean(postDraws3 > postDraws0)
  
  # Report maximum probablity an arm is greater than control
  pMax <- max(p1,p2,p3)
  # unname n0 objects for consistent object names in output
  n0 <- unname(n0)
  n1 <- unname(n1)
  n2 <- unname(n2)
  n3 <- unname(n3)
  out <- c(V0=V0,V1=V1,V2=V2,V3=V3,p1=p1,p2=p2,p3=p3,pMax=pMax,n0=n0,n1=n1,n2=n2,n3=n3)
  return(out)
  
}



design1 <- function(y, nMcmc=10000, h0, h1, h2, h3){
  
  # By the end of the study, each arm will have equal allocation
  postDraws(y=y,nMcmc=nMcmc,
            n0=nrow(y)/ncol(y),
            n1=nrow(y)/ncol(y),
            n2=nrow(y)/ncol(y),
            n3=nrow(y)/ncol(y),
            h0=h0, h1=h1, h2=h2, h3=h3)
  
}

design2 <- function(y, N, nInterim, h0, h1, h2, h3){
  
  #-----------------------------------------------
  # Set up parameters to inform interim monitoring
  #-----------------------------------------------
  
  # arms and looks as derived from y and look attributes
  arms         <- ncol(y)
  looks        <- floor(N / nInterim)
  
  # n at time t with n = 10 for each arm at t = 1
  nt           <- matrix(NA,nrow=looks,ncol=arms)
  colnames(nt) <- 0:(arms-1)
  nt[1,]       <- rep(nInterim / arms,arms)
  
  # Number of observations between each look
  # Account for possibility of no residual number of nInterim looks
  if(N %% nInterim != 0) {
    residual <- N %% nInterim
  } else {
    residual <- NULL
  }
  size         <- c(rep(nInterim,looks - 1),residual)
  
  
  
  #---------------------------------------------------------------
  # Update allocation probabilities and nt for each look iteration
  #---------------------------------------------------------------
  for(i in seq(looks-1)){
    
    alloProbs <- postDraws(y=y, nMcmc = 1000, h0=h0,h1=h1,h2=h2,h3=h3,
                           n0 = nt[i,"0"],
                           n1 = nt[i,"1"],
                           n2 = nt[i,"2"],
                           n3 = nt[i,"3"])
    
    nt[i+1,] <- nt[i,] + c(rmultinom(n = 1, size = size[i], 
                                     prob = alloProbs[c("V0","V1","V2","V3")]))
    
  }
  
  #--------------------------------------------------------
  # Report final probabilities of best arm and sample sizes
  #--------------------------------------------------------
  post <- postDraws(y=y, nMcmc = 1000, h0=h0,h1=h1,h2=h2,h3=h3,
                    n0 = nt[i,"0"],
                    n1 = nt[i,"1"],
                    n2 = nt[i,"2"],
                    n3 = nt[i,"3"])
  
  return(post)
  
}


# Generate outcomes under null
y0 <- rbinom(N,size=1,prob=h0)
y1 <- rbinom(N,size=1,prob=h1)
y2 <- rbinom(N,size=1,prob=h2)
y3 <- rbinom(N,size=1,prob=h3)

y <- cbind("0"=y0,"1"=y1,"2"=y2,"3"=y3)

design1(y,h0=h0,h1=h1,h2=h2,h3=h3)
```

            V0         V1         V2         V3         p1         p2         p3 
     0.5718947  0.1437894  0.1412707  0.1430452  0.4954000  0.5061000  0.4993000 
          pMax         n0         n1         n2         n3 
     0.5061000 57.0000000 57.0000000 57.0000000 57.0000000 

``` r
design2(y,N=N,nInterim = 40,h0=h0,h1=h1,h2=h2,h3=h3)
```

            V0         V1         V2         V3         p1         p2         p3 
     0.4389528  0.1965408  0.1700565  0.1944499  0.5070000  0.4820000  0.4720000 
          pMax         n0         n1         n2         n3 
     0.5070000 70.0000000 25.0000000 37.0000000 28.0000000 

``` r
# 1. CREATING A CLUSTER
library(parallel)
cores <- parallel::detectCores()
cl <- parallel::makePSOCKcluster(cores)    
x  <- 20

# 2. PREPARING THE CLUSTER
parallel::clusterSetRNGStream(cl, 123) # Equivalent to `set.seed(123)`
parallel::clusterExport(cl, c("y", "N", "arms", "h0", "h1", "h2", "h3", "postDraws"))

bench::mark(
  "normal" = replicate(1000, design1(y,h0=h0,h1=h1,h2=h2,h3=h3)), 
  "parallel" = parSapply(cl, 1:1000, design1, y = y, h0=h0, h1=h1, h2=h2, h3=h3), 
  relative = TRUE, check = FALSE
)
```

    Warning: Some expressions had a GC in every iteration; so filtering is
    disabled.

    # A tibble: 2 × 6
      expression   min median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <dbl>  <dbl>     <dbl>     <dbl>    <dbl>
    1 normal      82.6   54.2       1        587.     1.14
    2 parallel     1      1        42.0        1      1   

``` r
parallel::stopCluster(cl)
```
