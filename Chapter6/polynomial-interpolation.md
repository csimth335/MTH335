# Polynomial Interpolation

The problem: we know a function's value at some points, $(x_0, y_0)$, $(x_1, y_1), \dots, (x_n, y_n)$. How can we approximate that function?


There are many functions that can go through a sequence of points, the problem is not unique in general.

However Theorem 1 on polynomial interpolation (p309)

> There is a *unique* polynomial of degree $n$ going through the $n+1$ points. (We assume the $x_i$ are real.)

## Uniqueness

Well, suppose there are two such polynomials $p(x)$ and $q(x)$. Then we have $h(x) = p(x) - q(x)$. It has degree at most $n$, so there are no more than $n$ roots. But $h(x_i) = p(x_i) - q(x_i) = y_i - y_i = 0$. So there are $n+1$ roots, hence a contradiction.


## Existence

For existence, we can use induction.

For $n=0$ we just have a constant $p_0(x) = y_1$ and then $p_0(x_1) = y_1$ too.

For $n=1$: we have two points and we can make the line between them. The point slope form is helpful, it would look like:

$$~
p_1(x) = x_0 + \frac{y_1 - y_0}{x_1 - x_0} (x - x_0).
~$$

----

Assuming that the statement is true for $k$, can we show it is true for $k+1$.

First from $p_{k-1}$ with degree $\leq k-1$ from the first $k-1$ points. Then we write the following formally:

$$~
p_k = p_{k-1}(x) + c(x-x_0)(x-x_1)\cdots (x - x_{k-1})
~$$

For some $c$ we will show that this polynomial has degree $\leq k$ and $p_k(x_i) =y_i$ for all $i$ between $0$ and $k$.

The term added is an $k$th degree polynomial. So $p_k$ is a polynomial
of degree $\leq k$ and degree of $p_{k-1}$.

The term added is $0$ at each of $x_0, \dots, x_{k-1}$, so for these values

$$~
p_k(x_i) = p_{k-1}(x_i) + 0 = y_i.
~$$

Finally, $p_k(x_n) = p_{k-1}(x_k) + c \prod_{i=0}^{k-1}(x_k - x_i)$

Setting this to $y_k$ gives:

$$~
y_k=  p_{k-1}(x_k) + c \prod_{i=0}^{k-1}(x_k - x_i)
~$$

Or

$$~
c = \frac{y_k - p_{k-1}(x_k)}{\prod_{i=0}^{k-1}(x_k - x_i)}.
~$$

The divisor is clearly not $0$, so this defines $c$ and we have found $p_k$.

### The form of the polynomial

We have just seen that

$$~
p_k(x) = c_0 + c_1(x-x_0) + c_2(x-x_0)(x-x_1) + \cdots + c_k(x-x_0)\cdots(x-x_{k-1}) =
\sum_{i=0}^{k} c_i \prod_{j=0}^{i-1} (x - x_j).
~$$

where

$$~
c_k = \frac{y_k - p_{k-1}(x_k)}{\prod_{i=0}^{k-1}(x_k - x_i)}.
~$$




### The Lagrange form of the polynomial:

There are other means to express this polynomial, that are a bit clearer.

The Lagrange form of the interpolating polynomial uses the $y_i$ as
coefficients:

$$~
L(x) = \sum y_i \cdot l_i(x),
~$$

Where

$$~
l_i(x) = \prod_{m \neq i} \frac{x - x_m}{x_i - x_m}.
~$$


Why this? We want a polynomial that a) takes a value of $0$ at $x_j$
($j \neq i$) and $1$ at $x_i$. Clearly a) is satisfied by $c(x - x_0)
\cdot (x - x_k)$ **skipping** $x_i$. Putting in $x_i$, then says $c$
should be the reciprocal of $(x_i-x_0) \cdots (x_i - x_k)$
**skipping** $x_i-x_i$.


