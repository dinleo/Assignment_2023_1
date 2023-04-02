exception NotImplemented;;
exception DivByZero;;

type exp =
  | X
  | INT of int
  | ADD of exp * exp
  | SUB of exp * exp
  | MUL of exp * exp
  | DIV of exp * exp
  | SIGMA of exp * exp * exp
;;

let rec subst v x exp =
  match exp with
  | X -> if v = X then x else exp
  | INT (_) -> exp
  | ADD (exp1, exp2) -> ADD (subst v x exp1, subst v x exp2)
  | SUB (exp1, exp2) -> SUB (subst v x exp1, subst v x exp2)
  | MUL (exp1, exp2) -> MUL (subst v x exp1, subst v x exp2)
  | DIV (exp1, exp2) -> DIV (subst v x exp1, subst v x exp2)
  | SIGMA (exp1, exp2, exp3) -> SIGMA (subst v x exp1, subst v x exp2, subst v x exp3)
;;


let rec calculator : exp -> int = function
    | X -> 0
    | ADD (e1, e2) -> (calculator e1) + (calculator e2)
    | SUB (e1, e2) -> (calculator e1) - (calculator e2)
    | MUL (e1, e2) -> (calculator e1) * (calculator e2)
    | DIV (e1, e2) -> (if (calculator e2) = 0
        then raise DivByZero
        else (calculator e1) / (calculator e2)
    )
    | INT (i) -> i
    | SIGMA (ea, eb, e) -> (
        let a = calculator ea in
        let b = calculator eb in
        let f = fun x -> calculator (subst X (INT x) e) in
        let rec sigma acc x = if b < x
            then acc
            else sigma (acc + (f x)) (x+1)
        in
        sigma 0 a
    )
;;

calculator (SIGMA(INT 1, INT 10, SUB(MUL(X, X), INT 1)))