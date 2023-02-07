Week 5 Notes
================
Kline DuBose

# R is great, but…

There are some problems with like for loops and othe stuff that can slow
down even a vectorized R program. `lapply` is faster, but it is a faster
for-loop that allocates the necessary memory before hand. (Python is not
faster in general than R -George)

It is better to get proficient in one language than use a bunch of them.

rcpp11 is another similar package that could be worth looking into.

## Example 1: Looping over a vector

``` rcpp

#include<Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector add1(NumericVector x) {
  NumericVecotr ans(x.size());
  for (int i = 0; i < x.size(); ++i)
    ans[i] = x[i] 1;
  return ans;
}
```

``` r
add1(1:10)
```

1)  Unlike R, c++ starts loops at 0, like python and other programming
    languages.

## Example 1: Version 2

``` rcpp
#include<Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector add1Cpp(NumericVector x) {
  return x + 1;
}
```

``` r
add1Cpp(1:10)
```

# Fibinochi sequence examples

``` r
library(Rcpp)
cppFunction(
'int fibCpp(int n){
if (n <= 1) 
  return n;

return fibCpp(n - 1) + fibCpp(n - 2);
}')

fibR <- function(n){
  if(n<=1){return(n)}
  else{fibR(n - 1) + fibR(n - 2)}
}

bench::mark(fibR(20), fibCpp(20), relative = TRUE)
```

    # A tibble: 2 × 6
      expression   min median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <dbl>  <dbl>     <dbl>     <dbl>    <dbl>
    1 fibR(20)    446.   421.        1       11.5      Inf
    2 fibCpp(20)    1      1       397.       1        NaN
