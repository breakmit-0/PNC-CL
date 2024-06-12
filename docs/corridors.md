# <span class="code"> <span class="mod">module</span> corridors </span>

Operations related to the safety area around the paths.

<hr>

### <span class="code"> <span class="fun">function </span> edge_weight </span>

A default way to calculate edge weights for pathfinding

This can be replaced by a user functions, simply set `g.Edges.Weight` from `g.Edges.length` and `g.Edges.width`

**Usage**

```matlab
corridors.edge_weight(g)
```

**Parameters**

`g`
: The graph


### <span class="code"> <span class="fun">function </span> corridor_post_processing </span>

Calculates the actual corridor data once the path is found.

**Usage**

```matlab
[cor, min_width] = corridor_post_processing(G, path, start, target, obstacles, n)
```

**Parameters**

`G`
: The graph

`path`
: The path to calculate corridors on

`start`
: The start of the path

`target`
: The end of the path

`obstacles`
: The obstacles vector

`n`
:
