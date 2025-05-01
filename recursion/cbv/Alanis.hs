module Alanis where
import Prelude hiding (EQ, lookup)

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
            
-- Compiler
data Code = HALT
  | PUSHN Int Code
  | PUSHB Bool Code
  | ADD Code
  | SUB Code
  | DIV Code
  | MUL Code
  | IF Code Code
  | EQ Code
  | PAIR Code
  | FST Code
  | LAMBDA String Code
  | ABS Code Code
  | LOOKUP String Code
  | RET
  | APP Code deriving Show

comp :: Expr -> Code
comp e = comp' e HALT

comp' :: Expr -> Code -> Code
comp' (Num n) c       = PUSHN n c
comp' (Boolean b) c   = PUSHB b c
comp' (Var id) c      = LOOKUP id c
comp' (Add x y) c     = comp' x (comp' y (ADD c))
comp' (Sub x y) c     = comp' x (comp' y (SUB c))
comp' (Mul x y) c     = comp' x (comp' y (MUL c))
comp' (Div x y) c     = comp' x (comp' y (DIV c))
comp' (If x t e) c    = comp' x (IF (comp' t c) (comp' e c))
comp' (Eq x y) c      = comp' x (comp' y (EQ c))
comp' (Pair x y) c    = comp' x (comp' y (PAIR c))
comp' (Fst x) c       = comp' x (FST c)
comp' (Lambda id e) c = ABS (LAMBDA id (comp' e RET)) c
comp' (App f a) c     = comp' f (comp' a (APP c))

-- Virtual Machine 
data Value = NumV Int 
            | BooleanV Bool 
            | Closure Code Env 
            | PairV Value Value 
            | Error deriving Show

data Elem  = VAL Value | CLO Code Env deriving (Show)
type Env   = [(String, Value)]
type Stack = [Elem]
type Conf  = (Stack, Env)


exec :: Code -> Conf -> Conf
exec _ (VAL Error:s,e) = error ("Division por cero")
exec HALT (s, e)                                        = (s, e)
exec (PUSHN n c) (s, e)                                 = exec c (VAL (NumV n) : s, e)
exec (PUSHB b c) (s, e)                                 = exec c (VAL (BooleanV b) : s, e)
exec (LOOKUP id c) (s, e)                               = exec c (VAL (lookup id e):s,e)
exec (ADD c) (VAL (NumV m):VAL (NumV n):s,e)            = exec c (VAL (NumV (n + m)):s,e)
exec (SUB c) (VAL (NumV m):VAL (NumV n):s,e)            = exec c (VAL (NumV (n - m)):s,e)
exec (MUL c) (VAL (NumV m):VAL (NumV n):s,e)            = exec c (VAL (NumV (n * m)):s,e)
exec (DIV c) (VAL (NumV 0):VAL (NumV n):s,e)            = exec c (VAL Error : s, e)
exec (DIV c) (VAL (NumV m):VAL (NumV n):s,e)            = exec c (VAL (NumV (n `div` m)):s,e)
exec (IF ct ce) (VAL (BooleanV b):s,e)                  = if b then exec ct (s,e) else exec ce (s,e)
exec (EQ c) (VAL (NumV m):VAL (NumV n):s,e)             = exec c (VAL (BooleanV (n == m)):s,e)
exec (PAIR c) (VAL v : VAL u :s,e)                      = exec c (VAL (PairV v u):s,e)
exec (FST c) (VAL (PairV u v):s,e)                      = exec c (VAL u:s,e)
exec (ABS c c') (s, e)                                  = exec c' (VAL (Closure c e):s,e)
exec RET (VAL u : CLO c e : s, _)                       = exec c (VAL u:s,e)
exec (APP c) (VAL u:VAL (Closure (LAMBDA a c') e'):s,e) = exec c' (CLO c e:s, (a,u):e')

lookup :: String -> [( String , a)] -> a
lookup s [] = error (" Variable no encontrada : " ++ s )
lookup s (( k , v) : xs )
                        | s == k = v
                        | otherwise = lookup s xs