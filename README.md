# Path Planning using Convex Lifting

This is a [MATLAB](https://mathworks.com) toolbox for pathplanning, or finding a path in a continuous environment with obstacles, in two or three dimensions.
It uses the Convex Lifting method to construct a graph of possible paths in the environment.

This toolbox requires [MPT](https://www.mpt3.org/) and [tbxmanager](https://www.tbxmanager.com/).

# Installation

First, install both dependencies :

* [MPT](https://www.mpt3.org/)
* [tbxmanager](https://www.tbxmanager.com/)

You may also install the [Matlab Optimisation Toolbox](https://fr.mathworks.com/products/optimization.html) to speed up some calculations.


To use the tooblox, download the [latest release](https://github.com/breakmit-0/lift-ppl/releases), decompress it and add the `toolbox` directory to your matlab path, for example by adding
```matlab
add_path("/home/... path to the toolbox ../toolbox");
```
to `startup.m` in your project directory.

Before calling any function from this toolbox (or MPT), call 
```matlab
mpt_init;
```

# Usage

### Basic Usage

```matlab
    % required before using mpt
    mpt_init; 

    % let obstacles be a column vector of Polyhedron objects

    % returns a lifting object
    lifting = Lifting.find(obstacles, LiftOptions.linearDefault());

    % choose the method to construct the graph then build it
    g = lifting.getGraph(graph.EdgeGraphBuilder(), PolyUnion(obstacles).convexHull());
    P = lifting.getPartition()

    % perform calculations on the graph
    g = corridors.corridor_width(g, obstacles);
    g = corridors.edge_weigth(g);

    % find the shortest path
    found_path = graph.path(g, src, dst);

    % perform calculations on the path
    [Corridors, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
    path_length = graph.path_length(G, path, src, dest)
```

### Examples

More example programs are available in the `examples` directory as scripts. To run them, simply add the `examples` directory to the matlab path and call the relevant script names from matlab.


# Building

This section is relevant for developpers only and not necessary to use the toolbox

### Toolbox

To create a release of the toolbox, run `./install.sh` this requires a POSIX shell (sh) and the [zip](https://infozip.sourceforge.net/Zip.html) command line utility.


### Documentation

This documentation is built with `mkdocs`, the following python packages are required:

* `mkdocs`
* `pymdown-extensions`
* `pygments`


run ` mkdocs build`  to build the html documentation to use with github pages in `site/`
and `mkdocs serve` to build and serve on `localhost`



