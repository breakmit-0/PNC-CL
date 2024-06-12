# <span class="code"> <span class="kw"> class </span> Lifting </span>

Lifting is an abstract class with methods to create and manipulate a convex lifting.

You may create a subclass of <span class="code">[Lifting](Lifting.md)</span> but it will not be accessible
through the <span class="code">[find](Lifting.md#static-method-find)</span> constructor

<hr>

### <span class="code"> <span class="fun">static method </span> find </span>

This is the main constructor for the [Lifting](Lifting.md) class see [LiftOptions](LiftOptions.md) for more details.

The convex lifting is performed immediatly when this is called but the partition is not generated until it is needed

**Usage**

```matlab
lifting = Lifting.find(obstacles, options)
```

**Parameters**

`obstacles`
: A column vector of [MPT]() `Polyhedron` objects

`options`
: A <span class="code">[LiftOptions](LiftOptions.md) object

`lifting`
: The function returns a <span class="code">[Lifting](Lifting.md)</span> object


<hr>

### <span class="code"> <span class="fun">method </span>getGraph</span>

A function to construct a graph from a lifting

**Usage**

```matlab
g = lifting.getGraph(graph_builder, bbox)
```

**Parameters**

`graph_builder`
: A  [IGraphBuilder](GraphBuilder.md) 

`bbox`
: A bounding box used to create the partition, should be at least the convex hull of the obstacles

`g`
: A matlab `graph`




<hr>

### <span class="code"> <span class="fun">abstract method </span>isSuccess</span>

This quickly tests wether lifting was successful, if this returns false, displaying the result of <span class="code">[getDiagnostic](Lifting.md#abstract-method-getdiagnostic)</span>
may provide help

**Usage**

```matlab
result = lifting.isSuccess()
```

**Parameters**

`result`
: a `logical` value, `true` if a lifting wa sucessuflly found


<hr>

### <span class="code"> <span class="fun">abstract method </span>getDiagnostic</span>

This returns details on the failure or success of <span class="code">[Lifting.find](Lifting.md#static-method-find)</span>

**Usage**
```matlab
diagnostic = lifting.getDiagnostic()
```

**Parameters**

`diagnostic`
: a struct that contains diagnostic data, depends on the lift implementation

