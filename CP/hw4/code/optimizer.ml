open Spvm

let optimize : Spvm.program -> Spvm.program
= fun target ->
let rec optimize_pgm pgm =
match pgm with
| [] -> []
| inst :: _pgm -> begin
    match inst with
    | (_, COPY(id, id2)) -> begin

    end
    | (_, COPYC(id, i)) -> begin
        let rec id2int t_pgm = begin
            match t_pgm with
            | [] -> []
            | inst_::_t_pgm -> begin
                match inst_ with
                | (l, COPY(x, y)) when y=id -> (l, COPYC(x, i))::(id2int _t_pgm)
                | (l, ASSIGNV(x, bop, y, z)) when z=id -> (l, ASSIGNC(x, bop, y, i))::(id2int _t_pgm)
                | _ -> inst_::(id2int _t_pgm)
            end
        end in
        let new_pgm = (id2int _pgm) in
        let usage = (find_id_usage new_pgm id) in
        begin
            match usage with
            | [] -> optimize_pgm new_pgm       (*no usage for new_pgm -> can remove*)
            | _ -> inst::(optimize_pgm _pgm)   (*have usage -> can't remove*)
        end
    end
    | (_, COPYS(id, s)) -> begin
        let rec replace_same_str t_pgm same_id = begin
        	match t_pgm with
            | [] -> []
            | inst_::_t_pgm -> begin
                match inst_ with
                | (_, COPYS(id2, s2)) when s2=s -> begin (*add id(which have same string with s) that only used for input, print*)
                    match (find_id_usage _t_pgm id2) with
                    | [(_, WRITE(_))] -> inst_::(replace_same_str _t_pgm (same_id@[id2]))
                    | [(_, READ(_))] -> inst_::(replace_same_str _t_pgm (same_id@[id2]))
                    | _ -> inst_::(replace_same_str _t_pgm same_id)
                    end
                | (l, WRITE(id2)) when (List.mem id2 same_id) -> (l, WRITE(id))::(replace_same_str _t_pgm same_id)
                | (l, READ(id2)) when (List.mem id2 same_id) -> (l, READ(id))::(replace_same_str _t_pgm same_id)
                | _ -> inst_::(replace_same_str _t_pgm same_id)
            end
        end in
    	let rec id2str t_pgm = begin
    		match t_pgm with
            | [] -> []
            | inst_::_t_pgm -> begin
                match inst_ with
                | (l, COPY(x, y)) when y=id -> (l, COPYS(x, s))::(id2str _t_pgm)
                | (l, INT_OF_STR(x, y)) when y=id -> (l, COPYC(x, (int_of_string s)))::(id2str _t_pgm)
                | _ -> inst_::(id2str _t_pgm)
            end
    	end in
    	let new_pgm = (replace_same_str _pgm []) in (*only replace write/read*)
    	let new_new_pgm = (id2str new_pgm) in
        let usage = (find_id_usage new_new_pgm id) in
        begin
            match usage with
            | [] -> optimize_pgm new_new_pgm
            | _ -> inst::(optimize_pgm new_pgm) (*reflect only replace_same_str*)
        end
    end
    | (_, COPYN(id)) -> begin
    	let usage = (find_id_usage _pgm id) in
    	begin
            match usage with
            | [] -> optimize_pgm _pgm
            | _ -> inst::(optimize_pgm _pgm)
        end
    end
    | _ -> inst :: (optimize_pgm _pgm)
end
and find_id_usage t_pgm id = begin
	match t_pgm with
	| [] -> []
	| inst_ :: _t_pgm -> begin
        match inst_ with
        | (_, FUNC_DEF(_, id_list, _)) when (List.mem id id_list) -> inst_::(find_id_usage _t_pgm id)
        | (_, CALL(x, _, id_list)) when ((List.mem id id_list)||(x=id)) -> inst_::(find_id_usage _t_pgm id)
        | (_, RETURN(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, RANGE(x, lo, hi)) when (x=id || lo=id || hi=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, LIST_EMPTY(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, LIST_APPEND(x, y)) when (x=id || y=id) ->inst_::(find_id_usage _t_pgm id)
        | (_, LIST_INSERT(x, y)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, LIST_REV(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, TUPLE_EMPTY(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, TUPLE_INSERT(x, y)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ITER_LOAD(x, a, y)) when (x=id || a=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ITER_STORE(a, x, y)) when (a=id || x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ITER_LENGTH(x, y)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ASSIGNV(x, _, y, z)) when (x=id || y=id || z=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ASSIGNC(x, _, y, _)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ASSIGNU(x, _, y)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, COPY(x, y)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, COPYC(x, _)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, COPYS(x, _)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, COPYN(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, CJUMP(x, _)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, CJUMPF(x, _)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, READ(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, WRITE(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | (_, INT_OF_STR(x, y)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, IS_INSTANCE(x, y, _)) when (x=id || y=id) -> inst_::(find_id_usage _t_pgm id)
        | (_, ASSERT(x)) when x=id -> inst_::(find_id_usage _t_pgm id)
        | _ -> (find_id_usage _t_pgm id)
    end
end
in
optimize_pgm target
