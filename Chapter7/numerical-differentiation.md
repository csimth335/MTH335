# Numeric derivatives

If we only know $f$ at $n+1$ points, how can we approximate the derivative of $f$? Other derivatives? What about integrals?


No luck without adding in some assumptions -- functions can be too crazy,

For example, if we *know* $f$ is a polynomial of degree $n$ then we know it is uniquely determined by these points, and we can *explicitly* compute it. From there derivatives or integrals are routine.

## forward approximation

We are familiar with the limit:

$$~
f'(x) = \lim_{h \rightarrow 0} \frac{f(x+h) - f(x)}{h}.
~$$

This gives rise to the approximation:

$$~
f'(x) \approx \frac{f(x+h) - f(x)}{h}.
~$$

For linear functions this is in fact exact. For other functions, it is likely not exact, except by happenstance.

### Error

We can look at the error from Taylor's remainder theorem:

$$~
f(x+h) = f(x) + f'(x)h + \frac{1}{2!}f''(\xi)(h)^2.
~$$

We rearrange to get:

$$~
\frac{f(x+h) - f(x)}{h} = f'(x) + \frac{1}{2!}f''(\xi)\cdot h.
~$$

So we can get a sense of the error: $h/2 \cdot f''(\xi)$. This is the *truncation error*. Call it $d h$, for some $d$

There is also *floating point* error. In the expression we are subtracting two terms of like size. Recall

$$~
fl( f(fl(x+h)) - f(fl(x)) ) = (f((x+h)(1+\delta_1)) - f(x(1 + \delta_2)))(1 + \delta_3)
\approx f(x+h) - f(x) + c x \delta.
~$$

Dividing by $h$, we would get

$$~
fl(\frac{f(fl(x+h)) - f(fl(x))}{h}) \approx \frac{f(x+h) - f(x)}{h} + \frac{cx\delta}{h}.
$$~

We see the two errors that come in if this is done in floating point: the truncation error is the first term, the floating point error the second. Recall, typically $\delta \approx 10^{-16}$, so if $c=1$ and $x=1$, say, we have the error in doing this in floating point is like:

$$~
error = d h + 10^{-16} h
~$$

Making the error as small as possible has to balance of both errors, as choosing $h$ too small runs into floating point error and too big runs into truncation error.


### Example

Let's look at forming the derivative of the tangent.

We have $f(x) = atan(x)$ and $c=\sqrt{2}$ (as in the book

```
f(x) = atan(x)
c = sqrt(2)
hs = [1/10^i for i in 5:20]
[(f(c+h) - f(c)) / h for h in hs]
```

We see that somewhere the answer went off the rails.


### A strategy

Can we get smaller truncation error, so we can get more accuracy before round off considerations come into play?

The central difference will also converge to $f'$. However, the error is different:

$$~
\begin{align}
&f(x+h) = f(x) + f'(x) h + f''(x)h^2/2 + f'''(\xi_1)h^3/6\\
&f(x-h) = f(x) - f'(x) h + f''(x)h^2/2 - f'''(\xi_2)h^3/6
\end{align}
~$$

Subtract and divide by $2h$ to get:

$$~
\frac{f(x+h) - f(x)}{2h} = f'(x) + \frac{h^2}{12}(f'''(\xi_1) + f'''(xi_2)).
~$$

We we too assume $f'''$ is continuous, then we could replace $ (f'''(\xi_1) + f'''(xi_2))$ with $2f'''(\xi_3)$, so the error is basically

$$~
\frac{h^2}{6} f'''(\xi)
~$$

(The above is similar to a test question to find an approximate second derivative using $f(x+h)- 2f(x) + f(x-h)$...

### Relate to polynomial

What would be derivative of the function if you only knew its values at $x-h, x, x+h$?

Well, we could find the interpolating polynomial and find its derivative.

For example, suppose in general we have points $x_0, x_1, x_2$:

$$~
p2(x) = f[x_0] + f[x_0,x1](x-x_0) + f[x_0,x_1,x_2] (x-x0)(x-x1)
~$$

Differentiating:

$$~
p2'(x) = f[x_0,x_1] + f[x_0, x_1, x_2](2x - (x_0+x_1))
~$$

Does this give a familiar formula?

```
dd(f, xs) =   length(xs) ==1 ? f(xs[1]) : (dd(f,xs[2:end]) - dd(f,xs[1:end-1])) / (xs[end] - xs[1])
using SymPy
x,h = symbols("x,h")

f(x) = atan(x)
x0, x1, x2 = x-h, x, x + h
dd(f, [x0,x1]) + dd(f, [x0,x1,x2])*(2x -(x0 + x1)) |> simplify
```

### Automatic Differentation

[Automatic differentiation](https://en.wikipedia.org/wiki/Automatic_differentiation) is an alternate means to compute numeric derivatives that does not suffer from truncation error. (This is different from symbolic differentiation.) There are two flavors, we will mention an implementation of *forward* automatic differentiation.

There are various ways to view this, but we will choose Taylor series.

Consider the first-order Taylor series for $f(x)$ about $c$:

$$~
f(x) = f(c) + f'(c)(x-c) + \mathcal{O}(x-c)^2
~$$

So, we can think of a function $f(x)$ in terms of $f(c)$ and $f'(c)$. With this, we can define an algebra of functions:

$$~
\begin{align}
f(x) &= \begin{bmatrix} f(x)\\f'(x) \end{bmatrix}\\
\lambda f(x) &= \begin{bmatrix}\lambda f(x)\\\lambda f'(x)\end{bmatrix}\\
f(x) + g(x) &= \begin{bmatrix}f(x) + g(x)\\ f'(x) + g'(x)\end{bmatrix}\\
f(x) \cdot g(x) &= \begin{bmatrix}f(x) \cdot g(x)\\ f'(x)g(x) + f(x)g'(x)\end{bmatrix}\\
f(x)^n &= \begin{bmatrix}f(x) ^n\\ nf(x)^{n-1} f'(x) \end{bmatrix}\\
f(g(x)) &= \begin{bmatrix}f(g(x))\\ f'(g(x)) g'(x) \end{bmatrix}
\end{align}
~$$


Then we can just follow these rules. For example $\sin(x^2)$ would be the composition of the sine function with $x$ times itself:

$$~
\sin(x^2) =
\begin{bmatrix}\sin(\cdot)\\\cos(\cdot)\end{bmatrix} \circ (
\begin{bmatrix}x\\1\end{bmatrix} \cdot \begin{bmatrix}x\\1\end{bmatrix} )
= \begin{bmatrix}\sin(\cdot)\\\cos(\cdot)\end{bmatrix} \circ
\begin{bmatrix}x \cdot x\\ x\cdot 1 + 1\cdot x\end{bmatrix}
= \begin{bmatrix} \sin(x^2) \cos(x^2) \cdot 2x\end{bmatrix}
~$$

We can implement this with just a little work:

```
type DFunction
f
fp
end

## Some functions
Sin = DFunction(sin, cos)
Cos = DFunction(cos, x->-sin(x))
Exp = DFunction(exp, exp)
X = DFunction(x->x, x->1)

## Some operations
import Base: *, +,-,  ^

(*)(lambda::Real, F::DFunction) = DFunction(x->lambda*F.f(x), x->lambda*F.fp(x))
+(F::DFunction, G::DFunction) = DFunction(x->F.f(x) + G.f(x), x -> F.fp(x) + G.fp(x))
-(F::DFunction, G::DFunction) = DFunction(x->F.f(x) - G.f(x), x -> F.fp(x) - G.fp(x))
(*)(F::DFunction, G::DFunction) = DFunction(x->F.f(x) * G.f(x), x -> F.fp(x) * G.f(x) + F.f(x) * G.fp(x))
^(F::DFunction, n) = DFunction(x->F.f(x) ^ n, x -> n * F.f(x)^(n-1) * F.fp(x) )
Base.call(F::DFunction, G::DFunction) = DFunction(x -> F.f(G.f(x)), x->F.fp(G.f(x)) * G.fp(x))
Base.call(F::DFunction, x::Real) = F.f(x)
Base.ctranspose(F::DFunction) = x->F.fp(x) ## does '
```


```
Sin(1) - sin(1)
```

```
Sin'(1) - cos(1)
```

```
(Sin(Cos(Exp(X))))'(3) - cos(cos(exp(3))) * (-sin(exp(3))) * exp(3)
```

And it is faster too:

```
@time prod([Sin(n*X) for n in 1:100])'(1/10) # 0.021830 
```

Against

```
using SymPy
x = symbols("x")
@time diff(prod([sin(n*x) for n in 1:100]), x)(x => 1/10) # 3.031204
```
