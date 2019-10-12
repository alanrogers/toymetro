#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
/**
   toymetro: a toy model illustrating the metropolis algorithm.

   Data is (are?) one toss of a coin, which comes up heads.
   Likelihood of data is p, the probability of a head.  Prior density
   of p is uniform, so posterior density is

                     p
   Pr[p|heads] = -------- = 2p
                  1
                 int p dp
                  0 

   The goal is to reproduce this using Metropolis.  

   The proposal density is defined as follows:

   1. Draw an observation from a uniform distribution of width w,
   centered on zero, and add it to the current value of the Markov
   Chain.  Call the result y.

   2. If y > 1, then set z = 1 - (y-1).  (In other words, reflect at
   the boundary.)

   3. If y < 0, then set z = -y.  (Another reflection).

   Only one reflection will be needed to ensure that 0 <= z <= 1.
   This proposal distribution is symmetric: The probability of moving
   from x to y is the same as that of moving from y to x.
   Consequently, we can use the Metropolis algorithm without bothering
   with the correction introduced by Hastings.

   Licensing: I am placing this code into the public domain.

   @author Alan Rogers <rogers@anthro.utah.edu>

   Revision History

   1998-3-27 Initial version.  Used a proposal distribution that was
   independent of current value of Markov Chain.  Proposal
   distribution was asymmetric so the Hastings correction was used.

   2001-7-13 Implemented a symmetric proposal distribution, dropped
   the Hastings correction.
**/
int main(void)
{
    double x=0.5;   /* state variable with initial value */
    double y;       /* proposed value */
    double w = 0.4; /* width of proposal distribution */
    double delta;   /* proposed change in x */
    int i, iterations=100000;
    int nacpt=0;    /* number of proposals accepted */
    double mr;
    double xsum=0.0;

    srand48((int) time((time_t *) 0)); /* initialize random numbers */

    printf("%7s %10s %10s %10s", "it", "x", "mean", "nacpt");
    for(i=1; i<=iterations; i++) {
	/*
	 * delta is drawn from a uniform distribution of width w,
	 * symmetric about 0
	 */
	delta = w * (drand48() - 0.5);

	/* draw from proposal distribution */
	y = x + delta;
	if(y > 1.0)
	    y = 2.0 - y;  /* reflect at upper boundary */
	if(y < 0.0)
	    y = -y;       /* reflect at lower boundary */
	
	mr = y/x;         /* Metropolis ratio */

	if(mr >= 1.0 || drand48() <= mr) { /* accept */
	    nacpt += 1;
	    x = y;
	}
	xsum += x;
	if(i%100==0)
	    printf("\n%7d %10.6f %10.6f %10d", i, x, xsum/i, nacpt);
    }
    printf("\n\nMean should converge to 2/3, density to 2*p\n");
    return 0;
}
