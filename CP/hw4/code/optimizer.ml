open Spvm

let optimize : Spvm.program -> Spvm.program
= fun target ->
let rec optimize_pgm pgm =
match pgm with
| [] -> []
| inst :: _pgm -> begin match inst with
    | (_, COPYC(x, c)) -> (id2val inst _pgm x c)
    | _ -> inst :: (optimize_pgm _pgm)
end
and id2val o_inst t_pgm id v =
    let replace_inst t_inst = begin match o_inst with
        | (_, COPYC(_, i)) -> begin match t_inst with
            | (l, COPY(x, y)) -> if y=id
                then (l, COPYC(x, i))
                else t_inst
            | (l, ASSIGNV(x, bop, y, z)) -> if y=id
                then (l, ASSIGNC(x, bop, z, i))
                else begin if z=id
                    then (l, ASSIGNC(x, bop, y, i))
                    else (l, ASSIGNV(x, bop, y, z))
                end
            | _ -> t_inst
        end
        | (_, COPYS(_, _)) -> t_inst
        | _ -> t_inst
    end
    in begin match t_pgm with
        | [] -> []
        | inst_ :: _t_pgm -> (replace_inst inst_)::(id2val o_inst _t_pgm id v)
    end
in
optimize_pgm target
