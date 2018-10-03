# Secant Method

> The secant method can be thought of as a finite difference approximation of Newton's method. However, the method was developed independently of Newton's method, and predated the latter by over 3,000 years [Wikipedia](https://en.wikipedia.org/wiki/Secant_method).

What is it? We start with two points $x_0$ and $x_1$ (not the same). Then instead of the tangent line at $(x_1, f(x_1))$, we use the secant line.

Solving for when it intersects the $x$ axis yields:

$$~
x_{n+1} = x_n - \frac{x_n - x_{n-1}}{f(x_n) - f(x_{n-1})} \cdot f(x_n)
~$$

Basically use the slope of a secant line instead of $f'(x_n)$, the
slope of the tangent. Hence the advantage, each step only requires one
function evaluation $f(x_n)$, not two (the other being $f'(x_n)$ in
Newton's method).

### Example

Let $f(x) = \sin(x)$, $x_0=3$, $x_1=4$ and what do we get?


```
f(x) = sin(x)
x = [3.0, 4.0]
push!(x, x[end] - (x[end] - x[end-1]) / (f(x[end]) - f(x[end-1])) * f(x[end]))
```

```
push!(x, x[end] - (x[end] - x[end-1]) / (f(x[end]) - f(x[end-1])) * f(x[end]))
```

```
push!(x, x[end] - (x[end] - x[end-1]) / (f(x[end]) - f(x[end-1])) * f(x[end]))
push!(x, x[end] - (x[end] - x[end-1]) / (f(x[end]) - f(x[end-1])) * f(x[end]))
```


So it converges in this case.

### Some check

We could implement the method following the algorithm on page 95, but instead use that given in the `Roots` package.

```
using Roots
f(x) = x^3 - sinh(x) + 4x^2 + 6x + 9
xstar = find_zero(f, (7.0, 8.0), Roots.Secant(), verbose=true)
```


And we see

```
f(xstar)
```

## Error analysis.

For Newton's method, we found

$$~
e_{n+1} = \frac{1}{2} \frac{f''(\xi)}{f'(x_n)} e_n^2.
~$$

With the secant  method we have (p96)

$$~
e_{n+1} \approx \frac{1}{2}\frac{f''(r)}{f'(r)} e_n e_{n-1}
~$$

Not quite the same, but similar

### Order of convergence

Suppose we expect convergence with order $\alpha$, that is we suppose

$$~
|e_{n+1}| \approx A |e_n|^\alpha
~$$

($\alpha=2$ for Newton). Then from the above can write:

$$~
\begin{align}
|e_{n+1}| &\approx A|e_n|^\alpha \text{ and }\\
|e_{n-1}| &\approx (A^{-1}|e_n|)^{1/\alpha}.
\end{align}
~$$

The latter comes from solving for $e_n$. We use both to get

$$~
A |e_n|^\alpha \approx |C| |e_n| (A^{-1}|e_n|)^{1/\alpha}
~$$

Solving gives

$$~
A^{1 + 1/\alpha} |C|^{-1} \approx |e_n|^{1 - \alpha + 1/\alpha}.
~$$

The left side is constant, so the right side exponent should be $0$.

```
using SymPy
@vars alpha
solve(1 - alpha + 1/alpha, alpha)
```

Taking the positive root gives the rate, roughly 1.61803.

### Robust

Two steps of the secant method would have a rate twice that, which is more than quadratic. There is more compuation, but the same number of function calls as Newton's method. So in some cases the secant method is "faster."

However, the secant method requieres more work -- two guesses, not one; and is more sensitive to the quality of the initial guess.

### Proof of error

This follows the book

$$~
\begin{align}
e_{n+1}
&= x_{n+1} - r\\
&= x_n - f(x_n)(x_n - x_{n-1})/(f(x_n) - f(x_{n-1})) - r\\
&= \frac{f(x_n)x_{n-1} - f(x_{n-1})x_n}{f(x_n) - f(x_{n-1})} - r\\
&= \frac{f(x_n)e_{n-1} - f(x_{n-1})e_n}{f(x_n) - f(x_{n-1})}\\
&= \frac{x_n - x_{n-1}}{f(x_n) - f(x_{n-1})} \cdot \frac{f(x_n)/e_n - f(x_{n-1})/e_{n-1}}{x_n - x_{n-1}} \cdot e_n e_{n-1}\\
&= A \cdot B \cdot e_n e_{n-1}.
\end{align}
~$$

It hopefully is clear that

$$~
A \approx 1/f'(r).
~$$


To work at B,  Taylor's theorem has

$$~
f(x) = f(r) + f'(r) (x-r) + (1/2)f''(r)(x-r)^2 + \mathcal{O}((x-r)^3)
~$$

Taking $x=x_n$ and using $(x-r) = (x_n-r) = e_n$ makes this:

$$~
f(x_n)/e_n = f'(r) + (1/2)e_n f''(r) +  \mathcal{O}(e_n^2)
~$$

And taking $x=x_{n-1}$ is similar:

$$~
f(x_{n-1})/e_{n-1} = f'(r) + (1/2)e_{n-1} f''(r) +  \mathcal{O}(e_{n-1}^2)
~$$

The difference is then $1/2 \cdot (e_n - e_{n-1})f''(r) + \mathcal{O}(e_{n-1}^2)$. Using $x_n - x_{n-1} = e_n - e_{n-1}$ means that $B \approx 1/2 \cdot f''(r)$. Combining, we get the result.

## Steffensen

A modification of the secant method that has better convergence is [Steffensen's](http://tinyurl.com/o5q2xz6) method.

Here, the derivative is replaced by

$$~
\frac{f(x + f(x)) - f(x)}{f(x)}.
~$$

An eyeful, but basically $h=f(x)$, so we assume $f(x)$ is close to zero -- we need a good guess.

## Modern extensions

[Here](http://article.sapub.org/pdf/10.5923.j.ajcam.20120203.08.pdf) is a link to a pdf of a 16 order method. How much can we read?
