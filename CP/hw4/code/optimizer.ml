open Spvm

let optimize : Spvm.program -> Spvm.program
= fun target ->
let rec optimize_pgm pgm = match pgm with
| [] -> []
| inst :: _pgm ->
begin
    match inst with
    | (_, COPYC(x, c)) -> (replace_id _pgm x c)
    | _ -> inst :: (optimize_pgm _pgm)
end
and replace_id t_pgm id v = match t_pgm with
| [] -> []
| inst :: _t_pgm ->
begin
    match inst with
    | (l, COPY(x, y)) -> if y=id
    then
    begin
    	match v with
    	| i -> (l, COPYC(x, i))::(replace_id _t_pgm id v)
(*    	| String(s) -> (l, COPYS(x, s))::(replace_id _t_pgm id v)*)
(*    	| None -> (l, COPYN(x))::(replace_id _t_pgm id v)*)
    end
    else (l, COPY(x, y))::(replace_id _t_pgm id v)
    | (l, ASSIGNV(x, bop, y, z)) -> if y=id
    then (l, ASSIGNC(x, bop, z, v))::(replace_id _t_pgm id v)
    else
    begin
    	if z=id
        then (l, ASSIGNC(x, bop, y, v))::(replace_id _t_pgm id v)
        else (l, ASSIGNV(x, bop, y, z))::(replace_id _t_pgm id v)
    end
    | _ -> inst::(replace_id _t_pgm id v)
end
in
optimize_pgm target
