# <span class="code"> <span class="mod">module</span> graph </span>

Functions on graphs.

<hr>

### <span class="code"> <span class="fun">function </span> path </span>

Calculates the shortest path on a graph.

**Usage**

```matlab
path = graph.path(g, start, dest, obstacles, partition)
```

**Parameters**

`g`
: The graph to operate on

`start`
: A vector, the point to start from

`dest`
: A Vecotr, the point to end on

`obstacles`
: The obstacles vector used to create the lifting

`partition`
: The partition obtained from the lifting

`path`
: A vector of indices into the graph


<hr>

### <span class="code"> <span class="fun">function </span> path_length </span>

Calculates the length of the path

**Usage**

```matlab
length = graph.path_length(g, path, start, dest)
```

**Parameters**

`g`
: The graph to operate on

`path`
: The path from `graph.path`

`start`
: The starting point

`dest`
: The end point



