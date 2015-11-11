# Neumann series and iterative methods

When we have a norm, $\| \cdot \|$, we can talk about *convergence* of a sequence of vectors, $v^k$ to a vector $v$ or convergence of matrices.

> Fact: For a finite dimensional vector space if $v^k$ converges to $v$ with one norm, it will with another.

Which is not the case on infinite dimensional spaces such as the space of functions.

## Example, iterations of a matrix $A$

Take $A$ to be a square matrix. Then we can form a series of matrices by

$$~
A^0, A^1, A^2, \dots, A^n, \dots
~$$

Example:

```
A = (1/4) * [1 2; 2 1]
```

Then we have

```
A^1, A^2, A^3, A^4
```

The terms seem to be getting smaller.

> Claim: $A^k \rightarrow 0$.

Let's show the following: for a unit vector, we have $(4/3)^k A^k u \rightarrow (1/2) [1,1]$.

```
n = 1; (4/3)^n * A^n * [1,0]
```

```
n =5; (4/3)^n * A^n * [1,0]
```

And jumping ahead:

```
n = 20; (4/3)^n * A^n * [1,0]
```


> Claim: $\sum A_k$ exists.

Such sums are callend [Neumann Series](https://en.wikipedia.org/wiki/Neumann_series).

We see that $\| A_k \|$ looks like $(3/4)^k$, so the sum should exist, as:

$$~
\| \sum_{k=0}^n A^k \| \leq \sum_{k=0}^n \|A^k\| \leq \sum_{k=0}^n \|A\|^k \approx
\sum_{k=0}^n (3/4)^k
\rightarrow 1 / (1 - 3/4)
~$$

In fact, we have more

## Theorem on convergence of Neumann series

> Theorem (p198). If $\|A \| < 1$, then the matrix $I -A$ is invertible and its inverse can be expressed as

$$~
(I-A)^{-1} = \sum_k A^k.
~$$

Proof:

First, the matrix is invertible. If not, there is a non-zero $x$ where $(I-A)x = 0$. We can suppose it is a unit vector. But then from $x = Ax$ we have

$$~
1 = \|x \| = \| Ax \| \leq \|A \| \cdot \| x \| = \| A \| < 1.
~$$

This is of course a contradiction.

To see that the sum is the correct one, we note this is basically the same as showing $\sum r^k = 1/(1-r)$, used above. Only instead of dividing, we multiply:

$$~
(I -A) \sum^n A^k = \sum^n (I - A) A^k = \sum^n (A^k - A^{k+1}) =
(A^0 - A^1) + (A^1 - A^2) + (A^2 - A^3) + \cdots + (A^{n+1} - A^n) = I - A^{n+1}.
~$$

But from $\|A^m\| \leq \|A\|^m$ we get the latter goes to $0$, and the convergence is to $I$.

### Alternatively

> Thm: (p200) Suppose $A$ and $B$ are $n \times n$ with $\| I - AB \| < 1$, then *both* $A$ and $B$ are invertible and we can write as

$$~
A^{-1} = B \sum(I - AB)^k
~$$

Why? We can reexpress the previous one by saying $A^{-1} = \sum (I-A)^k$, under assumptions. Applying this to $AB$ gives that under our assumption we have:

$$~
(AB)^{-1} = \sum (I - AB)^k
~$$

But multiplying both sides by $B$ gives the right hand side, whereas $B(AB)^{-1} = (BB^{-1}A^{-1}) = A^{-1}$.


## Iteratively solving $Ax =b$.

Suppose we have an *approximate* solution, $x^0$ to $Ax=b$ and $A$ is invertible. Then:

$$~
x = A^{-1}b\quad x^0 = A^{-1} Ax^0.
~$$

And so, we can write:

$$~
x = x^0 + A^{-1}(b - Ax^0) = x^0 + e^0,
~$$

Defining the error vector $e^0$ as above. The residual vector is the difference between $b$ and the value $Ax^0$, which id $r^0 = b - Ax^0$.

The relationship between the error vector and the residual vector is:

$$~
e^0 = A^{-1} r^0, \quad\text{or } Ae^0 = r^0
~$$

Given the inputs, $b$, $A$ and $x^0$ we can compute $r^0$ and then solve for $e^0$. This means we can refine our guess to give

$$~
x^1 = x^0 + e^0
~$$

If we expect round off errors or other errors, then this too will be an approximation. It should be a better one.

### Example

From the book

```
A = [420 210 140 105; 210 140 105 84; 140 105 84 70; 105 84 70 60]
```


and

```
b = [875, 539, 399, 319]
```

They claim this is a decent guess

```
x0 = [0.999988, 1.000137, 0.99967, 1.000215]
```

And indeed we have:

```
r0 = b - A*x0
```


Can we refine it?

```
e0 = A \ r0
x1 = x0 + e0
```

The answer is $[1,1,1,1]$. We aren't quite there:

```
x1 - [1,1,1,1]
```

We try to refine it again:

```
r1 = b - A*x1
e1 = A \ r1
x2 = x1 + e1
```

And now

```
x2 - [1,1,1,1]
```


So no better, as we got there in one step.


###

Suppose we have a *perturbed* inverse for $A$, $B$, which yields $x^0 = B b$ and is used for solving. (This might be due just to round off.)

Then we have

$$~
x^1 = x^0 + e^0 = x^0 + Br^0 = x^0 + B(b - Ax^0)
~$$

And iterating:

$$~
x^{k+1} = x^{k} + e^{k} = x^{k} + Br^{k} = x^{k} + B(b - Ax^k).
~$$


This says $x^{k+1} - x^k$ is $x^0 - (BA)x^k$



If $B$ is close to $A^{-1}$, then we should have $\| I - BA\| < 1$. So we can express $A^{-1}$ in iterms of $B$ via the previous formulas.

> Thm (P202). If $\| I - AB \| < 1$ then we have for $m \geq 0$:

$$~
x^m = B \sum_{k=0}^m (I - AB)^k b.
~$$

The partial sums on the right hand side converge to $A^{-1}b = x$, so our iterative refinement converges to $x$.

Proof: We use induction. The case $m=0$ is just saying $x^0 = BIb$, which is the definition of $x^0$.

Assuming this is true for case $m$, we need to show it try for $m+1$. We note that the right hand side can be worked around to:

$$~
B \sum_{k=0}^{m+1} (I - AB)^k b = Bb + B\sum_{k=1}^{M+1} (I - AB)^kb = B(b + (I-AB)\sum_{k=0}^m (I-AB)^k b.
~$$

Now, starting from the left hand side:

$$~
\begin{align}
x^{m+1}
&= x^m + B(b - Ax^m)\\
&= B \cdot \sum_{k=0}^m (I-AB)^k b + B\cdot (b - A(B \sum_{k=0}^m (I-AB)^k b))\\
&= B \cdot (b + \sum_{k=0}^m (I-AB)^k b - AB \cdot \sum_{k=0}^m (I-AB)^k b)\\
&= B \cdot (B + (I-AB) \cdot \sum_{k=0}^m (I-AB)^k b\\
&= B \sum_{k=0}^{m+1} (I - AB)^k b.
\end{align}
~$$


## Generalizations

We are again discussing indirect, iterative solutions to $Ax=b$.

Suppose now $B$ is not an approximate inverse, but just some matrix. Called $Q$ in the book and given thename a splitting matrix. Then adding $Qx$ to both sides of $Ax =b$ gives:

$$~
Qx = (Q-A)x + b
~$$

Which suggests an iterative scheme of the type

$$~
Q x^{k+1} = (Q- A)x^k + b.
~$$

(If $Q^{-1} = B$, then multiplying both sides by $B$ shows that our previous equation $x^{k+1} = x^k + B(b-Ax^k)$ is a special case.)

For this to be good in general, we would want:

* the sequence $x^k$ to be easy (cheap) to compute
* the sequence to converge rapidly

In which case, we can solve.

(Suppose we had a large matrix, solving via $LU$ takes $n^3/3$ steps. If we can compute $x^k$ cheaply, say order $n^2$, and convergence is rapid, this *could* be faster for large $n$.)

## Example

Let $A$ be the matrix:

```
A= [1 1/2 1/3; 1/3 1 1/2; 1/2 1/3 1]
b = [11, 11, 11]/18
```

We take $Q$ to be the identify matrix, $I$:

```
Q = eye(3)
```

We check that $\| I - Q^{-1}A \| < 1$:

```
norm(I - A)
```

So our convergence should hold.


With this $Q$, our iteration step is just $x^{k+1} = (I-A)x^{k} + b = x^k + (b - Ax^k) = x^k + r^k$

And we start at $x=[0,0,0]$. What do 100 iterations produce:

```
x = [0,0,0]
r = b - A*x
x = x + r
```

and again

```
r = b - A*x
x = x+r
```

Now we repeat 100 more times:

```
for k in 1:100
  r = b - A*x 
  x = x + r
end
x, b - A*x
```

Such a choice of $Q$ is called the Richardson method.

### Example

For a different example, take $A$ by

```
A = [2 -1 0; 1 6 -2; 4 -3 9]
```

and $b$:

```
b = [2, -4, 5]
```

Now, let $Q$ be the diagonal matrix of $A$. 

```
Q = diagm(diag(A))   # diag finds element, diagm makes matrix
```

We have

```
norm(I - inv(Q)*A)
```

So we should have convergence of the algorithm

$$~
Qx^{k+1} = (Q-A)x^k + b
~$$


If we start with $x=[0,0,0]$, then our first step is given by

```
x = [0,0,0]
x = Q \ ((Q-A)*x + b)
```

We repeat a few times:

```
x = Q \ ((Q-A)*x + b)
x = Q \ ((Q-A)*x + b)
```

Are we close?

```
A*x - b
```

Not really, let's repeat 20 times:

```
for k in 1:20
  x = Q \ ((Q-A)*x + b)
end
```

And check the residual

```
A*x - b
```

Another 20 times gets us closer:


```
for k in 1:20
  x = Q \ ((Q-A)*x + b)
end
A*x - b
```

For this method, called *Jacobi iteration* the solving part is trivial, as $Q$ is diagonal. The multiplying by $(Q-A)$ need not be costly for sparse matrices, so it could possibly be faster than the direct method of $LU$ factorization.


### Example

If we let $Q$ be the lower triangular part of $A$ we get the *Gauss-Seidel* method. Let's see that this converges as well:

For our same A, we know define $Q$ by:

```
Q = tril(A)
```

We have

```
norm(I - inv(Q)*A)
```

so convergence should occure.

With a starting point at $x=[0,0,0]$ we dash off 25 iterations:

```
x = [0,0,0]
for k in 1:20
  x = Q \ ((Q-A)*x + b)
end
A*x - b
```

This method seems to converge faster than Jacobi iteration. It has other advantages, such as being able to be run in parallel.

### convergence of the method

> Thm. (p210) Suppose $\| I - Q^{-1}A\| < 1$ for some subordinate matrix norm. Then the sequence started at $x^0$ will converge in the associated vector norm.

Pf. The algorithm starts from  $Ax=b$, so if $x$ is an actual solution, it is a fixed point of the algorithm. That is:

$$~
Qx = (Q-A)x + b, \quad \text{and } Qx^{k+1} = (Q-A)x^{k} + b
~$$

Solving -- mathematically -- by multiplying by $Q^{-1}$ reexpresses these as:

$$~
x = (I - Q^{-1}A)x + Q^{-1}b \text{ and } x^{k+1} = (I-Q^{-1}A)x^{k} + Q^{-1}b.
~$$


If we look at the difference vector

$$~
x^{k+1} - x
=  (I-Q^{-1}A)x^{k} + Q^{-1}b - ( (I - Q^{-1}A)x + Q^{-1}b)
=  (I-Q^{-1}A)(x^{k} - x)
~$$

So in norm, we have

$$~
\| x^{k+1} -  x\| \leq \| I - Q^{-1}A\| \|x^k - x\|.
~$$

Which when iterated shows $ \| x^{k+1} -  x\| \rightarrow 0$.

Now, we can say $x$ exists because the assumption $\| I - Q^{-1}A\| < 1$ means that the $Q^{-1}A$ is invertible, and hence so is $A$. So $x = A^{-1} b$. Thus, any starting point will converge to $x$.


## An even more general case

The following is an even more general iterative scheme:

$$~
x^{k+1} = G x^k + c
~$$

Where $G$ is $n \times n$ and $c$ is a vector in $R^n$. What conditions will ensure that this will converge?

### Eigenvalues

The answer will involve the *eigenvalues* of a matrix $A$.

Recall, these are those $\lambda$ for which $det(A - \lambda I) = 0$, this being the characteristic equation of $A$ and is a polynomial. These values may be complex values. The *spectral* radius is defined as the largest eigenvalue in magnitude:

$$~
\rho(A)  = \max \{ |\lambda|: det(A - \lambda I) = 0\}
~$$


> Theorem: (p214) The spectral radius of $A$ is the minimal value over all possible subordinate matrix norms.

This says that we know

$$~
\rho(A) \leq \| A\|
~$$

for any subordinate matrix norm. And for and $\epsilon >0$ there is some subordinate matrix norm with $\|A \| \leq \rho(A) + \epsilon$,

### Convergence

The iteration

$$~
x^{k+1} =  Gx^k + c
~$$

will produce a sequence converging to $(I-G)^{-1}c$ for any starting vector iff and only if $\rho(G) < 1$.

Pf. We start by wrting

$$~
x^k = G^k x^0 + \sum_{j=0}^{k-1} G^j c.
~$$

We know there is some matrix norm with $\| G \| < 1$ (the is the minimal value part). For this norm, we have $\|G^kx^0\| \rightarrow 0$.

The sum has a limit as $k \rightarrow \infty$, as the Neumann series theorem applies:

$$~
\sum_{j=0}^\infty G^j c = (I-G)^{-1} c.
~$$

Hence, as $x^k \rightarrow (I-G)^{-1}c$.

If $\rho(G) \geq 1$, then with $x^0 = 0$ we get $x^k = \sum_{j=0}^{k-1} G^j c$. We can select $\lambda$ and $u$ where $Gu = \lambda u$ and $|\lambda| > 1$. Taking this as $c$, we get $x^k = \sum_{j=0}^{k-1} \lambda^j u$ and this will diverge.









