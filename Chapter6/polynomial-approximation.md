# Polynomial Approximation

How well can we *approximate* a function with a polynomial?

The Taylor polynomial is the best approximation near a point $x=c$, but what polynomial is the "best" approximation over an entire interval $[a,b]$?

Here "best" *might* mean which $p$ has the smallest value of $max_{[a,b]} | f(x) - p(x) |$. This is the infinity-norm between two functions.


What do we know:

> Theorem 2 p315: Error in the polynomial interpolation
> Let $f$ be continuous of degreen $n+1$ over $[a,b]$ and $p$ be a polynomial interpolating $p$ at $n+1$ distinct points. Then for each $x$ there exists $\xi$ with
> $$~
> f(x) - p(x) = \frac{1}{(n+1)!} f^{(n+1)}(\xi) \prod_{i=0}^n (x - x_i).
> ~$$


#### Example

We can visualize this a bit:
Consider $f(x) = \sin(x)$ on $[0, \pi/2]$. Then the interpolation
between 2 points is just a secant line:

```
f(x) = sin(x)
a,b = pi/2 * sort(rand(2))
g(x) = f(a) + (f(b)-f(a))/(b-a)*(x-a)
plot(f, 0, pi/2)
plot!(g)
scatter!([a,b], f.([a,b]), markersize=3)

u = pi/2 * rand()
plot!([u,u], sort([f(u), g(u)]), linewidth=3)
```




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
plot(f, 0, pi/2)
plot!(p4)
```

Not too illuminating, so we try this:

```
plot(x -> f(x) - p4(x), 0, pi/2)
```


So the actual difference is nowhere near as
large as is possible ($0.079$).



### Chebyshev polynomials

Goal, make the difference as *small* as possible:

Fix $[-1,1]$ -- this is no loss of generality as we can transform a polynomial.

Define special polynomials -- Chebyshev polynomials of the first kind -- by the relations:

$$~
T_0(x) = 1, \quad
T_1(x) = x, \quad
T_{n+1}(x) = 2x T_n(x) - T_{n-1}(x).
~$$

These will be polynomials with the smallest infinity norm in $[-1,1]$.

> Theorem. Fix $x$ in $[-1,1]$, then $T_n(x) = \cos(n \cos^{-1}(x))$ for $n \geq 0$.

Pf. We need $\cos(A+B) = \cos(A) \cos(B) - \sin(A) \sin(B)$. So applying twice we get:

$$~
\cos((n+1)\theta) = \cos(n\theta + \theta) = \cos(n\theta) \cos\theta - \sin(n\theta) \sin\theta,\quad
\cos((n-1)\theta) = \cos(n\theta - \theta) = \cos(n\theta) \cos\theta + \sin(n\theta) \sin\theta.
~$$

So, we see that adding the two will give $2 \cos(n\theta) \cos\theta$, so that

$$~
\cos((n+1)\theta) = 2 \cos\theta \cos(n\theta) - \cos((n-1)\theta).
~$$

Now, $x = \cos\theta$ so $\theta = \cos^{-1}(x)$, so we have with $T_n = \cos(n\cos^{-1}(x))$ that these $T_n$ satisfy the defining relationship.

#### Quick properties

* We must have $|T_n(x)| \leq 1$ on $[-1,1]$, as the cosine function is so bounded

* As $\cos^{-1}\cos(j\pi/n) = j\pi/n$ we have $T_n(\cos(j\pi/n_)$ is $(-1)^j$.

* Similarly, $T_n(\cos((2j-1)\pi/(2n))) = 0$, for $1 \leq j \leq n$.

* The leading coefficients are $2^{n-1}$. (Induction from the defining relationship $T_{n+1} = 2x\cdot T_n - T_{n-1}$.)

> Thm: if $p$ is monic (leading coefficient $1$) then $\|p\|_\infty \geq 2^{1-n}$.

Proof (p317): Assume *not*, then for *all* $x$ in $[-1,1]$ it must be $|p(x) < 2^{1-n}$. Let $q = 2^{1-n}T_n$ and $x_i = \cos(i\pi/n)$. Then $q$ is monic and $T_n(x_i)$ is $1$ or $-1$. So

$$~
(-1)^i p(x_i) \leq |p(x_i)| < 2^{1-n} \quad \text{(by assumption)}
~$$

So, for each $i$ in $0, 1, 2, \dots n$:

$$~
(-1)^i (q(x_i) - p(x_i) > 0).
~$$

This means the polynomial crosses $0$ atleast $n$ times. So either $q-p$ is a polynomial of degree $n$ or more or is the zero polynomial. But both $q$ and $p$ are monic of degree $n$, so their difference is a polynomial of degree *less* than $n$, hence it must be the $0$ polynomial.


#### Application:

So for a fixed number of nodes, to minimize the error between $f(x)$ and its interpolating polynomial *over* $[-1,1]$, use these Chebyshev nodes
$$~
x_i = \cos(\frac{2i-1}{2n+2}\pi).
~$$

For these nodes, we have $max_{[-1,1]} |x-x_i|$ is as small as possible.



```
using Polynomials
f(x) =  sin(4x) + cos(x)^2
n = 5
xs = sort(2*rand(n) - 1)
zs = cos.((2*(0:4) +1)/(2n)* pi)
p = Polynomials.polyfit(xs, f.(xs))
q = Polynomials.polyfit(zs, f.(zs))
plot(f, -1, 1, legend=false, linewidth=3)
plot!(x->p(x), color=:green)
plot!(x->q(x), color=:red, linewidth=3)
```


## The errors can grow!

Fix a function $f$ and an interval $[a,b]$. We would expect that if we take more and more points to interpolate $f$ that the interpolating polynomial would get closer and closer to $p$. In fact, w might expect that $\|f-p_n\|_\infty \rightarrow 0$ as $n \rightarrow \infty$.



However, the bound on the error depends on the derivatives of the function. For some functions, these may get big, so it isn't the case that we definitely know that $\| f -p_n \|_\infty \rightarrow 0$. In fact:

> p319: "The surprising state of affairs is that for most continuous functions the quantity will not converge to 0"

Example, (Runge 1901). Let $f(x) = 1/(x^2+1)$ and $[a,b] = [-5,5]$. We will use *evenly* spaced points and have a look:

```
f(x) = 1/(x^2 + 1)
a,b = -5, 5


