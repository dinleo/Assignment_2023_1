exception NotImplemented;;

let fastrev : 'a list -> 'a list = function
    | lst -> (
        let rec f = function
            | ([], acc) -> acc
            | (hd::tl, acc) -> f (tl, hd::acc)
        in
        f (lst, [])
    )
;;

fastrev [1;2;3;4;5;6]