exception NotImplemented;;

let rec uniq = function
    | [] -> []
    | hd :: tl -> hd :: uniq (List.filter (fun x -> x <> hd) tl)
;;
uniq [5;6;5;4]