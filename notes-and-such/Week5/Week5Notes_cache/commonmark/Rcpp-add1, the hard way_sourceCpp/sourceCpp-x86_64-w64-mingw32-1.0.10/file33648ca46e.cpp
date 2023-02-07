
#include<Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
NumericVector add1(NumericVector x) {
  NumericVecotr ans(x.size());
  for (int i = 0; i < x.size(); ++i)
    ans[i] = x[i] 1;
  return ans;
}
