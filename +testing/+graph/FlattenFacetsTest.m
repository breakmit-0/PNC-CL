classdef FlattenFacetsTest < matlab.unittest.TestCase
    
    methods(Test)
        function flattenFacetsTest(testCase)
            polyhedra = [Polyhedron('V', [0 0, 1 1, 0 1, 1 0]);
                Polyhedron('V', [-1 -1 0; 1 -1 0; 0 1 0; 0 0 1]);
                Polyhedron('V', [1 2 3; 4 5 6])
                ];

            facets = graph.flatten_facets(polyhedra);
            testCase.check(facets, polyhedra);
        end

        function flattenFacetsTest2(testCase)
            polyhedra = Polyhedron('V', [0 0, 1 1, 0 1, 1 0]);

            facets = graph.flatten_facets(polyhedra);
            testCase.check(facets, polyhedra);
        end

        function flattenFacetsEmpty(testCase)
            testCase.check(graph.flatten_facets([]), []);
        end
    end
    

    methods (Access=private)
        function check(testCase, facets, polyhedra)
            count = 0;
            for p = polyhedra.'
                p.minHRep();
                for facet = p.getFacet().'
                    found = false;

                    for facet2 = facets.'
                        if facet.Dim == facet2.Dim && facet == facet2
                            found = true;
                            break
                        end
                    end

                    testCase.assertTrue(found, "A facet in polyhedra isn't in facets")
                    count = count + 1;
                end
            end

            testCase.assertEqual(height(facets), count, "Too many or not enough facets in facets")
        end
    end
end