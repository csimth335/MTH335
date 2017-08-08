# Taylor series methods

Consider the problem of solving an initial value problem when an answer is not immediate.

We have

$$~
x'(t) = f(t,x), \quad x(t_0) = x_0
~$$

At $(t_0, x_0)$ we know the derivative of $x$ is $f(t_0, x_0)$. But the tangent line approximation should then be:

$$~
x(t + h) \approx x(t) + h x'(t) = x(t) + h(f(t, x(t))).
~$$

This should allow us to step forward by steps of size $h$ to recover the function.

Consider, the problem of wind resistance:

$$~
x'(t) = a - cx
~$$

We make it concreate by taking $a=10$ and $c=1$ and start at $(0,0)$. If we step forward with steps of size $1/10$, we get:

```
f(t,x) = 10 - 1*x
ts = [0.0]
xs = [0.0]
h = 1/10
for i in 1:10
push!(xs, xs[end] + h * f(ts[end], xs[end]))
push!(ts, ts[end] + h)
end
```

And we can visualize the points:

```
using Plots
backend(:gadfly)
plot(ts, xs)
```

What is the exact answer? In this case, we can compute:

```
using SymPy
r = SymFunction("r")
t = symbols("t")
dsolve(diff(r(t),t) - (10 - r(t)))
```

We solve for $c_1$ by the initial condition $x(0) = 0$, so we get

$$~
f(t) = 10 - 10 \cdot \exp(-t)
~$$

And we graph both:

```
f(t) = 10 - 10*exp(-t)
plot(f, 0, 1)
plot!(ts, xs, color=:red)
```

### Step size

Let's try doing bigger steps and visualizing:

```
f(t,x) = 10 - 1*x
ts = [0.0]
xs = [0.0]
h = 1/3
for i in 1:3
push!(xs, xs[end] + h * f(ts[end], xs[end]))
push!(ts, ts[end] + h)
end
f(t) = 10 - 10*exp(-t)
plot(f, 0, 1)
plot!(ts, xs, color=:red)
```

The difference is more pronounced. This might seem like a reasonable strategy:

* pick $h$ to be small enough so that we get a good approximation but not so small floating point issues might creep in.


## The Taylor Series method

Suppose we have an IVP:

$$~
x'(t) = f(t,x), \quad x(t_0) = x_0.
~$$

Then if we assume $x$ is reasonably nice, we might look for a taylor series approximation to $x$:

$$~
x(t+h) \approx x(t) + x'(t) h + \frac{1}{2!} x''(t) h^2 + \cdots + \frac{1}{n!} x^{(n)}(t) h^n.
~$$

But we have $x'(t) = f(t, x(t))$, so we can substitute, as with Euler.

But also then

$$~
x''(t) = [f(t, x(t))]' = \frac{\partial f}{\partial t} \cdot \frac{dt}{dt} + \frac{\partial f}{\partial x} \cdot \frac{dx}{dt} =
\frac{\partial f}{\partial t} + \frac{\partial f}{\partial x} \cdot x'(t)
~$$

Armed with this, we can differentiate again to find $x'''$ etc.

### Example

The book illustrates with $f(t,x) = \cos(t) - \sin(x) + t^2$ and $(t_0, x_0) = (-1,3)$.

For this, we have:

$$~
\begin{align}
\frac{\partial f}{\partial t} &= -\sin(t) + 2t\\
\frac{\partial f}{\partial x} &= -\cos(x)
\end{align}
~$$

So, that

$$~
x''(t) = (-\sin(t) + 2t) \cdot 1 + (-\cos(x))\cdot (\cos(t) - \sin(x) + t^2)
~$$

Etc.

The book finds $x^{(4)}$ and stops there. The error in the taylor series expansion then is $\mathcal{O}(h^5)$.


To visualize we (like the book) take $h=1/100$ and look for a solution on $[-1,1]$.

```
xp1(t,x) = cos(t) - sin(x) + t^2
xp2(t,x) = -sin(t) - xp1(t,x) *cos(x) + 2t
xp3(t,x) = -cos(t) - xp2(t,x) * cos(x) + (xp1(t,x))^2 * sin(x) + 2
xp4(t,x) = sin(t) + cos(x) * (xp1(t,x)^3 - xp3(t,x)) + 3*xp1(t,x) * xp2(t,x) * sin(x)

a,b = -1,1
h = 1/100
M = 200 # (b-a)/h as an integer
ts = [-1.0]
xs = [3.0]
for k in 1:M
  t,x = ts[end], xs[end]
  push!(xs,  x + h*xp1(t,x) + 1/2 * h^2 * xp2(t,x) + 1/6 * h^3 * xp3(t,x) + 1/24* h^4 * xp4(t,x))
  push!(ts, t + h)
end
plot(ts, xs)
```


The book uses a different formula:

$$~
x + h(x' + \frac{h}{2}(x'' + \frac{h}{3}(x''' + \frac{h}{4}x'''')))
~$$

Why?


## Error?

How does the error propogate? Here the *local truncation error* is the order of $h^5$ at each step, or about $C \cdot 10^{-10}$, for some $C$ depending on the derivatives of $x$. The *global* truncation error would be the sum. In addition, at each step there is local roundoff error. These accumulate to yield the gloabl roundoff error. As with differentiation, there is a contribution to the total error by each.


