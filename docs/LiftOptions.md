
# <span class="code"> <span class="kw"> class </span> LiftOptions </span>

A data structure that contains options for <span class="code">[Lifting.find](Lifting.md#static-method-liftingfind)</span>

Every property for this class is public and meant to be read and written directly

<hr>

## Properties
```matlab
sdp             (1, 1) struct   = sdpsettings()   
debug           (1, 1) logical  = false        
verbose         (1, 1) logical  = false      
strategy        (1, 1) string   = "linear"   
cluster_count   (1, 1) uint32   = 5     
depth           (1, 1) uint32   = 0             
fallback        (1, 1) string   = "linear"   
min_cvx         (1, 1) double   = 0.001       
solver          (1, 1) string   = ""           
```

`sdp`
: An overwrite for the settings used when calling [MPT](), see [MPT]() / [YALMIP]() documentation

`debug`
: If this flag is set, functions are allow to show debug information like timing etc..., this also sets `debug = true` in [MPT]() / [YALMIP]() calls

`verbose`
: If this flag is set, functions may print extra information, this also sets `verbose = true` in [MPT]() / [YALMIP]() calls

`strategy`
: One of `"linear"`, `"convex"`, `"cluster"`. sets the strategy for finding the lifting, `"linear"` is generaly best for less than 60 obstacles, use `"cluster"` for
more obstacles, `"convex"` is generally worse than the other options. See [Lifting Strategies](Lifting.md#strategies)

`cluster_count`
: For the `"cluster"` strategy only, how many clusters to use

`depth`
: For the `"cluster"` strategy only, how deep the tree or recursive call should be

`fallback`
: What stratgey to use when `depth == 0` or when a clustering operation fails

`min_cvx`
: For the `"convex"` strategy, a minimal convexity requirement, must be strictly greater than 0

`solver`
: Which solver to use, must be comatible with the strategy, see [YALMIP]() documentation

<hr>

## Methods

### <span class="code"> <span class="fun">static method </span> linearDefault </span>

Creates a [LiftOptions](LiftOptions.md) with default (non debug) settings for the `"linear"` strategy

**Usage**
```matlab
options = LiftOptions.linearDefault()
```
<hr>

### <span class="code"> <span class="fun">static method </span> convexDefault </span>

Creates a [LiftOptions](LiftOptions.md) with default (non debug) settings for the `"convex"` strategy

**Usage**
```matlab
options = LiftOptions.convexDefault()
```


<hr>

### <span class="code"> <span class="fun">static method </span> clusterDefault </span>

Creates a [LiftOptions](LiftOptions.md) with default (non debug) settings for the `"cluster"` strategy

**Usage**
```matlab
options = LiftOptions.clusterDefault()
```



