# Gaussian Quadrature

Our goal: approximate the definite integral of $f$ over $[a,b]$ by a sum:

$$~
\int_a^b f(x) dx = \sum_{i=0}^n f(x_i) A_i.
~$$

In fact, we generalize this to include a positive *weight* function, $w(x)$:

$$~
\int_a^b f(x) w*x( dx = \sum_{i=0}^n f(x_i) A_i.
~$$

With $f(x)$ interpolated by the polynomial $\sum f(x_i) l_i(x)$, we have

$$~
A_i = \int_a^b w(x) \prod_{j=0, j \neq i}^n \frac{x-x_j}{x_i - x_j} dx
~$$.

Goal: can we choose the weights in such a way that this is exact for polynomials of a certain degree?

## Orthogonal

Let $\Pi_n$ be the polynomials of degree $n$.

Say a function $q$ is $w$-orthoganal to $\Pi_n$ if for any $p \in \Pi_n$

$$~
\int_a^b q(x) p(x) w(x) dx = 0
~$$

### Example: Legendre polynomials

Let $P_0(x) = 1$ and $P_1(x) = x$. Define recursively $P_n(x)$ by:

$$~
(n+1)P_{n+1}(x) = (2n + 1) x P_n(x)  - n P_{n-1}(x).
~$$

There are the [Legendre polynomials](https://en.wikipedia.org/wiki/Legendre_polynomials). Here are the first few:

```
using SymPy
x = symbols("x")
ps = Sym[1, x]
for n = 1:5
   pn, pn_1 = ps[end], ps[end-1]
   p =( (2n+1) * x*pn - n*pn_1 ) * (1// (n+1))
   push!(ps, simplify(p))
end
ps
```

Now, take $a=-1$, $b=1$ and $w(x) = 1$. Are these orthogonal? That is, do we have:

$$~
\int_a^b p_i(x) p_j(x) w(x) dx = \int_{-1}^1 p_i(x) p_j(x) dx = 0?
~$$

We can check. For example,

```
[integrate(ps[end] * ps[i], (x, -1, 1)) for i in 1:length(ps)-1]
```

So $p_i$ is orthogonal to any linear combination of the $p_j, j < i$. But these polynomials span the space of polynomials of degree $i-1$. So they are $w$-orthogonal.

### Gaussian quadrature theorem

> (p 493) If $q(x)$ is a non-zero polynomial of degree $n+1$, $w$-orthogonal to $\Pi_n$ and $x_0, x_1, \dots, x_n$ are the *zeros* of $q$, then the quadrature formula will be exact for all functions in $\Pi_{2n+1}$.

Before seeing why, let's see that it works with $P_4$:

```
p4 = ps[5] # 1/8 *(35x^4 - 30x^2+3)
xis = collect(keys(polyroots(ps[5])))
map(N, xis)
```

We define $l_i$ via:

```
function l(i)
out = 1
n = length(xis)-1 # 0, ..., n => 1, ..., n+1
for j in 0:n
  if j != i
    out = out * (x-xis[j+1])/(xis[i+1] - xis[j+1])
  end
end
out
end
```

With these, we define $A_i$ via:

```
Ais = [integrate(l(i), (x, -1,1)) for i in 0:3]
```

Then the claim is $\sum f(x_i) A_i$ will be exactly the integral $\int f(x) dx$ for any $7$th degree polynomial or less. Let's try a polynomial:

```
f(x) = 5x^5 - 4x^4
integrate(f(x), (x, -1, 1))
```

And compare with:

```
sum([f(xi) * Ais[i] for (i,xi) in enumerate(xis)])
```

Wow, not even close. But let's simplify:

```
sum([f(xi) * Ais[i] for (i,xi) in enumerate(xis)]) |> simplify
```

Now let's try for some "arbitrary" polynomial:

```
f(x) = exp(x)
p = series(f(x), x, n=8) |> removeO # 7th degree poly
```

```
integrate(p, (x, -1, 1))
```

And compare with:

```
sum([subs(p,x,xi) * Ais[i] for (i,xi) in enumerate(xis)]) |> simplify
```

The theorem does *not* guarantee this is true for 8th degree polynomials:

```
p = series(f(x), x, n=9) |> removeO
integrate(p, (x, -1,1))
```

Compare with

```
sum([subs(p,x,xi) * Ais[i] for (i,xi) in enumerate(xis)]) |> simplify
```


### Proof

We have $q$ given. Take $f$  a polynomial of degree $2n+1$ or less. Then we can do polynomial long division to write:

$$~
f(x) = q(x) p(x) + r(x)
~$$

Where the degree of $r(x)$ is less than that of $q(x) = n+1$. We can evaluation at $x_i$ to see that:

$$~
f(x_i) = q(x_i) p(x_i) + r(x_i) = 0 \cdot p(x_i) + r(x_i) = r(x_i).
~$$

So we get:

$$~
\int_a^b f(x) w(x) dx = \int_a^b [(q(x)p(x)w(x)) + (r(x) w(x)) ] dx = \int_a^b r(x) w(x) dx.
~$$

And

$$~
\sum_{i=0}^n A_i f(x_i) = \sum_{i=0}^n A_i r(x_i).
~$$

But, when $A_i$ is defined as it is, it is known the sum is exact for $n$th degree polynomials. So we can equate the two things we just did to get:

$$~
\int_a^b f(x) w(x) dx  = \sum_{i=0}^n A_i f(x_i)
~$$

Which is what was to be shown.

### Fact

If $q(x)$ is as assumed, it will have real, simple roots all inside $(a,b)$.

Why?

> Thm. If $q$ is $w$-orthogonal to $\Pi_n$, then it has at least $n+1$ sign changes on $(a,b)$.

First, $1$ is in $\Pi_n$ and $\int q(x) 1 w(x) =0$, so $q$ must change sign, as $w > 0$.

Suppose, $q$ changes sign only $r$ times, $r \leq n$. Then one can partition $(a,b)$ by $t_0=a < t_1 < \cdot < t_r < t_{r+1} = b$ so that $q$ does not change sign on each partition.

Form the polynomial $p(x) = (x-t_1) \cdots (x-t_r)$. Then $p$ is in $\Pi_n$. and $p$ does not change sign on $(t_i, t_{i+1})$. So

$$~
\int_a^b q(x) p(x) w(x) dx \neq 0
~$$

But by orthogonality, this isn't the case, so there is a contradiction and there are more sign changes thatn assumed.

## Error

> Theorem 4 (p497)

Let $E$ be the error:

$$~
E = \int_a^b f(x) dx - \sum_{i=1}^{n-1} A_i f(x_i).
~$$

Where $f$ is $C^{2n}$. Then the error term can be represented as:

$$~
E = \frac{f^{2n}(\xi)}{(2n)!} \int_a^b \prod_{i=0}^{n-1}(x-x^i)^2 w(x) dx.
~$$

(For polynomials of degree $\leq 2n-1$ it is clear that $f^{2n}(\xi) = 0$ and so $E=0$.)

## The FastGaussQuadrature package illustrates this

[FastGaussQuadrature](https://github.com/ajt60gaibb/FastGaussQuadrature.jl)

## The quadgk function

In `Julia`, the [quadgk](https://github.com/JuliaLang/julia/blob/master/base/quadgk.jl) is a built-in function  provided to compute one-dimensional integrals. We have:

* `quad` is for quadrature, an old-term now meaning integrals
* `g` is Gauss
* `k` is Kronrod

The [Kronrod](https://en.wikipedia.org/wiki/Gauss%E2%80%93Kronrod_quadrature_formula) part is a modification to the choice of Gauss points.

The `quadgk` function is adaptive, in that it compute an estimated integral over a region. If the error is not small enough, it subdivides that region and tries again on each subdivision. The Kronrod part makes the computation over subdivisions more efficient.

The function returns *both* an answer and an error estimate:

```
quadgk(sin, 0, pi)
```

Here the *exact*  answer of $2$ is found, but the algorithm used estimates the error by `1e-12`. (As the error is 0, this is a good bound, though larger than needed.)

Other integrals are possible:

```
quadgk(x->exp(x^2), -1, 1)
```

