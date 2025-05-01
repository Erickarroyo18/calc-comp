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
      "=>" { TokenImplies }
      "<=>"     { TokenIff }
      '('       { TokenPA }
      ')'       { TokenPC }

%%

S : Expr { $1 }

Expr : "True"                       { BooleanE True }
     | "False"                      { BooleanE False }
     | '(' "not" Expr ')'           { NotE $3 }
     | '(' Expr "and" Expr ')'      { AndE $2 $4 }
     | '(' Expr "or" Expr ')'       { OrE $2 $4 }
     | '(' Expr "=>" Expr ')'       { ImpliesE $2 $4 }
     | '(' Expr "<=>" Expr ')'      { IffE $2 $4 }

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

-- AST para lógica proposicional en notación prefija
data CST = BooleanE Bool
         | NotE CST
         | AndE CST CST
         | OrE CST CST
         | ImpliesE CST CST
         | IffE CST CST
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
lexer [] = []
lexer (' ' : xs) = lexer xs
lexer ('(' : xs) = TokenPA : lexer xs
lexer (')' : xs) = TokenPC : lexer xs
lexer ('T':'r':'u':'e':xs) = TokenTrue : lexer xs
lexer ('F':'a':'l':'s':'e':xs) = TokenFalse : lexer xs
lexer ('n':'o':'t':xs) = TokenNot : lexer xs
lexer ('a':'n':'d':xs) = TokenAnd : lexer xs
lexer ('o':'r':xs) = TokenOr : lexer xs
lexer ('=':'>':xs) = TokenImplies : lexer xs
lexer ('<':'=':'>':xs) = TokenIff : lexer xs
lexer _ = error "Unknown token"

main = getContents >>= print . parse . lexer
}