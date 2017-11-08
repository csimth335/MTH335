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
error = d h + \frac{10^{-16}}{h}
~$$

Making the error as small as possible has to balance of both errors, as choosing $h$ too small runs into floating point error and too big runs into truncation error.


### Example

Let's look at forming the derivative of the tangent.

We have $f(x) = \tan^{-1}(x)$ and $c=\sqrt{2}$ (as in the book

```
f(x) = atan(x)
fp(x) = 1/(1+x^2)
c = sqrt(2)
hs = [1/10^i for i in 5:20]
ds = [(f(c+h) - f(c)) / h for h in hs]
[hs ds ds.-fp(c)] # a table
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
\frac{f(x+h) - f(x)}{2h} = f'(x) + \frac{h^2}{12}(f'''(\xi_1) + f'''(\xi_2)).
~$$

We we too assume $f'''$ is continuous, then we could replace $ (f'''(\xi_1) + f'''(\xi_2))$ with $2f'''(\xi_3)$, so the error is basically

$$~
\frac{h^2}{6} f'''(\xi)
~$$



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
Base.getindex(f::T, xs...) where {T <: Function} = dd(f, [xs...])

using SymPy
x,h = symbols("x,h")

f(x) = atan(x)
x0, x1, x2 = x-h, x, x + h
f[x0,x1] + f[x0,x1,x2] * (2x -(x0 + x1)) |> simplify
```

#### Keeping track of the error term

We have -- in the LaGrange Base (p470):

$$~
f(x) = \sum_0^n f(x_i) l_i(x) + \frac{f^{(n+1)}(\xi)}{(n+1)!} w(x),
\quad w(x) = \prod(x - x_i).
~$$

Then we can differentiate in $x$ using the product rule **and** noting
the $\xi = \xi(x)$:

$$~
f'(x) =  \sum_0^n f(x_i) l_i'(x) +
\frac{f^{(n+1)}(\xi)}{(n+1)!} w'(x) +
\frac{d}{dx}(\frac{f^{(n+1)}(\xi)}{(n+1)!}) w(x) .
~$$

Rather than differentiate $\xi_x$, we take $x=x_\alpha$ as $w(x_\alpha) = 0$. So
this simplifies to:

$$~
f'(x_\alpha) = \sum_0^n f(x_i) l_i'(x_\alpha)  +
\frac{f^{(n+1)}(\xi)}{(n+1)!} w'(x_\alpha)
~$$

But $w'(x) = \sum_{i=0}^n \prod_{j\neq i}(x - x_j)$ so $w'(x_\alpha)=\prod_{j \neq \alpha}(x_\alpha - x_j).$

This gives:


$$~
f'(x_\alpha) = \sum_0^n f(x_i) l_i'(x_\alpha)  +
\frac{f^{(n+1)}(\xi)}{(n+1)!} \prod_{j \neq \alpha}(x_\alpha - x_j).
~$$


Example. What happens if equally spaced


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
\begin{bmatrix}\sin(\cdot)      \\  \cos(\cdot)\end{bmatrix} \circ (
\begin{bmatrix}x\\1\end{bmatrix} \cdot \begin{bmatrix}x\\1\end{bmatrix} )
= \begin{bmatrix}\sin(\cdot)    \\  \cos(\cdot)\end{bmatrix} \circ
\begin{bmatrix}x \cdot x        \\ x\cdot 1 + 1\cdot x\end{bmatrix}
= \begin{bmatrix} \sin(x^2)     \\ \cos(x^2) \cdot (x\cdot 1 + 1\cdot x) \end{bmatrix}
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

(F::DFunction)(G::DFunction) = DFunction(x -> F.f(G.f(x)), x->F.fp(G.f(x)) * G.fp(x))
(F::DFunction)(x::Real) = F.f(x)
Base.transpose(F::DFunction) = x->F.fp(x) ## does '
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


Julia has several packages for computing automatic derivatives including
`ForwardDiff` and `ReverseDiff`. (The difference is one is better with
many inputs, the other with many outputs.)
