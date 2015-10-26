# LU Factorization

Return to the task of solving a system of equations:

$$~
\begin{align}
a_{11} x_1 + a_{12}x_2 + \cdots a_{1n} x_n &= b_1\\
a_{21} x_1 + a_{22}x_2 + \cdots a_{2n} x_n &= b_2\\
&\vdots\\
a_{m1} x_1 + a_{m2}x_2 + \cdots a_{mn} x_n &= b_m
\end{align}
~$$


Which we wrote as $Ax=b$.

## Easy to solve systems

If we have equations resulting in $A$ being a diagonal matrix, then we have basically:

$$~
\begin{align}
a_{11}x_1 &= b_1\\
a_{22}x_2 &= b_2\\
& \vdots\\
a_{nn}x_n &= b_n
\end{align}
~$$

This has *easy* solutions, namely. If $a_{ii} \neq 0$, then $x_i = b_i/a_{ii}$.

If an $a_{ii} = 0$, then the determinant of $A$ is $0$, and there is not a unique solution.

### Lower triangular matrices

If $A$ is *lower triangular*, that is ($a_{ij} = 0$ if $j > i$) or:

$$~
A = \left(
\begin{array}{cccc}
a_{11} & 0 & \cdots & 0\\
a_{21} & a_{22} & \cdots & 0\\
 & \vdots &  & \\
a_{m1} & a_{m2} & \cdots & a_{mn}\\
\end{array}
\right)
~$$

Then we can solve recursively

* First, we solve $a_{11} x_1 = b_1$ with $x_1 = b_1 / a_{11}$.
* Next we solve $a_{21}x_1 + a_{22}x_2 = b_2$ by first subsititution in for our just-solved $x_1$, and then solving:

$$~
a_{21}x_1 + a_{22}x_2 = b_2
~$$

$$~
a_{21} ( b_1 / a_{11})+ a_{22}x_2 = b_2
~$$

$$~
x_2 = (b_2 - a_{21}(b_1/a_{11})) / a_{22}
~$$

* repeat. In general we have

$$~
x_i = (b_i - \sum_{j=1}^{i-1} a_{ij} x_j) \cdot \frac{1}{a_{ii}}
~$$

It is important that we have $a_{ii} \neq 0$, as otherwise we will have issues dividing. But this will be the case if $det(A) \neq 0$. (Why?)

This method is called *forward substitution*

### Upper triangular matrices

A matrix $U$ is *upper triangular* if $u_{ij} = 0$ if $i < j$. For example:

$$~
A = \left(
\begin{array}{cccc}
a_{11} & a_{12} & \cdots & a_{1, n-1} & a_{1n}\\
0 & a_{22} & \cdots & a_{2,n-1} &a_{2n}\\
&&\vdots&&\\
0 & 0 &\cdots & a_{n-1,n-1} & a_{n-1,n}\\
0 & 0 &\cdots & 0 & a_{nn}\\
\end{array}
\right)
~$$

Then solving $Ax=b$ can be done by working *backwards*:

$$~
x_n = b_n / a_{nn}
~$$

and from here:

$$~
x_{n-1} = (b_{n-1} - a_{n-1, n}x_n)/a_{n-1, n-1} = (b_{n-1} - a_{n-1, n}) \cdot b_n / a_{nn}/a_{n-1, n-1}
~$$

And in general

$$~
x_i = (b_i - \sum_{j=i+1}^n a_{ij} x_j) / a_{ii}.
~$$

Again, we need $a_{ii} = 0$.

## Permuted L or U matrices

Consider

$$~
A = \begin{array}{ccc}
1 & 2 & 3\\
0 & 0 & 4\\
0 & 5 & 6
\end{array}
~$$

Clearly if we permuted rows 2 and 3 this would be upper triangular, so we could solve easily by: first solving row 2, then use that to solve row 3 and then finally row 4.

Define $p = [p_1, p_2, \cdots, p_n]$,  to be a permutation vector if the mapping $i \rightarrow p_i$ maps the set $1, \dots, n$ to itself in a bijective manner *and* the matrix $(\alpha_{ij}) = (a_{p_i j})$ is either upper or lower triangular.


