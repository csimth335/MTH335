# linear algebra review

## systems of equations and matrices

In Chapter 3 our problem was methods to solve $f(x) = 0$ where $f:R \rightarrow R$.
Of course, this also handles problems of the type $f(x) = g(x)$ and $f(x) = b$.

In Chapter 4 we begin with **linear** systems of equations:

$$~
\begin{align}
a_{11} x_1 + a_{12}x_2 + \cdots a_{1n} x_n &= b_1\\
a_{21} x_1 + a_{22}x_2 + \cdots a_{2n} x_n &= b_2\\
&\vdots\\
a_{m1} x_1 + a_{m2}x_2 + \cdots a_{mn} x_n &= b_m
\end{align}
~$$

A solution is a set of values $x_1, x_2, \dots, x_n$ so that each equation is true simultaneously.

### Matrix

We see three sets of numbers: the $a$s, the $b$s and the $x$s. We represent these as matrices:

$$~
A = \left(
\begin{array}{cccc}
a_{11} & a_{12} & \cdots & a_{1n}\\
a_{21} & a_{22} & \cdots & a_{2n}\\
 & \vdots &  & \\
a_{m1} & a_{m2} & \cdots & a_{mn}\\
\end{array}
\right)
~$$


$$~
x = \left(
\begin{array}{c}
x_1\\
x_2\\
\vdots\\
x_n
\end{array}
\right)
~$$

$$~
b = \left(
\begin{array}{c}
b_1\\
b_2\\
\vdots\\
b_n
\end{array}
\right)
~$$

### Why?

This is because matrices have their own, nearly familar, algebra that allows us to represent the system of equations in terms of an equation:

$$~
Ax = b.
~$$

Here are two main problems in linear algebra that repeat themselves all the time:

* Solve for $x$ in $Ax = b$. Also, somewhat related, if $Ax = b$ has no solutions, can we find "best" solutions?

* Solve for the $\lambda$ for which $Ax = \lambda x$ has non zero solutions




## Example:

Consider the system of equations is

$$~
\begin{align}
1x_{11} + 2x_{12} + 3x_{13} &= 4\\
5x_{21} + 6x_{22} + 7x_{23} &= 8\\
9x_{31} + 10x_{32} + 11x_{33} &= 12
\end{align}
~$$

Then we can do the following:

```
A = [1 2 3; 5 6 7; 9 10 11]
b = [4,8,12]
A
```

and

```
b
```

To put in *variables* we can use symbolic math:

```
using SymPy
x = [symbols("x$i") for i in 1:3]
```

And from here:

```
A*x - b
```



### Notation

We saw $A$ has $m$ rows and $n$ columns.

Here we can view $x$ and $b$ as *vectors* or as matrices with 1 column. This is an identification, they are not mathematically the same thing.


#### A matrix is a vector! A vector is not a matrix!

A basic matrix in `Julia` is stored in contigous memory, so has an order. Here we can see what it is  by looking at the first 4 elements

```
A[1:4]
```

A vector on the other hand is not stored as a matrix in this sense:

```
isa(b, Matrix)
```

This is because `b` has only 1 dimension, a matrix has two. This is different from the "row vector" and "column vector""

```
A[1,:]
```


```
A[:, 1:1]
```

But note this is similar  -- but different. How?

```
A[:,1]
```


### +, -, *,/

We can add and subtract matrices of the same size. The result is a matrix $(a_{ij} - b_{ij})$.

```
A = [1 2 3; 4 5 6; 7 8 9]
B = [1 4 7; 2 5 8; 3 6 9]
A
```

and

```
B
```

And here we have:

```
A-B
```

```
B-A
```

#### Multiplication

Multiplication is possible for matrices, but the size constraint is different: $A B$ is defined if the number of columns of $A$ matches the number of rows of $B$. That is if $A$ is $m \times n$ then $B$ must be $n \times p$ for some $m$ and $p$.

