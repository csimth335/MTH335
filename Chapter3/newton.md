# Newton's method

## Bisection

The bisection method has many advantages:

* given a bracket, can be guaranteed to converge

* will find a root or the next best thing in floating point

However, ...

* slow -- many steps

* needs a bracket

* won't work with roots of functions like $f(x) = (x-2)^2$

## Newton's method

See this [algorithm](http://calculuswithjulia.github.io/derivatives/newtons_method.html#Examples)

Basic idea: approximate function by tangent line and find that intersection.

More formally, Let $r$ be a zero of $f(x)$. Suppose $r = x + h$ for some small $x$, then:

$$
0 = f(r) = f(x+h) = f(x) + f'(x) \cdot h + \mathcal{O}(h^2)
$$

###

If we were to just ignore the error term and solve for $h$, we would get:

$$
h \approx -f(x)/f'(x)
$$

So $r \approx x - f(x)/f'(x)$. But not exactly

###


Iterating yields this algorithm:

$$
x_{n+1] = x_n - f'(x_n) / f(x_n), \quad x_0 \text{ should be near answer}
$$

### Example

Solve $x - 2sin(x) - 1 = 0$ near $2$.

Start with $x = 2. We note that $f'(x) = 1 - 2\cos(x)$

```
f(x) = x - 2sin(x) - 1
fp(x) = 1 - 2cos(x)
x = 2
x = x - f(x) / fp(x)
```

```
x = x - f(x) / fp(x)
```


```
x = x - f(x) / fp(x)
```


```
x = x - f(x) / fp(x)
```


```
x = x - f(x) / fp(x)
```


```
x = x - f(x) / fp(x)
```

### Termination

When do we stop?

- the method stabilizes to 16 *or so* digits

- the method doesn't stabilize after many iterations



### made for floating point not exact math

Look at finding the square root of 2 starting at 2. We use $f(x) = x^2 - 2$, so $x - f(x)/f'(x) = x - (x^2-2)/(2x) = x/2 - 1/x$

```
x = 2//1
x = x/2 + 1/x
```

```
x = x/2 + 1/x
```


```
x = x/2 + 1/x
```


```
x = x/2 + 1/x
```


```
x = x/2 + 1/x
```


```
x = x/2 + 1/x
```

The floating point doesn't go crazy, the digits just get refined.

### Special cases are quite old

The [Babylonian](https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method) method is this algorithm:

$$
x_{n+1} = \frac{1}{2}(x_n + \frac{S}{x_n}.
$$

It converges to solutions of $x^2 - S = 0$:

$$
x - (x^2 - S) / (2x) = x - x/2 + S/(2x) = x/2 + S/(2x) = \frac{1/2}(x + S/x)
$$

## Analysis



###
...

### Roots with multiplicity

Suppose $\alpha$ is a simple zero for $f(x)$.  (The value $\alpha$ is
a zero of multiplicity $k$ if $f(x) = (x-\alpha)^kg(x)$ where
$g(\alpha)$ is not zero. A simple zero has multiplicity $1$. If
$f'(\alpha) \neq 0$ and the second derivative exists, then a zero
$\alpha$ will be simple.)  Around $\alpha$, quadratic convergence should
apply.


However, consider the function $g(x) = f(x)^k$ for some integer
$k \geq 2$. Then $\alpha$ is still a zero, but the derivative of $g$
at $\alpha$ is zero, so the tangent line is basically flat. This will
slow the convergence up. We can see that the update step $g'(x)/g(x)$
becomes $(1/k) f'(x)/f(x)$, so an extra factor is introduced.

The calculation that produces the quadratic convergence now becomes:

$$
x_{i+1} - \alpha = (x_i - \alpha) - \frac{1}{k}(x_i-\alpha + \frac{f''(\xi)}{2f'(x_i)}(x_i-\alpha)^2) =
\frac{k-1}{k} (x_i-\alpha) + \frac{f''(\xi)}{2kf'(x_i)}(x_i-\alpha)^2.
$$

As $k > 1$, the $(x_i - \alpha)$ term dominates, and we see the
convergence is linear with $\lvert e_{i+1}\rvert \approx (k-1)/k
\lvert e_i\rvert$.