(In the above we would have $p_1 = 1, p_2 = 3$, and $p_3 = 2$.)

Then clearly we could solve the permuted system of equations. For example, in the case that we end up lower triangular, so that forward substitution works, we would have:

$$~
x_i = (b_{p_i} -  \sum_{j=1}^{i-1} a_{p_i j}) / a_{p_i i}.
~$$


## Why bother?

Suppose we knew that $A=LU$, then we can solve $Ax = b$ easily by:

* solve the  equatulation $Ly = b$ for $y$.
* But $y = Ux$, so we solve $Ux = y$ for $x$.

So if we can *factorize* $A = LU$, we can easily solve $Ax = b$.

### Example

In Julia (and MATLAB) there is a built in solver for these problems:

```
U = [1 2; 0 1]
```

```
b = [1, 3]
x = U \ b
```

```
U*x - b
```

In fact, there are many different methods depending on assumptions. For example, rationals:

```
U = [1//1 2; 0 1]
U \ b
```

There are special methods for many others...

## Can we find LU for a given A?


Suppose $A = LU$, then we have:

$$~
a_{ij} = l_{i1} u_{1j} + l_{i2} u_{2j} + \cdots l_{in} u_{nj}
~$$

But:

* lower triangular means $l_{ij} = 0$ if $j > i$

* upper triangular means $u_{ij} = 0$ is $j < i$.

So

$$~
a_{ij} = \sum_{s = 1}^{min(i, j)} l_{is} u_{sj}.
~$$


Now to prove we can find $LU = A$. We will do so by  induction. Suppose we know the first $k-1$ columns of $L$ and the first $k-1$ rows of $U$. We then have:

$$~
a_{kk} = \sum_{s=1}^{min(k,k)} \cdot = \sum_{s=1}^k \cdot = \sum_{s=1}^{k-1} l_{ks}u_{sk} + l_{kk} u_{kk}.
~$$

The first part of the right hand sum involves columns of $L$ for which $s < k$ and rows of $U$ or which $s < k$. So all values are known by our assumption. So if $l_{kk}$ is known (say assumed to 1 or some other non-zero value) we can solve for $u_{kk}$ in terms of known values. To be explicit:

$$~
u_kk = (a_kk - \sum_{s=1}^{k-1} l_{ks}u_{sk} ) / l_{kk}.
~$$

Then to fill out the $k$ row of $U$, we consider for $j > k$ (for which $min(j,k) = l$):

$$~
a_{kj} = \sum_{s=1}^{k-1} l_{ks} u_{sj} + l_{kk} u_{kj}
~$$

The sum is of known values and $l_{kk}$ is known, so for each $j$, as specified, we can solve for $u_{kj}$.

Similarly, for the $k$ column of $L$, we consider for $j > k$

$$~
a_{jk} = \sum_{s=1}^{k-1} l_{js} u_{sk} + l_{jk} u_{kk}
~$$

As before, the sum is known, and here, so is $u_{kk}$, so we can solve for $l_{jk}$ when $j > k$. That is we can fill in the $k$ column.

### Special cases

* If we always were to take $l_{ii} = 1$ we get Dolittle's factorization
* If we always were to take $u_{ii} = 1$ we get Crout's factorization
* If we take $u_{ii} = l_{ii}$ we get Cholesky's factorization.

### Example

Let's look at this matrix

```
A = [1 1 1; 1 2 2; 1 2 3]
```
 
We need to fill in $U$ and $L$. We start with a zeros:

```
L = zero(A)
U = zero(A)
```

Now we fill in: we have $1 = a_{11} = l_{11} u_{11}$ so we can take each to be 1:

```
L[1,1] = 1
U[1,1] = 1
```

Then for $U$ we need to fill in $u_{12}$ and $u_{23}$. For these we have

$$~
a_{12} = 1 = (0) +  l_{11} u_{12} = 1 u_{12}, \quad
a_{13} = 1 = (0) + l_{11} u_{13} = 1 u_{13}
~$$

