# Iteration as fixed points

## General Framework

A general framework for Newton's method is

$$~
x_{n+1} = F(x_n), \quad (n\geq 0)
~$$

Where $F(u) = u - f(u)/f'(u)$.

What conditions on $F$ ensure that this sequence will converge? For the specific case of Newton's method, the following can work:

Suppose $f(z) = 0$ and $f$ is twice differentiable around $z$. 
If there is some $\delta > 0$ such that $|f''(y)/f'(x)| < 2/\delta$ whenever $|x-z|, |y-z| < \delta$, then the algorithm will converge to $z$.

## A fixed point

Suppose $x_n \rightarrow s$. Then if $F$ is continuous we have

$$~
s = \lim x_{n+1} = \lim F(x_n) = F(s)
~$$

That is $s = F(s)$, so $s$ is a **fixed point** of $F$.

### What general assumptions on $F$ will ensure a fixed point exists?

> Theorem: Contractive Mapping Theorem

Suppose $C \subset R$, and $F$ is a *contractive mapping*, that is there exists $\lambda < 1$ with

$$~
| F(x) - F(y) | \leq \lambda |x - y|
~$$

The $F$ has a unique fixed point, $s$. Furthermore, for any $x_0 $ in $C$, the sequence $x_{n+1} = F(x_n)$ will converge to $s$.

### Example

Let $f(x) = x^2 - s$ and $C$ is a ball around $\sqrt{s}$. Then Newton's method has $F(x) = x - f(x)/f'(x)$, so we have:

Then $F(x) = x - (x^2 - s)/(2x) = x/2 - s/(2x)$. So

$$~
F(x) - F(y) = \frac{x-y}{2} - \frac{s}{2}[\frac{1}{x} - \frac{1}{y}] = (x-y) \cdot \frac{1}{2}[1 + \frac{s}{xy}].
~$$

Thus,

$$~
\frac{|F(x) - F(y)|}{|x-y|} \leq \frac{1}{2}[1 + \frac{s}{xy}].
~$$

For a specific case with $s=2$ we can use $C=(\sqrt{2}-\delta, \sqrt{2}+\delta)$ where $\delta = 1/10$, say.

```
s, delta = sqrt(2), 1/10
1/2 * (1 + s/( (s-delta)*(s-delta)))
```

## Proof of contractive mapping theorem

We have

$$~
|x_n - x_{n-1}| = |F(x_{n-1}) - F(x_{n-2})| \leq \lambda |x_{n-1} - x_{n-2}|.
~$$

So, by repeating, we get

$$~
|x_n - x_{n-1}| \leq \lambda^{n-1} |x_1 - x_0|.
~$$

This implies the sequence $x_n$ will converge:

We write

$$~
x_n = (x_n - x_{n-1}) + (x_{n-1} - x_{n-2}) + \cdots + (x_1 - x_0) + x_0
~$$

So the sequence of $x_n$ will converge only if the series $\sum_{i=0}^n (x_i -x_{i-1})$ converges. In this case it is easy to see, as

$$~
\sum_{i=0}^n (x_i -x_{i-1}) \leq \sum \lambda^{i-1} |x_1 - x_0| = |x_1 - x_0| \cdot \sum \lambda^{i-1}  \rightarrow \frac{1}{1 - \lambda} |x_1 - x_0|.
~$$

Let $s = \lim x_n$. Then $F(s) = s$ by continuity (why is $F$ continuous).

Is this fixed point unique? Suppose $s$ and $t$ are different fixed points in $C$. Then

$$~
|s - t|  = |F(s) - F(t)| \leq \lambda |s-t| < |s -t|
~$$

A contradiction.

### Cauchy

A Cauchy sequence is one where for any $\epsilon > 0$, there is an $N$
for which if $n,m \geq N$, then $|x_n - x_m| < \epsilon$. Cauchy
sequences on the real line converge. Another way to prove the
convergence would be to prove that the sequence is cauchy. The book
shows (p103), that this bound could be found:

