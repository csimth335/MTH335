# Gaussian Elimination

The solving of $Ax=b$ is typically taught first by using Gaussian Elimination. Rather than find $LU$ and then solve, we reduce the augmented matrix $[A | b]$ to an upper triangular form and then back substitute.

Let's see that we get $U$ and $L$ from this familar process:

## Example

Following the text, let

```
A = [6 -2 -2 4; 12 -8 6 10; 3 -13 9 3; -6 4 1 -18]
```

and

```
b = [12, 34, 27, -38]
```

Then we form the augmented matrix, `M`:

```
M = [A b//1]
```

We want to subtract the first row times a factor from the each of the next three rows:

```
M[2,:] = M[2,:] - 2*M[1,:]
M[3,:] = M[3,:] - 1//2*M[1,:]
M[4,:] = M[4,:] + 1*M[1,:]
M
```

Then we look at the second row. We use that $M_{22}$ value to "knock out" those below it:

```
M[3,:] = M[3,:] -3*M[2,:]
M[4,:] = M[4,:] +1//2 * M[2,:]
M
```

Finally, we use the third row to knock out the 4th:

```
M[4,:] = M[4,:] +1//5*M[3,:]
```

We have $U$ sitting in this:

```
U = M[:, 1:4]
```

And what about $L$? Form the matrix with the products:

```
L = [1 0 0 0;  2 1 0 0; 1//2 3 1 0; -1 -1//2 -1//5 1]
```


We verify the product:

```
A - L*U
```

### Where did $L$ come from?

We have the operations of adding $\lambda$ to the $i$th row and adding to the $j$th row where $j > i$. Call these $R_m$. And then we have:

$$~
\begin{align}
[U~ b'] &= R_n R_{n-1} \cdots R_2 R_1 [A~ b]\\
(R_n R_{n-1} \cdots R_2 R_1)^{-1} [ U ~ b'] &= [A ~ b] \\
[LU ~ Lb'] &= [A ~ b]
\end{align}
~$$

And we have $LU = A$. Is $L$ actually lower diagonal?

The $R_m$ matrices look like $I + \lambda \delta^{ij}$. The inverses for these are $I - \lambda \delta^{ij}$:

$$~
(I + \lambda \delta^{ij}) \cdot (I - \lambda \delta^{ij}) =
I^2 + \lambda \delta^{ij}- \lambda \delta^{ij} - \lambda^2 \delta^{ij} = I.
~$$

(The $lk$ term of $\delta^{ij} \cdot \delta^{ij}$ is $\sum_m \delta^{ij}(lm) \cdot \delta^{ij}(mn)$. The first means $m=j$, the second means $m=i$, so this is $0$ unless $i=j$, but $i < j$.)

So the inverses are lower triangular.

Finally, $R_p R_m = (I + \lambda \delta^{ij})(I + \gamma \delta^{kl}) = I +  \lambda \delta^{ij} + \gamma \delta^{kl}$ which is lower triangular, so the product of the inverses will be.

Thus $L$ is unit lower triangular, as the diagonal is all 1.

## Pivoting

The book points out that these two problems are similar mathematically, but not computationally:

$$~
A = \left[\begin{array}{cc}
\epsilon & 1\\
1 & 1
\end{array}\right]
~$$

and



$$~
B = \left[\begin{array}{cc}
1 & 1\\
\epsilon & 1
\end{array}\right]
~$$


Solving $A=[1, 2]$ we get

$$~
\begin{align}
\epsilon\cdot x_1 + 1\cdot x_2 &= 1\\
0 \cdot x_1 + (1 - \epsilon^{-1}) x_2 &= 2 - \epsilon^{-1}
\end{align}
~$$

So,

$$~
\begin{align}
x_2 &= \frac{2 - \epsilon^{-1}}{1 - \epsilon^{-1}} \approx 1\\
x_1 &= \epsilon^{-1} [ 1 - \frac{2-\epsilon^{-1}}{1-\epsilon^{-1}}]
\end{align}
~$$

If $\epsilon$ is small, then $1/\epsilon$ is big and subtracting from 1 or 2 can be an issue. (e.g., we saw `10^30 -1 = 10^30` on the computer. So, in the computation of $x_1$, we might get $1/\epsilon [1 - 1] = 0$. But, in fact, this is $ -\epsilon^{-1}/(1-\epsilon^{-1}) \approx 1$.


Whereas, with $Bx = [2; 1]$, we get 


$$~
\begin{align}
1\cdot x_1 + 1\cdot x_2 &= 2\\
0 \cdot x_1 + (1 - \epsilon) x_2 &= 2 - \epsilon
\end{align}
~$$

So, $x_2 = (1-2\epsilon)/(1 - \epsilon) \approx 1$ and $x_1 = 2 - x_2 \approx 2 - 1 = 1$, as desired.

So, switching rows can make a *big* difference in the output when dealing with floating point.

(We don't really switch, but rather keep track of which row is used to pivot using a permutation. Moving data in a matrix is costly, much more so than keeping track of indices.)


### Pivoting strategies

Pivoting results in  permutation of the rows of $A$. This can be written different ways. If $P$ is a permutation matrix, then we can write $LU = PA$ as a $LU$ factorization. Whereas, if `p` is a permutation vector, we can use the matrix notation of `julia` to write `L*U = A[p,:]`.

There are different ways that pivot rows can be selected:

* **partial pivoting**: at step $i$ choose the row with the largest value of $|a_{li|}$, where $l$ runs over the rows that have *not* been used to pivot. 

* **complete pivoting** consider the largest of all value values in rows not used for pivoting

* **scaled row pivoting**. Defing the scale of a row by:


$$~
s_i = max_{i \leq j \leq n} |a_{ij}| = \text{largest of } |a_{i1}|, |a_{i2}|, \dots, |a_{in}|.
~$$

Then at step $i$, form the ratios: $|a_{li}/s_l|$, for $l$ running over the rows not already used for pivoting. Choose the $l$ with the largest ratio to be the new pivot row.


(At step $i$, an easier strategy could be to just pick the row which has the largest value of $|a_{li}|$ where $l$ runs over the rows which have not been used to pivot. This has the effect that the matrix $L$ will have entries no greater than $1$ in absolute value.)


### Example

Consider the matrix

```
Aorig = [-1.0 1 -4; 2 3 1; 3 3 2]
A = copy(Aorig)
```


We first do partial pivoting:

As $3$ is the largest valuein the first column, we choose row 3 to pivot on, and eliminate the first entry in rows 1 and 2 by the appropriate multiplication. We store those values in a matrix $L$:

```
L = zeros(A) # copies size of A, fills with 0
i = 1
p = 3
ps = [p]
L[ps[end], i] = 1
for l in setdiff(1:3, ps)
   L[l, i] = A[l, i] / A[p, i]
   A[l, :] = A[l,:] - L[l,i]*A[p,:]
 end
A   
```

We now have to consider the matrix without the third row:

```
A[setdiff(1:3, ps), :]
```

We see that row 1 is the next pivot row, as $2$ is bigger that $1$ in absolute value

```
i = 2
p = 1
ps = push!(ps, p)
L[ps[end], i] = 1
for l in setdiff(1:3, ps)
   L[l, i] = A[l, i] / A[p, i]
   A[l, :] = A[l,:] - L[l,i]*A[p,:]
 end
A   
```

We finish by pushing the last row, $2$ onto our permutation vector and making sure to set the diagonal entry to $1$:

```
i, p = 3, 2
push!(ps, p)
L[p,i] = 1
```

Are we done? Our bookkeeping, `ps`, points to the pivot rows, to see $L$ and $U$ we need to reverse that:

```
L = L[ps, :]
U = A[ps, :]
L, U
```

And we verify

```
L*U - Aorig[ps, :]
```

To compare below, we record the 3 values computed:

```
L, U, ps
```




### Scaled row pivoting

Now we repeat with scaled row pivoting:

```
A = copy(Aorig)
```


We begin by finding the scale for each row:

```
s = mapslices(x->maximum(abs(x)), A, 2) # mapslices does all rows at once
```

Then we divide column 1 to find the largest:

```
i = 1
A[:,i] ./ s
```

We see $p=3$ will work.

```
L = zeros(A)  
p=3
ps = [p]
L[p,i] = 1
for l in setdiff(1:3, ps)
  L[l,i]=  (A[l,i]/A[p,i])
  A[l,:] = A[l,:] - L[l,i]*A[p,:]
end
A
```

Now we repeat, only we don't want to consider row 3, which we keep track of mentally and don't try to code.

```
s = mapslices(x->maximum(abs(x)), A, 2) 
```

```
i = 2
A[:,i]./ s
```

The answer is $p=2$ now. We  continue by subtracting a multiple of row 2 from row 1 

```
p = 2
push!(ps, p)
L[p, i] = 1
L[1,i] = A[1,i] /A[p,i]
A[1,:] = A[1,:] - L[1,i] * A[p,:]
A
```



So we have our permutation vector: $p = [3, 2, 1]$. Our matrix $U$ is then seen to be

```
push!(ps, 1)
L[1,3] = 1
U = A[ps,  :]
```

Our matrix $L$ comes from using the  factors above (where we used minus signs):

```
L = L[ps, :]
```


Finally, we check that we got what we wanted: $LU$ is the permuted $A$:

```
L*U - Aorig[ps,:]
```

For scaled pivoting we found:

```
L, U, ps
```

This is different than partial pivoting, as might be expected in some cases. The $LU$ factorization is not unique. What can be said is:


> Theorem 2, p173 With pivoting, there is a factorization $LU = PA$.


### Compare to lu function

Julia has a built in `lu` function to return the triple:

```
A = copy(Aorig)
lu(A)
```

This agrees with the factorization we found with partial pivoting. The empirical claim is that partial pivoting is nearly always better compared to complete pivoting due to the extra overhead required for complete pivoting.

## Counting steps

Suppose $A$ is $n \times n$. If applicable, mathematicallly solving $Ax = b$ is as easy as writing $x = A^{-1} b$. Why bother with $LUx = b$ and then solving both $Ly=b$ and $Ux=y$? (Actually we take  $[A ~b]$ and find $[U ~ b']$ then solve this backsubstitution problem.)

One reason is it takes fewer steps.

The book argues that addition and subtraction are much cheaper to do than multiplication and division, so when counting operations, we should just count the long operations, `ops` or short.

Let's look at how many such operations are done for our pivoted Gaussian elimination. First the $U$ term.

For $i=1$, the first row is multiplied by some factor and $n-1$ times and subtracted from other rows. This is $n\cdot(n-1)$ steps, not counting the division to find the factor. For that, we have $n$ operations to find the pivot row (not counting the time to find a maximum, we did divide the $i$th column by the scale, hence $n$). So all told, we have basically $n(n-1) + n$ `ops`.

For $i=2$, we could repeat, but note that we are basically working with matrix without the $p$th row and the first column, so we have the same computation with an $(n-1) \times (n-1)$ size matrix. So the answer will be $n-1$ `ops`.

And so on, to where we get this elimination costs us this many `ops`:

$$~
n^2 + (n-1)^2 + \cdots + 2^2 = \sum_{i=1}^n i^2 -1 = \frac{n(n-1)(2n-1)}{6} -1 \approx \frac{n^3}{3} + \frac{n^2}{2}.
~$$

Now to count the steps to modify the $b$ to get $b'$. The first row introduces $n-1$, the second $n-2$, the third $n-3$ and so on, so this involves $\sum_{i=1}^{n-1} u$  or $n(n-1)/2$

To do the back substitution, we have $1$ division for the first row, $2$ `ops` for the second (we have $ax_j + bx_{j-1}=c$ and we solve for $x_j$ through $(1/a) \cdot (c - bx_{j-1})$ which is $2$ `ops`.) And so on to give: $ 1 +2 + \cdots +n$ or $(n+1)n/2$ counts.

All told we can put together to get a count. The book presents this a bit differently, for the case where we are solving $[A; b_1;b_2; \dots;b_m]$ simulataneously, and then we have:

> Theorem 4 (p176) on Long Operations: To solve $Ax=b$ for $m$ vectors $b$ where $A$ is $n\times n$ involves approximately this many `ops`:

$$~
\frac{n^3}{3} + (\frac{1}{2} + m) n^2.
~$$


So, for a single $b$, to solve $Ax=b$ by this method is basically $n^3/3$ steps. Whereas to find the inverse itself (and not counting the steps in $A^{-1}b$, can be found by taking $m=n$ in the formula (reducing $[A;I]$). To give:

$$~
\text{steps to find } A^{-1} = \frac{n^3}{3} + (\frac{1}{2} + n) n^2 \approx \frac{n^3}{3} + n^3 = \frac{4}{3} n^3.
~$$



## Special case -- Diagonally dominant matrices

Call the matrix $A$ *diagonally dominant$ if the diagonal terms are the largest in each row and column. (That is $|a_{ii}| \geq |a_{il}|, |a_{ki}|$).

> Thm: A diagonal dominant matrix is non-singular and has an LU factorization where no pivoting is necessary.

This is a result of the fact that Gaussian elimination preserves the diagonal dominance, so picking a different partial pivot row or scaled pivot row is unecessary.


## tridiagonal system

Consider the approximation formula for the second derivative:

$$~
f''(x) \approx \frac{f(x + h) - 2 f(x) + f(x-h)}{h^2}
~$$

If we took an interval, say $[0,1]$ and split into a grid of $n+1$ points, then we could discretize $f$ on these points. Using just these point, then we would approximate the second derivative at each point as above. Suppose we had values $f_i = f((i-1_/n)$ for $i = 1, 1, \dots n+1$. Then we could do many of these derivatives at once using matrix notation. To be speicific, we take $n=4$. Then we get

```
n=4
xs = linspace(0, 1, n)
```

```
f(x) = sin(x)
fs = map(f, xs)
```

```
A =  [-2 1 0 0; 1 -2 1 0; 0 1 -2 1; 0 0 1 -2]
```

And then, we would have

```
h = (1-0)/n
(A * fs) / h^2 + fs
```

We see we don't have very good approximations to the second derivative. Were we to increase $n$ this could be the case, except on the edge cases:

```
n = 1000
xs = linspace(0, 1, n)
fs = map(f, xs)

A = zeros(n,n)
for i in 1:n A[i,i] = -2 end
for i in 2:n
  A[i,i-1] = 1
  A[i-1, i] = 1
end
h = (1-0)/n
(A * fs) / h^2 + fs
```

But our focus here is on the special shape of $A$ -- it is tridiagonal. that is $a_{ij} = 0$ if $|i-j| > 1$. For this system -- which does not need pivoting -- then number of `ops` is dramatically reduced, as each row is done with $2$ `ops`, so to get the $LU$ factorization can be done quite quickly.

This is a good thing, as we see that large $n$s are needed to get accuracy, an if the algorithm scaled like $(1/3) \cdot n^3$ that would be a big problem.
