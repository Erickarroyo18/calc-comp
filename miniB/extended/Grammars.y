{
module Grammars where

import Data.Char
}

%name parse
%tokentype { Token }
%error { parseError }

%token 
      "True"    { TokenTrue }
      "False"   { TokenFalse }
      "not"     { TokenNot }
      "and"     { TokenAnd }
      "or"      { TokenOr }
      "=>"      { TokenImplies }
      "<=>"     { TokenIff }
      '('       { TokenPA }
      ')'       { TokenPC }

%%

S : Expr { $1 }

Expr : "True"                       { BooleanS True }
     | "False"                      { BooleanS False }
     | '(' "not" Expr ')'           { NotS $3 }
     | '(' Expr "and" Expr ')'      { AndS $2 $4 }
     | '(' Expr "or" Expr ')'       { OrS $2 $4 }
     | '(' Expr "=>" Expr ')'       { ImpliesS $2 $4 }
     | '(' Expr "<=>" Expr ')'      { EquivS $2 $4 }

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

-- srcASA para lógica proposicional en notación prefija
data ASAS = BooleanS Bool
         | NotS ASAS
         | AndS ASAS ASAS
         | OrS ASAS ASAS
         | ImpliesS ASAS ASAS
         | EquivS ASAS ASAS
         deriving (Show)

data Token = TokenTrue
           | TokenFalse
           | TokenNot
           | TokenAnd
           | TokenOr
           | TokenImplies
           | TokenIff
           | TokenPA
           | TokenPC
           deriving (Show)

lexer :: String -> [Token]
lexer []                       = []
lexer (' ' : xs)               = lexer xs
lexer ('(' : xs)               = TokenPA : lexer xs
lexer (')' : xs)               = TokenPC : lexer xs
lexer ('T':'r':'u':'e':xs)     = TokenTrue : lexer xs
lexer ('F':'a':'l':'s':'e':xs) = TokenFalse : lexer xs
lexer ('n':'o':'t':xs)         = TokenNot : lexer xs
lexer ('a':'n':'d':xs)         = TokenAnd : lexer xs
lexer ('o':'r':xs)             = TokenOr : lexer xs
lexer ('=':'>':xs)             = TokenImplies : lexer xs
lexer ('<':'=':'>':xs)         = TokenIff : lexer xs
lexer _                        = error "Unknown token"

main = getContents >>= print . parse . lexer
}