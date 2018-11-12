# Norms and the analysis of errors

Consider the task of walking in New York City. We need to go 3 blocks over and 4 blocks up? How far do we need to walk?

* As the "crow flies" the answer is easy: $\sqrt{3^2 + 4^2}$.

* as you end up walking, the answer is easy: $3 + 4$

* if you need to know the farthest you go in any one direction, the answer is just the larger of $3$ and $4$.

The point is, you might answer "distance" in different manners.

## Vector norms

Let $V$ be a vector space.

Define a *norm*  as a function, $\| \cdot \|$, from $V$ to non-negative reals if it obeys:

* $\| x \| > 0$ if $x \neq 0$.

* $\| \lambda x\| = |\lambda| \| x\|$ for real $\lambda$ and $x \in V$.

* $\|x + y \| \leq \| x\| + \| y \|$. (The triangle inequality)

### Examples

The familiar Euclidean distance is a norm where

$$~
\| x \| = \sqrt{x_1^2 + x_2^2 + \cdots + x_n^2}.
~$$

We also have others:

* The city walking norm:

$$~
\| x \| = |x_1| + |x_2| + \cdots + |x_n|
~$$

* The max distance in any direction norm:

$$~
\| x\| = max_i |x_i|
~$$

In fact, for any $p \geq 1$, we can define the $p$-norm by:

$$~
\| x \|_p = (x_1^p + x_2^p + \cdots + x_n^p)^{1/p}.
~$$

With this, we have the $2$-norm, the $1$-norm and the limiting $\infty$-norm.

```
using LinearAlgebra
x = [1,2,3]
norm(x, 2)  # default so just norm(x) works too
```

```
norm(x, 1)
```

and

```
norm(x, Inf)
```

> It is customary to call these the $l_2$, $l_1$ and $l_\infty$ norms.

### The unit ball

With a  norm, we can define sets. Such as the set of points within a "distance" of $1$ of $x$. Call this the unit ball about $x$:

$$~
B_1(x) = \{ y : \| y - x\| \leq 1 \}
~$$

We could define this for any size $\delta$, and would use the notation $B_\delta(x)$ for that.

## Matrix norms

A norm is a general thing and can be defined for matrices and other objects. A special case of matrix norms are those induced by a vector norm.

If we consider all vectors $u$ with $\| u \| = 1$, then we can map these vectors under a matrix $A$ to a new set of vectors $Au$. How big are these? If we were to focus on the largest, we would consider

$$~
\sup \{ \| Au \|: u \in V, \| u\| = 1 \}.
~$$

This will vary depending on $A$ -- If $A$ is a rotation, the lengths won't change so we will get $1$ our. If $A$ is a dilation, then some vectors will get stretched, so this would typically be different from $1$.

Define the *matrix norm* induced by the vector norm $\| \cdot \|$ to be the value of this supremum:


$$~
\| A\| = \sup \{ \| Au \|: u \in V, \| u\| = 1 \}.
~$$

### This defines a norm

> Thm (p188) This matrix norm is a norm.

We have if $A$ is non-zero, then there is some $v$ with $Av \neq 0$ and if we consider $v/\|v\|$ some unit vector with $Av \neq 0$. Hence $\| A \| \geq \|Av\| > 0$>

If $\lambda$ is non zero, the since $\| \lambda v\| = |\lambda| \| v\|$, it will also be true that:

$$~
\{ \| \lambda Au \|: u \in V, \| u\| = 1 \} = \{ |\lambda|\| Au \|: u \in V, \| u\| = 1 \}
~$$

and so the $\lambda$ can come outside.

Finally, we consider the triangle inequality and show it is inherited. We need to consider two matrices (of the same size):

$$~
\begin{align}
\| A + B \|
&= \sup \{ \| (A+B)u \|: \|u \| = 1\}\\
&\leq \sup \{ \| Au \| + \|Bu \|: \|u \| = 1\}\\
&\leq \sup \{ \| Au \|  : \|u \| = 1\} + \sup \{ \| Bu \|  : \|u \| = 1\}\\
&\|A\| + \|B\|.
\end{align}
~$$

> Corollary:

$$~
\| Ax \| \leq \|A \| \cdot \| x\|.
~$$

> Corollary. If $A$ and $B$ are of the appropriate size, then

$$~
\| A B \| \leq \| A \| \cdot \| B\|.
~$$


(Why? For unit $x$ we have: $\| (AB)x\| = \|A (Bx)\| \leq \| A\| \cdot \| Bx\| \leq \|A\| \cdot \| B \| \cdot \|x \|$.)


### Can we identify these norms

> Thm. (p294) The norm induced by the $2$-norm is the largest singular value.

(A singular value is an eigen value of $A^T A$.)

> Thm. (p189) The norm induced by the $\infty$-norm is

$$~
\|A \|_\infty = \max_{1 \leq i \leq n} \sum_{j=1}^n | a_{ij}|
~$$

That is, take the $l_1$ norm for each row vector and find the largest value

> Thm. The $||A||_1$ norm is found by taking the $l_1$ norm of each column vector and finding the largest.

## Condition number

Consider $Ax=b$.

We wish to quantify when a matrix might give issues, beginning with two examples, the first when the matrix is slightly perturbed, the second when the target vector $b$ is.


### perturbed matrix

