# Illustrations of numerical integration


## Newton Cotes formulas and errors

A Newton-Cotes formula uses an interpolating polynomial over $[a,b]$ to estimate $f$ and in turn the integral of $f$ over $[a,b]$. The nodes are evenly spaced, e.g.: `{a}`, `{a,b}`, `{a,(a+b)/2, b}`, ...

```
linspace(a,b,n=251) = range(a,stop=b, length=n)
function interpolating_nodes(a, b, n)
  n == 0 && return [a]
  collect(linspace(a,b,n+1))
end

function l(i, nodes)
  length(nodes) == 1 && return(x -> 1.0)
  x -> begin
    prod((x-nodes[j])/(nodes[i]-nodes[j]) for j in eachindex(nodes) if i !== j)
  end
end

function poly_interp(f, nodes)
  x -> sum(f(nodes[i]) * l(i, nodes)(x) for i in eachindex(nodes))
end

function quadrature(f, a, b, nodes)
	As = [quadgk(l(i, nodes), a, b)[1] for i in eachindex(nodes)]
	sum(f(nodes[i]) * As[i] for i in eachindex(nodes))
end

function newton_cotes(f, a, b, n)
  nodes = interpolating_nodes(a, b, n)
  quadrature(f, a, b, nodes)
end
```

```
using Plots, QuadGK
f = sin
a, b = 0, pi/2
plot(f, a, b)
plot!(poly_interp(f, interpolating_nodes(a, b, 0)), color=:red)
plot!(poly_interp(f, interpolating_nodes(a, b, 1)), color=:brown)
plot!(poly_interp(f, interpolating_nodes(a, b, 2)), color=:yellow)
```

How accurate for the sine function

```
quadgk(f, a, b)  # 1.0
```

```
[newton_cotes(f, a, b, i) for i in 0:6] .- 1.0
```

Should be exact for polynomials of degree $n$ or less -- but not necessarily more:

```
a, b = 0, 1
function err(n)
  fn = x -> x^n  # x-> x^(n+1)
  nodes = interpolating_nodes(a, b, n)
  p = poly_interp(fn, nodes)
  newton_cotes(p, a, b, n) - quadgk(fn, a, b)[1]
end
[err(n) for n in 0:6]
```


## Gauss quadrature

Legendre polynomials satisfy $P_0=1$, $P_1(x) = x$, and $(n+1)P_{n+1}(x) = (2n+1)xP_n(x) -nP_{n-1}(x)$.

```
using SymPy
@vars x
ps = Sym[1, x]
for n = 1:5
   pn, pn_1 = ps[end], ps[end-1]
   p =( (2n+1) * x*pn - n*pn_1 ) * (1// (n+1))
   push!(ps, simplify(p))
end
ps
```


We were told these were *orthogonal*:

```
w = 1
[integrate(ps[i] * ps[j] * w, (x, -1, 1)) for i in eachindex(ps), j in eachindex(ps) if i < j]
```

We were told that these give exact quadrature for polynomials in $\Pi_{2n+1}$.

```
n = 5
a,b = -1, 1
pn = ps[n+1]  # 1 - based
nodes = solve(pn)  # solve p(x) == 0
```

```
function err(i)
   fn = x -> x^i
   Fn = x -> x^(i+1)/(i+1)
   quadrature(fn, a, b, N.(nodes)) - (Fn(b) - Fn(a))
end
n = length(nodes) - 1
[err(i) for i in 0:2n+1]
```

But 10th degree polys are not necessarily exact:

```
fn = x -> x^10
Fn = x -> x^11/11
quadrature(fn, a, b, N.(nodes)) - (Fn(b) - Fn(a))
```


## Error

Thm 4 on p497 has: if $f$ is in $C^{2n}([a,b])$ where $g(x)$ is of degree $n$ (so that there are $n$ nodes) then (note $n-1$):

$$~
E = \int_a^b f(x) w(x)dx - \sum_{i-1}^{n-1} f(x_i) A_i
= \frac{f^{(2n)}(\xi)}{(2n)!} \int_a^b q^2(x) w(x) dx
= \frac{f^{(2n)}(\xi)}{(2n)!} \langle q,q \rangle_w
~$$

Here $q(x) = \Pi(x - x_i)$.

For this $n=5$ we have the exact integral

```
q = prod(x-xi for xi in nodes)
integrate(q*q*w, (x, a, b))
```

So for $f(x) = x^{10}$  we have $f^{(10)}(\xi)/10! = 1$ and so the error is

```
float(integrate(q*q*w, (x, a, b)))
```

Which matches what was previously found.


### Simpson's error

If we used 5 points and simpson's formula, then we would apply simpsons over $x_0, x_1, x_2$ and $x_2, x_3, x_4$. How accurate would that be?

```
nodes = N.(nodes) # make floating point
quadrature(fn, nodes[1], nodes[3], nodes[1:3]) +
quadrature(fn, nodes[3], nodes[5], nodes[3:5]) - (Fn(1) - Fn(-1))
```

So quite far off by comparison

## QuadGk

The [QuadGK](https://github.com/JuliaMath/QuadGK.jl) package, as seen, performs integration. The name is now less opaque:

* `Quad` as we are performing quadrature
* `G` For Guass
* `K` is for Kronrod, who added a computationally important step

The basic idea is to adaptively integrate over a region using Gaussian quadrature. If the estimated error in a region is too large, the region is split in two and Gaussian quadrature is used to investigate each piece. The method is quite efficient.

For example, with errors like $1/n$, $1/n^2$ and $1/n^4$ for Riemann, Trapezoid and Simpsons, we see that it might take 10^4 steps to get machine tolerance accuracy.

For example, to integrate $\sin(x)$ over $[0, \pi]$ using Simpson's we have

```
simpson(f, a, b) = 1/6 * (f(a) + 4f((a+b)/2) + f(b))
a, b = 0, pi
n = 10_000
xs = linspace(a, b, n)
sum(simpson(sin, a, b)*(b-a) for (a,b) in zip(xs[1:end-1], xs[2:end])) - 2.0
```

How many function calls is this?

```
mutable struct CountingFunction
  n::Int
  f::Function
  CountingFunction(f) = new(0, f)
end
(F::CountingFunction)(x) = (F.n += 1; F.f(x))
```

And

```
Sin = CountingFunction(sin)
sum(simpson(Sin, a, b)*(b-a) for (a,b) in zip(xs[1:end-1], xs[2:end])) - 2.0
```

How many steps:

```
Sin.n
```

Whereas for `quadgk`:

```
Sin = CountingFunction(sin)
quadgk(Sin, 0, pi)
```

and

```
Sin.n
```