The defintion is $(AB)_{ij} = a_{i1}b_{1j} + a_{i2}b_{2j} + \cdots + a_{in}b_{nj}$.

```
A * B
```

If we think of $A = [a_1; a_2; \cdots; a_m]$ as comprised of *row* vectors and $B = [b_1 b_2 \cdots b_p]$ as *column* vectors, then we have the $ij$ terms is the product $a_i \cdot b_j$. If we identify these row and column vectors as just vectors, this is the dot product.

```
A[1, :] * B[:, 2]
```

```
(A*B)[1, 2]
```

Though matrix multiplication is defined and uses the same notation as multiplication of numbers, it doesn't have two key properties:

* It is not -- in general -- commutative. That is $AB \neq BA$ except in special cases:

```
A*B - B*A
```

* There is no cancellation property. That is if $A\cdot B=0$ is need not be that $B$ or $A$ must be $0$.

```
C = [1 0 0;-2 0 0; 1 0 0]
```

So $C$ is non-zero, $A$ is non-zero, and yet:

```
A*C
```

#### Division

We don't have "division" defined for matrices. There are for some *square* matrices an analog, $A^{-1}$ for which $AA^{-1} = I$, the matrix with a one on the diagonal. This is sort of like $a \cdot (1/a) = 1$ when $a \neq 0$.

There is a built in function like division `\`. The expression `A \ b` will be a solution, `x` to `Ax =b`:

```
A * (A \ b)  # should be b = [1,2,3]
```

### The transpose
The transpose of the matrix $A=(a_{ij})_{1 \leq i \leq m, 1 \leq j \leq n}$ is found by swapping rows and columns:

$$~
A^T = (a_{ji})_{1 \leq i \leq m, 1 \leq j \leq n}
~$$

On the computer we see easily using `'` for transpose:

Here is $A$:

```
A
```

and its transpose

```
A'
```

The transpose is an *involution* -- meaning do it twice and you haven't changed anything:

```
(A')'
```

A matrix is *symmetric* if $A^T = A$. This means $A$ needs to be square and have symmetry along its main diagonal.

Our example `A` is *not* symmetric:

```
A' - A
```

However, in general $A^TA$ is symmetric:

```
B = A'*A
```

We could see visually, or confirm as follows

```
B' - B
```

## positive definite

A matrix $A$ is *positive definite* if for every nonzero vector $x$, $x^T A x > 0$.

The example in the book is

```
A = [2 1; 1 2]
```

For which $x^T A x = (x_1 + x_2)^2 + x_1^2 + x_2^2 > 0$ (if $x \neq 0$).


## Inverses

Let $I$ be an $n \times n$ *identify matrix*,  that is $I$ is all $0$s with $1$s on the diagonal:

Then$AI = A$ and  $IA = A$, if defined. For example:

$$~
(AI)_{ij}
= a_{i1} I_{1j} + \cdots+ a_{ij} I_{jj} + \cdots + a_{in} I_{nj}
= a_{i1} 0+ \cdots+ a_{ij} 1+ \cdots + a_{in} 0
= a_{ij}
~$$


Let $A$ be given (and $m \times n$) Then $B$ is a *right inverse* if $AB = I$.

> Thm: A *square* matrix, $A$, can possess at most one right inverse.

Proof: a linear algebra proof that rests on a fact: a linear combination of a *basis* producing $x$ is unique.

Suppose $B$ is an inverse. We aim to show $B$ is unique. The product

$$~
(AB)_{\cdot k} = \sum_l a_{\cdot l} b_{lk}
~$$

So if we look at the $k$th column vector of a matrix and write this as $A_{:k}$, then:

$$~
I_{:k} = \sum_l b_{lk}A_{:l}
~$$

So the $k$th column vector of $I$ is a linear combination of the column vectors of $A$. This means the columns of $A$ span the same space as the columns of $I$, which is $R^n$. So the columns of $A$ form a basis for $R^n$, ans so the values $b_{lk}$ are uniquely defined.

