Week 5 Lab
================
Kline DuBose

# Lab description

Construct a `Rcpp` function that improves upon the following:

``` r
ps_matchR <- function(x) {
  
  match_expected <- as.matrix(dist(x))
  diag(match_expected) <- .Machine$integer.max
  indices <- apply(match_expected, 1, which.min)
  
  list(
    match_id = as.integer(unname(indices)),
    match_x  = x[indices]
  )
  
}
```

# Question 1: Create a simple function

``` rcpp
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
List ps_match1(const NumericVector & x) {
  
  int n = x.size();
  IntegerVector indices(n);
  NumericVector values(n);
  
  for (int i = 0; i < n; ++i) {
    
    int best_n = 0;
    double best_dist = std::numeric_limits< double >::max();
    
    for (int j = 0; j < n; ++j) {             //..loop over j and check if it is the optimum...
       
       if (i == j)
         continue;
       
       double tmp_dist = abs(x[i] - x[j]);         // if (...the closests so far...) {
       
       if (tmp_dist < best_dist) {
         
         best_dist = tmp_dist;
         best_n    = j;
         
       }                                       //     ...update the optimum...
        
    }

        indices[i] = best_n + 1;
        values[i] = x[best_n];
                                                    // }
  }
  
  return List::create(
    _["match_id"] = indices,
    _["match_x"] = values
  );                       // [a list like the R function]
  
}

/*** R

ps_matchR <- function(x) {
  
  match_expected <- as.matrix(dist(x))
  diag(match_expected) <- .Machine$integer.max
  indices <- apply(match_expected, 1, which.min)
  
  list(
    match_id = as.integer(unname(indices)),
    match_x  = x[indices]
  )
  
}

set.seed(123)
x <- runif(5)

ps_matchR(x)

ps_match1(x)
*/
```

``` r
set.seed(1134)
x <- runif(5)

ps_matchR(x)
```

    $match_id
    [1] 5 4 2 2 1

    $match_x
    [1] 0.8523161 0.2194393 0.2180166 0.2180166 0.5870534

``` r
ps_match1(x)
```

    $match_id
    [1] 5 4 2 2 1

    $match_x
    [1] 0.8523161 0.2194393 0.2180166 0.2180166 0.5870534