function show_n(n)
  xs = linspace(a, b, n + 1 + 2)[2:end-1]

  ip(x)  = f(xs[1]) + sum( [ dd(f, xs[1:(k+1)]) * prodk(x, k, xs) for k in 1:n])
  plot(f, a, b)
  plot!(ip)
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


Some theorems:

> Faber's Theorem p320: For each $n$, fix a set of nodes $a \leq x^{(n)}_1 < x^{(n)}_2 < \cdots <   x^{(n)}_n \leq b$. There is some function $f$ for which the interpolating polynomial will not converge uniformly to $f$.

Meanwhile

> Convergence of interpolants p320: For each $f$ there is a system of nodes such that $p_n$ converges uniformly to $f$.

So not all nodes will work, but for each $f$ some nodes will.

This next theorem is similar, but speaks just to the size of an error:

> Weirstrass Approximation Theorem. Let $f$ be continuous on $[a,b]$. Then for any $\epsilon > 0$ there exists a polynomial $p$ with $\|f-p\|_\infty < \epsilon$.

The classic proof of this is *constructive*. Assume $[a,b] = [0,1]$. The Bernstein basis for the polynomials of degree $n$ is:

$$~
g_{nk}(x) = {n \choose k}x^k(1-x)^{n-k}
~$$

With this, we can defined a $n$th degree polynomial approximation to $f$ by:

$$~
B_n(f)(x) = \sum_{k=0}^n f(x/k) \cdot g_{nk}(x).
~$$

[Wikipedia](https://en.wikipedia.org/wiki/Bernstein_polynomial) shows that $B_n(f) \rightarrow f$ *uniformly* on $[0,1]$.

Wikipedia's proof uses probability. The book's proof uses Thm 9 (Bohman-Korovkin) to show that if we can prove convergence for three functions $1$, $x$ and $x^2$ then it will be true -- provided $B_n(f)$ is a *linear operator* (which it is).

So, we would need to show the explicit *uniform* convergence of $B_n(x^k)$ for $k=0,1,2$. For $k=0$, $f(k/n) = 1$ and so:

$$~
B_n(1) = \sum_k g_{nk}(x) = \sum {n \choose k}x^k (1-x)^{n-k} = (x + (1-x))^n = 1.
~$$

and for $k=1$, $f(k/n) = k/n$ and so

$$~
B_n(x) = \sum {n \choose k} (k/n) x^k (1-x)^{n-k} = \sum_{k=1}^n {n-1 \choose k-1}x^k(1-x)^{n-k} = x \sum_{k=0}^{n-1} {n-1 \choose k} x^k (1-x)^{(n-1)-k} = x.
~$$

And for $k=2$, we will get (p323) $B_n(x^2)(x) = (n-1)/n x^2 + x/n$ which converges uniformly to $x^2$.


### ApproxFun


In Julia, the `ApproxFun` package does computations by finding a high order polynomial approximation to the function $f$ and then solving using the polynomial approximation.

For example, we have from the [Readme](https://github.com/JuliaApproximation/ApproxFun.jl)

```noeval
using ApproxFun
x = x = Fun(identity,0..pi)
f = sin(x^2)
g = cos(x)
```

And then

```noeval
h = f + g^2
r = roots(h)
rp = roots(h')

using Plots
plot(h)
scatter!(r,h.(r))
scatter!(rp,h.(rp))
```

Secretly `h` is a high order polynomial:

```noeval
h.coefficients
```




### Bezier Curves

The Bernstein polynomials find another usage:

Consider this great graphic: https://www.jasondavies.com/animated-bezier/

There are $n+1$ points $P_0, P_1, \dots, P_n$. The blue circles *interpolate* between $P_i$ and $P_{i+1}$ at the same rate. Between adjacent blue circles are further interpolations, and so on until there is just one circle, which lays out a trajectory. The resulting trajectory is the Bezier curve for the given control points.

What are the mathematics behind this? The Bernstein basis comes in:

$$~
B(t) = \sum_{k=0}^n {n \choose k} t^k (1-t)^k P_k
~$$

Can we graph?

```
choose(n,k) = gamma(n+1) / gamma(k+1) / gamma(n-k+1)   
```

```
Ps = [[0,0], [1,1/2], [1/2, 1], [0,1/2]]
n = length(Ps) - 1
B(t) = sum(choose(n,k) * t^k *(1-t)^(n-k) * Ps[k+1] for k in 0:n)
plot(t -> B(t)[1], t -> B(t)[2], 0, 1, legend=false)
scatter!([u[1] for u in Ps], [u[2] for u in Ps])
```



