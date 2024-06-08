classdef EdgesToGraphTest < matlab.unittest.TestCase
    
    methods(Test)
        function edgesToGraphVRepTest(testCase)
            V1 = [1 0];
            V2 = [2 0];
            V3 = [4 0];
            V4 = [1 1];
            V5 = [3 1];
            V6 = [0 2];
            V7 = [2 2];
            V8 = [4 2];
            V9 = [2 3];
            V10 = [1 4];
            V11 = [3 4];
           
            edges = [
                Polyhedron([V1; V6]); 
                Polyhedron([V1; V7]);
                Polyhedron([V2; V5]); 
                Polyhedron([V2; V3]);
                Polyhedron([V3; V8]);
                Polyhedron([V4; V7]);
                Polyhedron([V5; V8]); 
                Polyhedron([V5; V9]);
                Polyhedron([V6; V9]); 
                Polyhedron([V6; V10]);
                Polyhedron([V7; V8]); 
                Polyhedron([V7; V9]);
                Polyhedron([V8; V11]);
                Polyhedron([V9; V10]);
                Polyhedron([V9; V11])
                ];

            G = graph.edges_to_graph(edges);
            testCase.check(edges, G)
        end

        function edgesToGraphHRep(testCase)
            edges = [
                Polyhedron('A', [1 0; -1 0], 'b', [1, 0], 'Ae', [-2 -1], 'be', -2);
                Polyhedron('A', [1 0; -1 0], 'b', [2, -1], 'Ae', [2 -1], 'be', 2);
                Polyhedron('A', [1 0; -1 0], 'b', [3, -2], 'Ae', [1 -1], 'be', 2);
                Polyhedron('A', [1 0; -1 0], 'b', [4, -2], 'Ae', [0 -1], 'be', 0);
                Polyhedron('A', [0 1; 0 -1], 'b', [2, 0], 'Ae', [-1 0], 'be', -4);
                Polyhedron('A', [1 0; -1 0], 'b', [2, -1], 'Ae', [1 -1], 'be', 0);
                Polyhedron('A', [1 0; -1 0], 'b', [4, -3], 'Ae', [1 -1], 'be', 2);
                Polyhedron('A', [1 0; -1 0], 'b', [3, -2], 'Ae', [-2 -1], 'be', -7);
                Polyhedron('A', [1 0; -1 0], 'b', [2, 0], 'Ae', [0.5 -1], 'be', -2);
                Polyhedron('A', [1 0; -1 0], 'b', [1, 0], 'Ae', [2 -1], 'be', -2);
                Polyhedron('A', [1 0; -1 0], 'b', [4, -2], 'Ae', [0 -1], 'be', -2);
                Polyhedron('A', [0 1; 0 -1], 'b', [3, -2], 'Ae', [-1 0], 'be', -2);
                Polyhedron('A', [1 0; -1 0], 'b', [4, -3], 'Ae', [-2 -1], 'be', -10);
                Polyhedron('A', [1 0; -1 0], 'b', [2, -1], 'Ae', [-1 -1], 'be', -5);
                Polyhedron('A', [1 0; -1 0], 'b', [3, -2], 'Ae', [1 -1], 'be', -1)
                ];

            G = graph.edges_to_graph(edges);
            testCase.check(edges, G)
        end
    end
    
    methods (Access=private)
        function check(testCase, edges, G)
            testCase.assertEqual(G.numedges, height(edges), "Invalid number of edges")

            for edge = edges.'
                i1 = testCase.findVertex(G, edge.V(1, :));
                i2 = testCase.findVertex(G, edge.V(2, :));

                testCase.assertTrue(i1 ~= 0, "Vertex not found")
                testCase.assertTrue(i2 ~= 0, "Vertex not found")
                iEdge = G.findedge(i1, i2);
                testCase.assertTrue(iEdge ~= 0, "Edge not found")

                weight = G.Edges.Weight(iEdge);
                testCase.assertEqual(weight, ...
                    norm(edge.V(1, :) - edge.V(2, :)), ...
                    "Invalid distance")
            end
        end
    end

    methods(Access=private, Static)

        function index = findVertex(G, vertex)
            pos = G.Nodes.position;
            for i = 1:height(pos)
                if ismembertol(pos(i, :), vertex, 1e-5, 'DataScale', 1, 'ByRows', true)
                    index = i;
                    return
                end
            end

            index = 0;
        end
    end
end