Rcpp::sourceCpp("lab-week-08-openmp/dist.cpp")

# Simulating data
set.seed(1231)
K <- 50
n <- 10000
x <- matrix(rnorm(n*K), ncol=K)
# Are we getting the same?
hist(as.matrix(dist(x)) - dist_par(x, 4)) # Only zeros

# Check lab work

n <- 500
Y <- matrix(rnorm(n * n), ncol = n)
X <- cbind(rnorm(n))

# Running the benchmark
res <- microbenchmark::microbenchmark(
  K4B_v1(X, Y, 2),
  K4B_v2(X, Y, 2, 4),
  check = "equal",
  times = 10
)

print(res, unit = "relative")
print(res, unit = "ms")