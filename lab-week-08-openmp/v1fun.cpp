#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;

//' Fourth order biweight kernel
 // [[Rcpp::export]]
 arma::mat K4B_v1(
     arma::mat X,
     arma::mat Y,
     arma::vec h
 ) {
   
   arma::uword n_n = X.n_rows;
   arma::uword n_m = Y.n_cols;
   arma::mat Nhat(n_n, n_m);
   arma::vec Dhat(n_n);
   arma::mat Yhat(n_n, n_m);
   
   for (arma::uword i = 0; i < n_n; ++i)
   {
     
     const auto xrow_i = X.row(i);
     for (arma::uword j = 0; j < i; ++j)
     {
       
       arma::vec Dji_h = (X.row(j) - xrow_i) / h;
       auto Dji_h2 = arma::pow(Dji_h, 2.0);
       
       double Kji_h = prod(
         (arma::abs(Dji_h) < 1) %
           (1.0 - 3.0 * Dji_h2) %
           arma::pow(1.0 - Dji_h2, 2.0) * 105.0 / 64.0
       );
       
       Dhat(i) += Kji_h;
       Dhat(j) += Kji_h;
       
       Nhat.row(i) += Y.row(j) * Kji_h;
       Nhat.row(j) += Y.row(i) * Kji_h;
       
     }
     
   }
   
   for (size_t i = 0u; i < n_n; ++i)
   {
     if (Dhat(i) != 0)
       Yhat.row(i) = Nhat.row(i)/Dhat(i);
   }
   
   return(Yhat);
   
 }