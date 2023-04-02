exception NotImplemented;;

type nat = ZERO | SUCC of nat;;

let rec natadd : nat -> nat -> nat = function
    | ZERO -> (fun y -> y)
    | SUCC(x) -> (function
        | ZERO -> SUCC(x)
        | y ->  natadd x (SUCC (y))
    )
;;

let rec natmul : nat -> nat -> nat = function
    | ZERO -> (fun _ -> ZERO)
    | (SUCC ZERO) -> (fun y -> y)
    | SUCC (x) -> (function
        | ZERO -> ZERO
        | y -> natmul x (natadd y y)
    )
;;

let two = SUCC (SUCC ZERO);;
let three = SUCC (SUCC (SUCC ZERO));;

let six = natmul two three;;
natmul two six
