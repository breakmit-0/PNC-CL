% Compute a graph based on the edges of all faces.
% param:
% * faces: a list of Polyhedron of equal dimension (>= 2)
function [G] = facetsToGraph(faces)
    vertexSet = VertexSet();
    
    edges = polyunionToEdges(faces);
    startNodes = [];
    endNodes = [];
    weights = [];
    
    for edge = edges.'
        if size(edge.V, 1) == 2
            V1 = edge.V(1, :);
            V2 = edge.V(2, :);
            i1 = vertexSet.getIndex(V1);
            i2 = vertexSet.getIndex(V2);
    
            startNodes = [i1; startNodes];
            endNodes = [i2; endNodes];
            weights = [dist(V1, V2); weights];
        end
    end
    
    G = graph(startNodes, endNodes, weights);
end

