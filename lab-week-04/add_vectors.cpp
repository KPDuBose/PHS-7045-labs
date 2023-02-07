#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp 
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
NumericVector add_vectors(
    NumericVector x,
    NumericVector y
    ) {
  NumericVector ans(x.size());
  if (x.size() != y.size())
  {
    stop("The vector lengths must match, stupid");
  }
  for (int i = 0; i < x.size(); ++i)
  {
    ans[i] = x[i] + y[i];
  }
  return ans;
}

/***R
add_vectors(1:5, 11:15)
add_vectors(1:5, 1:10)
*/