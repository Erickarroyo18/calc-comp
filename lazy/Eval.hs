module Eval where
import Prelude hiding (lookup)

data Expr = Num Int
          | Boolean Bool
          | Var String
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr
          | If Expr Expr Expr
          | Eq Expr Expr
          | Pair Expr Expr
          | Fst Expr
          | Lambda String Expr
          | App Expr Expr deriving (Show, Eq)

data Value = NumV Int 
           | BooleanV Bool 
           | Closure Expr Env 
           | Thunk Expr Env 
           | PairV Value Value 
           | ErrorV deriving (Show,Eq)

type Env = [(String, Value)]  

type Config = (RTExpr, Env)

data RTExpr = S Expr
            | C Expr Env
            | T Expr Env 
            | F RTExpr
            | E   deriving Show
            
step :: Config -> Maybe Config
step (S (Num n), env)      = Nothing
step (S (Boolean b), env)  = Nothing
step (S (Pair f s), env)   = Nothing
step (S (Var x), env)      = case lookup x env of
                                Thunk e env'   -> Just (T e env', env)
-- Force ----------------------------------------------------------------- Force
step (F (T expr env), oEnv) = case step (S expr, env) of
                              Just (S expr', env')      -> step (F (T expr' env'), oEnv)
                              Just (T expr' envT, env') -> step (F (T expr' envT), oEnv)
                              Just (C expr' envC, env') -> Just (C expr' envC, oEnv)
                              Nothing                   -> Just (S expr, oEnv)
-- Add ----------------------------------------------------------------- Add
step (S (Add (Num n) (Num m)), env) = Just (S (Num (n+m)), env)
step (S (Add (Num n) e2), env) = case step (S e2, env) of
                                Just (S e2', env')   -> Just (S (Add (Num n) e2'), env')
                                Just (T e2' d, env') -> case step (F (T e2' d), env') of
                                                        Just (S v, env'') -> Just  (S (Add (Num n) v), env'')
                                Nothing              -> Nothing
step (S (Add e1 e2), env) = case step (S e1, env) of
                            Just (S e1',env')    -> Just (S (Add e1' e2), env')
                            Just (T e1' d, env') -> case step (F (T e1' d), env') of
                                                    Just (S v, env'') -> Just (S (Add v e2), env'')
                            Nothing              -> Nothing
-- Sub ----------------------------------------------------------------- Sub
step (S (Sub (Num n) (Num m)), env) = Just (S (Num (n-m)), env)
step (S (Sub (Num n) e2), env) = case step (S e2, env) of
                                Just (S e2', env')   -> Just (S (Sub (Num n) e2'), env')
                                Just (T e2' d, env') -> case step (F (T e2' d), env') of
                                                        Just (S v, env'') -> Just (S (Sub (Num n) v), env'')
                                Nothing              -> Nothing
step (S (Sub e1 e2), env) = case step (S e1, env) of
                            Just (S e1',env')    -> Just (S (Sub e1' e2), env')
                            Just (T e1' d, env') -> case step (F (T e1' d), env') of
                                                    Just (S v, env'') -> Just (S (Sub v e2), env'')
                            Nothing              -> Nothing
-- Mul ----------------------------------------------------------------- Mul
step (S (Mul (Num n) (Num m)), env) = Just (S (Num (n*m)), env)
step (S (Mul (Num n) e2), env) = case step (S e2, env) of
                                Just (S e2', env')   -> Just (S (Mul (Num n) e2'), env')
                                Just (T e2' d, env') -> case step (F (T e2' d), env') of
                                                        Just (S v, env'') -> Just  (S (Mul (Num n) v), env'')
                                Nothing              -> Nothing
step (S (Mul e1 e2), env) = case step (S e1, env) of
                            Just (S e1',env')    -> Just (S (Mul e1' e2), env')
                            Just (T e1' d, env') -> case step (F (T e1' d), env') of
                                                    Just (S v, env'') -> Just (S (Mul v e2), env'')
                            Nothing              -> Nothing
-- Div ----------------------------------------------------------------- Div
step (S (Div (Num n) (Num 0)), env) = Just (E, env)
step (S (Div (Num n) (Num m)), env) = Just (S (Num (n `div` m)), env)
step (S (Div (Num n) e2), env) = case step (S e2, env) of
                                Just (S e2', env')   -> Just (S (Div (Num n) e2'), env')
                                Just (T e2' d, env') -> case step (F (T e2' d), env') of
                                                        Just (S v, env'') -> Just  (S (Div (Num n) v), env'')
                                Nothing              -> Nothing
step (S (Div e1 e2), env) = case step (S e1, env) of
                            Just (S e1',env')    -> Just (S (Div e1' e2), env')
                            Just (T e1' d, env') -> case step (F (T e1' d), env') of
                                                    Just (S v, env'') -> Just (S (Div v e2), env'')
                            Nothing              -> Nothing
-- Fst ----------------------------------------------------------------- Fst
step (S (Fst p), env) = case p of
                        Pair f s -> Just (T f env, env)
                        _        -> case step (S p, env) of
                                    Just (S p', env')   -> Just (S (Fst p'), env')
                                    Just (T p' d, env') -> case step (F (T p' d), env') of
                                                          Just (S v, env'') -> Just (S (Fst v), env'')
                                    Nothing             -> Nothing
-- Eq ----------------------------------------------------------------- Eq
step (S (Eq (Num n) (Num m)), env) = Just (S (Boolean (n==m)), env)
step (S (Eq (Num n) e2), env) = case step (S e2, env) of
                                Just (S e2', env')   -> Just (S (Eq (Num n) e2'), env')
                                Just (T e2' d, env') -> case step (F (T e2' d), env') of
                                                        Just (S v, env'') -> Just  (S (Eq (Num n) v), env'')
                                Nothing              -> Nothing
step (S (Eq e1 e2), env) = case step (S e1, env) of
                            Just (S e1',env')    -> Just (S (Eq e1' e2), env')
                            Just (T e1' d, env') -> case step (F (T e1' d), env') of
                                                    Just (S v, env'') -> Just (S (Eq v e2), env'')
                            Nothing              -> Nothing
-- If ----------------------------------------------------------------- If
step (S (If (Boolean True) t e), env)  = Just (S t, env)
step (S (If (Boolean False) t e), env) = Just (S e, env)
step (S (If c t e), env) = case step (S c, env) of
                            Just (S c', env')   -> Just (S (If c' t e), env')
                            Just (T c' d, env') -> case step (F (T c' d), env') of
                                                   Just (S v, env'') -> Just (S (If v t e), env'')
                            Nothing             -> Nothing                          
-- Lambda -------------------------------------------------------------- Lambda
step (S (Lambda a c), env) = Just (C (Lambda a c) env, env)
-- App ----------------------------------------------------------------- App
step (S (App f a), env) = case step (S f, env) of
                          Just (C (Lambda x y) d, env') -> Just (S y, (x, Thunk a env'):d)
                          Just (S f', env')   -> Just (S (App f' a), env')
                          Just (T f' d, env') -> case step (F (T f' d), env') of
                                                  Just (S v, env'')               -> Just (S (App v a), env'')
                                                  Just (C (Lambda x y) d', env'') -> Just (S y, (x, Thunk a env''):d')
                          Nothing             -> Nothing

eval:: Expr -> Env -> Value
eval expr env = case step (S expr, env) of
    Nothing -> case expr of
        Num n     -> NumV n
        Boolean b -> BooleanV b
        Pair f s  -> PairV (Thunk f env) (Thunk s env)
    Just (E, env')       -> ErrorV
    Just (T s d, env')   -> Thunk s d
    Just (C f d, env')   -> Closure f d
    Just (S expr', env') -> eval expr' env'

lookup :: String -> [( String , a)] -> a
lookup s [] = error ("Variable no encontrada: " ++ s )
lookup s (( k , v) : xs )
                        | s == k = v
                        | otherwise = lookup s xs