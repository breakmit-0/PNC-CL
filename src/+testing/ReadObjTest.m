% WARNING EQUALITY BETWEEN POLYHEDRON IS NOT IMPLEMENTED BY MPT.
% Therefore all equality check between two polyhedron is performed by
% MATLAB, who checks if all properties are equals. So, a polyhedron in HRep
% will no be equal to a polyhedron in VRep.
classdef ReadObjTest < matlab.unittest.TestCase
    
    methods(Test)
        function readObjTest1(testCase)
            polyhedron = util.read_obj("src/+testing/obj/plane.obj");
            expected = Polyhedron('V', [1 1 0; 1 -1 0; -1 1 0; -1 -1 0]);
            testCase.assertTrue(polyhedron == expected, "Polyhedron not equals");
        end

        function readObjTest2(testCase)
            polyhedra = util.read_obj("src/+testing/obj/multi.obj");
            expected1 = Polyhedron('V', [1 1 0; 1 -1 0; -1 1 0; -1 -1 0]);
            expected2 = Polyhedron('V', [1 1 1; 1 -1 1; -1 1 1; -1 -1 1]);
            testCase.assertTrue(all(size(polyhedra) == [1 2]), "Bad array size");
            testCase.assertTrue(polyhedra(1) == expected1, "Polyhedron not equals");
            testCase.assertTrue(polyhedra(2) == expected2, "Polyhedron not equals");
        end
    end
end