# Review for test 2

> 11/11: Please let me know if something seems wrong. I may add more questions, but wanted to get this up sooner than later.

This is some of the material that will be up for testing on test 2.

## Chapter 3

In Chapter 3 we discussed various means to solve the equation $f(x)=0$ where $f: R \rightarrow R$. (That is a $f$ is a scalar-valued function of a real variable). This formulation applies to finding answers for each of these equations:

$$~
\begin{align}
\sin(x) -x + 1/2 &= 0\\
\tan(x) + x &= 1\\
a\cos(x) &= x
\end{align}
~$$

Here is a summary of the methods we discussed:

### Bisection method:

* assumes $f(x)$ is $C$ (continuous).

* $c_i = mid(a_i, b_i)$; and $[a_{i+1}, b_{i+1}]$ chosen from $[a_i, c_i]$ or $[c_i, b_i]$.

* The error, $e_n = c_n -r$  is bounded by $2^{-(n+1)}(b_0 - a_0)$.

* guaranteed (mathematically) to converge ($c_n \rightarrow r$) if $a_0, b_0$ brackets a root. (Intermediate value theorem.)

* linear convergence

* in floating point can be guaranteed to produce a floating point number $r$ where it may not be $f(r)=0$, but if not, the `f(prevfloat(r)) * f(nextfloat(r)) < 0$.


### Newton's method

* assumes $f(x)$ is $C^2$ and $r$ is a *simple* zero

* a process $x_{n+1} = x_n - f(x_n) / f'(x_n)$

* the error satisfies $e_{n+1} = f''(\xi)/(2f'(x_n)) e_n^2 \approx f''(r)/(2f'(r)) e_n^2$.

* Let $C(\delta) = max(f''(y))/(2min(f'(y)))$ for $x,y$ within $\delta$ of $r$. If $\delta C(\delta) < 1$, then any starting value within $\delta$ of $r$ will converge to $r$ quadratically fast.

* If $f'>0$ and $f''>0$ then any initial value will converge

* numerically one needs to clarify when we stop iterating using different tolerances.

* If $r$ is not a simple zero, convergence is linear.

### Secant method

* Assume $f$ is $C^2$ and $r$ is a simple zero.

* if $f[a,b] = (f(b) - f(a))/(b-a) \approx f'(a)$, then the method is $x_{n+1} = x_n - f(x_n) / f[x_n, x_{n-1}]$.

* $e_{n+1} \approx f''(r) / (2f'(r)) e_n e_{n-1}$.

* convergence is faster than linear, slower than quadratic: $\alpha = (1 + \sqrt{5})/2$

### Fixed point

* Assume $F$ is $C^q$ and $r$ is a simple zero

* method is $x_{n+1} = F(x_n)$.

* If $F$ is a **contractive mapping**, then the method converges to a (uinque) fixed point $s$.

* If $x_{n+1} = F(x_n)$ converges to $s$ and If $q$ is the first integer where $F^{(q)})(r) \neq 0$, then

- $e_{n+1} = F^{(q)}(\xi)/q! e_n^q$

- $q$ is the order of convergence.

### some sample problems

* Will the bisection method find the zero of $(x-1)^2$?

* Will Newton's method find the zero of $(x-1)^2$?

* In what ways does the function $f(x) = x^{20} - 1$ challenge the convergence of Newton's method?

* Why do you know that using Newton's method on the function $f(x) = e^x + x$ will be guaranteed to converge?

* Let $f(x) = \sin(x)$. Starting with the $x_0, x_1 = 3, 4$, perform 2 steps of the secant method (find $x_2, x_3$). How accurate is your value ($f(x_3) - \pi$)?

* The *efficiency index* is defined by $\mu^{1/f}$ where $\mu$ is the order of convergence of a method and $f$ is the number of function calls per step. For Newton, these values are $2$ and $2$ and for the secant method $(1 + \sqrt{5})/2$ and $1$. Which method has a bigger efficiency index?

* Let $e_n = x_n -r$, Taylor's theorem gives

$$~
f(x_n) = f(r) + f'(r)e_n + (1/2) f''(r) e_n^2 + \mathcal{O}(e_n^3)
~$$

Divide this by $e_n$, then use for both the case $n$ and $n-1$. Use these pieces to identify the limit as $n$ goes to $\infty$ of

$$~
\frac{f(x_n)/e_n - f(x_{n-1})/e_{n-1}}{x_n - x_{n-1}}.
~$$

* Let $F(x) = x/2 + f(x)$ where we assume $|f'(x)| \leq 1/4$. Show that $F(x)$ is a contractive map.

* Let $F(x) = x/2 + f(x)$ where we assume $|f'(x)| \leq 1/4$. What is the order of convergence of the iterative mapping: $x_{n+1} = F(x_n)$?

* Let $p>0$. What is the value of this expression:

$$~
\sqrt{p + \sqrt{p + \sqrt{p + \cdots}}}
~$$

(As the book says, this is $x_{n+1} = \sqrt{p + x_n}$.)







## Chapter 4

Chapter 4 deals with the problem of simulataneous solutions of linear equations expressed in matrix form: $Ax=b$.

### 4.1 
In the first section, there is a review of linear algebra concepts. Some important pieces are:

* how $Ax=b$ represents a system of equations
* the language of matrix, vector, column vector, row vector
* matrix operations: scalar multiplication, addition, subtraction, multiplication, transpose.
* symmetric, positive definite matrices.
* block multiplication of matrices
* the inverse of a matrix
* special types of matrices: square, invertible, symmetric, upper triangular, lower triangular, etc.


### 4.2

We looked at solving $Ax=b$ is special cases: diagonal matrices, upper triangular, or lower triangular.


We looked at forming an LU decomposition of a matrix $A$. The first step of the method basically forms this matrix product:

$$~
A = \left[
\begin{array}{cc}
a_{11} & c^T\\
b & A_1
\end{array}
\right]
= L_1 \cdot U_1
= \left[
\begin{array}{cc}
1 & 0\\
b/a_{11} & L_2
\end{array}
\right]
\cdot
\left[
\begin{array}{cc}
a_{11} & c^t\\
0 & R_2
\end{array}
\right]
~$$

(We won't do this method though, but you should know how to do Gaussian Elimination to find $LU$, with a possible $P$.)

We saw a block-matrix multiplication method to find the Cholesky decomposition. It starts with

$$~
A = \left[
\begin{array}{cc}
a_{11} & w^T\\
w & K
\end{array}
\right],
\quad
L_1 = \left[
\begin{array}{cc}
a_{11} & w^T\\
w & K
\end{array}
\right]
\quad\text{ and }

B_1= \left[
\begin{array}{cc}
I & 0^T\\
0 & K - \frac{ww^T}{a_{11}}
\end{array}
\right].
~$$

And then we have $A = L_1 B_1 L_1^T$, and we can repeat the work on $B_1$ to get a decomposition.

We had these theorems:

> If all $n$ leading principal minors of $A$ are non-singular, then $A$ has an $LU$ decomposition (without pivoting).

>If $A$ is real, symmetric and positive definite then it has a unique (Cholesky) factorization $A=LL^T$ and $L$ has a positive diagonal.

## 4.3 Gaussian Elimination

The Gaussian Elimination process produces a matrix $U$, possibly with row swaps, and if one counts the row multipliers appropriately, a matrix $L$, where $LU=PA$, $P$ being a permutation matrix.

The decomposition is not unique. In addition to having degrees of freedom to pick the diagonal values of $L$ and $U$, it depends on  the choice of pivot row. We discussed briefly three pivot types:

* partial pivot
* scaled pivot
* complete pivoting

you should know the partial pivoting, where the largest magnitude entry of $a_{li}$, in column $i$, after removing the previously chosen $i-1$ rows is taken to be the pivot row. This choice ensures the values $\lambda_i$ are all bounded by 1 in magnitude, so $L$ will be unit triangular with dominant diagonal.

One compelling reason to choose to solve $Ax=b$ via solving $LUx=b$ is that it takes fewer steps than solving $x = A^{-1}b$. The following theorem allows us to count:

> Theorem 4 (p176) on Long Operations: To solve $Ax=b$ for $m$ vectors $b$ where $A$ is $n\times n$ involves approximately this many `ops`:

$$~
\frac{n^3}{3} + (\frac{1}{2} + m) n^2.
~$$

## Section 4.4

Section 4.4 introduces the concept of a norm. This makes talking about convergence possible, as it gives  a sense of size.

We saw that a norm on a vector space was a function satisfying three properties:

* $\| x \| = 0$ implies $x=0$;
* $\| \lambda x \| = |\lambda| \cdot \| x \|$;
* $\| x + y \| \leq \|x \| + \| y \|$.

There main vector norms a indexed: $l_1$, $l_2$, and $l_\infty$. For $p \geq 1$, we have also

$$~
\| x \|_p = (|x_1|^p +|x_2|^p +|x_3|^p +\cdots + |x_n|^p)^{1/p}.
~$$

The induced matrix norm is a norm on the set of matrices that is derived from a norm on vectors. It is specified by:

$$~
\| A \|_p = \text{The largest value of } \{\|Ax\|_p: \|x \|_p = 1\}.
~$$

We commented that when $p=2$, this is related to the singular values of $A$, which are the eigen values of $A^TA$.

When $p=\infty$, the $\| \cdot \|_{\infty}$ norm is related to largest of the $l_1$ norms of the **row** vectors of $A$.


A useful inequality of matrix norms is $\| A B \| \leq \| A \| \cdot \| B \|$, Similarly, $\|Ax\| \leq \| A \| \cdot \| x \|$. These are true for the matrix norm induced by the vector norm.

The use of norms make it possible to prove this inequality on the relative errors of solving $Ax=b$ when there is an error in finding $b$:

$$~
\frac{\| x - \tilde{x} \|}{\|x\|} \leq \kappa(A) \cdot \frac{\| b - \tilde{b} \|}{\|b\|}.
~$$

The condition number is $\kappa(A) = \| A \| \cdot \|A^{-1}\|$. It depends on the  norm used.


## Iterative schemes

We spoke about a few iterative schemes. The first is used to "polish" approximate answers. It goes like:

Suppose we have an approximate answer $x^{(0)}$ to $Ax=b$. Then we get the residual is

$$~
r^{(0)} = b - A x^{(0)}
~$$

And from here we solve the error from $A e^{(0)} = r^{(0)}$. And finally, we get

$$~
x^{(1)} = x^{(0)} + e^{(0)}.
~$$

I everything is exact, then this is the answer, but if there is some loss in solving, then it is an improved answer. In that case the process can be repeated.

This can be made concrete by assuming we have an approximate inverse to $A$, called $B$. Then when solving $Ae^{(0)} = r^{(0})$ by multiplying by $B$, we lose some information. In that case, the value of $x^{(1)}$ satisfies:

$$~
r^{(0)} = b - A x^{(0)}; \quad e^{(0)} = B r^{(0)}; \quad x^{(1)} =x^{(0)} + e^{(0)}
~$$

And in general, the value of $x^{(m)}$ satisfies:

$$~
x^{(m)} = B \sum_{k=0}^m (I - AB)^k b.
~$$

The sum on the right is convergent if $\|I - AB \| < 1$ and so $x^{(m)}$ will converge.

This requires knowing that when $\|A\|<1$, then $I-A$ is invertible and can be written as a Neumann sum.


### Other convergent algorithms.

If we have a *splitting matrix* $Q$, then we can form the equation $Qx = Qx - Ax + b$. Which suggests an iterative scheme of the type:

$$~
Q x^{(k+1)} = (Q- A)x^{(k)} + b.
~$$

For various choices of $Q$ this will converge:

* $Q=I$ -- Richardson method
* $Q=diag(A)$ -- Jacobi iteration
* $Q = tril(A)$ -- Gauss-Seidel.

As long as $\| I - Q^{-1}A \| < 1$ for some subordinate norm, this sequence will converge.

More generally, if the iterative scheme is

$$~
x^{(k+1)} = Gx^{(k)} + c
~$$

then this will converge if the magnitude of the largest eigenvalue is less than 1.


### Some sample problems

* Show that the product of lower triangular matrices is lower triangular using the characacteriaztion that $L$ is LT if $l_{ij}=0$ when $j > i$ (the column index is bigger than the row one).



* Solve for $x$ in $Ax=b$, when

$$~
A = \left[
\begin{array}{ccc}
1 & 0 & 0\\
2 & 3 & 0\\
4 & 5 & 6
\end{array}
\right],
\quad
b = [7,8,9]^T
~$$




* Decompose $A$ as a product of $L\cdot U$ using Gaussian Elimination when $A$ is

$$~
A = \left[
\begin{array}{ccc}
2 & 0 & -8\\
-4 & -1 & 0\\
7 & 4 & -5
\end{array}
\right].
~$$

Did you need to use a permutation matrix?

Use your answer to solve $Ax=[1,2,3]^T$.

* Prove or disprove: If $L$ and $U$ are lower and upper triangular, then $UL$ can not be upper triangular.

* A symmetric, positive-definite matrix satisfies the inequality: $|a_{ij}|^2 \leq a_{ii} a_{jj}|$ Verify if this is the case for the symmetric matrix

$$~
A = \left[
\begin{array}{cc}
1 & 2\\
2 & 1
\end{array}
\right]
~$$

Does $A$ have a Cholesky decomposition?

* for the matrix

```
using SymPy
A = [ Sym(4) 1 2; 1 2 3; 2 1 2]
```

The LU decomposition is given by:

```
L, U, p = lu(A)
```

From this, we have inverses:

```
inv(L)
```

and

```
inv(U)
```

Show that we can find $A^{-1}$ using these two matrices. What is the value?

* Find $\| A\|_\infty$ when $A$ is the matrix


$$~
A = \left[
\begin{array}{ccc}
2 & 0 & -8\\
-4 & -1 & 0\\
7 & 4 & -5
\end{array}
\right].
~$$


* Find the condition number of $A$ using the $l_\infty$ norm when $A$ is the matrix:

$$~
A = \left[
\begin{array}{ccc}
1 & 0 & 0\\
2 & 3 & 0\\
4 & 5 & 6
\end{array}
\right].
~$$


* Suppose we write $A = Q + B$ where $Q$ is invertible. Then the expression $Qx^{(k+1}) = (Q- A)x^{(k)} + b$ can be rewritten as

$$~
x^{(k+1)} = Q^{-1} B x^{(k)} + Q^{-1}b.
~$$

This is of the general form $x^{(k+1)} = Gx^{(k)} + c$. Using the criteria that the spectral radius of $G$ must be less than 1, how does this translate to a condition on $Q$ and $B$ that will ensure convergence?

* Define the matrix $A$ and vector $b$ by

```
A = [1 2; 3 4]
```

and

```
b = [1,2]
```

A guess at an answer is $x^{(0)} = [-1/4, 1/4]$. Compute the residual value $r^{(0)} = b - Ax^{(0)}$. The error $e^{(0)}$ satisfies $Ae^{(0)} = r^{(0))}$. Find $e^{(0)}$.


* Let the matrix $A$ be given by:

```
A = [1 1/2; 1/3 1/4]
```

The Jacobi method takes $Q$ to be the diagonal of $Q$. Is it guaranteed to converge for some $b$? (Use the $\|\cdot \|_\infty$ norm.)

You might be interested in this computation:

```
Q = diagm(diag(A)) # [1 0; 0 1/4]
I - inv(Q) * A
```

* Prove that is $A$ is invertible and $\| B - A\| < \|A^{-1}\|^{-1}$ then $B$ is invertible.

* Prove that if $A$ is invertible, $(A^{-1})^T = (A^T)^{-1}$.

* Suppose $A$ is invertible. Show that there exists an $\epsilon > 0$ such that any $B$ satisfying $\|A - B\| < \