$$~
|x_n - x_m| \leq \lambda^N |x_1 - x_0| (1 - \lambda)^{-1}.
~$$

Since both $|x_1 - x_0|$ and $(1 - \lambda)^{-1}$ are bounded, some $N$ can be chosen to make this as small as desired.

### Example

Let $F(x) = 4 + 1/3 \cdot \sin(2x)$. The book shows that this is a contractive mapping with $\lambda=2/3$:

$$~
F(x) - F(y) = \frac{1}{3}(\sin(2x) - \sin(2y)) = \frac{1}{3}(2\cos(2\xi))( x- y) = \cos(2\xi) \cdot \frac{2}{3} \cdot (x-y).
~$$

### 

So we have a contractive map. It will converge for *any* starting point, as $C$ did not need specifying. Let's see.

```
function iterate(f, x)
  xn, xn_1 = x, Inf
  while abs(xn - xn_1) > 100 * eps()
    xn, xn_1 = f(xn), xn
  end
  xn
end
```

```
f(x) = 2 + 1/3 * sin(2x)
iterate(f,4), iterate(f, 40)
```

## Error analysis

Suppose $F$ is a contractive map over $C$ and iteration converges to $s$. How fast? Supppose further that $F$ is $C^k$.

Let $e_n = x_n - s$, as before. Then the mean value theorem gives us:

$$~
e_{n+1} = x_{n+1} - s = F(x_n) - F(s) = F'(\xi_n) (x_n - s) = F'(\xi_n) e_n.
~$$

Since $|F'(\xi_m)| < 1$, we must have the sequence $|e_n|$
decreasing. As $F'(\xi_n) \approx F'(s)$, if the latter is small the convergence should be rapid. If it is $0$ even more so.

The book defines $q$ to be the first positive integer with $F^{(q)}(s) \neq 0$. With this, the Taylor series for $F$ about $s$ becomes:

$$~
\begin{align}
F(x_n) - F(s) &= x_{n+1} - s = e_{n+1}\\\\
&= F(s + e_n) - F(s)\\\\
&= [F(s) + F'(s) \cdot e_n + 1/2 F''(s) e_n^2 + \cdots] - F(s)\\\\
&= F'(s) e_n + (1/2) F''(s) e_n + \cdot (1/(q-1)!) F^{(q-1)}(s) e_n^{q-1}(s) + \frac{1}{q!}F^{(q)}(\xi_n) e_n^q \\\\
&= \frac{F^{(q)}(\xi_n)}{q!} e_n^q.
\end{align}
~$$

So that

$$~
\lim_n \frac{|e_{n+1}|}{|e_n|^q} = \lim \frac{1}{q!}F^{(q)}(\xi_n) \rightarrow \frac{1}{q!}F^{(q)}(s).
~$$

So the *order of convergence* is atleast $q$.

### Newton, order of convergence at least $2$

For Newton's method, $F(u) = u - f(u)/f'(u)$. We have

$$~
F'(u) = 1 - \frac{f'(u)^2 - f(u) f''(u)}{f'(u)^2} = \frac{f(u)f''(u)}{f'(u)^2}.
~$$

If $s$ is a fixed point, $f(s) = 0$, so $F'(s)=0$. That is $q \geq 2$.


### visualize

If we graph $F(x)$ and layer on the line $y=x$, we can see cobwebbing converges to a fixed point.


```
using Plots

F(x) = x - sin(x)/cos(x)
a,b = 2.0, 4.3
x0 = 2.0


plot(F, a, b)
plot!( x ->x, a, b)

xs = [x0]
ys = F.(xs)


for i = 0:3
  annotate!([(x0, F(x0), "(x$i, F(x$i))")])
  x0 = F(x0)
end

for i in 1:5
  append!(xs, [ys[end], ys[end]])
  append!(ys, [ys[end], F(ys[end])])
end
plot!(xs, ys, linewidth=5, alpha=0.5)

```
