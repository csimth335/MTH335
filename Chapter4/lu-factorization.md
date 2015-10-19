# LU Factorization

Return to the task of solving a system of equations:

$$~
\begin{align}
a_{11} x_1 + a_{12}x_2 + \cdots a_{1n} x_n &= b_1\\
a_{21} x_1 + a_{22}x_2 + \cdots a_{2n} x_n &= b_2\\
&\vdots\\
a_{m1} x_1 + a_{m2}x_2 + \cdots a_{mn} x_n &= b_m
\end{align}
~$$


Which we wrote as $Ax=b$.

## Easy to solve systems

If we have equations resulting in $A$ being a diagonal matrix, then we have basically:

$$~
a_{11}x_1 &= b_1\\
a_{22}x_2 &= b_2\\
& \vdots\\
a_{nn}x_n &= b_n
~$$

This has *easy* solutions, namely. If $a_{ii} \neq 0$, then $x_i = b_i/a_{ii}$.

If an $a_{ii} = 0$, then the determinant of $A$ is $0$, and there is not a unique solution.

### Lower triangular matrices

If $A$ is *lower triangular*, that is ($a_{ij} = 0$ if $j > i$) or:

$$~
A = \left(
\begin{array}{cccc}
a_{11} & 0 & \cdots & 0\\
a_{21} & a_{22} & \cdots & 0\\
 & \vdots &  & \\
a_{m1} & a_{m2} & \cdots & a_{mn}\\
\end{array}
\right)
~$$

Then we can solve recursively

* First, we solve $a_{11} x_1 = b_1$ with $x_1 = b_1 / a_{11}$.
* Next we solve $a_{21}x_1 + a_{22}x_2 = b_2$ by first subsititution in for our just-solved $x_1$, and then solving:

$$~
a_{21}x_1 + a_{22}x_2 &= b_2
~$$

$$~
a_{21} ( b_1 / a_{11})+ a_{22}x_2 &= b_2
~$$

$$~
x_2 = (b_2 - a_{21}(b_1/a_{11})) / a_{22}
~$$

* repeat. In general we have

$$~
x_i = (b_i - \sum_{j=1}^{i-1} a_ij x_j) \cdot \frac{1}{a_{ii}}
~$$

It is important that we have $a_{ii} \neq 0$, as otherwise we will have issues dividing. But this will be the case if $det(A) \neq 0$. (Why?)

This method is called *forward substitution*

### Upper triangular matrices

A matrix $U$ is *upper triangular* if $u_{ij} = 0$ if $i < j$. For example:

$$~
A = \left(
\begin{array}{cccc}
a_{11} & 0 & \cdots & 0\\
a_{21} & a_{22} & \cdots & 0\\
 & \vdots &  & \\
a_{m1} & a_{m2} & \cdots & a_{mn}\\
\end{array}
\right)
~$$
