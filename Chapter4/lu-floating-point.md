# LU decomposition and floating point issues

Solving $A x = b$ for $x$ with inputs $A$ and $b$ can be done more efficiently by $LU$ factorization, than by finding an inverse and then solving via $x = A^{-1}b$. The number of steps is at least 1/3 as few.

However, there are still many steps needed ($n^3/3$) and we know that at each floating point operation we have:

$$~
fl(x \odot y) = (x \odot y) (1 + \delta)
~$$

Where $\delta \leq \epsilon$, the machine tolerance number. So, even if each operation introduces an error that is bounded, when there are many operations these errors can accumulate. How much?

## Recall

We have seen such a question before in Theorem 1 on page 49:

> Theorem: If $x_1, x_2, \dots, x_n$ are positive machine numbers with unit roundoff $\epsilon$ then the *relative* roundoff error in computing their sum is at most $(1+\epsilon)^n \approx n \epsilon$.


A near analog is this theorem from p249 (modified and simplified):

> Theorem 2 p 249. Suppose $x_1, \dots, x_n$ and $y_1, \dots, y_n$ are machine numbers. (We further suppose these are positive. Consider the sum $\sum^n x_i y_i$ (the dot product). If we compute in the natural way, then the machine value is bounded by the mathematical value times $(6/5\cdot(n+1)\epsilon)$.

By the natural way, we mean $z_k = fl(z_{k-1} + fl(x_ky_k))$.

## LU Factorization

Let's look at the LU factorization with partial pivoting. The algorithm produces numbers $a_{ij}^{(k)}$ and $l_{ik}$ for $k=0,1,\dots,n$ steps.

Where we have for the case $i > k$ and $j>k$

$$~
a_{ij}^{(k+1)} = a_{ij}^{(k)} - l_{ik}a_{kj}^{(k)}, \quad\text{and }
l_{ik} = \frac{a_{ik}^{(k)} }{a_{kk}^{(k)}}.
~$$

With floating point concerns, this becomes:


$$~
\tilde{a}_{ij}^{(k+1)} =
 fl(\tilde{a}_{ij}^{(k)} -  fl( \tilde{l}_{ik}\tilde{a}_{kj}^{(k)})), \quad\text{ and }
\tilde{l}_{ik} = fl(\frac{\tilde{a}_{ik}^{(k)} }{\tilde{a}_{kk}^{(k)}}). 
~$$

So, the end of the process we have two matrices $\tilde{L}$ and $\tilde{U}$ instead of the mathematical $L$ and $U$. How far away will these be?

> Theorem (p247). Under some pivoting assumptions

$$~
\tilde{L} \tilde{U} = A + E
~$$

Where the entries of $E$ are bounded by:

$$~
|e_{ij}| \leq 2n\epsilon \max |a_{ik}^{(k)}|.
~$$


## And then...

We solve $Ax=b$ by solving $Ly=b$ and then $Ux=y$. But secretly we solve $\tilde{L}y=b$. But the substitution will introduce errors. How big?

> Thm 3 p250. If $L$ is a $n\times n$ lower triangular matrix of machine numbers (like $\tilde{L}$) and $b$ a vector of machine numbers and $y$ is computed by substituting with $L$ and $b$, then the resulting vector, $\tilde{y}$ is subject to rounding, so may not exactly solve $Ly=b$. It does solve

$$~
(L+\Delta) \tilde{y} = b
~$$

Where the entries of $\Delta$ satisfy:

$$~
|\Delta_{ij}| \leq \frac{6}{5}(n+1) \epsilon |l_{ij}|.
~$$

A similar theorem applies for solving $Uy=b$, though the bound  includes $|u_{ij}|$ terms.

### But with our pivoting...

With our pivoting we have the entries of $L$ are bounded by $1$, as we pivot to make the row chosen have the largest value and our entries involve $a_{ik}^{(k)} / a_{kk}^{(k)}$. This isn't the case for $U$ and $U$ can grow. For example, consider this [matrix](http://www.math.iit.edu/~fass/477577_Chapter_7.pdf):

```
n = 5
A = I-tril(ones(Int, n,n),-1)
A[:,n] = ones(Int, n)
A
```

We have

```
L,U,p = lu(A)
U
```

The bottom right entry gets big. If fact, for $n=20$ we have:


```
n = 20
A = I-tril(ones(Int, n,n),-1)
A[:,n] = ones(Int, n)
L,U,p = lu(A)
U[n,n]
```


This example is contrived as it produces the worst case results. Here we define:

$$~
g_n(A) = \frac{\max_{ij}|U_{ij}|}{\max_{ij}|A_{ij}|}.
~$$

(The book defines a  related, but not identical quantity, but this fits more inline with the bounds given in the theorems.)

Then the worst case is $g_n(A) \leq 2^{n-1}$.

In theory then the bound of the form:

$$~
|\Delta_{ij}| \leq \frac{6}{5}(n+1) \epsilon |u_{ij}|
~$$

Is just saying that the terms are like $n2^n\epsilon$, which for even modest size $n$ would be  a problem.

However, in practice the growth is closer to $n$ -- not $2^n$ which means that the LU decomposition is assumed to be stable to use.


### Example

Let's see the difference between a random $A$ and the one with the devious pattern:

```
n = 50
x = rand(n)

A = I-tril(ones(n,n),-1)
A[:,n] = ones(n)

L,U,p = lu(A)

b = A[p,:]*x
xtilde = U \ (L \ b)
norm(x - xtilde, Inf)/norm(x, Inf)
```

Whereas,

```
A = rand(n,n)
L,U,p = lu(A)

b = A[p,:]*x
xtilde = U \ (L \ b)
norm(x - xtilde, Inf)/norm(x, Inf)
```

This is quite a difference. In the book, we find this bound:

$$~
\frac{\| x - \tilde{x}\|_\infty}{\|x\|_\infty} \leq 4n^2 g_n(A) \kappa_\infty(A) \epsilon
~$$

The $\kappa$ is the condition number. This is for a slightly different definition of the growth number, but using ours we have:

```
growth(A,U=lu(A)[2]) = maximum(abs.(U)) / maximum(abs.(A))
bound(A) = 4*size(A)[1] * growth(A) * cond(A, Inf) * eps()
```

Then we have for our random matrix

```
bound(A)
```

This is a small bound and we see that the actual value is orders of magnitude less


And for our devious one -- where there is a a big relative error -- we have a very large bound:

```
A = I-tril(ones(n,n),-1)
A[:,n] = ones(n)
bound(A)
```

	
	