So both are 1:

```
U[1,2] = 1
U[1,3] = 1
```

And for the first row of $L$ we have:

$$~
a_{21} = 1 = (0) + l_{21}u_{11} = l_{21}, \quad
a_{31} = 1 = (0) + l_{31}u_{11} = l_{31}
~$$

So ditto:

```
L[2,1] = 1
L[3,1] = 1
```

Moving on to $k=2$ gives first the diagonal terms:

$$~
a_{22} = (l_{21} u_{12}) + l_{22} u_{22}, \quad\text{or}
2 = (1 \cdot 1) + l_{22} u_{22}
~$$

We can take both to be $1$:

```
L[2,2] = 1
U[2,2] = 1
```

And to fill in for $j > 2$:

$$~
a_{23} = 2 = (l_{21} u_{13}) + l_{22}u_{23} = (1\cdot 1) + 1 u_{23},
~$$

So $u_{23} = 1$

```
U[2,3] = 1
```

And from

$$~
a_{32} = 2 = (l_{31} u_{12}) + l_{32} u_{22} = (1 \cdot 1) + l_{32} \cdot 1
~$$

So $l_{32} = 1$:

```
L[3,2] = 1
```

Finally, we need to find the last diagonal terms:

$$~
a_{33} = 3 = (l_{31}u_{13} + l_{32}u_{23}) + l_{33} u_{33} = (1\cdot 1 + 1\cdot 1) +  l_{33} u_{33}
~$$

So we can take each to be $1$:

```
L[3,3] = 1
U[3,3] = 1
```

```
L
```

and

```
U
```

And we verify:

```
A - L*U
```

### Optimized versions

There are built in functions for these:

```
L, U, p =  lu(A)
```

We already verified that $LU = A$ for this $A$. The `p` is a permulation vector. In general, we should verify

```
A[p,:]  -  L * U
```

## When do we know this will work?

Define the $k$th leading principal minor of $A$ to be the submatrix $a_{ij}$ for $1 \leq i,j \leq k$. Call this $A_k$.

> Thm: If $A$ is $n \times n$ and all $n$ leading principle minors are non-singular, then $A$ has an LU decomposition

Proof. Suppose by induction this is true for step $k-1$. The we have $A_{k-1}$ can be factored: $A_{k-1} = L_{k-1} U_{k-1}$.

We wish to find $L_k$ and $U_k$ which are extensions and satisfy $A_k = L_k U_k$.

Consider the case $1 \leq i \leq k-1$ and

$$~
a_{ik} = \sum_{s = 1}^{k-1} l_{is}u_{sk}
~$$

We know the $a_{ik}$, the $l$'s involved are from $L_{k-1}$. The $u$'s we don't know (yet), but as $L_{k-1}$ is non-singular we can solve for the $u$s and this is just of the form $b = L_{k-1} x$. So we can fill out the value of $U_k$.

Similarly, for $1 \leq j \leq k-1$ we have:

$$~
a_{kj} = \sum_{s=1}^{k-1} l_{ks} u_{sj}
~$$

This is of the form $b = U_{k-1} x$ so can be solved to fill out the value of $L_k$.

FInally, we need to solve for $l_{kk}$ and $u_{kk}$, but we have:

$$~
a_{kk} = \sum_s^{k-1} l_{ks} u_{sk} + l_{kk}u_{kk}
~$$

If the value of $l_{kk} = 1$, then $u_{kk}$ can be solved as the sum is now known. That is, we can fill out $L_k$ and $U_k$ with
$A_k = L_k U_k$, as desired.

## Cholesky factorization

We know the transpose of a lower triangular matrix is upper and vice versa. This gives hope to a factorization of the form $A = L L^T$, known as the Cholesky factorization. When is this possible?

> Thm: If $A$ is real, symmetric and positive definite then it has a unque factorization $A=LL^T$ and $L$ has a positive diagonal.

Pf: We must have $Ax=0$ has only a solution $x=0$, as positive definite means $x^T A x > 0$ for non-zero $x$. By considering vectors of the form $x = [x_1 x_2 \cdot x_k 0 0 \cdots 0]$ we can see that $A_k$ will also be non-singular.

