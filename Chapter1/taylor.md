# Mathematical preliminaries

## A limit of a function

> The expression $\lim_{x \rightarrow c}f(x) = L$ means: for every $\epsilon$ there exists a $\delta$ such that *if* $0 < |x-c| < \delta$ it *must* be that $|f(x) - L| < \epsilon$.

## Continuous

A function is continuous at $x=c$ if $\lim_{x\rightarrow c}f(x) = f(c)$.

This says three things:

* $f$ is defined at $c$
* $f$ has a limit at $c$.
* the two are the same value

Basically this says $|f(x) - f(c)| \rightarrow 0$ as $x \rightarrow c$. 

### 
A function is continuous on $I = (a,b)$ if it is at each $c$ in $I$.

A function is continuous in $I=[a,b]$ if ....

## Derivative at a point

The derivative of $f$ at $c$ is the limit (when it exists):

$$
\lim_{h \rightarrow 0} \frac{f(c+h) - f(c)}{h}.
$$

(There are other ways to write this.)

The function is differentiable on $I=(a,b)$ provided it has a derivative at each $c$ in $I$.

A function which is differentiable on $I=(a,b)$ it is continuous on $I$. (Why???)

### Example

We have many rules for finding derivatives, the above limit is the definition.

## Higher order derivatives

The derivative of a function returns a function through this definition:

$$
f'(x) = \lim_{h \rightarrow 0} \frac{f(x+h) - f(x)}{h}.
$$

Since $f'(x)$ is also a function, it too may have a derivative. This would be the second derivative of $f$, writing $f''$.

Of course, we can repeat to talk about the $k$th derivative, $f^{(k)}$.

## The space of function C, C^1, C^2, ...

A differentiable function is continuous, but not vice versa. There are some common function spaces:

$C([a,b])$: the set of all continuous functions on $[a,b]$

$C^1([a,b])$: the set of all functions on $[a,b]$ that have a *continuous* derivative on $[a,b]$.

$C^k([a,b])$: the set of all functions on $[a,b]$ that have a *continuous* $k$-th derivative on $[a,b]$.

### Example

