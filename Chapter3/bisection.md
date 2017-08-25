# Bisection Method

> The Intermediate Value Theorem: Let $f(x)$ be a *continuous* function on $[a,b]$ with the property that $f(a)$ and $f(b)$ have a different sign ($[a,b]$ is a bracket). Then there exists a value $c$ in $[a,b]$ with $f(c) = 0$.

This gives us a guarantee that under some assumptions the equation $f(x) = 0$ has a solution in the interval.

But it does not tell us what a value of $c$ is.

## A recipe to find $c$

Consider the following algorithm starting with $[a,b]$ and $f$ as in the IVT and, say, $f(a) < 0$.

* compute the midpoint $c = (a+b)/2$

* compute $f(c)$

----

- If $f(c) == 0$ we are done

- If $f(c) < 0$ then our *new* interval is $[c,b]$

- If $f(c) > 0$ our *new* interval is $[a,c]$

[Repeat](http://calculuswithjulia.github.io/limits/intermediate_value_theorem.html#Bolzanoandthebisectionmethod).

###

What does this algorithm produce? At each step we get a value of $c$. To distinguish, call them $c_i$. Then:

* we have $f(c_i) = 0$ for some $i$ and we are done; or

* we have $f(c_i) \neq 0$ for all $i$.

In the latter case, what to do?

###

Let $c = \lim_i c_i$. This exists as the sequence is clearly Cauchy ($|x_n - x_{n+m}| \leq C2^{-n}$). Then:

* it must be that $c$ exists! *And*
* the value satisfies: $f(c) = 0$.

Why? Split the values $c_i$ into those that have $f(c_i) < 0$ and those that have $f(c_i) > 0$. Call these sequences $l_i$ and $u_i$.

If a sequence is infinite, it must converge to $c$. If both are infinite, then one limit is less than or equal to $0$, the other greater than or equal to $0$, so must be $0$.

If a sub-sequence is finite, say terminating at $N$. The $c_i, i \geq N$ has $f(c_i)$ all of the same sign. So in the choice which endpoint to replace $[a,b]$ one is always chosen. Say $f(a) > 0$ and $f(c_i) < 0$ for all $i > N$. It must be that $c_i$ converges to $a$, so we have $f(c_i)$ converges to $f(a)$ which is positive, but each $f(c_i)$ is negative. So this can't happen.

## Bisection method in floating point

The above is true mathematically, but can it be true in floating point?

* The $c_i$ in any algorithm are necessarily finite in number, so they
  can't take on any value, just machine numbers. Since machine numbers
  are rational numbers in binary, numbers like $\sqrt{2}$ can not be
  represented exactly, so the value of $c$ is not guaranteed!

* Even the simple statement $c = (a+b)/2$ has problems! $x+y$ can
  overflow, It isn't even guaranteed that $fl((x+y)/2)$ is in $[x,y]$
  with some rounding modes!

### What to do

Use thresholds:

Stop the algorithm if

* either $|f(c_i)| < \epsilon$

* or $|b_i - a_i| < \delta$.

## An algorithm (take 1)

```
function bisectme(f, a, b)
    delta, epsilon=4eps(), 1e-12
	@assert f(a) * f(b) < 0  # check bracket
    c = (a + b)/2
	while abs(f(c)) >= epsilon && (b-a) >= delta
	  c = (a + b) / 2
	  f(c) == 0.0 && return(c)
	  f(c)*f(a) < 0 ? (b = c) : (a = c)
	end
	return(c)
end
```

###

Solve $f(x) = e^x - \sin(x) = 0$ in the interval $[-4, -3]$:

```
f(x) = exp(x) - sin(x)
xstar = bisectme(f, -4, -3)
xstar, f(xstar)
```

## How fast does this converge?

Theoretically, at each step we have $a_i < c_i < b_i$. Let $c$ be a solution. Then how big is $|c - c_i|$?

$$~
|c - c_i| \leq \frac{1}{2} (b_i - a_i)
~$$

But:

$$~
b_i - a_i = (1/2)(b_{i-1} - a_{i-1}) = (1/2)^2 (b_{i-2} - a_{i-2}) = \cdots = 2^{i}(b_0 - a_0).
~$$ 

So,

$$~
|c - c_i| \leq \frac{1}{2^{i+1}} (b_0 - a_0).
~$$

### Example

If we have $a_0, b_0 = -4, -3$, how many steps to get $|c - c_i| < 10^{-15}$?

We'd need to solve for the smallest $i$ so that:

$$~
\frac{1}{2^{i+1}} (b_0 - a_0) = \frac{1}{2^{i+1}} < 10^{-15}
~$$

```
ceil(log2(1e-15) - 1)
```

## Can we do better?

Mathematically, we can always subdivide $[a,b]$ via $c=(a+b)/2$. Not so with the computer.

We said that using
`c = (a+b)/2` has issues (overflow, loss of low bits, magnified errors...)

We avoid some of that with `c = a + (b-a)/2`

Or we could have tried `c = a + b/2 - a/2`

These aren't all the same:

```
a, b = prevfloat(0.0), nextfloat(0.0)
(a + b)/2, a + (b-a)/2, a + b/2 - a/2
```


```
b = prevfloat(Inf)
a = prevfloat(prevfloat(b))
(a + b)/2, a + (b-a)/2, a + b/2 - a/2
```

### 

The problem is studied in [this paper](https://hal.archives-ouvertes.fr/hal-00576641v1/document).

Without care, the following two properties of $m(I)$ are not guaranteed:

* that $m(I) \in I$, or
* for all machine numbers $v$, $|c - v| \geq |c - M(I)|$ for $c = (a + b)/2 \in R$.


That is, we can't be sure that this will stop appropriately

```
Verbatim("""
c = (a + b)/2
if a < c < b
   ....
end
""")
```


### One solution

In `Julia`'s `Roots` package they use something different by Jason [Merrill](http://squishythinking.com/2014/02/22/bisecting-floats/)

We can see the following:

```
Verbatim("""
x1_int = reinterpret(UInt64, abs(x1))
x2_int = reinterpret(UInt64, abs(x2))
unsigned = reinterpret(Float64, (x1_int + x2_int) >> 1)
""")
```

### What does reinterpret do...

In practice this converts the (positive) floating point numbers into an ordered set of integers:


```
as = rand(1)
for i in 1:9
  push!(as, nextfloat(as[end]))
end
map(x -> bits(reinterpret(UInt64, x)), as)
```

###

Using this for finding the midpoint (suitably configured to handle mixed signs) means that in no more than 64 steps this process is guaranteed to converge. This means we can skip the check on the size of $f(x_n)$ to look something like:

```
Verbatim("""
while a < midpoint(a,b) < b
  do something...
end
""")
```

What happens at each step: we must have:

* either `f(c) == 0` (exactly), 

- one of `f(c) * f(a) < 0` or `f(c) * f(b) < 0`

So if the answer is not exact, we guarantee that this condition holds for the returned value of `c`

> It must be that `f(prevfloat(c)) * f(nextfloat(c)) <= 0`.

(Even without IVT).

### the Roots package

```
using Roots
f(x) = sin(x)
c = fzero(f, 3, 4)
c, f(c), sign(f(prevfloat(c))) * sign(f(nextfloat(c)))
```

###

What about $f(x) = 1/x$? It has no zero, but it does have a zero crossing at $0$ which will get picked up:

```
f(x) = 1/x
c = fzero(f, -1, 1)
c, f(c), sign(f(prevfloat(c))) * sign(f(nextfloat(c)))
```