The inequalities $\| Ax\| \leq \|A\| \|x\|$ and $\|AB\| \leq \|A\| \|B\|$ are widely used. For example, Suppose we are considering $Ax=b$. One solution would be to form the inverse and write $x = A^{-1} b$. The compuation is not always possible though, so we might end up with $B \approx A^{-1}$. Then we have $\tilde{x} = Bb$. What can we say about how far apart $x$ and $\tilde{x}$ are?

$$~
\| x - \tilde{x} \| = \| x - Bb \| = \|x - BAx\| = \|(I - BA)x\| \leq \|I - BA\| \|x\|.
~$$

So the *relative error* is bounded by:

$$~
\frac{\| x - \tilde{x} \| } {\|x\|} \leq \|I - BA\|.
~$$


If the relative error is big for small pertubations, then the problem is unstable.

### perturbed target vector

Suppose $A$ is invertible and we wish to solve $Ax=b$, but instead have a perturbed value for $b$, $\tilde{b}$. (Which might happen solving via a $LU$ decomposition). Then we get values $x$ and $\tilde{x}$ which satisfy $Ax = b$ and $A\tilde{x} = \tilde{b}$. How close are the $x$'s?

$$~
\| x - \tilde{x}\| - \| A^{-1}b - A^{-1} \tilde{b}\| = \| A^{-1}(b-\tilde{b}) \| \leq
\| A^{-1}\| \|b - \tilde{b}\|.
~$$

To get a sense of the *relative error*, we continue by multiplying and dividing by $\|b\|$ on the right-hand side:

$$~
\| x - \tilde{x}\|  \leq
\| A^{-1}\| \|b\| \frac{ \|b - \tilde{b}\| }{\|b\|}
= \| A^{-1}\|  \cdot  \|Ax\| \cdot \frac{ \|b - \tilde{b}\|} {\|b\|}
\leq \| A^{-1}\| \cdot \|A\| \cdot  \|x\| \frac{ \|b - \tilde{b}\|}{\|b\|}.
~$$

Dividing by $\|x\|$ gives the relative error in $x$ is bounded by $\|A^{-1}\| \cdot \|A\|$ times the relative error in the $b$.

### Condition number

The *condition number* of a matrix is given by

$$~
\kappa(A) = \|A \| \cdot \|A^{-1}\|.
~$$


Example,

```
A = [1 1 1; 2 2 5; 4 6 8]
```

What is the condition number? For the $l_\infty$ norm, we have the row sums, $\sum_j |a_{ij}|$ are $3,9, 18$, so $18$ is $\|A\|_\infty$. We can show that $A^{-1} = (1/6) B$, where


```
B = [14 2 -3;  -4 -4 3; -4 2 0]
```

The largest row sum is $14 + 2 +3 = 19$. So the
$l_\infty$ norm of the inverse is $1/6 \cdot 19$. This gives a condition number of:

```
18 * 19 /6
```

Which we can check with

```
cond(A, Inf)
```

#### l_1 norm

Had we done the $l_1$ norm, we only need to take columns instead of rows. For that we see:

$$~
\|A\|_1 = 14, \quad \|A^{-1}\| = (1/6) \cdot (14 + 4 + 4), \quad \text{and } \kappa(A) = 14 \cdot22 /6 = 51~1/3.
~$$

This is confirmed by

```
cond(A, 1)
```

#### l_2 norm

Finally, we note that the $l_2$ norms for $A$ and $A^{-1}$ can be found with:

```
B = inv(A)
sqrt(maximum(eigvals(B'*B))) * sqrt(maximum(eigvals(A'*A)))
```

Which can be verified

```
cond(A, 2)
```

### Example, a matrix with a large condition number

Consider the matrix

$$~
A = \left[
\begin{array}{cc}
1 & 1 + \epsilon\\
1 - \epsilon & 1
\end{array}
\right].
$$~

As the book points out, this has inverse

$$~
A^{-1}= \frac{1}{\epsilon^2} \cdot
\left[
\begin{array}{cc}
1 & -1 - \epsilon\\
-1 + \epsilon & 1
\end{array}
\right].
$$~

For small $\epsilon>0$, we can read off the $l_\infty$ norms. We have $l_2(A) =2 + \epsilon$ and
$l_2(A^{-1}) = \epsilon^{-2} (2 + \epsilon)$. This means

$$~
\kappa(A) = \frac{(2+\epsilon)^2}{\epsilon^2} \approx 4 \epsilon^{-2}.
~$$

So for small $\epsilon$, this can be large.

```
ep = 1e-2
A = [1 1+ep; 1-ep 1]
cond(A, Inf)
```

####

To see an example, let $b = [3.02, 2.99]$ and $\tilde{b} = [3,3]$. The relative error is small

```
b = [3.02, 2.99]; bt = [3,3]
norm(b - bt, Inf)/norm(b, Inf)
```

But solving yields two values quite a distance apart

```
x, xt = A \ b, A \ bt
```

And these have a relative error of:

```
norm(x-xt, Inf) / norm(x, Inf)
```

Here a small change in $b$ led to a *large* change in determining $x$. Such a matrix is called **ill conditioned**.

## More notation

Suppose $Ax = b$ and $A\tilde{x} = \tilde{b}$. Define

* the *residual vector* $r = b - A\tilde{x} = b - \tilde{b}$.

* the *error vector* $e=x - \tilde{x}$.

Then we have this relationship between their norms, given the condition number:

$$~
\frac{1}{\kappa(A)} \frac{\|r\|}{\|b\|}
\leq
\frac{\|e\|}{\|b\|}
\leq
\kappa(A) \frac{\|r\|}{\|b\|}.
~$$
