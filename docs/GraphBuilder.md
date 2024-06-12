# <span class="code"> <span class="kw"> class </span> graph.IGraphBuilder </span>

An abstract class for building a [Liftgraph](LiftGraph.md) from a partition provided by a [Lifting](Lifting.md).

Creating a subclass of this is encouraged if you need to build a graph in a way to supported by the default builders

<hr>

### <span class="code"> <span class="kw"> subclass </span> graph.EdgeGraphBuilder </span>

A possible graph builder, construct with the default constructor.

<hr>

### <span class="code"> <span class="kw"> subclass </span> graph.BarycenterGraphBuilder </span>

A possible graph builder, construct with the default constructor.


<hr>

### <span class="code"> <span class="fun">method </span> getGraph </span>

Constructs a [LiftGraph](LiftGraph.md) 

**Usage**
```matlab
lift_graph = builder.getGraph(partition)
```

**Parameters**

`lift_graph`
: Returns a [LiftGraph](LiftGraph.md) 

`partition`
: A column vector of [MPT]() Polyhedron objects, the builder may fail if they are not a partition (every edge must be fully shared between neighbours)

