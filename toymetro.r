# toymetro: a toy model illustrating the metropolis algorithm.
#
# Data consiste of k tosses of a coin, each of which comes up heads.
# Likelihood of data is p^k, the probability of a head.  Prior density
# of p is uniform, so posterior density is
#
#                    p^k
# Pr[p|k heads] = -------- = (1+k) p^k
#                 1
#                int p^k dp
#                 0
#
# The mean of this distribution is (1+k)/(2+k).
#
# Posterior cumulative distribution function is Pr[X<x] = x^(k+1)
#
# Quantile q is q^(1/(k+1)).
#
# The goal is to reproduce this using Metropolis.
#
# The proposal density is defined as follows:
#
# 1. Draw an observation from a uniform distribution of width w,
# centered on zero, and add it to the current value of the Markov
# Chain.  Call the result y.
#
# 2. If y > 1, then set z = 1 - (y-1).  (In other words, reflect at
# the boundary.)
#
# 3. If y < 0, then set z = -y.  (Another reflection).
#
# Only one reflection will be needed to ensure that 0 <= z <= 1.
# This proposal distribution is symmetric: The probability of moving
# from x to y is the same as that of moving from y to x.
# Consequently, we can use the Metropolis algorithm without bothering
# with the correction introduced by Hastings.
#
# Licensing: I am placing this code into the public domain.
#
# @author Alan Rogers <rogers@anthro.utah.edu>
#
# Revision History
#
# 1998-3-27 Initial version.  Used a proposal distribution that was
# independent of current value of Markov Chain.  Proposal
# distribution was asymmetric so the Hastings correction was used.
#
# 2001-7-13 Implemented a symmetric proposal distribution, dropped
# the Hastings correction.
#
# 2007-4-19 Translated from C to Python.
#
# 2012-7-16 Translated Python version to R
#
# 2012-7-26 Modified code so that number of tosses of coin is a parameter, k.


k <- 10     # number of tosses of coin
x <- 0.5   # state variable with initial value
w  <- 0.4  # width of proposal distribution
iterations <- 1000
nacpt <- 0 # number of proposals accepted
xsum <- 0.0
xvec <- rep(NA, iterations) # data vector

print(sprintf("%7s %10s %10s %10s", "it", "x", "mean", "nacpt"))
for(i in 1:iterations) {
    # perturbation delta is drawn from a uniform distribution of width
    # w, symmetric about 0
    delta <- w * (runif(1) - 0.5)

    # draw from proposal distribution
    y <- x + delta
    y <- abs(y)            # reflect at lower boundary
    while(y>1) {
        y <- abs(2.0 - y)  # reflect at both boundaries
    }

    mr <- (y/x)^k     # Metropolis ratio

    if (mr >= 1.0 || runif(1) <= mr) {
        # accept
        nacpt <- nacpt + 1
        x <- y
    }
    xvec[i] <- x
    xsum <- xsum + x
    if (i %% 100==0) {
        print(sprintf("%7d %10.6f %10.6f %10d", i, x, xsum/i, nacpt))
    }
}
print(sprintf("Mean should converge to (1+%d)/(2+%d)=%f",
              k, k, (1.0+k)/(2+k)))
print(sprintf("Distribution should converge to %d*p^%d",
               1+k, k))

# Quantile-quantile plot showing that MCMC generated correct posterior
# density.
pr <- seq(0.01, 0.99, 0.01)
plot(pr^( 1/(1.0+k)), quantile(xvec, probs=pr), main="QQ plot",
     xlab="Quantiles of true posterior",
     ylab="Quantiles of MCMC approximation")

