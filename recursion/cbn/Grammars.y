
{
module Grammars where

import Data.Char
}

%name parse
%tokentype { Token }
%error { parseError }

%token 
      var       { TokenId $$ }
      int       { TokenNum $$ }
      boolT     { TokenTrue }
      boolF     { TokenFalse }
      "fst"     { TokenFst }
      '('       { TokenPA }
      ')'       { TokenPC }
      ','       { TokenComma }
      '+'       { TokenAdd }
      '-'       { TokenSub }
      '*'       { TokenMul }
      '/'       { TokenDiv }
      '='       { TokenEq }
      "if"      { TokenIf }
      "Lambda"  { TokenLambda }
      "Rec"     { TokenRec }

%%

S  : Expr { $1 }

Expr : int                         { NumE $1 }
     | boolT                       { BooleanE True }
     | boolF                       { BooleanE False }
     | var                         { VarE $1 }
     | '(' "fst" Expr ')'          { FstE $3 }
     | '(' Expr ',' Expr ')'       { PairE $2 $4 }
     | '(' Expr Expr ')'           { AppE $2 $3 }
     | '(' "if" Expr Expr Expr ')' { IfE $3 $4 $5 }
     | '(' '+' Expr Expr ')'       { AddE $3 $4 }
     | '(' '-' Expr Expr ')'       { SubE $3 $4 }
     | '(' '*' Expr Expr ')'       { MulE $3 $4 }
     | '(' '/' Expr Expr ')'       { DivE $3 $4 }
     | '(' '=' Expr Expr ')'       { EqE $3 $4 }
     | '(' "Lambda" var Expr ')'   { LambdaE $3 $4 }
     | '(' "Rec" var Expr Expr ')' { RecE $3 $4 $5 }

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

-- Definición de la estructura del AST
data CST = NumE Int
          | BooleanE Bool
          | VarE String
          | FstE CST
          | PairE CST CST
          | AppE CST CST
          | IfE CST CST CST
          | AddE CST CST
          | SubE CST CST
          | MulE CST CST
          | DivE CST CST
          | EqE CST CST
          | LambdaE String CST
          | RecE String CST CST
          deriving(Show)

data Token = TokenId String
           | TokenNum Int
           | TokenTrue
           | TokenFalse
           | TokenFst
           | TokenPA
           | TokenPC
           | TokenComma
           | TokenAdd
           | TokenSub
           | TokenMul
           | TokenDiv
           | TokenEq
           | TokenIf
           | TokenLambda
           | TokenRec
           deriving(Show)

lexer :: String -> [Token]
lexer [] = []
lexer (' ' : xs) = lexer xs
lexer ('(' : xs) = TokenPA : lexer xs
lexer (')' : xs) = TokenPC : lexer xs
lexer (',' : xs) = TokenComma : lexer xs
lexer ('+' : xs) = TokenAdd : lexer xs
lexer ('-' : xs) = TokenSub : lexer xs
lexer ('*' : xs) = TokenMul : lexer xs
lexer ('/' : xs) = TokenDiv : lexer xs
lexer ('=' : xs) = TokenEq : lexer xs
lexer ('f':'s':'t':xs) = TokenFst : lexer xs
lexer ('i':'f':xs) = TokenIf : lexer xs
lexer ('L':'a':'m':'b':'d':'a':xs) = TokenLambda : lexer xs
lexer ('R':'e':'c':xs) = TokenRec : lexer xs
lexer ('T':'r':'u':'e':xs) = TokenTrue : lexer xs
lexer ('F':'a':'l':'s':'e':xs) = TokenFalse : lexer xs
lexer (x:xs)
    | isDigit x = lexNum (x:xs)
    | isAlpha x = lexAlph (x:xs)

lexNum :: String -> [Token]
lexNum cs = TokenNum (read num) : lexer rest
      where (num,rest) = span isDigit cs

lexAlph :: String -> [Token]
lexAlph cs = TokenId var : lexer rest
      where (var,rest) = span isAlpha cs

main = getContents >>= print . parse . lexer
}