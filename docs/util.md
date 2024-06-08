
# <span class="code"> <span class="mod">module</span> util </span>

This modules contains internal functions that are not meant to be used
by the end user.



### <span class="code"> <span class="kw">function</span> assert_shape </span>

Causes an error if `size(x)` is different from `shape`.

**Usage**

```matlab
util.assert_shape(x, shape)
```

### <span class="code"> <span class="kw">function</span> barycenter </span>

**Usage**
```matlab
center = util.barycenter(poly)
```

**Parameters**

`poly`
: Any bounded, non empty `Polyhedron` of dimension `D`

**Return Values**

`center`
: A `D` dimensional row vector representing the barycenter of `poly` 


### <span class="code"> <span class="kw">function</span> box </span>

Returns a hypercube of a given radius, potentially stretch vertically

**Usage**
```matlab
poly = util.box(center, radius)
poly = util.box(center, radius, z_size)
```

**Parameters**

Calculates the barycenter of a polyhedron : the average of all its vertices.

`center`
:   A row vector of dimension `D`

`radius`
:   A Scalar, he distance in each dimension  from `center` to the edge of the cube

`z_size`
:   If given, overrides `radius` for the last dimension

**Return Values**

`poly`
:   A `D` dimensional hypercube, stretched if z_size is different from radius

### <span class="code"> <span class="kw">function</span> is_near_unit </span>

Tests wether a vector is nearly colinear to any of the unit vectors of 
the canonical basis. The exact formula used is `N(v/N(v) - u) <= epsilon`
where `v` is the tested vector, `u` the unit vector and `N` is the euclidian norm.

**Usage**
```matlab
test = util.is_near_unit(vector)
test = util.is_near_unit(vector, epsilon)
```

**Parameters**

`vector`
: Any row vector

`epsilon`
: The error margin, defaults to `0.001`


### <span class="code"> <span class="kw">function</span> read_obj </span>

Reads a set of polyhedra from a `.obj` (blender) file.

**Usage**
```matlab
poly = util.read_obj(file)
poly = util.read_obj(file, useHRep)
```

**Parameters**

`file`
: The name of a file to load polyhedra from, relative to the `cwd`

`useHrep`
: If `true`, the polyhedra are returned in hrep, defaults to `false`

**Return Values**

`poly`
: A column vector of `Polyhedron` objects

### <span class="code"> <span class="kw">function</span> reduction </span>

Scales a polyhedron by some factor around its barycenter.

**Usage**
```matlab
scaled = util.reduction(poly, factor)
```

**Parameters**

`poly`
: Any `Polyhedron`

`factor`
: A scalar to scale `poly` by

**Return Values**

`scaled`
: A new `Polyhedron`


### <span class="code"> <span class="kw">function</span> unit_vec </span>

Creates nth `n`-th unit vector of the canonical base in dimension `dim`.

**Usage**
```matlab
u = util.unit_vec(dim, n)
```

**Parameters**

`dim`
: The dimension of the output vector

`n`
: An integer in `1:dim`

**Return value**

`u`
: A `dim` dimensional unit row vector, its only non zero component is th `n`-th

