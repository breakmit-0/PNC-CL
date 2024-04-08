classdef NodeTest < matlab.unittest.TestCase
    
    methods(Test)
        function insertAfterTest(testCase)
            import testing.NodeTest.*;

            n1 = graph.Node(1);
            testCase.assertNodeEmpty(n1, 1);

            n1.value = 0;
            n2 = n1.insertAfter(1);
            testCase.assertHead(n1, 0, n2);
            testCase.assertTail(n2, n1, 1);

            n3 = n1.insertAfter(2);
            testCase.assertHead(n1, 0, n3);
            testCase.assertNode(n3, n1, 2, n2)
            testCase.assertTail(n2, n3, 1);
        end

        function removeMiddle(testCase)
            n1 = graph.Node(1);
            n2 = n1.insertAfter(2);
            n3 = n2.insertAfter(3);
            
            n = n2.remove();
            testCase.assertHead(n1, 1, n3);
            testCase.assertTail(n3, n1, 3);
            testCase.assertNodeEmpty(n2, 2);
            testCase.assertEqual(n, n3);
        end

        function removeHeadTest(testCase)
            n1 = graph.Node(1);
            n2 = n1.insertAfter(2);

            n = n1.remove();

            testCase.assertNodeEmpty(n1, 1);
            testCase.assertNodeEmpty(n2, 2);
            testCase.assertEqual(n, n2);
        end 

        function removeTailTest(testCase)
            n1 = graph.Node(1);
            n2 = n1.insertAfter(2);

            n = n2.remove();

            testCase.assertNodeEmpty(n1, 1);
            testCase.assertNodeEmpty(n2, 2);
            testCase.assertEmpty(n);
        end
    end

    methods(Access=private)
        function assertNode(testCase, node, prev, value, next)
            testCase.assertTrue(node.prev == prev);
            testCase.assertTrue(node.next == next);
            testCase.assertTrue(node.value == value);
        end

        function assertHead(testCase, node, value, next)
            testCase.assertTrue(isempty(node.prev));
            testCase.assertTrue(node.next == next);
            testCase.assertTrue(node.value == value);
        end

        function assertTail(testCase, node, prev, value)
            testCase.assertTrue(node.prev == prev);
            testCase.assertTrue(isempty(node.next));
            testCase.assertTrue(node.value == value);
        end

        function assertNodeEmpty(testCase, node, value)
            testCase.assertTrue(isempty(node.prev));
            testCase.assertTrue(isempty(node.next));
            testCase.assertTrue(node.value == value);
        end
    end
    
end