module Desugar where
import Grammars 
import Iris

desugar :: ASAS -> Expr
desugar (NumS n)       = Num n
desugar (BooleanS b)   = Boolean b
desugar (VarS x)       = Var x
desugar (FstS e)       = Fst (desugar e)
desugar (PairS e1 e2)  = Pair (desugar e1) (desugar e2)
desugar (AppS e1 e2)   = App (desugar e1) (desugar e2)
desugar (IfS e1 e2 e3) = If (desugar e1) (desugar e2) (desugar e3)
desugar (AddS e1 e2)   = Add (desugar e1) (desugar e2)
desugar (SubS e1 e2)   = Sub (desugar e1) (desugar e2)
desugar (MulS e1 e2)   = Mul (desugar e1) (desugar e2)
desugar (DivS e1 e2)   = Div (desugar e1) (desugar e2)
desugar (EqS e1 e2)    = Eq (desugar e1) (desugar e2)
desugar (LambdaS x e)  = Lambda x (desugar e)
desugar (RecS x e1 e2) = App (Lambda x (desugar e2)) (App y (Lambda x (desugar e1)))

y :: Expr 
y = Lambda "f" (App 
                    (Lambda "x" (App (Var "f") (App (Var "x") (Var "x")))) 
                    (Lambda "x" (App (Var "f") (App (Var "x") (Var "x")))))