module Eval where 
import Prelude hiding (lookup)

data Expr = Num Int
  | Boolean Bool
  | Var String
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | If Expr Expr Expr
  | Eq Expr Expr
  | Pair Expr Expr
  | Fst Expr
  | Lambda String Expr
  | App Expr Expr deriving (Show, Eq)

data Value = NumV Int 
            | BooleanV Bool 
            | Closure Expr Env 
            | PairV Value Value 
            | Error deriving Show

type Env   = [(String, Value)]

eval :: Expr -> Env -> Value
eval (Num n) env = NumV n
eval (Boolean b) env = BooleanV b
eval (Var id) env = lookup id env
eval (Add x y) env = case eval x env of
                        NumV n -> case eval y env of
                                    NumV m -> NumV (n + m)
eval (Sub x y) env = case eval x env of
                        NumV n -> case eval y env of
                                    NumV m -> NumV (n - m)
eval (Mul x y) env = case eval x env of
                        NumV n -> case eval y env of
                                    NumV m -> NumV (n * m)
eval (Div x y) env = case eval x env of
                        NumV n -> case eval y env of
                                    NumV 0 -> Error
                                    NumV m -> NumV (n `div` m)
eval (Eq x y) env = case eval x env of
                        NumV n -> case eval y env of
                                    NumV m -> BooleanV (n == m)
eval (Pair x y) env = PairV (eval x env) (eval y env)
eval (Fst x) env    = case eval x env of
                        PairV f s -> f
eval (If c t e) env = case eval c env of
                        BooleanV b -> if b then eval t env else eval e env
eval (Lambda x y) env = Closure (Lambda x y) env
eval (App x y) env = case eval x env of
                        Closure (Lambda a c) env' -> eval c ((a, eval y env) : env')

lookup :: String -> [( String , a)] -> a
lookup s [] = error (" Variable no encontrada : " ++ s )
lookup s (( k , v) : xs )
                        | s == k = v
                        | otherwise = lookup s xs