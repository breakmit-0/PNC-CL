classdef MatrixEqualsTest < matlab.unittest.TestCase
    
    methods(Test)
        function equalWithPrecisionTest(testCase)
            m1 = [0 0 0; 0 0 0];
            m2 = [0 0 0; 1 1 1];

            testCase.assertTrue(util.matrix_equals(m1, m2, 1));
        end

        function notEqualWithPrecisionTest(testCase)
            m1 = [0 0 0; 0 0 0];
            m2 = [0 0 0; 1 1 1];

            testCase.assertFalse(util.matrix_equals(m1, m2, 0.9999));
        end

        function badSizeTest(testCase)
            m1 = [0 0 0; 0 0 0];
            m2 = [0 0 0];

            testCase.assertFalse(util.matrix_equals(m1, m2, 1));
        end

        function notEqualWithoutPrecision(testCase)
            m1 = [0 0 0; 0 0 0];
            m2 = [0 0 0; 1 1 1];

            testCase.assertFalse(util.matrix_equals(m1, m2));
        end

        function equalWithoutPrecision(testCase)
            m1 = [0 0 0; 0 0 0];
            m2 = [0 0 0; 1e-3 1e-3 0.2];

            testCase.assertFalse(util.matrix_equals(m1, m2));
        end

        function emptyTest(testCase)
            m1 = [0 0];
            m2 = double.empty;

            testCase.assertFalse(util.matrix_equals(m1, m2));
        end
    
        function bothEmptyTest(testCase)
            m1 = double.empty;
            m2 = double.empty;

            testCase.assertTrue(util.matrix_equals(m1, m2));
        end
    end
end