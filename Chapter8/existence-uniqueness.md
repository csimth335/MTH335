# Existence and Uniqueness

The basic model we have is a initial value problem of the type:

$$~
x'(t) = f(t, x), \quad x(t_0) = x_0$.
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

Example from the book:

$$~
x' = 1 + x^2, \quad x(0) = 0
~$$

This has solution $\tan(x)$ on $(0,\pi/2)$, but blows up at $\pi/2$>

### Existence

> Thm 1. Existence theorem

If $f$ is *continuous* on a rectangle centered at $(t_0, x_0)$, say:

$$~
R = \{ (t,x) : |t - t_0| \leq \alpha, |x - x_0| \leq \beta \}.
~$$

Then the inital value problem has a solution $x(t)$ for $|t - t_0| \leq min(\alpha, \beta/M)$ where $M$ maximizes $|f|$ in $R$.


Example: $f(t,x) = 1 + x^2$. This is continuous everywhere. On an interval of the form $R_{\alpha,\beta}$ centered at $(0,0)$, the maximum value of $f$ will be $1 + \beta^2$. So $\beta/M = \beta/(1 + beta^2)$ This is largest at $beta=1$ or $M=1/2$. So this guarantee only guarantees existence through $-1/2, 1/2$ for $t$, but it is wider.


### Uniqueness

> Thm 2 (p526). If both $f$ and $\partial f/\partial x$ are *continuous* in R, then there is a unique solution for $|t - t_0| \leq min(\alpha, \beta/M)$


### Existence and uniqueness

> Thm 3 If f is Lipshitz then the intial value problem will have a unique solution in some interval.

Precisely, if $f$ is continuous on the strip $a \leq t\leq b$ and $x \in (-\infy, \infty)$ *and* satisfies the inequality for a fixed $L$:

$$~
| f(t,x_1) - f(t, x_2) | \leq L | x_1 - x_2|
~$$

then the solution exists on the interval $[a,b]$.