These are polynomials of degree $n$. using the delta function, these satisfy:

$$~
l_i(x_j) = \delta_{ij}.
~$$

So $L(x_i) = \sum_j y_i \delta_{ij} = y_i \cdot 1 = y_i$, as expected. So $L(x)$ is a
polyonmial of degree at most $n$ and by uniqueness is the *interpolating* polynomial.


### Alternate derivations

Suppose we have a polynomial $p_k(x) = a_0 + a_1x + a_2x^2 + \cdots a_k x^k$ which satisfies $p_k(x_i) = y_i$. Then this leads to a system of equations:

$$~
\begin{array}{cc}
&a_0 \cdot 1 + a_1 x_0 + a_2 x_0^2 + \cdots + a_k x_0^k = y_0\\
&a_0 \cdot 1 + a_1 x_1 + a_2 x_1^2 + \cdots + a_k x_1^k = y_1\\
&\cdots\\
&a_0 \cdot 1 + a_1 x_k + a_2 x_k^2 + \cdots + a_k x_k^k = y_k
\end{array}
~$$

This is a *linear* system of $k+1$ equations in $k+1$ unknowns $a_0,
a_1, \dots, a_k$. If the coefficient matrix is nonsingular, it has solution $A^{-1}y$.

For example

```
using SymPy
k=2
xs = Sym["x$i" for i in 0:k]
ys = Sym["y$i" for i in 0:k]
as = Sym["a$i" for i in 0:k]

x = symbols("x")
p = sum([as[i+1] * x^i for i in 0:k])

eqs = Sym[subs(p, x, u) - v for (u,v) in zip(xs, ys)]
```

We can solve these (they are linear after all):

```
us = solve(eqs, as)
```

But it isn't pretty and doesn't get prettier with factoring

```
Dict(k=>factor(v) for (k,v) in us)
```


### Vandermonde matrix

