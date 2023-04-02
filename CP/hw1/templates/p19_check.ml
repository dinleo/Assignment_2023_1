exception NotImplemented;;

type var = string;;
type exp =
  | V of var
  | P of var * exp
  | C of exp * exp
;;

let check : exp -> bool = function
    | ex -> (let rec stack_var stack e = match e with
        | V v -> List.mem v stack
        | P (v, e1) -> stack_var (v::stack) e1
        | C (e1, e2) -> (stack_var stack e1) && (stack_var stack e2)
        in
        stack_var [] ex
    )
;;
check (P ("a", V "a"));;
check (P ("a", P ("a", V "a")));;
check (P ("a", P ("b", C (V "a", V "b"))));;
check (P ("a", C (V "a", P ("b", V "a"))));;
check (P ("a", V "b"));;
check (P ("a", C (V "a", P ("b", V "c"))));;
check (P ("a", P ("b", C (V "a", V "c"))));;
