# Review for test 3


Test 3 is the *final* exam. It will **NOT** be comprehensive **all** of the material will come from chapters 6,7, and 8. (This is different from what was earlier announced!)

## Ch 6: Polynomial Interpolation

The main goal: if we have points $(x_0, y_0), \dots, (x_n, y_n)$ where $y_i = f(x_i)$, can we approximate the function $f(x)$ with a polynomial $p(x)$?

> Thm: if the $x_i$'s are distinct, then there is a *unique* polynomial of degree $n$ with $p(x_i) = y_i$.

There are two different ways to write this:

* Newton form: $p_n(x) = \sum_{i=0}^n c_i \prod_{j=0}^{i-1} (x - x_j)$. We saw that the constants can be written in terms of divided differences: $c_i = f[x_0, x_1, \dots, x_i]$.

* Lagrange form: $p_n(x) = \sum y_k l_k(x)$. We mentioned that the $l_k$ can be written in a terms of a product:

$$~
l_i(x) = \prod_{j=0, j \neq i}^n \frac{x - x_j}{x_i - x_j}.
~$$

The Newton form represents $p$ in terms of polynomials of degree $i$ whereas the Lagrange form has terms all of degree $n$.


### Error:

$$~
f(x) - p_n(x) = \frac{1}{(n+1)!} f^{(n+1)}(\xi) \prod_{i=0}^n (x - x_i)
~$$

This gives a bound on the error.


### Convergence

Even if it is true that for each $x$, $f(x) - p_n(x) \rightarrow 0$ it need not be the case that $\|f - p_n\|_\infty = max_{a \leq x \leq b}|f(x) - p_n(x)| \rightarrow 0$. As we saw on the computer there can be wild oscillations near the edges in $p_n$. In fact: if the interpolation points are evenly spaced the interpolating polynomials become unbounded.

### HW Problems

6.1: 1, 2, 12

> 6.1:1 Find polyomials that interpolate:

a) $(3,5), (7,-1)$. Two points determine a line. Using point slope we have:

```
using SymPy   ## we assume Julia version 0.4, not 0.3 below...
x = symbols("x")
x0,y0 = (3,5)
x1,y1=(7, -1)
m = (y1-y0) // (x1 - x0)
y = y0 + m * ( x - x0)
```

b) We have three points now. A quick graph shows they are not collinear, so the answer will be quadratic. At this point, we use a formula to plug into. LaGrange's form gives:

```
xs = [7,1,2]
ys = [146,2,1]
l(i::Int, xs) = prod( [i==j ? 1 : (x-xs[j]) / (xs[i] - xs[j]) for j in 1:length(xs)] )

p = ys[0+1]*l(0+1, xs) + ys[1+1] * l(1+1,xs) + ys[2+1] * l(2+1, xs)
simplify(p)
```

We can check this is correct:

```
map(p, xs)
```


c) If doing this by hand and using Newton's method we could leverage the fact that a new point is added. Here is how.

We add a new point, $(3,10)$, so a recursive formula might be good. Here we use the first formula on p311 to find $c_k$:

```
push!(xs, 3) 
ck = (10 - p(3)) / prod([xs[end] - u for u in xs[1:end-1]])
q = p + ck*prod([x-xs[i] for i in 1:length(xs)-1])
simplify(q)
```

checking:

```
map(q, xs)
```

Wait! the polynomial $q$ is the same as $p$. The new point lies on the parabola. The theorem guarantees a unique polynomial exists of degree $n$ or less, not necessarily of degree $n$.

d) this is similar, only $y=12$ not 10 and we expect to get a 3rd degree polynomial:

```
ck = (12 - p(3)) / prod([xs[end] - u for u in xs[1:end-1]])
q = p + ck*prod([x-xs[i] for i in 1:length(xs)-1])
simplify(q)
```

e) We can do this by taking advantage of the fact that all but one of the points are zeros, so we know the polynomial *must* have this form:

