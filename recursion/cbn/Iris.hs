module Iris where
import Prelude hiding (EQ, lookup)

data Expr = Num Int
          | Boolean Bool
          | Var String
          | Add Expr Expr
          | Sub Expr Expr
          | Div Expr Expr
          | Mul Expr Expr
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
          | LOOKUP String Code
          | ADD Code
          | SUB Code
          | MUL Code
          | DIV Code
          | EQ Code
          | IF Code Code
          | FORCE Code
          | CEV
          | RET
          | FST Code
          | PAIR Code Code Code
          | ABS Code Code
          | LAMBDA String Code
          | APP Code Code deriving (Show, Eq)

comp :: Expr -> Code
comp e = comp' e HALT

comp' :: Expr -> Code -> Code
comp' (Num n) c      = PUSHN n c
comp' (Boolean b) c  = PUSHB b c
comp' (Var x) c      = LOOKUP x c
comp' (Add x y) c    = comp' x (FORCE (comp' y (FORCE (ADD c))))
comp' (Div x y) c    = comp' x (FORCE (comp' y (FORCE (DIV c))))
comp' (Sub x y) c    = comp' x (FORCE (comp' y (FORCE (SUB c))))
comp' (Mul x y) c    = comp' x (FORCE (comp' y (FORCE (MUL c))))
comp' (Eq x y) c     = comp' x (FORCE (comp' y (FORCE (EQ c))))
comp' (If c t e) c'  = comp' c (FORCE (IF (comp' t c') (comp' e c')))
comp' (Pair x y) c   = PAIR (comp' x CEV) (comp' y CEV) c
comp' (Fst x) c      = comp' x (FORCE (FST c))
comp' (Lambda x y) c = ABS (LAMBDA x (comp' y RET)) c
comp' (App x y) c    = comp' x (FORCE (APP (comp' y CEV) c))

-- Virtual Machine
data Value = NumV Int 
           | BooleanV Bool 
           | Closure Code Env 
           | PairV Value Value 
           | Thunk Code Env 
           | ErrorV deriving (Show, Eq)

data Elem = VAL Value | CLO Code Env deriving (Show, Eq)

type Env = [(String, Value)]

type Stack = [Elem]

type Conf = (Stack, Env)

exec :: Code -> Conf -> Conf
exec _ (VAL ErrorV:s,e)                               = error ("Division por cero")
exec HALT (s, e)                                      = (s, e)
exec (FORCE c) (VAL (Thunk c' d):s, e)                = exec c' (CLO c e: s, d)
exec (FORCE c) (VAL (NumV n): s, e)                   = exec c (VAL (NumV n): s, e)
exec (FORCE c) (VAL (BooleanV b): s, e)               = exec c (VAL (BooleanV b): s, e)
exec (FORCE c) (VAL (PairV u v): s, e)                = exec c (VAL (PairV u v): s, e)
exec (FORCE c) (VAL (Closure (LAMBDA a b) d):s,e)     = exec c (VAL (Closure (LAMBDA a b) d):s,e)
exec CEV (VAL (Thunk c' d): CLO c e:s,_)              = exec c' (CLO c e:s,d) 
exec CEV (VAL v: CLO c e:s,_)                         = exec c (VAL v:s,e) 
exec (PUSHN n c) (s,e)                                = exec c (VAL (NumV n):s,e)
exec (PUSHB b c) (s,e)                                = exec c (VAL (BooleanV b):s,e)
exec (LOOKUP x c) (s,e)                               = exec c (VAL (lookup x e):s , e )
exec (ADD c) (VAL (NumV m):VAL (NumV n):s, e)         = exec c (VAL (NumV (n+m)):s, e) 
exec (MUL c) (VAL (NumV m):VAL (NumV n):s, e)         = exec c (VAL (NumV (n*m)):s, e) 
exec (DIV c) (VAL (NumV 0):VAL (NumV n):s, e)         = exec c (VAL ErrorV:s, e) 
exec (DIV c) (VAL (NumV m):VAL (NumV n):s, e)         = exec c (VAL (NumV (n `div` m)):s, e) 
exec (SUB c) (VAL (NumV m):VAL (NumV n):s, e)         = exec c (VAL (NumV (n-m)):s, e) 
exec (PAIR x y c) (s, e)                              = exec c (VAL (PairV (Thunk x e) (Thunk y e)):s,e)
exec (FST c) (VAL (PairV x y):s, e)                   = exec c (VAL x:s,e)
exec (IF c _) (VAL (BooleanV True):s,e)               = exec c (s,e)
exec (IF _ c) (VAL (BooleanV False):s,e)              = exec c (s,e)
exec (EQ c) (VAL (NumV n):VAL (NumV m):s, e)          = exec c (VAL (BooleanV (n==m)):s, e) 
exec RET (VAL v: CLO c e:s,_)                         = exec c (VAL v:s,e)
exec (ABS c' c) (s,e)                                 = exec c (VAL (Closure c' e):s,e)
exec (APP a c) (VAL (Closure (LAMBDA p c') e'): s, e) = exec c' (CLO c e:s, (p,Thunk a e):e')

lookup :: String -> [( String , a)] -> a
lookup s [] = error ("Variable no encontrada: " ++ s )
lookup s (( k , v) : xs )
                        | s == k = v
                        | otherwise = lookup s xs