# Euler's method

Consider $x'(t) = a - b x(t)$. Suppose we try and solve *numerically*

We do this by find a table of values $(t_0, x(t_0))$, $\dots$, $(t_0 + nh, x(t_0+nh))$.

Well, what to do for the first one -- we need $x(t_0 + h)$?

If we *approximate* we might have $x(t_0 + h) \approx x(t_0) + x'(t_0) \cdot h$. *But*, we have then $x(t_0+h) \approx x(t_0) + h \cdot f(t_0, x(t_0))$ so we can actually compute this:

```
a,b = 1, 1//2
f(t, x) = a - b*x^2
t0, x0 = 0, 1
h = 1/10
n = 10
ts = Float64[t0]
xs = Float64[x0]

for i in 1:n
  ti, xi = ts[end], xs[end]

  xi1 = xi + f(ti, xi) * h
  
  push!(ts, ti + h)
  push!(xs, xi1)
end
```

Our table:

```
[ts xs]
```

Our plot

```
using Plots
plot(ts, xs)
```

How does this compare to the actual answer?

```
using SymPy
u = SymFunction("u")
@vars t
eqn = dsolve(u'(t) - f(t, u(t)), t, (u, t0, x0))
fn = lambdify(real(rhs(eqn)))
plot!(fn, color=:red)
```

Not too bad. Could we do better?

Would more points help?

```
h = 1/100
n = 100

ts = Float64[t0]
xs = Float64[x0]

for i in 1:n
  ti, xi = ts[end], xs[end]

  xi1 = xi + f(ti, xi) * h

  push!(ts, ti + h)
  push!(xs, xi1)
end

plot(fn, 0, 1)
plot!(ts, xs, color=:green)
```

So yes, more points would help.

But more points **could** mean floating point errors might creep in. So we would need to be mindful of:

* the mathematical error used in truncating using $x(t+h) = x(t) + x'(t) h$ on each step
* the *accumulated* truncation error used in this truncation
* the floating point error in each step
* the *accumulated* floating point error in each step
* The total error.


What can we do improve? One way is to use more terms in the Taylor Series for $x(t+h)$:

* the truncation error on each step is $x^{(n+1)}(\xi)/(n+1)! \cdot h^{n+1}$ so *should* get smaller as $n$ gets bigger if $\mathcal{O}(h^{n+1})$.

* More accuracy will let us use fewer steps to achieve the overall same total accuracy

* More work!

Let's see by using $T_4$:

$$~
x(t+h) = x(t) + x'(t) h + x''(t)h^2/2! + x'''(t) h^3/3! + x''''(t)h^4/4!.
~$$

What is $x''(t)$?

$$~
x''(t) = [x'(t)]' = [f(t,x)]' = [a - b\cdot x(t)^2]' =
-2bx(t) \cdot x'(t).
~$$

And $x'''(t) = [x''(t)]'$:

$$~
x'''(t) = [-2bx(t) \cdot x'(t)]= -2b[x'(t)^2 + x(t) \cdot x''(t)].
~$$

Finally,

$$~
x''''(t) = -2b[x'(t)^2 + x(t) \cdot x''(t)]' =
-2b[2x'(t)\cdot x''(t) + x'(t) \cdot x''(t) + x(t) \cdot x'''(t)].
~$$


Armed with this, we can now compute a step and iterate this:

```
h = 1/10
n = 10
xs = Float64[x0]
ts = Float64[t0]
for i in 1:n
  ti, xi = ts[end], xs[end]

  xpi = f(t0, xi)
  xppi = -2b*xi*xpi
  xpppi = -2b*(xpi^2 + xi * xppi)
  xppppi = -2b*( 2xpi * xppi + xpi * xppi + xi * xpppi)
  xi1 = xi + xpi*h/1 + xppi*h^2/2 + xpppi*h^3/6 + xppppi * h^4 / 24
  
  push!(ts, ti + h)
  push!(xs, xi1)
end
```

We can visualize with

```
plot(ts, xs, legend=false)
plot!(fn)
```

Notationally, we can write the following for the $n+1$st term in the Taylor polynomial

$$~
x_{[n+1]} = \frac{f_{[n]}}{n!},
~$$

emphasizing that the $n+1$ term involves terms with derivatives up to order $n$ coming from differentiating the function $f$.



## Taylor Series Method

Use a higher order Taylor approximation for $x(t+h)$, repeat for many steps.

Here is a description of a Julia Package [Taylor.jl](https://github.com/JuliaDiff/TaylorSeries.jl/blob/master/examples/1-KeplerProblem.ipynb)



An interesting application is [here](https://github.com/PerezHz/TaylorIntegration.jl/blob/master/examples/JuliaCon2017/TaylorIntegration_JuliaCon.ipynb)



## Errors


We have this description of Euler's method (from [Wikipedia](https://en.wikipedia.org/wiki/Euler_method))

> The Euler method is a first-order method, which means that the local error (error per step) is proportional to the square of the step size, and the global error (error at a given time) is proportional to the step size. 


The *local error* is proportional to the step size -- Why? We have

$$~
x(t + h) = x(t) + x'(t) h + \mathcal(O)h^2.
~$$

The global error is propogated through $c/h$ steps, so the errors accumulate to give basically $\mathcal{O}(h)$, or proportional to the step size.


More rigorously, we have with $x^*_i$ being the estimate and assuming Lipschitz:

$$~
GTE_{i+1} = |x^*_{i+1} - x_{i+1}| =
|x^*_i- + h \cdot f(t_i, x^*_i) -  x_{i+1} + h \cdot f(t_i, x_i) +  x_{i+1} + h \cdot f(t_i, x_i) - x_{i+1}| \leq
\delta + (1 + Lh) \cdot |x^*_i - x_i|,
~$$

Where $\delta = M/2 h^2$ is a bound on the one-step truncation error $f''(\xi)/2 h^2$.

This iterates to yield (with $\gamma = 1 + Lh$):

$$~
GTE_{i+1} \leq \delta + \gamma + GTE_{i} \leq \delta (1 + \gamma + \gamma^2 + \dots + \gamma^k),
~$$

With $k = (t - t0)/h$, the number of steps needed to progress to $t$.

But this means

$$~
GTE \leq \delta \cdot \frac{1 - \gamma^{(t-t_0)/h}}{1 - \gamma} \leq \frac{M}{2L}(e^{L(t-t_0)} - 1) h.
~$$

So we see $\mathcal{O}(h)$.










