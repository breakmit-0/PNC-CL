
# <span class="code"> <span class="mod">module</span> lift </span>

This modules contains functions to create and operate on a convex lifting



### <span class="code"> <span class="kw">function</span> find </span>

Find a convex lifting over a set of obstacles,

**Usage**

```matlab
[oa, ob] = lift.find(obstacles)
```

**Parameters**

`obstacles`
:   An array of `Polyhedron` of length `N`. All the elements must be of the same dimension `D`

**Return Values**

The returned values define the found convex lifting, they are such that the lifting function
is defined by `z(x) = max(oa * x + ob)`.

`oa`
:   A matrix with `N` lines and '`D` columns

`ob`
: A column vector with `N` lines


### <span class="code"> <span class="kw">function</span> max </span>

Find the maximum of the convex lifting function in a given space, used 
internally when tracing the lifting function to place the obstacles above it.

**Usage**
```matlab
max_value = lift.max(oa, ob, space)
```

**Parameters**

`oa` and `ob`
: The values returned by `lift.find`

`space`
: Where to look for the maximum, currently a scalar representing the radius
of a hypercube

**Return Values**

`max_value`
:   The maximum of the convex lifting

