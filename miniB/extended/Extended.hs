module Extended where
import Grammars
import MiniB
import Desugar

run :: String -> Bool
run s = head $ exec (comp (desugar (parse (lexer s)))) []

test1 :: String
test1 = "True" 

test2 :: String
test2 = "False" 

test3 :: String
test3 = "(not True)" 

test4 :: String
test4 = "(not False)" 

test5 :: String
test5 = "(True and False)" 

test6 :: String
test6 = "(True or False)" 

test7 :: String
test7 = "(True => False)" 

test8 :: String
test8 = "(True <=> False)" 

test9 :: String
test9 = "(not (True and False))" 

test10 :: String
test10 = "((True or False) and (not False))" 