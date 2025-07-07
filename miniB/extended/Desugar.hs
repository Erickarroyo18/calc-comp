module Desugar where
import Grammars 
import MiniB

desugar :: ASAS -> Expr
desugar (BooleanS b)   = Val b
desugar (NotS p)       = Not (desugar p)
desugar (AndS p q)     = And (desugar p) (desugar q)
desugar (OrS p q)      = Or (desugar p) (desugar q)
desugar (ImpliesS p q) = Or (Not (desugar p)) (desugar q)
desugar (EquivS p q)   = Or (And (desugar p) (desugar q)) (And (Not(desugar p)) (Not(desugar q)))