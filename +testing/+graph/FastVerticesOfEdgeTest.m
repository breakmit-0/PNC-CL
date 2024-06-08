classdef FastVerticesOfEdgeTest < matlab.unittest.TestCase
    
    methods(Test)

        function fastVerticesOfEdgeMinHRepTest(testCase)
            edge = Polyhedron('A', [1 0 0; -1 0 0], 'b', [5; -1], ...
                'Ae', [0.75, -1, 0; 0.75, 0, -1], 'be', [-2.25, -3.25]);
            vertices = graph.fast_vertices_of_edge(edge);
            testCase.check(edge, vertices)
        end

        function fastVerticesOfEdgeMinTest(testCase)
            edge = Polyhedron('A', [188.0801  819.8631  207.3131;
                                    -74.7231  -26.4024   30.0222;
                                    50.1408  897.1358  149.3046;
                                    0.0090   -0.0223   -0.0184;
                                    0.0128   -0.0192   -0.0158;
                                    0.0228   -0.0117   -0.0060], ...
                 'b', [0; -2.0000; -2.0000; 0.0010; 0.0010; 0.0010], ...
                 'Ae', [188.0801 -114.4994 674.5977;
                        -73.0067 -27.9303 32.3290], ...
                 'be', [-0.3695; -2.0000]);
            vertices = graph.fast_vertices_of_edge(edge);
            testCase.check(edge, vertices)
        end
    end

     methods (Access=private)
        function check(testCase, edge, vertices)
            testCase.assertEqual(height(vertices), 2, "An edge has two vertices")

            expected = edge.V;
            testCase.assertEqual(width(expected), width(vertices), "Invalid dimension")
        
            if ismembertol(expected(1, :), vertices(1, :), 1e-7)
                testCase.assertEqual(expected(2, :), vertices(2, :), "Invalid second point", "AbsTol", 1e-7)
            else
                testCase.assertEqual(expected(1, :), vertices(2, :), "Invalid first point", "AbsTol", 1e-7)
                testCase.assertEqual(expected(2, :), vertices(1, :), "Invalid second point", "AbsTol", 1e-7)
            end
        end
    end
end