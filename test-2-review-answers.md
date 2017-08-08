# Review for test 2, some answers
### some sample problems of Ch 3

* Will the bisection method find the zero of $(x-1)^2$?

> No. The functions does not cross 0

* Will Newton's method find the zero of $(x-1)^2$?

> Yes, but the proofs of this we saw assume simple zeros, which $r=1$ is not.

* In what ways does the function $f(x) = x^{20} - 1$ challenge the convergence of Newton's method?

> Even though starting at $x_0 > 0$ is guaranteed to converge, the bound on convergence is quite large when the second derivative is large (which happens for $x_n >> 1$. And when $f'$ is close to zero which happens when $x_0$ is less than 1.

* Why do you know that using Newton's method on the function $f(x) = e^x + x$ will be guaranteed to converge?

> We know if both $f'$ and $f''$ are positive, there will be convergence.

* Let $f(x) = \sin(x)$. Starting with the $x_0, x_1 = 3, 4$, perform 2 steps of the secant method (find $x_2, x_3$). How accurate is your value ($f(x_3) - \pi$)?


> Let's see on the computer:

```
f(x) = sin(x)
appfp(x,y) = (f(y) - f(x))/(y-x)
x0,x1 = 3//1 , 4//1
x2 = x1 - f(x1)/appfp(x1, x0)
x3 = x2 - f(x2)/appfp(x2, x1)
x0, x1, x2, x3
```

We have this error

```
err = x3 - pi
```


* The *efficiency index* is defined by $\mu^{1/f}$ where $\mu$ is the order of convergence of a method and $f$ is the number of function calls per step. For Newton, these values are $2$ and $2$ and for the secant method $(1 + \sqrt{5})/2$ and $1$. Which method has a bigger efficiency index?

> We need to compare:

```
## netwon
mu_n=2; steps_n = 2
## secant
mu_s = (1+sqrt(5))/2; steps_s = 1
mu_n^(1/steps_n), mu_s^(1/steps_s)
```

* Let $e_n = x_n -r$, Taylor's theorem gives

$$~
f(x_n) = f(r) + f'(r)e_n + (1/2) f''(r) e_n^2 + \mathcal{O}(e_n^3)
~$$

Divide this by $e_n$, then use for both the case $n$ and $n-1$. Use these pieces to identify the limit as $n$ goes to $\infty$ of

$$~
\frac{f(x_n)/e_n - f(x_{n-1})/e_{n-1}}{x_n - x_{n-1}}.
~$$

> We did this in class. It is also in the book in the estimate for the error in the secant method. The limit is $1/2 f''(r)$.

* Let $F(x) = x/2 + f(x)$ where we assume $|f'(x)| \leq 1/4$. Show that $F(x)$ is a contractive map.

> We showed this in class:

$$~
|F(x) - F(y)| \leq |x/2 - y/2 + f(x) - f(y)| \leq |x/2 - y/2| + |f(x) - f(y)| =
(1/2)|x-y| + |f'(\xi)||x-y| \leq (1/2 + 1/4) |x-y|.
~$$

* Let $F(x) = x/2 + f(x)$ where we assume $|f'(x)| \leq 1/4$. What is the order of convergence of the iterative mapping: $x_{n+1} = F(x_n)$?

> We showed in class that $F^1(s) \neq 0$, so the order is linear.

$$~
F'(x) = (x/2 0 f(x))' = 1/2+ f'(x) \geq 1/2 - 1/4 = 1/4 > 0.
~$$

So in particular, for a fixed point $x$, $F'(s) > 0$.

* Let $p>0$. What is the value of this expression:

$$~
\sqrt{p + \sqrt{p + \sqrt{p + \cdots}}}
~$$

(As the book says, this is $x_{n+1} = \sqrt{p + x_n}$.)

> We saw in class for $p > 0$, this will be when the graph of the  function $F(x) = \sqrt{p + x}$ intersects the graph of the equations $y=x$, that is a solution to $x = \sqrt{p + x}$. We solved this using the quadratic equation.







### Some sample problems of Chapter 4

* Show that the product of lower triangular matrices is lower triangular using the characacteriaztion that $L$ is LT if $l_{ij}=0$ when $j > i$ (the column index is bigger than the row one).


> Say $A=LM$ where both $L$ and $M$ are lower triangular. We need to show if $j > i$, that $a_{ij} = 0$. But

$$~
a_{ij} = \sum l_{ik} m_{kj}
~$$

For $k>i$ we have $l_{ik}=0$ and for $k < j$ $m_{kj} = 0$. But, as $j > i$, this means for any $k$ the product will be zero and hence the sum of the products will be.

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

We solve by forward substitution:

```
x1 = 7/1                        # 1 x1 = 7
x2 = (8 - 2x1)/3            # 2x1 + 3x2 = 8
x3 = (9 - 4x1 - 5x2)/6  # 4x1 + 5x2 + 6x3 = 9
[x1,x2,x3]
```


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

> We solved this in class with parital pivoting. It got a bit messier that way. Here we solve without pivoting:

```
Aorig = [2//1 0 -8; -4 -1 0; 7 4 -5]
A = copy(Aorig)
L = diagm([1//1,1,1])
L[2,1] = A[2,1]/A[1,1]
A[2,:] = A[2,:] - L[2,1]*A[1,:]
L[3,1] = A[3,1] / A[1,1]
A[3,:] = A[3,:] - L[3,1]*A[1,:]
L[3,2] = A[3,2] / A[2,2]
A[3,:] = A[3,:] - L[3,2] * A[2,:]
U = A
L, U, Aorig - L*U
```




Use your answer to solve $Ax=[1,2,3]^T$.

> We solve $Ly=b$ and then $Ux = y$. First:

```
b = [1,2,3]
y = L \ b
```

And then

```
x = U \ b
```

By hand, we need to do forward substitution to solve for $y$ and back substitution to solve for $x$.

* Prove or disprove: If $L$ and $U$ are lower and upper triangular, then $UL$ can not be upper triangular.

> This is not true in general. Just take $L=I$, then $UL=U$ is upper triangular.

* A symmetric, positive-definite matrix satisfies the inequality: $|a_{ij}|^2 \leq a_{ii} a_{jj}|$ Verify if this is the case for the symmetric matrix

$$~
A = \left[
\begin{array}{cc}
1 & 2\\
2 & 1
\end{array}
\right]
~$$

> This not the case. Take $i=2, j=1$, then $a_{ij} = 2$ and $a_{22} a_{11} = 1 \cdot 1 = 1$.

Does $A$ have a Cholesky decomposition?

> No, the matrix is not symmetric positive definite.

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

> We have $A^{-1} = (LU)^{-1} = U^{-1} A^{-1}$ so we need to multiply:

```
inv(U) * inv(L)
```


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


> This is the larger of 10, 5, and 16. So is 16.

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


> For this we have to find $\|A\| \cdot \| A^{-1} \|$. We can tell that $\|A\|$ is the larger of $1$, $5$ or $15$, so is $15$. We have

```
A = [Sym(1) 0 0; 2 3 0; 4 5 6]
inv(A)
```

So the norm of $A^{-1}$ is the larger of 1, 1, or 5/9. So is $1$. Hence $\kappa(A, \infty) = 15 \cdot 1 = 15$.

* Suppose we write $A = Q + B$ where $Q$ is invertible. Then the expression $Qx^{(k+1}) = (Q- A)x^{(k)} + b$ can be rewritten as

$$~
x^{(k+1)} = Q^{-1} B x^{(k)} + Q^{-1}b.
~$$

This is of the general form $x^{(k+1)} = Gx^{(k)} + c$. Using the criteria that the spectral radius of $G$ must be less than 1, how does this translate to a condition on $Q$ and $B$ that will ensure convergence?

> We did this in class

* Define the matrix $A$ and vector $b$ by

```
A = [1 2; 3 4]
```

and

```
b = [1,2]
```

A guess at an answer is $x^{(0)} = [-1/4, 1/4]$. Compute the residual value $r^{(0)} = b - Ax^{(0)}$. The error $e^{(0)}$ satisfies $Ae^{(0)} = r^{(0))}$. Find $e^{(0)}$.