```
c = symbols("c")
p = c * (x-1.5)*(x-2.7) * (x-3.1) * (x+6.6)*(x-11)
```

Now we just need to solve $p(-2.1) =1$ to find $c$:

```
solve(p(x=>-2.1) -1, c)
```

> 6.1:2  Show that polynomial interpolation is a linear map. That is we can add before or after interpolation.

Suppose $f$ and $g$ are functions with interpolating polynomials $p$ and $q$. If we show that $(p+q)(x_i) = (f+g)(x_i)$ for each $i$, then by the *uniqueness* of interpolating polynomials we will be done. But:

$$~
(p+q)(x_i) = p(x_i) + q(x_i) = f(x_i) + g(x_i) = (f+g)(x_i).
~$$


> 6.1 12

Let's just see if this works for a small case, first, try $n=3$.

Then the algorithm produces:

$$~
(((a_3 b_3 + a_2)b_1 + a_1)b_2 + a_0) b_3
~$$

Does this equal the sum? We'll we see we get these terms:

$$~
a_3 b_3 \cdot b_1 \cdot b_3, \quad a_2 b_1 \cdot b_2 \cdot b_3, \quad a_1 b_2 \cdot b_3, \quad a_0 b_3
~$$

So, no, this isn't right!

To verify, if that isn't enough. Let's do the case $n=2$ symbolically:

```
as = Sym["a$i" for i in 0:2]
bs = Sym["b$i" for i in 0:2]
n=2
x = as[n+1] * bs[n+1]
for i in 1:n
x= (x + as[n-i + 1]) * bs[i + 1]
end

expand(x)
```

And compare to:

```
sum([as[i+1] * prod( [bs[j+1] for j in 0:i]) for i in 0:n])

```


> 6.2: 4,

Show if $f$ is a polynomial of degree $k$ then for $n > k$ we have $p[x_0, \dots, x_n] = 0$.  This is easy if you know that the divided difference is like $Cp^{(n)}(\xi)$ where $n > k$. But a polynomial of degree $k$ will have a 0 $n$th derivative in this case.

Alternatively, you can say that the Newton form is **unique**, so any extra terms of the type $f[x_0, \dots, x_n](x-x_0) \cdots (x-x){n-1}$ must be $0$ if $n > k$.

> 6.2 12. For the function $f(x) = x^m$ show the divided difference is $1$ if $n=m$ and $0$ if $n>m$.

The last part is 6.2.4. For the first, we use Theorem 4, again, to see that if $f(x) = x^n$ then

$$~
f[x_0, x_1, \dots, x_n] = \frac{1}{n!} f^{(n)}(\xi).
~$$

But $f^{(n)}(x) = n!$, a constant. Combine the two.


> 6.2 13 (n=1 only) The other cases are more algebra:

This is like a product rule. The $n=1$ case is proved like that:

