exception NotImplemented;;

let rec forall : ('a -> bool) -> 'a list -> bool = function
    | f -> (function
        | [] -> true
        | hd::tl -> (if f hd = true
            then forall f tl
            else false
        )
    )
;;

forall (fun x -> x > 5) [7;8;9]

