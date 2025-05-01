module Desugar where
import Grammars 
import Alanis

desugar :: CST -> Expr
desugar (NumE n)       = Num n
desugar (BooleanE b)   = Boolean b
desugar (VarE x)       = Var x
desugar (FstE e)       = Fst (desugar e)
desugar (PairE e1 e2)  = Pair (desugar e1) (desugar e2)
desugar (AppE e1 e2)   = App (desugar e1) (desugar e2)
desugar (IfE e1 e2 e3) = If (desugar e1) (desugar e2) (desugar e3)
desugar (AddE e1 e2)   = Add (desugar e1) (desugar e2)
desugar (SubE e1 e2)   = Sub (desugar e1) (desugar e2)
desugar (MulE e1 e2)   = Mul (desugar e1) (desugar e2)
desugar (DivE e1 e2)   = Div (desugar e1) (desugar e2)
desugar (EqE e1 e2)    = Eq (desugar e1) (desugar e2)
desugar (LambdaE x e)  = Lambda x (desugar e)
desugar (RecE x e1 e2) = App (Lambda x (desugar e2)) (App z (Lambda x (desugar e1)))

z :: Expr
z = Lambda "f" (App 
                      (Lambda "x" (App (Var "f") 
                                        (Lambda "y" (App (App (Var "x") (Var "x")) (Var "y"))))) 
                      (Lambda "x" (App (Var "f") 
                                        (Lambda "y" (App (App (Var "x") (Var "x")) (Var "y"))))))