![Imgur](http://i.imgur.com/xlwCxkr.jpg)



## Ch7: Numeric differentiation and Integration

Again, we have a table of function values $(x_0, y_0), \dots, (x_n, y_n)$ where $y_i = f(x_i)$, What can we say about the derivate of $f$? The integral of $f$?

We had a basic scheme:

* Find $p_n(x)$ an interpolating polynomial
* Find $p_n'(x)$ of $\int_a^b p_n(x)dx$.
* Approximate the desired answer by the computed answer.
* Assess the error

### Differentiation

For differentiation it was mentioned that if we applied the above to points $x$, $x-h$ and $x+h$, we would get the central difference formula:

$$~
f'(x) \approx \frac{f(x+h) - f(x-h)}{2h}.
~$$

The forward difference equation is $(f(x+h) - f(x))/h$.

The error in the approximation -- when done on the computer -- has two sources of error:

* truncation error -- what happens when using an approximate polynomial of degree $n$ and not an infinite series
* floating point error -- resulting from putting the problem on the computer

For the forward difference, the truncation error is *roughly* $\mathcal{O}(h)$, whereas the floating point error is $\mathcal{O}(\delta/h)$. So there needs to be a balance if using: take $h$ small enough so the truncation error isn't large but not *too* small so that the floating point error isn't large.

The central difference has similar floating point error, but truncation error like $\mathcal{O}(h^2)$.  (It is basically $f'''(\xi)/6\cdot h^2$.)

We mentioned automatic differentiation, but this won't be on the test.

## Integration

The process of approximating $f$ by $p$ and integrating $p$ leads to 3 familar concepts:

* The Riemann sum is when $n=0$, or using a constant for interpolation
* The trapezoid rule is when $n=1$, or using a linear polynomial for interpolation
* Simpson't rule is when $n=2$, that is a polynomial is used for interpolation

Rather than globally approximate $[a,b]$ with just a few points, what is done if that interval is partitioned and on each subpartition the approximation is used. With this we saw errors, $\int_a^b f(x) dx - \int_a^b p_n(x) dx$, given by

* Riemann $(b-a)^2/n$
* Trapezoid $-1/12f''(\xi)(b-a)^3/n^2$
* Simpsons $-1/180 f''''(\xi)(b-a)^5/n^4$


### Generalized

The expression $\int_a^b p_n(x)dx$ can be written differently taking LaGrange's form for polynomial interpolation:

$$~
\int_a^b f(x) dx \approx
\int_a^b p_n(x) dx - \int_a^b \sum_{k=0}^n f(x_k) l_k(x) dx
= \sum_{k=0}^n f(x_k) \int_a^b l_k(x)dx = \sum_{k=0}^n f(x_k) A_k.
~$$

The points $x_k$ are called the *nodes* and the terms $A_k$ the *weights*. Both can be precomputed, as they do not depend on $f$.


The main use here are quadrature formulas:

> (p493) Let $w$ be a positive weight function (like $w(x) = 1$) and let $q$ be a non-zero polynomial of degree $n+1$ that is $w$-orthogonal to the space of polynomials of degree $n$ or less. Then If $x_0, x_1, \dots, x_n$ are the zeros of $q$, the quadrature formula derived by using these zeros as the nodes and used in the weight computation will be *exact* for any polynomial of degree $2n+1$ or less.

(This is an improvement over polynomial interpolation, where the answer is exact for polynomials of degree $n$ or less.)


We saw one family of orthogonal polynomials, those when $w=1$. These were the Legendre polynomials satisfying the recursion:

$$~
P_0(x) = 1, \quad P_1(x) =x, \quad (n+1)P_{n+1}(x) = (2n + 1) x P_n(x)  - n P_{n-1}(x).
~$$


### Error

If we defined

$$~
\int_a^b f(x) w(x) dx = \sum_{i=0}^n A_i f(x_i) + E
~$$

Then for $f$ in $C^{2(n+1)}([a,b])$ the error can be written as:

$$~
E = \frac{1}{(2n)!} f^{(2(n+1))}(\xi) \int_a^b (\prod(x-x_i))^2 w(x) dx
~$$

### Questions

> 7.1 6 (for $f'(x)$ only),

We will do this symbolically about the point $x=0$:

```
h = symbols("h")
g = SymFunction("g")
k=5
1/(12h) * ( -series(g(2h), n=k)+ 8*series(g(h), n=k) - 8*series(g(-h), n=k) + series(g(-2h),  n=k))
```

It may not look it, but that is $g'(0) + \mathcal{O}(h^4)$.

> 7.2 1

Newton-Cotes is done by integrating the interpolating polynomial. Using $g$, we have:

```
x = symbols("x")
xs = Sym[0, 1//3, 2//3, 1]
l(i::Int,xs) = prod( [j == i ? 1 : (x-xs[j+1]) / (xs[i+1] - xs[j+1]) for j in 0:3])
p = g(0) * l(0, xs) + g(1//3) * l(1, xs) + g(2//3) * l(2, xs) + g(1)*l(3, xs)
```

And we integrate from $0$ to $1$:

```
integrate(p, (x, 0, 1))
```

We can see the weights: $1/8$, $3/8$, $3/8$, $1/8$.


> 7.2 2

We need to show that for $p(x) = ax^3 + bx^2 + cx + d$ we have that $\int_u^v p(x) dx$ is given by Simpson's rule.

First, Simpson's rule will integrate any *quadratic* polynomial, as it basically estiamates the function by a quadratic polynomial so the rule will find the given function. But this need not be the case for a cubic. In fact, it is a happy coincedence.

Second, it is enough to do this over the interval $[0,1]$ by a change of variable. So we do that. First, we have the integral of $p(x)$:

```
a,b,c,d,x = symbols("a,b,c,d,x")
p = a*x^3 + b*x^2 + c*x + d
q = integrate(p, (x, 0, 1))
```

Now we apply Simspons rule to $p$:

```
q1 = (1-0)//6 * (p(0) + 4*p(1//2) + p(1))
```

And we simply ask are they equal by seeing if their difference is 0?

```
simplify(q - q1)
```




> 7.2.27 Prove the Chebyshev polynomials are orthogonal.

This follow from a trick that re-expresses the polynomial in terms of $U_n(x) = \cos(n acos(x))$. For then

$$~
\int_{-1}^1 U_n U_m \sqrt{1-x^2}dx = - \int_0^\pi \cos(mu) \cos(nu) du.
~$$

The latter is integrated by using a formula for sums:

$$~
\frac{-1}{2} \int_0^\pi (\cos((m-n)u) + \cos((m+n)u)) du
~$$

When $m\neq n$ these are $0$ and otherwise yield $\pi/2$.


>7.3 3

Derive the Gaussian Quadrature formula for $n=3$.

For the Gaussian Quadrature, the nodes are the roots of the 4th degree Legendre polynomial and the weights are the integrals thereoff.

it all starts with the Legendre Polynomials. See Example 1 p496 to find a reference on p401 for

$$~
p4(x) = x^4 - 6/7x^2 + 3/35
~$$

This is a quadratic polynomial in $x^2$, so the quadratic formula can be used. We skip to the chase:

```
x = symbols("x")
p4 = x^4 - 6//7*x^2 + 3//35
xs = polyroots(p4) |> keys |> collect |> sort
```

With these, the values of $A_i$ come from integrating the LaGrange form of the interpolating polynomial:

```
function l(i::Int, xs)    # another way to define l_i
  us = copy(xs)
  xi = splice!(us, i+1)
  prod( [(x - u)/(xi - u) for u in us])
end

A(i) = integrate(l(i, xs), (x, -1, 1))
As = map(A, 0:3) |> N
```

We can then approximate an integral. For example, $\int_{-1}^1 \exp(x) dx = 2.350402387287602\dots$:

```
[exp(xi)*Ai for (xi,Ai) in zip(xs, As)] |> sum |> N
```

> 7.3 6

We can determine monic polynomial $q(x)$ of degree $n+1$ orthogonal to each polynomial of degree $n$ or less by ensuring that

$$~
q(x) = x^{n+1} + c_nx^n + \cdots + c_1 x + x_0
~$$

satisifes $\int_{-1}^1 q(x) x^k dx = 0$ for all $0 \leq k \leq n$.

Doing so would lead us to the equations of this type for $n=5$

```
n = 5
a, b= -1, 1
cs = Sym["c$i" for i in 0:n]
q = x^(n+1) + sum([ cs[i+1]*x^i for i in 0:n])
eqs = Sym[integrate(q*x^k,(x,a,b)) for k in 0:n]
```

Solving for 0 yields:

```
solve(eqs, cs)
```

So

```
q = x^6 - 15//11 * x^4 + 5//11 * x^2 -5//231
```

Is orthogonal.

Is this a good way to go about this? Likely not, it isn't very efficient as compared to the interative scheme.


* The Gauss weights and nodes for $n=3$ are given by:

```
nodes = [-sqrt(3 / 5), 0.0, sqrt(3 / 5)]
weights = [5 // 9, 8 // 9, 5 // 9]
```

Use these to estimate $\int_{-1}^1 \sin(x) dx$.


ANS: We just need to evaluate the sum of each term $f(x_i)A_i$:

```
f(x) = sin(x)
sum([ f(xi)*Ai for (xi, Ai) in zip(nodes, weights)])
```

- Use the error term and the fact that $|f^{(2n)}(\xi) |<1$ to estimate the error.

For this odd function the error is 0, as the expression will be exact. However, if we didn't know this, then the error for this function is bounded by Theorem 4, which if we take $n=3$ here gives a bound of

$$~
\frac{f^{(6)}(\xi)}{6!} \int_a^b q^2(x) \cdot 1 dx
~$$

This is just:

```
n = 3
1/ factorial(2n) * integrate((x-xs[1]) * (x - xs[2]) * (x - xs[3]), (x, -1, 1)) |> N
```

That is basically `5e-4`.




## Chapter 8. Differential Equations

The IVP (initial value problem) is a specification about a function $x(t)$ through a relation involving its derivative at time $t$:

$$~
x'(t) = f(t, x), \quad x(t_0) = x_0
~$$

In 8.1, we see that an IVP may not have an answer for all $t$; it may not have an answer at all; and if it does have an answer, it may not be unique.

There are theorems which will vouch for uniqueness and existence:

> Thm 1. Existence theorem

If $f$ is *continuous* on a rectangle centered at $(t_0, x_0)$, say:

$$~
R = \{ (t,x) : |t - t_0| \leq \alpha, |x - x_0| \leq \beta \}.
~$$

Then the inital value problem has a solution $x(t)$ for $|t - t_0| \leq min(\alpha, \beta/M)$ where $M$ maximizes $|f|$ in $R$.


> Thm 2 (p526). If both $f$ and $\partial f/\partial x$ are *continuous* in R, then there is a unique solution for $|t - t_0| \leq min(\alpha, \beta/M)$


> Thm 3 If f is Lipshitz then the intial value problem will have a unique solution in some interval.

Precisely, if $f$ is continuous on the strip $a \leq t\leq b$ and $x \in (-\infty, \infty)$ *and* satisfies the inequality for a fixed $L$:

$$~
| f(t,x_1) - f(t, x_2) | \leq L | x_1 - x_2|
~$$

then the solution exists on the interval $[a,b]$.

----

The last two give conditions on $f$ that guarantee an answer exists and is unique, at least for some values of $t$.

### Euler's method

The granddaddy of all methods to numerically approximate the solution to an IVP is Euler's method:

From a sequence of time steps $t_i = t_0 +  ih$, where $h$ is the small time step, Euler's method defines a sequence of $x_i$ values through

$$~
x_{i+1} = x_{i} + f(t_i, x_i)
~$$

The approximate local truncation error at each step is like $\mathcal{O}(h^2)$, so if things are nice, the global truncation error will be like $\mathcal{O}(h)$, when the number of steps is basically $1/h$.

### Taylor methods

The Euler method can be derived by starting with a Taylor series:

$$~
x(t + h) = x(t) + x'(t)h + x''(t)/2 \cdot h^2 + \cdots + x^{(n)}(t)/n! \cdot h^n + \mathcal{O}(h^{n+1})
~$$

Then truncating at the first order. As the IVP defines $x'(t)$ in terms of $f$, Euler's method is nothing more than the tangent line approximation.

Using more terms can be done by differentiating, though that gets tricky.


### Runge-Kutte methods

The Runge - Kutte methods generalize Euler's method by adding various combinations of the approximations for $f$. The two discussed in class were:

* Heun's method where

$$~
\begin{align}
x_{n+1} &= x_n + \frac{1}{2} F_1 + \frac{1}{2} F_2, \text{ where}\\
F_1(x) &= h\cdot f(t, x)\\
F_2(x) &= h\cdot f(t+h, F_1)
\end{align}
~$$

This has  local truncation errors of $\mathcal{O}(h^3)$


* The fourth order method


$$~
\begin{align}
x_{n+1} &= x_n + \frac{1}{6}( F_1 + 4F_2 + 4F_3 + F_4), \text{ where}\\
F_1 &= h\cdot f(t_n, x_n)\\
F_2 &= h\cdot f(t_n+h, F_1/2)\\
F_3 &= h\cdot f(t_n+h, F_2/2)\\
F_2 &= h\cdot f(t_n+h, F_3)\\
\end{align}
~$$

This has  local truncation errors of $\mathcal{O}(h^5)$ and global error of  $\mathcal{O}(h^4)$

### Multistep methods


The general multistep model might look like this (from p557)

$$~
a_k x_n + a_{k-1}x_{n-1} + \cdots + a_0 x_{n-k} =
h( b_k f_n + f_{k-1} f_{n-1} + \cdots + b_0 f_{n-k}).
~$$

We discussed:

* if $b_k \neq 0$ the method is *implicit* otherwise it is explicit
* Definining $p(x)$ and $q(x)$ using the coefficients $a$ and $b$ that the method converges only if all the roots of $p$ are in or on the unit disc, and if on, they are simple roots *and* $p(1)=0$ and $p'(1) = q(1)$. (Consistent and stable)
* If $f_x < \lambda$, the if the local truncation error is $\mathcal{O}(h^{m+1})$ then the global error is $\mathcal{O}(h^m)$

Some special cases:

* Euler's method
* Backward Euler
* Adams Bashworth
* Adams Moulton




### Problems

* Let an IVP be given by $x'(t) = atan(x), \quad x(0) = 0$. Is $f(t,x)$

1) continuous in the strip $0 \leq t \leq 10$ and $-\infty < x < \infty$?
2) does it satisfy
$$~
|f(t,x_1) - f(t,x_2)| \leq L |x_1 - x_2|
~$$


> ANS:

The condition is satisfied if there is a derivative in $x$ that is bound. But the derivative of the arctangent is bounded by $1$ in absolute value.

* Use one of the theorems in section 8.1 to show p9 on page 528. You need to show that $\beta/M$ can be as large of the value, where $M$ is the biggest that $f(t,x)$ can be in when $|x| < \beta$.


We need to maximize  $\beta/M$, where $M$ is the maximum over $[-\beta, beta]$. But $t^2 + e^x$ is increasing, so we have to maximize $\beta/(t^2 + exp(\beta))$. This is a bit tricky, but we can verify that for $|t| \leq 0.351$ it works:

```
using Roots
M(beta) = 0.351^2 + exp(beta)
x0 = fzero(D(beta -> beta/M(beta)), 1)    # crtical point of the function beta/M(beta)
f(x0)
```

That this is more than `0.351` and the theorem says $t \leq min(\alpha, \beta/M)$, the problem is shown.

* Using $h=1/3$ use Euler's method to solve the IVP at $t=1$ with

$$~
x'(t) = 10 - 3x \cdot t\quad
x(0) = 1
~$$


```
h = 1/3
f(t, x) = 10-3x
t0, x0 = 0, 1
t1, x1 = t0 + h, x0 + h * f(t0, x0)
t2, x2 = t1 + h, x1 + h * f(t1, x1)
t3, x3 = t2 + h, x2 + h * f(t2, x2)
x3
```

* Using $h=1/3$ use the Heun's method to solve the following IVP at $t=1$. 


$$~
x'(t) = 1 + x^2,\quad x(0)=0
~$$

```
h = 1/3
h(t, x) = 1 + x^2
function heun(f, t,x)
  F1 = h*f(t, x)
  F2 = h*f(t + h, F1)
  x + (1/2) *F1 + (1/2)*F2
end

t1, x1 = t0 + h, heun(f, t0, x0)
t2, x2 = t1 + h, heun(f, t1, x1)
t3, x3 = t2 + h, heun(f, t2, x2)
x3
```




* problem 2, page 546


We need to solve for $x'(t) = f(t,x)$, so solving for $x'$ we see:

$$~
x' = (3-x) / (2t + x)
~$$

So $f(t,x) = (3-x)/(2t+x)$.

* The Runge Kutte method is often called `rk45`, as the global error is order 4 and the local error order 5. Assuming this, what should be the step size $h$ so that the error at time $1$ (starting at $0$ is basically $10^{-5}$?

> Ans

Assuming that $\mathcal{O}(h^5)$ means basically $h^5$, that is $C=1$ we have to solve: $h^4 \leq 10^{-5}$. But $h=(b-a)/n$ so if we are looking at an interval of length $1$, we should have $n \approx 10^{5/4}$.

* The second-order Adams-Bashworth method is

$$~
x_{n+1} = x_n + h[(3/2) f_n - (1/2) f_{n-1}]
~$$

Take $h=1/4$. Using Euler's method to find $x_1$, find $x_4$ when

$$~
x'(t) = t + x, \quad
x'(0) = 1
~$$

```
f(t,x) = t+x
h = 1/4
t0, x0 = 0, 1
t1, x1 = t0 + h,x0 + h*f(t0, x0)   # Euler step
t2, x2 = t1 + h,  x1 + h * (3/2 * f(t1, x1) - 1/2 * f(t0, x0))
t3, x3 = t2 + h,  x2 + h * (3/2 * f(t2, x2) - 1/2 * f(t1, x1))
t4, x4 = t3 + h,  x3 + h * (3/2 * f(t3, x3) - 1/2 * f(t1, x1))
x4
```

* The implicit Euler (backward) is

$$~
x_{n+1} = x_n + h f(t_{n+1}, x_{n+1}).
~$$

For the IVP

$$~
x'(t) = -10x, \quad x(0) =1
~$$

The implicitness can be solved directly, as $f$ is linear. Using $h=1/3$, find $x_3$.


> Ans.

As an aside, we need to solve at each step

$$~
x_{n+1} = x_n - 10 x_{n+1}
~$$

That is simply $x_n/11$. So,

```
f(t,x) = -10x
h = 1/3
t0, x0 = 0, 1
t1, x1 = t0+h, x0/11
t2, x2 = t1 +h, x1/11
t3, x3 = t2+h, x2/11
x3
```

* The multistep method is convergent if it is both stable and consistent. Both these may be checked by accompanying polynomials.

Show the  second-order Adams-Bashworth method 

$$~
x_{n+1} = x_n + h[(3/2) f_n - (1/2) f_{n-1}]
~$$

is convergent.


> Ans

We have $p(x) = x^2 - x=x(x-1)$ and $q(x) = 3/2 \cdot x - 1/2$. So, we need to check:

- the zeros of $p$ are 0 and 1, so the zeros are not ouside the unit disc and any on the boundary are simple.
- we have $p(1) = 0$ and $p'(1) = 2 = q(1)$.

* The Runge Kutta methods involve a certain number of function evaluations per step. The following table shows the best possible local truncation error for a given number of function evaluations:

```verbatim
Evals  order
2  2
3  3
4  4
5  4
6  5
7  6
8  6
9  7
```

- Why might this suggest using an order 4 method?

Going from 4 to 5 does not increase the order, but does mean more work done.

- Euler's method has 1 evaluation for order 2. Compare the sum of the 1-step errors in using 4 steps of Euler of size $h/4$ with one step of a fourth order RK method with order 4. What values of $h$ would make one more attractive than the other?


> Ans:

Euler would have $4 h/4 \approx(x)$, whereas at RK would have $h^4$. So if $|h| < 1$ , the second is better.