> We can compute this directly:

```
x0 = [-1/4, 1/4]
r0 = b - A*x0
```

And solving for e0 can be done by

```
A \ r0
```


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

> We have that convergence is guaranteed if $\|I - Q^{-1} A \| < 1$, which we see.

* Prove that is $A$ is invertible and $\| B - A\| < \|A^{-1}\|^{-1}$ then $B$ is invertible.

> This is done if we can show $\| I - A^{-1} B\| < 1$. But:

$$~
\| I - A^{-1} B\|  = \| A^{-1}A - A^{-1} B\| = \|A^{-1} (A-B)\| \leq \|A^{-1}\| \cdot \|A-B\| < \|A^{-1}\| \cdot \|A^{-1}\|^{-1}.
~$$

* Prove that if $A$ is invertible, $(A^{-1})^T = (A^T)^{-1}$.

> We show that $(A^{-1})^T$ is a right inverse and hence an inverse of $A^T$ using the fact $(MN)^T = N^TM^T$.

$$~
A^T \cdot (A^{-1})^T = (A^{-1} A)^T = IT = I.
~$$



* Suppose $A$ is invertible. Show that there exists an $\epsilon > 0$ such that any $B$ satisfying $\|A - B\| < \

> We pick $\epsilon$ to be $(1 - \|I - A\|)/2$ where we know $\|I-A\| < 1$, as $A$ is invertible. Then:

$$~
\| I - B \| = \| I - A + A - B\| \leq \|I - A\| + \|A-B\| \leq 1
~$$
