# ### Simulation for Week 2
# 
# # Equal arm allocation
# # Set up response variable - initial data set
# arm0 <- rbinom(57, 1, 0.35)
# arm1 <- rbinom(57, 57, 0.35)
# arm2 <- rbinom(57, 57, 0.35)
# arm3 <- rbinom(57, size = , 0.35)
# 
# datMat <- cbind(arm0, arm1, arm2, arm3)
# 
# posterior.distribution <- function(arm, n = 40){
#   a <- 0.35; b <- 0.65
#   rbeta(n, shape1 = (a + sum(arm)), shape2 = ()) 
# }
# set.seed(1134)
N <- 228
i <- 1:N
t <- 0:3
alpha_t <- 0.35
beta_t <- 0.65
equalArm <- N/4
subjects <- rbinom(228, 1, 0.35)
allocation <- split(subjects, t)

y_0 <- allocation$'0'
y_1 <- allocation$'1'
y_2 <- allocation$'2'
y_3 <- allocation$'3'

# Distribution of each thing
p_0 <- rbeta(1000, shape1 = alpha_t + sum(y_0), shape2 = beta_t + equalArm - sum(y_0))
p_1 <- rbeta(1000, shape1 = alpha_t + sum(y_1), shape2 = beta_t + equalArm - sum(y_1))
p_2 <- rbeta(1000, shape1 = alpha_t + sum(y_2), shape2 = beta_t + equalArm - sum(y_2))
p_3 <- rbeta(1000, shape1 = alpha_t + sum(y_3), shape2 = beta_t + equalArm - sum(y_3))

hist(p_0)
hist(p_1)
hist(p_2)
hist(p_3)

v_1 <- mean(p_1 > p_0)
sum(v_1) / 1000
v_1

v_2 <- mean(p_2 > p_0)
v_2

v_3 <- mean(p_3 > p_0)
v_3






sample(0:3,size = 40, prob(v0,v1,v2,v3))
