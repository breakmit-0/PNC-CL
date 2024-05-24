# Path Planning using Convex Lifting

This is a [MATLAB](https://mathworks.com) toolbox for pathplanning, or finding a path in a continuous environment with obstacles, in two or three dimensions.
It uses the novel [Convex Lifting]() method to construct a graph of possible paths in the environment.

This toolbox requires [MPT]() and [tbxmanager]().

# Installation

First, install both dependencies :

    * [MPT]()
* [tbxmanager]()

    You may also install the [Matlab Optimisation Toolbox]() to speed up some calculations.


    To use the tooblox, download the [latest release]() from github and add the `toolbox` directory to your matlab path, for example by adding
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
    buider = graph.EdgeGraphBuilder();
    g = builder.getGraph(lifting.getPartition());

    % TODO : make a better API
    g = corridors.corridor_width(g, obstacles);
    g = corridors.edge_weigth(g);

    % find the shortest path
    found_path = alt_graph.path(g, src, dst);

    % get information about the path
    [corridors, path_width, path_length] = corridors.corridor_post_processing(G, found_path, 100);
    ```

### Examples

    More example programs are available in the `examples` directory as scripts. To run them, simply add the `examples` to the matlab path.


# Building

    This section is relevant for developpers only and not necessary to use the toolbox

### Toolbox

    To create a release of the toolbox, run `make release`


### Documentation

    This documentation is built with `mkdocs`, the following python packages are required:

    * `mkdocs`
    * `pymdown-extensions`
    * `pygments`


    run ` mkdocs build`  to build the html documentation to use with github pages in `site/`
    and `mkdocs serve` to build and serve on `localhost`



# API Documentation

    Most of the information in this section is also available as doc comments inside the code of the toolbox.
    It can be acessed with `help <name>` or `doc <name>` inside matlab.

##### <span class="code"> <span class="kw"> class </span> [Lifting](Lifting.md) </span>
    : A class to perform a convex lifting and create a partition of the space

##### <span class="code"> <span class="kw"> class </span> [LiftOptions](LiftOptions.md) </span>
    : A simple structure that holds all the options to create a [Lifting] object

