# Iteration as fixed points

## General Framework

A general framework for Newton's method is

$$
x_{n+1} = F(x_n), \quad (n\geq 0)
$$

What conditions on $F$ ensure that this sequence will converge?

### Newton's Method

We have

$$
F(x_n) = x_n - \frac{f(x_n)}{f'(x_n)}.
$$

This converges in some area around the root provided there is a bound on the value

$$
\frac{f'(y)}{2f(x)}
$$

For $x$ and $y$ in this "area."

## A fixed point

Suppose $x_n \rightarrow s$. Then if $F$ is continuous we have

$$
s = \lim x_{n+1} = \lim F(x_n) = F(s)
$$

That is $s = F(s)$, so $s$ is a **fixed point** of $F$.

### What assumptions on $F$ will ensure a fixed point exists?

> Theorem: Contractive Mapping Theorem

Suppose $C \subset R$, and $F$ is a *contractive mapping*, that is there exists $\lambda < 1$ with

$$
| F(x) - F(y) | \leq \lambda |x - y|
$$

The $F$ has a unique fixed point, $s$. Furthermore, for any $x_0$ in $C$, the sequence $x_{n+1} = F(x_n)$ will converge to $s$.

### Example

Let $f(x) = x^2 - 2$ and $C$ is a ball around $s=\sqrt{2}$. Then Newton's method has $F(x) = x - f(x)/f'(x)$, so we have:

$$
|F(x) - F(y)| = |x - f(x)/f'(x) - y - f(y)/f'(y)| \leq |x - y| + |f(x)/f'(x)| + |f(y)/f'(y)|.
$$

But $f(r) = 0 = f(x) + f'(x)(x-r) + \mathcal{O}((x-r)^2)$, (similarly for $y$) which means:

$$
|f(x) / f'(x)| = |x - r   + \mathcal{O}((x-r)^2)| \leq \delta |x-r|
$$

All told then

