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

More formally, Let $r$ be a zero of $f(x)$.
Further, suppose $r$ is a *simple* zero where $f'(r) \neq 0$.

Suppose $x$ is an approximation to $r$. That is, suppose $r = x + h$ for some small $h$, then using Taylor's theorem about $x$, we have:

$$
0 = f(r) = f(x+h) = f(x) + f'(x) \cdot h + \mathcal{O}(h^2)
$$

###

If we were to just ignore the error term and solve for $h$, we would get:

$$
h \approx -f(x)/f'(x)
$$

So $r \approx x - f(x)/f'(x)$. (Not necessarily exactly, but this should be closer.)

###


Iterating the above process yields this algorithm:

$$
x_{n+1} = x_n - f(x_n) / f'(x_n), \quad x_0 \text{ should be near answer}
$$

### Example

Solve $x - 2\sin(x) - 1 = 0$ near $2$.

Start with $x = 2$. We note that $f'(x) = 1 - 2\cos(x)$

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

- We stopped when the method stabilized to 16 *or so* digits

- There is no guarantee it will stabilize though, so we should guard against that

- The goal is to solve $f(r) = 0$, so finding values where $f(r)$ is close to $0$ should also be a good criteria

### Let's implement it...

```
function nm(f, fp, x)
  ## Fill me in...
end
```  

### Programming a stopping value

The basic algorithm is simple:

As long as we have not converged or tried to many times, just update $x$ via `x = x - f(x) / fp(x)`.

The book (p82) has these stopping criteria for converging:

Either

$$
|x_{n+1} - x_n| \leq \delta, \quad \text{ or } |f(x_{n+1})| \leq \epsilon
$$

The first says stop if the `x`'s don't change much. This is what we see in the output. The second says stop if the function value is small.

But this isn't really enough. First, we should add in a bound on the
number of steps.  But, let's look at the latter point. It says stop if the function
value should be close to 0. But what is close to zero?
Answer: it depends on $x$!

###

We have in general $f(fl(x)) = f(x\cdot(1 + \delta)) \approx f(x) +
f'(x) x \delta$. This value depends on $x$! So, it is not unusual to
have a third tolerance depending on $x$. For example, this check on convergence comes from `quadgk`:


>    `while E > abstol && E > reltol * nrm(I) && numevals < maxevals`

`E` is the error and `numevals` the number of evaluations. The `nrm(I)` is *basically* $|x|$. So this checks that $E$ isn't small and $E$ is not small relative to $|x|$ and the number of evaluations is still small.

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
x_{n+1} = \frac{1}{2}(x_n + \frac{S}{x_n}).
$$

It converges to solutions of $x^2 - S = 0$:

$$
x - \frac{x^2 - S}{2x} = x - \frac{x}{2} + \frac{S}{2x} = \frac{x}{2} + \frac{S}{2x} = \frac{1}{2}(x + \frac{S}{x})
$$

## Analysis

Let $f(x)$ be our function and $r$ our root. Define $e_n = x_n - r$. We have the following expansion about $x_n$:

$$
f(x) = f(x_n) + f'(x_n) \cdot (x - x_n) + f''(\xi)/2 \cdot (x - x_n)^2
$$

Using $r$ for $x$ gives:

$$
0 = f(r) = f(x_n) + f'(x_n) \cdot (r - x_n) + f''(\xi)/2 \cdot (r - x_n)^2 
$$

Divide by $f'(x_n)$

$$
0 = f(x_n)/f'(x_n) + (r - x_n) + \frac{1}{2}\frac{f''(\xi)}{f'(x_n)}(e_n)^2.
$$

and rearrange:

$$
x_n - f(x_n)/f'(x_n) -r = \frac{1}{2}\frac{f''(\xi)}{f'(x_n)}(e_n)^2.
$$




But this is just

