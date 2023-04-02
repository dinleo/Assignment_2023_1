exception NotImplemented;;

let rec max : int list -> int = function
    | [] -> failwith "Empty"
    | [x] -> x
    | hd::tl -> (
        let m = max tl in
        if m < hd
            then hd
            else m
    )
;;


let rec min : int list -> int = function
    | [] -> failwith "Empty"
    | [x] -> x
    | hd::tl -> (
        let m = min tl in
        if hd < m
            then hd
            else m
    )
;;

max [3; 5; 1; 2; 4];;
min [3; 5; 1; 2; 4];;