The *first* [fundamental](https://en.wikipedia.org/wiki/Fundamental_theorem_of_calculus) theorem of calculus: If $f(x)$ is continuous on $I=[a,b]$ and $F(x) = \int_a^x f(u) du$. Then:

* $F(x)$ is continuous on $[a,b]$,
* $F(x)$ is differentiable in $(a,b)$, and
* $F'(x) = f(x)$, so is continuous.

So $F$ is in $C^1$ (of what interval).

## Taylor's theorem

Suppose $f(x)$ is in $C^n([a,b]$ *and* suppose that $f^{(n+1)}$ exists in $(a,b)$. (Why is it not $C^{n+1}$?) For $c$ and $x$ in $I$, we set

$$
T_n(x) = f(c) + f'(c) (x-c) + \frac{f''(c)}{2!}(x-c)^2 + \cdots + \frac{f^{n}(c)}{n!}(x-c)^n.
$$

($T_n$ is the Taylor polynomial of order $n$ about $c$. When $c=0$ it has a different name.) Then $T_n$ and $f$ are close (typically). How close?

### Taylor's theorem

Set $E_n(x) = f(x) - T_n(x)$. Then there exists $\xi$ between $c$ and $x$ with

$$
E_n(x) = \frac{f^{n+1}(\xi)}{(n+1)!}(x-c)^{n+1}.
$$

### Examples

Finding Taylor series by hand is possible. Here we let the computer do some 

```
using SymPy
```

### Examples

```
x = symbols("x")

f(x) = log(1 + x)
c, n = 0, 5

series(f(x), x, c, n)
```

Or for $1/(1+x)$.

```
f(x) = 1 / (1 + x)
c,n=0, 6

series(f(x), x, c, n)
```

### Using the error

For $f(x) = 1/(1+x)$ we can *approximate* by a Taylor polynomial with $c=0$. If $0\leq x \leq 1/2$, how big must $n$ be so that the error is no more than $10^{-8}$?

We have $f^{(k)}(x) = k!/(x+1)^{k+1}$, so the error term

$$
\begin{align}
| E_n(\xi) | &= |f^{(n+1)}(\xi) / (n+1)! \cdot x^{n+1} |\\
              &\leq \frac{1}{(1 + \xi)^{n+1}} \cdot x^{n+1} \\
              &\leq 1 \cdot (1/2)^{n+1}.
\end{align}			  
$$

We have then $(n+1)\log(1/2) = 8 \log(1/10)$, or $n\approx 26$.

### Manipulations

In the HW you are asked to show $(f(x+h) - f(x-h))/(2h)$ converges to $f'(x)$ -- when the derivative exists. If we *assume* that $f$ is $C^2$, then Taylor's theorem has:

$$
\begin{align}
f(x + h) &= f(x) + f'(x) h + f''(\xi)/2 \cdot h^2  \\
f(x - h) &= f(x) - f'(x) h + f''(\gamma)/2 \cdot h^2
\end{align}
$$

So, subtracting and dividing by $h$ gives:

$$
\begin{align}
(f(x+h) - f(x-h))/(2h) &= f'(x) + (f''(\xi) -f''(\gamma))/2 \cdot h\\
&\rightarrow f'(x)
\end{align}
$$

(How do we know $f''(\xi) - f''(\gamma)$ is bounded when all we know is $x < \xi,\gamma < x +h$?)

## Proving Taylor's theorem

Rolle's [Theorem](http://tinyurl.com/nkus4e7) is a humble little observation -- a "nice" function with a relative maximum or minimum must have a flat tangent line. ("Nice" rules out $|x|$ type functions). One formulation is:

> if $f(x)$ is continuous on $I=[a,b]$ and differentiable on $(a,b)$. (not quite $C^1$, but $C^1$ functions work), **and** $f(a)=f(b)$, then there exists $\xi$ in $(a,b)$ $f'(\xi) = 0$.


### Cauchy Mean Value Theorem

Rolle's Theorem will imply the Cauchy Mean Value [Theorem](http://tinyurl.com/ppt9kd8). Suppose $F$ and $G$ are continous on $I$ and differentiable on its interior, then there exists $\xi$ in $(a,b)$ with $(F(b)-F(a)) \cdot G'(\xi) = (G(b) - G(a)) \cdot F'(\xi)$.

### Visualize

Let $F(x) = \sin(x)$ and $G(x) = \cos(3x)$ and let $a,b=0,7\pi/8$. Then we make a parametric plot:

```
F(x) = sin(x); G(x) = cos(3x)
a, b = 0, 7pi/8
using Gadfly
ts = linspace(a, b)
plot(layer(x = map(G,ts), y = map(F,ts), Geom.line(preserve_order=true)),
     layer(x = [G(a),G(b)], y=[F(a), F(b)], Geom.line(preserve_order=true),Theme(default_color=color("red"))))
```

### a sloution

For fun, a solution is found with:

```
ψ = symbols("psi")
Fp = diff(F(x),x) |> subs(x, ψ)
Gp = diff(G(x),x) |> subs(x, ψ)
nsolve((F(b)-F(a))*Gp - (G(b)-G(a))*Fp, pi/2)
```

### Apply to Taylor's theorem.

(From [wikipedia](http://tinyurl.com/opmyyog) Fix $x$ and define:

$$
\begin{align}
F(t) &= f(t) + f'(t)(x-t) + f''(t)/2! \cdot (x-t)^2 + \cdots + f^{n}(t)/n!\cdot  (x-t)^n,\\
G(t) &=  (x-t)^{n+1}.
\end{align}
$$

Then

$F(x) = f(x)$, $G(x) = 0$, and

$$
\begin{align}
F'(t) &= f'(t) +f''(t) \cdot (x-t) + f'''(t)/2! \cdot (x-t)^2 + \cdots + f^{n+1}(t)/n! \cdot (x-t)^n +\\
      & -f'(t) -f''(t)/2! \cdot 2(x-t) - f'''(t)/3! \cdot 3(x-t)^2 - \cdots - f^n(t)/n! \cdot  n (x-t)^{n-1}\\
      &= 0 + 0 + \cdots + 0 + f^{n+1}(t)/n! (x-t)^n
\end{align}
$$

and

$$
G'(t) = (n+1)(x-t)^n
$$

Thus,

$$
\frac{F'(\xi)}{G'(\xi)} = \frac{f^{n+1}(\xi)/n! (x-\xi)^n}{(n+1)(x-\xi)^n} = \frac{f^{n+1}(\xi)}{(n+1)!}.
$$

But, solving for $F(x)$, we have

$$
F(x) - F(a) = \frac{F'(\xi)}{G'(\xi)}(G(x) - G(a)) = \frac{f^{n+1}(\xi)}{(n+1)!}(x-a)^{n+1}
$$

But $F(x) - F(a) = f(x) - \sum_i^{n} \frac{f^i(a)}{i!}(x-a)^u = E_n(x)$

All told, the error term is as advertised

## Big Oh little Oh ...

Returning to `series`, what is the last term in the expansion:

```
series(exp(sin(x)), x, 0, 5)
```

There are notations that allow a *rough comparison* between two functions. We define [Big "O"](https://en.wikipedia.org/wiki/Big_O_notation): (for some $M<\infty$ there exists $x_0$ such that...)

$$
f(x) = \mathcal{O}(g(x)) \text{ as } x \rightarrow \infty: |f(x)| \leq M |g(x)| \text{ if } x > x_0.
$$

Both $f$ and $g$ can be big "O" of each other, in which case $f(x) \approx M g(x)$ as $x$ gets big.

### Little "o"

And little "o" by (for every $\epsilon > 0$ there exists $x_0$ such that...)

$$
f(x) = \mathcal{o}(g(x)) \text{ as } x \rightarrow \infty: |f(x)| \leq \epsilon |g(x)| \text{ if } x > x_0.
$$

This says $f(x) \approx g(x)h(x)$ where $h(x)$ goes to $0$ as $x$ gets big.

### Big Oh at other values than infinity

We can also define for values other than $x \rightarrow \infty$.

In 

```
series(exp(sin(x)), x, 0, 5)
```

The $\mathcal{O}(x^5)$ is as $x \rightarrow c (=0)$. Is it right? we have

```
ex = diff(exp(sin(x)), x, 5)
```

A continuous function, so on *any* closed interval is bounded [Why?]. So... on $[0,x]$ the $|E_5(x)| \leq M/5! \cdot x^5$ or $\mathcal{O}(x^5)$.

### Little o can sometimes be the correct answer:

We can see that `SymPy` is not as precise as possible with

```
series(exp(sin(x)), x, 0, 3)
```

As we could use $\mathcal{o}(x^3)$ in this specific case. Why?

###

The value of $T_3(x) = 1 + x + x^2/2$ (no $x^3$) term, so $|E_4(x)/x^3| \leq M/4! \cdot x \rightarrow 0$.

### Seeing is believing?

We can see that the limit is $0$ with:

```
f(x) = exp(sin(x))
Err(x) = f(x) - removeO(series(f(x), x, 0, 3))
limit(Err(x)/x^3, x, 0)
```

### Big Oh algebra

Suppose $f_1$ and $f_2$ are $\mathcal{O}(n)$ and $g_1$ and $g_2$ are $\mathcal{O}(m)$ with $n < m$. What "O" is

* $f1 - f2$
* $f1 \cdot f1$
* $f1 + g1$
* $f1 \cdot g1$.

Let's look at some examples:

```
f4 = series(exp(x), x, 0, 4)
g4 = series(log(1+x), x, 0, 4)
f5 = series(sqrt(1 + x), x, 0, 5)
g5 = series(1/(1+x), x, 0, 5)
```

```
f4 - g4    # guess, what would be f4 - f4?
```

```
f5 * g5
```

```
f4 + g5
```

```
f4 * g5 |> expand
```

## Sequences: limit

Many algorithms are iterative. An example is Newton's method, where a sequence of approximate answers is provided: $x_0, x_1, x_2, \dots$ with the expectation that as $n$ gets bigger, the values get closer to the actual answer. (Which happens in most -- but not all cases.)

The formal definition of closer is in terms of a limit:

> $\lim_{n \rightarrow \infty} x_n = L$ means for any $\epsilon > 0$ there exists an $M$ such that if $n > M$, then $|x_n - L| < \epsilon$.

### Examples

Consider $x_n = (n+1)/n = 1 + 1/n$. It should be clear this converges to $1$. (What is $M$ for a given $\epsilon$?)

Less obvious, but well known, is the convergence of $x_n = (1 + 1/n)^n$. What does this converge to?

```
ns = [10^i for i in 1:6]
xns = [(1 + 1/n)^n for n in ns]
[ns xns]
```

Define the sequence $x_{n+1} = x_n/2 + 1/x_n$ starting with $x_0 = 2$. This has terms:

```
xs = [2.0]
for i in 1:5
  xn = xs[end]
  push!(xs, xn/2 + 1/xn)
end
xs  
```

### Rates of convergence

The difference in convergence between the last two examples is alot! We can quantify how fast a sequence converges.

* convergence means $x_n - L \rightarrow 0$

* linear convergence: $|x_{n+1} - L| \leq c |x_n - L|$. (This is like Big "O")

* super-linear convergence  $|x_{n+1} - L| \leq \epsilon_n |x_n - L|$ where $\epsilon_n \rightarrow 0$. (This is like little "o".)

* quadratic: $|x_{n+1} - L| \leq c |x_n - L|^2$. (In general, *order* $\alpha$ replaces $2$ with $\alpha$.)

### Empirical evidence if quadratic convergence

The sequence $x_{n+1} = x_n/2 + 1/x_n$ converges quite rapidly to $\sqrt{2}$. Can we see quadratic convergence? To do so we need to work with more precision:

```
xs = [big(2.0)]
for i = 2:8
  xn = xs[end]
  push!(xs, xn/2 + 1/xn)
end
ds = xs - sqrt(big(2.0))
```

###

We take the ratio to see convergence

```
[ds[i+1]/ds[i]^2 for i in 1:6]
```

(Basically, $e_{n+1} \approx 3.5355339 \cdot e_n^2$.)

### Empirical evidence of *non* quadratic convergence

The secant method is like Newton's method, only it replaces $f'(x)$ with a secant line slope. We have

```
f(x) = x^2 - 2
xs = [big(2.0), big(1.5)]
for i = 2:10
   xn,xn_1 = xs[end], xs[end-1]
   m = (f(xn) - f(xn_1)) / (xn - xn_1)
   push!(xs, xn - f(xn)/m)
end
ds = xs - sqrt(big(2.0))
xs
```

They converge, but not quadratically:

```
[ds[i+1]/ds[i]^2 for i in 1:8] ## not quadratic
```

But better than linear:

```
[ds[i+1]/ds[i] for i in 1:8]
```

### Not all sequences converge

Not all sequences converge. Just take $x_n = \sin(n)$. to
see. However, some things are known about them.

### Monotonicity

Suppose $x_0 \leq x_1 \leq x_2 \leq \cdots \leq x_n \leq \cdot \leq M$.

> Then it is true that this sequence will have a limit.

### Upper bounds

> For any non-empty set of real numbers (such as the sequence of
> $x_n$) with an upper bound, there is a *least* upper bound. That is
> a smallest number with $x_n \leq M$ for any $M$.

### Can't jump over a line...

> Suppose $x_0, x_1, \dots \leq 0$. If $\lim_n x_n = L$, then $L \leq 0$.


### Bounded

> Suppose $|a_{n+1}| \leq c |a_n|$. Then if $c < 1$, $\lim a_n = 0$.


