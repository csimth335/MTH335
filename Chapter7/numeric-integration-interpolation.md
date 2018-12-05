# Numeric integration based on interpolation.

The process of integration has an *easy* answer: $\int_a^b f(x) dx = F(b) - F(a)$ *when* you can find an antiderivative $F$. But that isn't always the case.

> The [Risch algorithm](https://en.wikipedia.org/wiki/Risch_algorithm) characterizes when an *elementary* function has an antiderivative of a specific form.  The original problem is posed by Liouville. Not all elementary functions (functions obtained by composing exponentials, logarithms, radicals, trigonometric functions, and the four arithmetic operations (+ − × ÷)) are integrable. For example, $f(x) = \exp(x^2)$.

## What to do when you can't find an antiderivative?

We can approximate an integral a few ways. First, if we approximate $f$ by $g$, then $\int_a^b f(x) dx \approx \int_a^b g(x) dx$.


For example, if we approximate $\sin(x)$ by its Taylor polynomial of degree $5$ we get an approximation.

```
using Roots, ForwardDiff
D(f,n=1) = n == 0 ? f : n > 1 ? D(D(f),n-1) : x -> ForwardDiff.derivative(f, float(x))
using Polynomials
f(x) = sin(x)
x = poly([0.0])
g = sum([ D(f,k)(0)*x^k / factorial(k) for k in 0:5])
g, polyint(g)
```

Integrating over $[0,\pi]$ gives an exact answer of 2. This one approximates via:



```
G = polyint(g)
G(pi) - G(0) # is this 2?
```

Not so close!

```noout, nocode
using Plots
```

The Taylor series isn't the best approximation over an interval, rather it is good near a point, in this case $c=0$.

```
using Plots
plot([f, x -> g(x)], 0, pi)
```


### Polynomial interpolation

We discussed that there exists a unique polynomial of degree $n$ or less that goes through the points $(x_i, f(x_i))$ for $i=0, 1, \dots, n$. We gave a formula in terms of *divided differences*. This is due to Newton. Lagrange gave an alternate form. Let

$$~
l_i(x) = \prod_{j=0, j\neq i}^n \frac{x - x_j}{x_i-x_j}.
~$$

Then, $p(x) = \sum_0^n f(x_i)l_i(x)$ so for $n+1$ points chosen in $[a,b]$ we have

$$~
\int_a^b f(x) dx \approx \int_a^b p(x) dx = \int_a^b \sum f(x_i) l_i(x) dx = \sum f(x_i) \int_a^b l_i(x) dx.
~$$

If $A_i = \int_a^b l_i(x) dx$, then we have the integral is approximately $\sum A_i f(x_i)$. (The $A_i$ do not depend on $f$, so could in theory be pre-computed.)

> A [Newton-Cotes](https://en.wikipedia.org/wiki/Newton%E2%80%93Cotes_formulas) formula is one where the $x_i$ are equally spaced over $[a,b]$.

Issues here are related to the approximating polynomials getting squirrelly out near the ends of the interval (Runge phenomenon).


## Riemann integration

Consider the easiest case $x_0$ some point in $[a,b]$. Then we have the approximate integral: $f(x_0)(b-a)$.

What is the error? We know that the error using $n+1$ points is $f(x) - p(x) = f^{(n+1)}(\xi_x)/(n+1)! (x-x_0)\cdots(x-x_n)$, so in this case we have:

$$~
\begin{align}
\int_a^b f(x) dx - \int_a^b p(x) &=
\int_a^b (f(x) - p(x)) dx\\
&= \int_a^b f'(\xi_x)(x-x_0) dx\\
&\approx f'(\xi) \frac{(x-x_0)^2}{2} \mid_a^b
\end{align}
~$$

If we were to take $x_0 = a$, then this becomes $f'(\xi)(b-a)^2/2$. So it depends on the length of the interval and the derivative.

## Trapezoid rule

Now suppose, $x_0=a, x_1=b$. So $n=1$. Then we have the trapezoid rule. We have then

$$~
l_0(x) = \frac{b-x}{b-a}, \quad \text{ and } l_1(x) = \frac{x-a}{b-a}
~$$

And $A_0 = A_1 = (b-a)/2$.

So, $\int_a^b f(x) dx \approx f(x_0)A_0 + f(x_1) A_1 = (b-a)/2 \cdot (f(a)  + f(b))$. The formula for the trapezoid.

To compute the error, we have $f(x) - p(x) = f''(\xi_x)/2 (x-a)(x-b)$. Is we write:

$$~
\int_a^b (f(x) - p(x))dx  = -\int_a^b  f''(\xi_x)/2 (x-a)(x-b) dx = -f''(\xi) \int_a^b (x-a)(x-b)/2 dx = -f''(\xi) (b-a)^3/12.
~$$

Again, the error depends on the length of the integral cubed.


### The more familiar trapezoid rule:

Take the partition $a=x_0 < x_1 < \cdots < x_{n-1} < x_n = b$ and apply the trapezoid rule to each pair. This will give an approximation formula. Suppose $x_i = a + (b-a)/n \cdot i$. Then the formulas become:

$$~
\int_a^b f(x) dx \approx \frac{h}{2}(f(a) + 2 \sum_{i=1}^{n-1} f(a + ih) + f(b)), \quad h=(b-a)/2.
~$$

The errors add to give:

$$~
\text{error } = -\sum_i^n f''(\xi_i) h^3/12 \approx -nf''(\xi) h^3/12 =- f''(\xi) \frac{(b-a)^3}{12n^2}.
~$$

## Simpson's rule

Using the points $a = x_0 < x_1 < x_2=b$ with $x_1$ the midpoint, yields Simpson's rule.

The approximation becomes:

$$~
\int_a^b f(x) dx = \frac{b-a}{6}(f(a) + 4f(\frac{a+b}{2}) + f(b))
~$$

With error, $-1/90 \cdot ((b-a)/2)^5 f^{(4)}(\xi)$.

If we apply over an equally spaced partition, the errors accumulate to yield

$$~
\text{Simpson's error} = -\frac{1}{180} \frac{(b-a)^5}{n^4} f^{(4)}(\xi)
~$$

### Compare.

We can numerically compare these errors.

```
riemann(f, a,b) = f(a)*(b-a)
trapezoid(f,a,b) = 1/2 * (b-a)*(f(b)  + f(a))
simpson(f, a, b) = (b-a)/6*(f(a) + 4f((a+b)/2) + f(b))
```

Let's look at $f(x) = e^x$ between $0$ and $\log(2)$ with an answer of $e^{log(2)} - e^0 = 2 - 1 = 1$.

```
linspace(a,b,n=251) = range(a, stop=b, length=n)
n = 10
a,b = 0, log(2)
xs = linspace(a, b, n+1)
xis = zip(xs[1:end-1], xs[2:end])
f(x) = exp(x)


r = sum([riemann(f, xi, xi1) for (xi,xi1) in xis])
t = sum([trapezoid(f, xi, xi1) for (xi,xi1) in xis])
s = sum([simpson(f, xi, xi1) for (xi,xi1) in xis])

[r-1 t-1 s-1]
```

## Change of variables

If we have a formula to approximate $\int_c^d f(x) dx$ then we can do a linear $u$-substitution to integrate over $[a,b]$. The transform is

$$~
u(t) = \frac{b-a}{d-c}t + \frac{ad - bc}{d-c}
~$$

And then

$$~
\int_a^b f(x) dx = \frac{b-a}{d-c}\int_c^d f(u(t)) dt.
~$$

It is conventional to use $a=-1, b=1$.

## Weight functions

The Newton-Cotes formulas can be generalized to handle integrals with weight functions:

$$~
\int_a^b f(x) w(x) dx \approx \int_a^b \sum f(x_i) l_i(x) w(x) dx = \sum f(x_i) \int_a^b l_i(x) w(x) = \sum f(x_i) A_i.
~$$

As before, only with the weight function defining $A$. Again, the $A_i$ do not depend on $x$. If we have $a,b=-1,1$, then they only depend on how the $x_i$ are chosen.

### Choosing the $x_i$ differently

Integrating the general error term and assuming $|f^{(n+1)}(\xi) | \leq M$ we have

$$~
| \int_a^b f(x) dx - \sum A_i f(x_i)| \leq \frac{M}{(n+1)!}  \int_a^b \prod|x - x_i| dx.
~$$

Some choice of $x_i$ will *minimize* this product.

Claim: For $a=-1, b=1$, the following will minimize:

$$~
x_i = \cos(\frac{(i+1)\pi}{n+2}), \quad 0 \leq i \leq n.
~$$

Let's investigate:

```verbatim
using Interact, Plots, QuadGK

xs = linspace(-1,1, 251)
f(xs) =  x -> prod([abs(x-xi) for xi in xs])

@manipulate for x0=xs, x1=xs, x2=xs, x3=xs
vs = [x0,x1,x2,x3]
v = QuadGK.quadgk(f(vs), -1, 1)[1]
plot(f(vs), -1, 1)
title!(string(v))
end
```


How to compare:

```
n = 3
i = 0:n
cos.((i.+1)*pi/(n+2))
```

These values are the zeros of the function

$$~
U_{n+1}(x) = \frac{\sin((n+2)\theta)}{\sin(\theta)}, \quad x = \cos(\theta).
~$$

These functions are polynomials in $x$! Called the Chebyshev polynomials of the second kind.

They have leading coefficient $2^{n+1}$, as

$$~
\int_{-1}^1 |\prod (x-x_i)| dx = 2^{-n}
~$$

With these nodes, one can minimize the error bound to get:

$$~
|\text{error}| \leq \frac{M}{(n+1)! 2^n}.
~$$

> Thm (p487): For monic polynomials $p$ of degree $n$, the Chebyshev polynomials minimize $\int_{-1}^1 |p(x)| dx$.
