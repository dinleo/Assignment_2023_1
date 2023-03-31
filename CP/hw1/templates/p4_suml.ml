exception NotImplemented;;

let rec suml: int list list -> int = function
| [] -> 0
| hdl::tll ->
    let rec sum = function
        | [] -> 0
        | hd::tl -> hd + sum tl in
    sum hdl + suml tll;;

suml [[1;2;3]; []; [-1; 5; 2]; [7]]