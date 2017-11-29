# Existence and Uniqueness

The basic model we have is a initial value problem of the type:

$$~
x'(t) = f(t, x), \quad x(t_0) = x_0.
~$$

Example,

$$~
x'(t) = a.
~$$

Here $f(t,x) = a$ for some constant $a$. We know that we can "integrate" to get $x(t) = at$. The formula for the velocity when acceleration is constant.

What about when there is a drag:

$$~
x'(t) = a - cx(t)
~$$

Then $f(t,x) = a-cx$. Is there a simple solution?

Fact: not all initial-value problems will have a solution.

Fact: even if there are solutions, they may blow up.


Let's see if the computer can help:

```
using SymPy
u = SymFunction("u")
@vars x a c x0
f(t, u) = a - c*u
dsolve(u'(x) - f(x, u(x)), x, (u, 0, x0))  # dsolve(eqn, variable, (fn, x0, fn(x0))
```


So here we have a solution, but we don't know its qualitative
properties without more work.


This example from the book shows that solutions may not exist for all
times $t$:

$$~
x' = 1 + x^2, \quad x(0) = 0
~$$

This has solution $\tan(x)$ on $(0,\pi/2)$, but blows up at $\pi/2$.


The argument goes: at $t=0$ $x'$ is positive, so $x$ increases, as
such $x'$ increases too. So at a minimum this function will be concave
up, but in this case it keeps increasing so that it blows up in finite
time -- the solution is $y=\tan(x)$.




Fact: There may be more than one solution!

Example from the book:

$$~
f(x) = x^{2/3}, \quad x(0) = 0
~$$

Here we find one with `SymPy`


```

dsolve(u'(x) - u(x)^(2//3), x, (u, 0, 0))
```

So we get one solution, but do note here the constant function $y=0$
is *also* a solution.



## We can visualize

```
using Plots
F(t, u) = 1 + u^2
plot(VectorField(F), xlim=(0,pi/3), ylim=(0,2))
plot!(tan)
```


```
using Plots
F(t, u) = cbrt(u^2)
plot(VectorField(F), xlim=(0,3), ylim=(-1,1))
plot!(x->x^3/27)
plot!(zero)
```

and

```
a, c, x0 = 1, 1, 0
f(x,u) = a - c*u
ex = dsolve(u'(x) - f(x, u(x)), x, (u, 0, x0))
plot(VectorField(f), xlim=(0,1), ylim=(-1,1))
plot!(lambdify(rhs(ex)))
```




### Existence

There are theorems that guarantee existence; theorems that guarantee
uniqueness, and theorems that guarante *both* existence and
uniqueness. These theorems must put some assumption on $f$.


> Thm 1. Existence theorem [Peano](https://en.wikipedia.org/wiki/Peano_existence_theorem)

If $f$ is *continuous* on a rectangle centered at $(t_0, x_0)$, say:

$$~
R = \{ (t,x) : |t - t_0| \leq \alpha, |x - x_0| \leq \beta \}.
~$$

Then the inital value problem has a solution $x(t)$ for $|t - t_0| \leq min(\alpha, \beta/M)$ where $M$ maximizes $|f|$ in $R$.


Example: $f(t,x) = 1 + x^2$. This is continuous everywhere. On an
interval of the form $R_{\alpha,\beta}$ centered at $(0,0)$, the
maximum value of $f$ will be $1 + \beta^2$. So $\beta/M = \beta/(1 +
beta^2)$ This is largest at $beta=1$ or $M=1/2$. So this guarantee
only guarantees existence through $-1/2, 1/2$ for $t$, but it is wider
-- though we say that it does blow up by $t=\pi/2$.


### Uniqueness

> Thm 2 (p526). If both $f$ and $\partial f/\partial x$ are
> *continuous* in R, then there is a unique solution for $|t - t_0|
> \leq min(\alpha, \beta/M)$


Example: $f(t,x) = 1 + x^2$ had $\partial f/\partial x = 2x$ so is
continuous. Hence the solution that exists will be unique -- it just
isn't good for all time $t$.

Exmaple: $f(t,x) = x^{2/3}$. As $\partial f/\partial x = (2/3)x^{-1/3}$
this function does *not* have a continuous derivative at $0$. So there
is *no* uniquess guaranteed if started at $0$. However, if starting at
$t=1S, then there is.


### Existence and uniqueness

> Thm 3 If f is Lipshitz then the intial value problem will have a
> unique solution in some interval. [Picard-Lindelof](https://en.wikipedia.org/wiki/Picard%E2%80%93Lindel%C3%B6f_theorem) theorm

Precisely, if $f$ is continuous on the strip $a \leq t\leq b$ and $x
\in (-\infy, \infty)$ *and* satisfies the following inequality for a fixed $L$:

$$~
| f(t,x_1) - f(t, x_2) | \leq L | x_1 - x_2|
~$$

then the solution exists on the interval $[a,b]$.



Note: this says $f$ is *Lipschitz* in the $x$ variable where the
constant does not depend on $t$. For one-dimensional problems,
Lipschitz is stronger than continuity but weaker than assuming a
derivative. (If a derivative exists, it must be bounded by $L$.)

Example: For $f(t,x) = x^{2/3}$ this can't be around $x=0$ as the
derivative blows up near $0$.