So by the last theorem $A= LU$ for some $l$ and $U$. But $A^T = A$ so $LU = (LU)^T = U^T L^T$. Multiplying on the right and left as follows gives

$$~
\begin{align}
L^{-1} (L U) (L^T)^{-1} &=L^{-1} U^T L^T (L^T)^{-1}\\
U (L^T)^{-1} &= L^{-1} U^T.
\end{align}
~$$

The left side is upper triangular, the right side lower triangular, hence the must be a diagonal matrix $D$:
$D = U (L^T)^{-1}$ and so  $L D = (LU)(L^T)^{-1} = A(L^T)^{-1}$, giving $A = L D L^T$.

If we can show that $D$ has all positive diagonal terms, then we can define $D^{1/2}$ by $(\sqrt{d_{ii}})$ and express $A$ as $(LD^{1/2}) (LD^{1/2})^T$ which is what we want.

So, why do we know $D$ has all positive diagonal terms? Because $D$ is positive definite:

Take $x$ and then:

$$~
\begin{align}
x^T D x &= x^T (L^{-1}) A (L^T)^{-1} x\\
&= (x^T L^{-1}) A ((L^T)^{-1} x)\\
&= ((L^{-1})^Tx)^T A ((L^T)^{-1}x)\\
&= ((L^{-1})^Tx)^T A ((L^{-1})^{t}x)
&> 0.
\end{align}
~$$

The last line as $A$ is positive definite and $(L^{-1})^Tx$ is non-zero. The fact we can swap out the inverse and transpose of a matrix is something to prove.

## Example

This comes from statistics. Consider the *overdetermined* system:

```
A = [1 2; 3 5; 4 7; 1 8]
```

```
b = [1,2,3,4]
```

The system $Ax=b$ has no solutions. However, this system will:

$$~
(A^T A) x = A^T b
~$$

(Assuming $A^TA$ is non-singular, we have it is symmetric and positive definite.)

```
M = A' *A
```

So we can take the cholesky decomposition:


```
L = chol(M)'   # default answer is upper triangular
```

So we can solve $LL^Tx = A^T b$. First we solve for $y$ in $Ly=A^Tb$ with:

```
y = L \ (A'*b)
```

And then solve $L^Tx = y$:

```
x = L' \ y
```

This answer is not the "answer" (as that doesn't exist):

```
A*x - b
```

However, it has a property: it is the `x` with the smallest difference:

```
norm(A*x - b)
```

```
sort([norm(A*rand(2) - b) for _ in 1:10])
```


### Why?

(P279) Suppose $Ax=b$ has $A$ being $m \times n$ with $m > n$ and $rank(A) = n$. Then, this will typically have no solutions. In that case, what is sought is a best solution in the sense of minimizing $\| b - Ax \|_2$.

Now suppose $x$ solves $A^TAx=A^Tb$, and $y$ is some other value, then

$$~
\begin{align}
\|b - Ay\|_2^2 &= \|b - Ax + A(x-y)\|_2^2\\
&= (b - Ax + A(x-y))^T \cdot  (b - Ax + A(x-y))\\
&= (b - Ax)^T\cdot (b-Ax) + (b-Ax)^T\cdot (A(x-y)) + (A(x-y))^T \cdot (b-Ax) + (A(x-y)^T) \cdot (A(x-y))\\
&= \| b - Ax \|_2^2 + \|A(x-y)\|_2^2 + 0
&\geq  \| b - Ax \|_2^2
\end{align}
~$$

The latter because, $Ax-b$ has a $0$ dot product with vectors in the column space of $A$ (as $A^T(Ax-b)=0$. But $A(x-y)$ is in the column space of $A$. (Any $Az = [A_{\cdot 1} ; A_{\cdot 2} ; \cdots ; A_{\cdot n}] \cdot z = z_1A_{\cdot 1} + z_2A_{\cdot 2} + \cdots + z_n A_{\cdot n}$.) So, the cross terms are 0 and the result holds.
