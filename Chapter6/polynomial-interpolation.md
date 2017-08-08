# Polynomial Interpolation

The problem: we know a function's value at some points, $(x_0, y_0)$, $(x_1, y_1), \dots, (x_n, y_n)$. How can we approximate that function?


There are many functions that can go through a sequence of points, the problem is not unique in general.

However (p309)

> There is a *unique* polynomial of degree $n$ going through the $n+1$ points. (We assume the $x_i$ are real.)

## Uniqueness

Well, suppose there are two such polynomials $p(x)$ and $q(x)$. Then we have $h(x) = p(x) - q(x)$. It has degree at most $n$, so there are no more than $n$ roots. But $h(x_i) = p(x_i) - q(x_i) = y_i - y_i = 0$. So there are $n+1$ roots, hence a contradiction.


## Existence

For existence, we can use induction.

For $n=0$ we just have a constant $p_0(x) = y_1$ and then $p_0(x_1) = y_1$ too.

$n=1$. Then we have two points and we can make the line between them. The point slope form is helpful, it would look like:

$$~
p_1(x) = x_0 + \frac{y_1 - y_0}{x_1 - x_0} (x - x_0).
~$$


Assuming that the statement is true for $k$, can we show it is true for $k+1$.

First form $p_{k-1}$ with degree $\leq k-1$ from the first $k-1$ points. Then we write the following formally:

$$~
p_k = p_{k-1}(x) + c(x-x_0)(x-x_1)\cdots (x - x_{k-1})
~$$

For some $c$ we will show that this polynomial has degree $\leq k$ and $p_k(x_i) =y_i$ for all $i$ between $0$ and $k$.

The term added is an $k$th degree polynomial. So $p_k$ is a polynomial of degree $\leq k$.

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

This is a *linear* system of $k+1$ equations in $k+1$ unknowns. If the coefficient matrix is nonsingular, it has solution $A^{-1}y$.

For example

```
using SymPy
k=2
xs = Sym[Sym("x"*string(i)) for i in 0:k]
ys = Sym[Sym("y"*string(i)) for i in 0:k]

as = Sym[Sym("a"*string(i)) for i in 0:k]
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
Sym[factor(v) for (k,v) in us]
```

### Divided differences

This is an alternate way of viewing the complicated coefficients. Note the following:

For $k=0$ we had $p_0(x) = f(x_0)$

For $k=1$ we hade $p_1(x) = f(x_0)  + (f(x_1) - f(x_0)) / (x_1 - x_0) (x - x_0)$.

Letting $f[x_0] = f(x_0)$ and $f[x_0, x_1] =  (f(x_1) - f(x_0)) / (x_1 - x_0) $.

Then these become

$p_0(x) = f[x_0]$, $p_1(x) = f[x_0] + f[x_0,x_1](x-x_0)$. 

In general we define the interpolating polynomials through

$$~
f(x) = \sum_{k=0}^n f[x_0, x_1, \dots, x_k] \prod_{j=1}^{k-1}(x-x_j).
~$$

Then

> Thm (p330)

$$~
f[x_0, x_1, \dots, x_n] = \frac{f[x_1, x_2,\dots,x_n] - f[x_0, x_1, \dots, x_{n-1}]}{x_n-x_0}.
~$$

These are like derivatives. But not quite.

> Thm (p333) If $a \leq x_i \leq b$, then there exists $\xi$ in $[a,b]$ with

$$~
f[x_0, x_1, \dots,x_n] = \frac{1}{n!}f^{(n)}(\xi).
~$$


### Error

Let $f$ be continuous of degreen $n+1$ over $[a,b]$ and $p$ be a polynomial interpolating $p$ at $n+1$ distinct points. Then for each $x$ there exists $\xi$ with

$$~
f(x) - p(x) = \frac{1}{(n+1)!} f^{(n+1)}(\xi) \prod_{i=0}^n (x - x_i).
~$$


#### Example

For the function $f(x) = \cos(x)$ over the interval $[0, \pi/2]$ if $k=4+1$ points are chosen and a polynomial interpolates, then the difference is

$$~
\cos(x) - p(x) = \frac{1}{120} f^{(5)}(\xi) \prod_0^4(x-x_i)
~$$

This can be as large (in absolute value) as:

$$~
|\cos(x) - p(x)| \leq \frac{1}{120} \cdot 1 \cdot  (\pi/2)^5 = 0.07969262624616703
~$$

This is a worst case. We can graph to see the difference.

```
function dd(f,xs)
  if length(xs) == 1
     f(xs[1])
  else
	 (dd(f,xs[2:end]) - dd(f, xs[1:end-1])) / (maximum(xs) - minimum(xs))
	 end
end
```

```
n = 4
f(x) = cos(x)
a,b = 0, pi/2
xs = a + sort(rand(n+1)) * b

## prod_j=0^(k-1)(x-x_j)
prodk(x, k, xs) = prod([ x - xs[j+1] for j in 0:(k-1)])
## sum _(k=0)^n f[x_0, \dots x_k] prod_j=0^(k-1)(x-x_j)
p4(x) = f(xs[1]) + sum( [ dd(f, xs[1:(k+1)]) * prodk(x, k, xs) for k in 1:n])
```

To visualize we try:

```
using Plots
backend(:gadfly)
plot([f, p4], 0, pi/2)
```

Not too illuminating, so we try this:

```
plot(x -> f(x) - p4(x), 0, pi/2)
```


So the actual difference is not as large as is possible $0.079$.


## The errors can grow!

The bound on the error depends on the derivatives of the function. For some functions, these may get big, so it isn't the case that we definitely know that $\| f -p_n \|_\infty \rightarrow 0$.

> p319: "The surprising state of affairs is that for most continuous functions the quantity will not converge to 0"

Example, (Runge 1901). Let $f(x) = 1/(x^2+1)$ and $[a,b] = [-5,5]$. We will use *evenly* space points and have a look:

```
f(x) = 1/(x^2 + 1)
a,b = -5, 5


function show_n(n)
  xs = linspace(a, b, n + 1 + 2)[2:end-1]

  ip(x)  = f(xs[1]) + sum( [ dd(f, xs[1:(k+1)]) * prodk(x, k, xs) for k in 1:n])
  Gadfly.plot([f,ip], a, b)
  end

show_n(2)
```

```
show_n(5)
```

```
show_n(7)
```

```
show_n(15)
```



(There are better functions to approximate over an entire interval.)