A [Vandermonde](https://en.wikipedia.org/wiki/Vandermonde_matrix)
matrix is a matrix with a geometric progression in each row. For
example, the matrix:

$$~
\begin{bmatrix}
1 & x_0 & x_0^2  & \cdots & x_0^k\\
1 & x_1 & x_1^2  & \cdots & x_1^k\\
  &     & \cdots &        & \\
1 & x_k & x_k^2 & \cdots & x_k^k
\end{bmatrix}
~$$


Calling this $V$, then our set of equations is represented by $Va =
y$. The determinant of $V$, when square, is known: $|V| = \prod_{i < j}
(x_j - x_i)$.





That this is non-zero says that there will be a unique solution $a$
for a given $y$ -- an alternate proof of the t





### Divided differences 6.2


Suppose we have $y_i = f(x_i)$ and we want to find the interpolating
polynomial. We can express this in terms of $f$.

Following the book (p328), we define

$$~
q_0(x) = 1, \quad q_1(x) = (x - x_0), \quad q_2(x) = (x - x_0)(x-x_1),
...
~$$

Then we have seen for some $c_k$ that $p(x) = \sum_{j=0}^n c_j q_j(x)$



For $n=2$, from $p(x_i) = f(x_i)$, we see that the $c_i$s satisfy $Lc=f$ where $c =
[c_0, c_1, c_2]$ and $f=[f(x_0), f(x_1), f(x_2)$ and $L$ is lower triangular

$$~
\begin{bmatrix}
1 & 0 & 0 \\
1 & (x_1-x_0) & 0 \\
1 & (x_2-x_0) & (x_2-x_0)\cdot (x_2 - x_1)
\end{bmatrix}.
~$$


We see that $c_m$ depends on $f(x_0), f(x_1), \dots, f(x_m)$ only and not $f(x_j)$ with $j > m$. The book writes $f[x_0, x_1, \dots, x_m]
= c_m$. This defines the notation with square brackets called divided
differences.

Notice:

* From $1 \cdot c_0 = f(x_0)$ that $f[x_0] = f(x_0)$.

* From $f(x_1) = f[x_1] = 1 \cdot c_0  + (x_1-x_0) c_1 = f[x_0] +
  (x_1 - x_0) f[x_0, x_1]$ that we can solve $f[x_0, x_1] = (f[x_1]
  -f[x_0])/(x_1 - x_0)$.

### Thm 1 p330

The following recursive formula holds:

$$~
f[x_0, x_1, \cdots, x_n] = \frac{f[x_1, \cdots, x_n] -
f[x_0, x_1, \cdots, x_{n-1}]}{x_n - x_0}.
~$$

PF: Let $p_k$ interpolate $f$ at $x_0, x_1, \dots, x_k$ and $q$
interpolate $f$ at $x_1, \dots, x_n$. Then

$$~
p_n(x) = q(x) + \frac{x - x_n}{x_n-x_0} \cdot (q(x)  - p_{n-1}(x)). (Why?)
~$$

What is coefficient of $x^n$? The left and right side must be the same. On left hand side it is
$f[x_0, \dots x_n]$. On right hand side it is

$$~
\frac{1}{x_n-x_0}(f[x_1, \dots, x_n] - f[x_0, \dots, x_{n-1}]).
~$$

### Properties:

> Thm 2 p333: can permute $x_i$s.  Sure, by uniqueness of polynomial coefficients.

> Thm 3 p333: Let $p$ be a polynomial that interpolates $f$ and $t$ some other point then

$$~
f(t) - p(t) = f[x_0, x_1, \dots, x_n, t] \cdot \prod (t-x_j)
~$$

Why? If $q(x)$ interpolates $f(x)$ at the points *and* $t$, then $q(t) =
f(t)$ and

$$~
q(x) = p(x) +  f[x_0, x_1, \dots, x_n, t] \cdot \prod (x - x_j)
~$$

> Thm 4 p333: Divided differences look like *derivatives*. If $f$ has sufficient
> derivatives, then if $a < x_0 < x_1 < \dots x_n < b$ there exists
> $\xi$ in $(a,b)$ with

$$~
f[x_0, x_1, \dots, x_n] = \frac{1}{n!}f^{(n)}(\xi).
~$$


This is the error bound theorem in disguise.




### Relate to Taylor polynomial


In calculus, we have that the tangent line is the limit of the secant
line. Here we can view it as the limit of the newton interpolating
polynomial between $x_0$ and $x_1$ as $x_1 \rightarrow x_0$:

```
function div_differences(f, xs) 
  if length(xs) == 1
    return f(xs[1])
  else
    return (div_differences(f, xs[2:end]) - div_differences(f,xs[1:end-1]))/(xs[end] - xs[1])
  end
end
```

And then if we skin it:

```
Base.getindex(f::T, xs...) where {T <: Function} = div_differences(f, [xs...])
Base.getindex(f::T, xs...) where {T <: SymFunction} = div_differences(f, [xs...])
```

```
using SymPy
@vars x x0 x1
f(x) = sin(x)
p = f[x0] + f[x0, x1]*(x-x0)
```

And taking a limit:

```
limit(p, x1 => x0)
```


Or with a symbolic function

```
u = SymFunction("u")
p = u[x0] + u[x0, x1]*(x-x0)
```

```
limit(p, x1 => x0)  # this is u(x_0) + u'(x_0) * (x - x_0)
```




More generally, we can take more points:

```
@vars x h x0
x1 = x0+h; x2=x0+2h; x3=x0+3h
p = u[x0] + u[x0, x1]*(x-x0) + u[x0, x1, x2]*(x-x0)*(x-x1)+u[x0, x1,x2,x3]*(x-x0) *(x-x1)*(x-x2)
```

```
limit(p, h=>0)(x0 => 0)  # u(0) + u'(0)x + (1/2) * u''(0)x^2 + (1/6) * u'''(0)x^3
```

