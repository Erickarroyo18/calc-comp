module Eval where

data Expr = Val Bool 
          | Not Expr 
          | And Expr Expr 
          | Or Expr Expr deriving (Show, Eq)

eval :: Expr -> Bool
eval ( Val b )     = b
eval ( Not e )     = not ( eval e)
eval ( And e1 e2 ) = eval e1 && eval e2
eval ( Or e1 e2 )  = eval e1 || eval e2