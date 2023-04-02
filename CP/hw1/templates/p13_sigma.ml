exception NotImplemented;;

let rec sigma : (int -> int) -> int -> int -> int = function
    | f -> (function
        | a -> (function
            | b -> (if a = b
                then f a
                else (f a) + (sigma f (a+1) b)
            )
        )
    )
;;
sigma (fun x -> x*x) 1 7;;