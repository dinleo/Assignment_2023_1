exception NotImplemented;;

type aexp =
    | Const of int
    | Var of string
    | Power of string * int
    | Times of aexp list
    | Sum of aexp list
;;

let rec is_variable_for = function
    | v -> (function
        | Const (_) -> false
        | Var (s) -> (if s = v
            then true
            else false
        )
        | Power (s, n) -> (if (s = v) && (n <> 0)
            then true
            else false
        )
        | Times ([]) -> false
        | Times (hd::tl) -> (is_variable_for v hd) || (is_variable_for v (Times(tl)))
        | Sum ([]) -> false
        | Sum (hd::tl) -> (is_variable_for v hd) || (is_variable_for v (Sum(tl)))
    )
;;

let rec diff : aexp * string -> aexp = function
    | (Sum(lst), r) -> Sum(List.map (fun att -> diff (att, r)) (List.filter (fun att -> is_variable_for r att) lst))
    | (Times(lst), r) -> Times(List.map (fun att -> diff (att, r)) lst)
    | (Power (x, n), r) -> (if x = r
        then (match n with
            | 0 -> Const (0)
            | 1 -> Var (x)
            | _ -> Times([Const (n);Power (x, n-1)])
        )
        else Power (x, n)
        )
    | (Const (i), _) -> Const(i)
    | (Var (x), r) -> (if x = r
        then Const(1)
        else Var(x)
    )
;;
diff (Sum [Times [Const 3; Power ("x", 2)]; Times [Const 2; Const 1]; Times [Var "y"; Times [Const 3; Power ("x", 2)]; Const 4]], "x");;
diff (Sum [Power ("x", 3); Times [Const 2; Var "x"]; Times [Var "y"; Power("x",3); Const 4]], "x")