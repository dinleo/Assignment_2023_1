exception NotImplemented;;

type exp =
    | Num of int
    | Plus of exp * exp
    | Minus of exp * exp
;;
type formula =
    | True
    | False
    | Not of formula
    | AndAlso of formula * formula
    | OrElse of formula * formula
    | Imply of formula * formula
    | Equal of exp * exp
;;
let rec eval_exp : exp -> int = function
    | Num i -> i
    | Plus (e1, e2) -> eval_exp e1 + eval_exp e2
    | Minus (e1, e2) -> eval_exp e1 - eval_exp e2
;;
let rec eval : formula -> bool = function
    | True -> true
    | False -> false
    | Not f -> not (eval f)
    | AndAlso (f1, f2) -> eval f1 && eval f2
    | OrElse (f1, f2) -> eval f1 || eval f2
    | Imply (f1, f2) -> not (eval f1) || eval f2
    | Equal (e1, e2) -> eval_exp e1 = eval_exp e2
;;

eval (Equal (Num 1, Plus (Num 1, Num 2)))
