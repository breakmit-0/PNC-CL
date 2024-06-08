classdef PathLengthTest < matlab.unittest.TestCase
    
    properties
        G
    end

    methods(TestClassSetup)
        function createGraph(testCase)
            vertices = [
                1 0;
                2 0;
                4 0;
                1 1;
                3 1;
                0 2;
                2 2;
                4 2;
                2 3;
                1 4;
                3 4
            ];

            edges = [
                1 6; 1 7;
                2 5; 2 3;
                3 8;
                4 7;
                5 8; 5 9;
                6 9; 6 10;
                7 8; 7 9;
                8 11;
                9 10;
                9 11
            ];

            node_data = table(vertices, 'VariableNames', {'position'});
            edge_table = table(edges, 'VariableNames', {'EndNodes'});

            testCase.G = graph(edge_table, node_data);
        end
    end

    % Function name convention
    %
    % longPath -> path length is greater than 1
    % shortPath -> path length is 1
    % emptyPath -> path length is 0
    %
    % startEmpty -> no start specified
    % destEmpty -> no dest specified

    methods(Test)
        function longPathStartTargetEmpty(testCase)
            path = [1 7 9 11 8 5 2 3];
            length = graph.path_length(testCase.G, path, [], []);
            testCase.assertEqual(length, 11.71477664, "AbsTol", 1e-7)
        end

        function shortPathStartTargetEmpty(testCase)
            path = 1;
            length = graph.path_length(testCase.G, path, [], []);
            testCase.assertEqual(length, 0)
        end

        function emptyPathStartTargetEmpty(testCase)
            path = [];
            length = graph.path_length(testCase.G, path, [], []);
            testCase.assertEqual(length, 0)
        end



        function longPathTargetEmpty(testCase)
            path = [1 7 9 11 8 5 2 3];
            length = graph.path_length(testCase.G, path, [10 2], []);
            testCase.assertEqual(length, 20.9343211, "AbsTol", 1e-7)
        end

        function shortPathTargetEmpty(testCase)
            path = 1;
            length = graph.path_length(testCase.G, path, [10 2], []);
            testCase.assertEqual(length, 9.219544457, "AbsTol", 1e-7)
        end

        function emptyPathTargetEmpty(testCase)
            path = [];
            length = graph.path_length(testCase.G, path, [10 2], []);
            testCase.assertEqual(length, 0)
        end


        function longPath(testCase)
            path = [1 7 9 11 8 5 2 3];
            length = graph.path_length(testCase.G, path, [10 2], [5 5]);
            testCase.assertEqual(length, 26.03334061, "AbsTol", 1e-7)
        end

        function shortPath(testCase)
            path = 1;
            length = graph.path_length(testCase.G, path, [10 2], [5 5]);
            testCase.assertEqual(length, 15.62266869, "AbsTol", 1e-7)
        end

        function emptyPath(testCase)
            path = [];
            length = graph.path_length(testCase.G, path, [10 2], [5 5]);
            testCase.assertEqual(length, 5.830951895, "AbsTol", 1e-7)
        end
    end
    
end