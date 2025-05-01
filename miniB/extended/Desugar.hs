module Desugar where
import Grammars 
import MiniB

desugar :: CST -> Expr
desugar (BooleanE b)   = Val b
desugar (NotE p)       = Not (desugar p)
desugar (AndE p q)     = And (desugar p) (desugar q)
desugar (OrE p q)      = Or (desugar p) (desugar q)
desugar (ImpliesE p q) = Or (Not (desugar p)) (desugar q)
desugar (IffE p q)     = Or (And (desugar p) (desugar q)) (And (Not(desugar p)) (Not(desugar q)))