> Theorem: If $A$ and $B$ are square matrices, then a right inverse is a left inverse.

Suppose $B$ is a right inverse ($AB=I$). Then set $C = BA - I + B$ and note: $AC = ABA - AI + AB = A(BA) - A + I = I$, so $C=B$ and consequently $BA = I$ as well.

So, if a square matrix $A$ has a $n\times n$ right inverse it has a unique inverse and is called invertible. When it exists, the inverse is written $A^{-1}$.

### How to find an inverse?

We return to system of equations. There we know a few basic facts:

* we could interchange the order in how we define our equations and we would have the same answers
* we could replace one equation by its multiple by a **non**-zero constant and would still have the same answers
* we could replace one equation by adding another to it and not effect the solutions.

The latter is on the only tricky one. If we use $E'_i = E_i + E_j$ instead, do we get a difference?

Well, if our solutions solved $E_i$ and $E_j$, then it would also solve $E'_I$, as $0 + 0$ is still $0$. To get the reverse, for $E'_j = -E_j$ and add this to $E'_i$ to get $E''_i = E'_i + E'_j = E_i + E_j - E_j = E_i$ and so the original set of equations will have the same solutions if we replace $E_i$ as specified.

### Matrix equivalence

We have systems of linear equations lend them selves to matrices, so elementary operations lend themselves to matrix operations.

To illustrate:

```
A = [1 2 3; 4 5 6; 7 8 9]
```

We can switch rows 2 and 3 via let multiplication of the identity matrix with rows $2$ and $3$ swapped

```
[1 0 0; 0 0 1; 0 1 0] * A
```

We can multiply row 2 as follows:

```
[1 0 0; 0 pi 0; 0 0 1] * A
```

We can replace row $2$ with row $2$ plus row $3$ via:

```
[1 0 0; 0 1 0; 0 1 1] * A
```

If we think of these elementary operations in terms of left multiplication by an elementary matrix, we can write the transformed matrix as $E_m E_{m-1} \cdots E_2 E_1 A$.

> Thm: If $A$ is invertible, we can find $A^{-1}$ from a sequence of elementary row operations.

Idea: If we can find a sequence such that $E_m E_{m-1} \cdots E_2 E_1 A = I$, the $E_m E_{m-1} \cdots E_2 E_1 \cdot I = A^{-1}$. Why?

$$~
A^{-1}A = (E_m E_{m-1} \cdots E_2 E_1 \cdot I) A
= E_m E_{m-1} \cdots E_2 E_1 (I \cdot A)
= E_m E_{m-1} \cdots E_2 E_1 \cdot A
= I.
~$$


### Nonsingular matrix properties

For an $n \times n$ matrix $A$, all of these are equivalent:

* $A$ is nonsingular
* the *determinant* of $A$ is non-zero
* The rows of $A$ for a basis for $R^n$
* The columns of $A$ for a basis for $R^n$
* The equation $Ax=0$ is only satisfied by $x=0$.
* The equation $Ax=b$ has only one solution, $x$.
* A is a product of elementary matrices
* $0$ is not an eigenvalue of $A$.

## Block multiplication

Matrices can be partitioned into blocks. So for example:

```
B = [1 2; 3 4]
C = [5 6; 6 5]
O = [0 0; 0 0]
I = [1 0; 0 1]
A = [B C; O I]
```

Problem 7 has one show that $A^k$ is also a block matrix with Blocks $B^k$ and $(B^k-I)(B-I)^{-1}C$ to go with O and I. Let's see with k = 2:

We need $B-I$ to have an inverse. We check:

```
det(B-I)
```

Now let $k=3$, we have

```
k = 3
out = A^k
```

And now check the pieces:

```
out[1:2, 1:2] ==B^k
```

and

```
(B^k - I)* inv(B-I) * C == out[1:2, 3:4]
```
