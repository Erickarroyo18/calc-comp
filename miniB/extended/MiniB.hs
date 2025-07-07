module MiniB where
    
data Expr = Val Bool 
          | Not Expr 
          | And Expr Expr 
          | Or Expr Expr deriving (Show, Eq)

data Code = HALT
          | PUSH Bool Code
          | NOT Code
          | AND Code
          | OR Code deriving (Show, Eq)

comp :: Expr -> Code
comp e = comp' e HALT

comp' :: Expr -> Code -> Code
comp' (Val n) c   = PUSH n c
comp' (Not e) c   = comp' e (NOT c)
comp' (And x y) c = comp' x (comp' y (AND c))
comp' (Or x y) c  = comp' x (comp' y (OR c))


type Stack = [Bool]

exec :: Code -> Stack -> Stack
exec HALT s          = s
exec (PUSH n c) s    = exec c ( n : s)
exec (NOT c) (b:s)   = exec c (not b : s)
exec (AND c) (m:n:s) = exec c ((n && m) : s )
exec (OR c) (m:n:s)  = exec c ((n || m) : s )