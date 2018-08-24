## Bisection in floating point

Mathematically, we have an easy way to find the middle of two numbers, say $0 < a < b$:

$$~
c = (a + b)/2
~$$

Well, we can have issues with this if we try to put it on the computer.


In particular, out at the edge, we can overflow by adding two large numbers:

```
b = prevfloat(Inf)
a = b/2
(a + b)/2
```

This can be avoided by finding a difference and adding:

```
a + (b-a)/2
```

In general this is a good practice as adding can lose precision.

(This too has issues when `a` and `b` are both large of different
signs. The definition `a/2 + b/2` is more robust.)


So, we can control for really big values by using mathematics. What about other areas?


When $a < b$ are real--mathematical--numbers, there is always a number between $a$ and $b$. This is not so in floating point which is discrete:

```
a = 0.09999999999999998405
b = 0.09999999999999999
(a + b)/2   ## less than the real number 0.09999999999999998405
```

It would require proof that the result of `c = fl((a+b)/2)` satisfies `a <= c <= b` for machine numbers `a` and `b`. (Which may not be true with some rounding schemes)

If this were the case, we can stop if `a == c`  or `b == c`.


## Floating point bisection

Rather than bisect in floating point, there is a trick to bisect over integers.

The floating point numbers are discrete and ordered, so there is a way to reinterpret them using *unsigned* integers:

```
a = Float16(0.1)
bits(a)
```

```
reinterpret(UInt16, a) |> bits
```

Reinterpretation is cost free, basically, as the memory is just reinterpreted. Here we see the same bit pattern. But because of how these numbers are stored we have:

* If `0 < a <  b` in floating point then `a < b` as unsigned integers.

Now division by `2` in unsigned integers is just a bit shift down:

```
UInt16(14) |> bits
```

Compared to

```
UInt16(7) |> bits
```

Division than can be fast using the `>>` shift operation:

```
UInt16(14) >> 1 |> bits
```

For odd numbers it will be truncated or rounded down (7 goes to 3).

Returning to the problem, it is clear for integers that `a <= (a+b)/2 = a +(b-a)/2 <= b` and equal to an endpoint only when the difference between a and b is at the last bit (`a-b = 00000000....0001`).



So a terminating bisection algorithm that will terminate in a number of steps bounded by the storage size (16 for 16 bits) we be defined with the "midpoint" as follows:


```
# from Jason Merrill; Roots.jl
_pairs = Dict(Float64 => UInt64, Float32 => UInt32, Float16 => UInt16)


function _middle(x::T, y::T) where {T <: Union{Float64, Float32, Float16}}
    # Use the usual float rules for combining non-finite numbers
    if !isfinite(x) || !isfinite(y)
        return x + y
    end
    
    # Always return 0.0 when inputs have opposite sign
    if sign(x) != sign(y) && !iszero(x) && ! iszero(y)
        return 0.0
    end
    
    negate = x < 0.0 || y < 0.0

    # do division over unsigned integers with bit shift
    xint = reinterpret(_pairs[T], abs(x))
    yint = reinterpret(_pairs[T], abs(y))
    mid = (xint + yint) >> 1

	# reinterpret in original floating point
    unsigned = reinterpret(T, mid)
    val =  negate ? -unsigned : unsigned

    (val, bits(xint), bits(yint), bits(mid))
    
end
```


We can see the algorithm in action:

```
a, b = Float16(2.5), Float16(100.5)
ai, bi = reinterpret(UInt16, a), reinterpret(UInt16, b)
bits(ai), bits(bi)
```

And the sum

```
bits(ai + bi)
```

And the "middle":

```
bits((ai + bi) >> 1)
```

And as a floating point number:

```
reinterpret(Float16, (ai + bi) >> 1)
```


We can see by looking the bits from left to right that the value is in the middle:

```
[bits(ai), bits((ai+bi) >> 1), bits(bi)]
```

This begs the question of looking at what `(b-a)/2` is:

```
[bits(ai), bits(bi - ai), bits((bi - ai) >> 1), bits(bi)]
```


## Speed

For 64 bit floating point numbers, this is guaranteed to take no more
than 64 steps. How many steps does the more traditional bisection
take?

The bound is $|b_n - a+n| <= 2^n |b_0 - a_0|. Generally this isn't too
bad: Take $f(x)=\sin(x)$, $(a,b) = (3,4)$. Then we can get $|b_n-a_n|
< \epsilon$ in

```
delta = (4-3)
# solve 2^(-n) * delta < eps:
-log2(eps(1pi)/delta)
```

So, it would take about 52 steps here.

But this isn't always the case. At an extreme, we might have to find a
zero of $x - 10^{-200}$. And we begin with the interval `(-1e6,
1e6)`. The value of `epsilon` is now very small

```
eps(1e-200)
```

Solving gives

```
delta = 1e-6 - (-1e-6)
-log2(eps(1e-200)/delta)
```

So almost 700 steps to get down to adjacent floating point values.