$$
e_{n+1} = \frac{1}{2}\frac{f''(\xi)}{f'(x_n)}(e_n)^2.
$$

### Theorem 1 (p85)

> Let $f$ be $C^2$ and $r$ be a simple zero of $f$, then there is a *neighborhood* of $r$ and a constant $C$ such that

$$
|e_{n+1}| \leq C \cdot e_n^2.
$$

### Typical convergence

The term on the right is *basically* $1/2 \cdot f''(r)/f'(r)$. If this
is bounded and $e_n$ goes to zero, we have *quadratic convergence*.

We basically need:

* $f''$ is not too big near $r$
* $f'$ is not too small near $r$
* $e_0$ not too far off.

### A function which has problems

Wilkinson proposed this function $f(x) = x^{20} - 1$ to test Newton's method for a root $r=1$. Why?

Notice $f''(x) = 20 \cdot 19 \cdot x^{18}$ is large if $x > 1$ ($f''(1.1) = 2112.\dots$)

But $f'(x) = 20 x^{19}$ is *small* when $x < 1$!. $f'(0.5) = 1.9\cdot 10^{-6}$.

So the Newton algorithm will have trouble

```
using Roots
f(x) = x^20 - 1
newton(f, 0.5)
```

If $x_0 = 0.5$ we have $C$ may be as big as: (Depends if $\xi$ is near $1$ or $0.5$.

```
1/2 * D(f,2)(1) / D(f)(0.5)
```

And after an iteraction, we have $x_n > 1$, so then the second
derivative is big. In this case, $x_1=26214$ so the second derivative is **huge**.

### What can guarantee convergence?

Suppose we have $f$ is $C^2$. If the above assumptions on $f$ are
true, for $\delta > 0$, we have in the ball around $r$ of size
$\delta$ (for some sufficiently small $\delta$ that

$$
c(\delta) = \frac{1}{2} \max|f''(x)| / \min |f'(y)|
$$

Satisfies $\delta \cdot c(\delta) = \rho < 1$. If we start within $\delta$ of $r$, then we have:

$$
|e_1| = |\frac{1}{2}\frac{f''(\xi_1)}{f'(x_0)} e_0^2 \leq c(\delta) |e_0|^2 \leq c(\delta) \delta |e_0| < \rho |e_0|.
$$

Iterating, we can get

$$
|e_n| \leq \rho^n |e_0| \rightarrow 0
$$.


(Note all three things were used!)

## Theorem 2 (p86) Guaranteed convergence

> If $f$ is $C^2$ and *concave up* and *increasing* and has a zero, then it is unique and Newton's method would converge from any starting point.

Why? We have $f' > 0$ and $f'' > 0$ by assumption.

So, from $e_{n+1} = 1/2 f''(\xi)/f'(x_n) e_n^2$ we get $e_{n+1} \geq 0$. This implies $x_n > r$ for $n \geq 1$.

But $e_{n+1} = e_n - f(x_n)/f'(x_n) \leq e_n$ (as $f' > 0$ and $f(x_n) > f(r) = 0$ for $n \geq 1$.

We must have $e_n \rightarrow L \geq 0$, and hence $x_n \rightarrow x = r + L$. Is $L=0$?

But then $L = L - f(x)/f'(x)$ so $f(x) = 0$, or $x = r$.

### Roots with multiplicity

Why did we need to assume "simple zero"? A simple zero means $f'(r)$ is non-zero.


A zero has multiplicity $k$ if $f(x) = (x-r)^k g(x)$ where $g(r)$ is
non-zero. For a zero of multiplicity $k$, $f(r)$, $f'(r), \cdot f^{(k-1)}(r)$ are all 0.



Suppose for simplicity $g(x) = f(x)^k$, for some $k > 1$ where $f$ has a simple 0 at $r$. Then "Newton's method" for $g$ becomes:

$$
x_{n+1} = x_n - \frac{1}{k}\frac{f(x_n)}{f'(x_n)}.
$$

So, not the same. The expansion around $x_n$ does not cancel off the same way.

### Rather

$$
x_{n+1} - r = (x_n - r) - \frac{1}{k}(x_n-r + \frac{f''(\xi)}{2f'(x_n)}(x_n-r)^2) =
\frac{k-1}{k} (x_n-r) + \frac{f''(\xi)}{2kf'(x_n)}(x_n-r)^2.
$$

That is

$$
e_{n+1} = \frac{k-1}{k} e_n + \frac{f''(\xi)}{2f'(x_n)}e_n^2 = \mathcal{O}(e_n)
$$

And not $\mathcal{O}(e_n^2)$.



That is, as $k > 1$, the $(x_n - r)$ term dominates, and we see the
convergence is linear with $\lvert e_{n+1}\rvert \approx (k-1)/k
\lvert e_n\rvert$.

### Example

```
using Roots
f(x) = cos(x) - x
g(x) = f(x)^4
newton(g, 0.7, verbose=true)
```

## Application: division through multiplication

[Newton-Raphson Division](http://tinyurl.com/kjj9w92) is a means to divide by multiplying.

Why would you want to do that? Well, even for computers division is
harder (read slower) than multiplying. The trick is that $p/q$ is
simply $p \cdot (1/q)$, so finding a means to compute a reciprocal by
multiplying will reduce division to multiplication.  (This trick is
used by
[yeppp](http://www.yeppp.info/resources/ppam-presentation.pdf), a high
performance library for computational mathematics.)

###

Well suppose we have $q$, we could try to use Newton's method to find
$1/q$, as it is a solution to $f(x) = x - 1/q$. The Newton update step
simplifies to:

$$
x - f(x) / f'(x) \quad\text{or}\quad x - (x - 1/q)/ 1 = 1/q
$$ 

That doesn't really help, as Newton's method is just $x_{i+1} = 1/q$
-- that is it just jumps to the answer, the one we want to compute by
some other means!

###

Trying again, we simplify the update step for a related function:
$f(x) = 1/x - q$ and then one step of the process is:

$$
x_{i+1} = -qx^2_i + 2x_i.
$$

Now for $q$ in the interval $[1/2, 1]$ we want to get a *good* initial
guess. Here is a claim. We can use $x_0=48/17 - 32/17 \cdot q$. Let's check
graphically that this is a reasonable initial approximation to $1/q$:

```
using Gadfly
g(q) = 1/q
h(q) = 1/17 * (48 - 32q)
plot([g,h], 1/2, 1)
```

###

It can be shown that we have for any $q$ in $[1/2, 1]$ with initial
guess $x_0 = 48/17 - 32/17\cdot q$ that Newton's method will converge
to 16 digits in no more than this many steps:

$$
\log_2(\frac{53 + 1}{\log_2(17)}).
$$

```
a = log2((53 + 1)/log2(17))
ceil(Integer, a)
```

That is 4 steps suffices.

### Why?

We can get a slightly bigger bound by estimating:

$$
|e_{n+1}| \leq \frac{f''(\xi)}{2f'(x_n)} e_n^2 \leq \frac{4}{2\cdot 1} e_n^2
$$

But $|e_0| \leq 1/17$, so we get

```
e0 = 1/17
e1 = 2*e0^2; e2 = 2*e1^2; e3=2*e2^2;e4=2*e3^2;e5=2*e4^2;
(e1,e2,e3,e4,e5)
```

So between 4 and 5 steps, so 5 steps would suffice.

(The better answer comes from computing that in this case this is exact: $e_{n+1} = e_n^2$.)

### Let's see...

For $q = 0.80$, to find $1/q$ using the above we have

```
q = 0.80
x = (1/17) * (48 - 32q)
x = -q*x*x + 2*x
x = -q*x*x + 2*x
x = -q*x*x + 2*x
x = -q*x*x + 2*x
```

Timing this shows the method to be slightly faster than a regular
division.
