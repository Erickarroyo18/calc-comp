module LambdaCBName where
import Iris
import Desugar
import Grammars hiding (main)
import Prelude hiding (EQ)

run :: String -> Value
run str = let (VAL v) = head $ fst (exec (comp (desugar (parse (lexer str)))) ([],[])) in v

test1 :: String
test1 = "42"

test2 :: String
test2 = "True"

test3 :: String
test3 = "(+ 3 4)"

test4 :: String
test4 = "(- 10 5)"

test5 :: String
test5 = "(* 2 6)"

test6 :: String
test6 = "(/ 8 2)"

test7 :: String
test7 = "(= 5 5)"

test8 :: String
test8 = "(= 3 7)"

test9 :: String
test9 = "(if True 1 0)"

test10 :: String
test10 = "(if False 1 0)"

test11 :: String
test11 = "(fst (3, 4))"

test12 :: String
test12 = "(+ (fst (7, 8)) 2)"

test13 :: String
test13 = "(if (= 4 4) (+ 1 1) (- 5 3))"

test14 :: String
test14 = "((Lambda x (+ x 1)) 5)"

test15 :: String
test15 = "((Lambda y (* y 2)) 3)"

test16 :: String
test16 = "(+ (fst ((Lambda z (z, z)) 5)) 1)"

test17 :: String
test17 = "((Lambda x (if x 1 0)) True)"

test18 :: String
test18 = "(/ 5 0)"  

test19 :: String
test19 = "((Lambda x (/ 10 x)) 0)" 

test20 :: String
test20 = "(+ ((Lambda x (+ x x)) 3) ((Lambda y (- y 1)) 4))"

testSum :: String
testSum = "(Rec sum (Lambda n (if (= n 0) 0 (+ n (sum (- n 1))))) (sum 5))"

testFact :: String
testFact = "(Rec fact (Lambda n (if (= n 0) 1 (* n (fact (- n 1))))) (fact 5))"

testFib :: String
testFib = "(Rec fib (Lambda n (if (= n 0) 0 (if (= n 1) 1 (+ (fib (- n 1)) (fib (- n 2)))))) (fib 9))"

-- Potencia de 2 elevado a n (2^n)
testPow2 :: String
testPow2 = "(Rec pow (Lambda n (if (= n 0) 1 (* 2 (pow (- n 1))))) (pow 4))"

-- Producto de los primeros n números impares
testOddProd :: String
testOddProd = "(Rec oddProd (Lambda n (if (= n 0) 1 (* (- (* 2 n) 1) (oddProd (- n 1))))) (oddProd 3))"

-- Suma de cuadrados de los primeros n números
testSumSquares :: String
testSumSquares = "(Rec sumSq (Lambda n (if (= n 0) 0 (+ (* n n) (sumSq (- n 1))))) (sumSq 3))"

-- Número triangular n(n+1)/2
testTriangular :: String
testTriangular = "(Rec tri (Lambda n (if (= n 0) 0 (+ n (tri (- n 1))))) (tri 5))"