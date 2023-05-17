open Spvm

let optimize : Spvm.program -> Spvm.program
= fun target ->
let rec optimize_pgm pgm =
match pgm with
| [] -> []
| inst :: _pgm -> begin
    match inst with
    | (l_o, FUNC_DEF(f,a_l,body)) -> (l_o, FUNC_DEF(f,a_l,(optimize_pgm body)))::(optimize_pgm _pgm)
    | (l_o, COPY(id, id_o)) -> begin
        let rec id2id_o t_pgm = begin
        	match t_pgm with
            | [] -> []
            | inst_::_t_pgm -> begin
                match inst_ with
                | (l, RETURN(y)) when y=id -> (l, RETURN(id_o))::(id2id_o _t_pgm)
                | (l, RANGE(x, y, z)) when y=id -> (l, RANGE(x, id_o, z))::(id2id_o _t_pgm)
                | (l, RANGE(x, y, z)) when z=id -> (l, RANGE(x, y, id_o))::(id2id_o _t_pgm)
                | (l, LIST_APPEND(a, y)) when y=id -> (l, LIST_APPEND(a, id_o))::(id2id_o _t_pgm)
                | (l, LIST_INSERT(a, y)) when y=id -> (l, LIST_INSERT(a, id_o))::(id2id_o _t_pgm)
                | (l, TUPLE_INSERT(a, y)) when y=id -> (l, TUPLE_INSERT(a, id_o))::(id2id_o _t_pgm)
                | (l, ITER_LOAD(x, a, y)) when y=id -> (l, ITER_LOAD(x, a, id_o))::(id2id_o _t_pgm)
                | (l, ITER_STORE(a, x, y)) when y=id -> (l, ITER_STORE(a, x, id_o))::(id2id_o _t_pgm)
                | (l, ASSIGNV(x, bop, y, z)) when y=id -> (l, ASSIGNV(x, bop, id_o, z))::(id2id_o _t_pgm)
                | (l, ASSIGNV(x, bop, y, z)) when z=id -> (l, ASSIGNV(x, bop, y, id_o))::(id2id_o _t_pgm)
                | (l, ASSIGNC(x, bop, y, n)) when y=id -> (l, ASSIGNC(x, bop, id_o, n))::(id2id_o _t_pgm)
                | (l, WRITE(y)) when y=id -> (l, WRITE(id_o))::(id2id_o _t_pgm)
                | (l, READ(y)) when y=id -> (l, WRITE(id_o))::(id2id_o _t_pgm)
                | _ -> inst_::(id2id_o _t_pgm)
            end
        end in
        let new_pgm = (id2id_o _pgm) in
        let check_pgm = (get_pgm_until_l target l_o)@new_pgm in
        let usage = (find_id_usage check_pgm id) in
        begin
            match usage with
            | [one_ins] when one_ins=inst -> optimize_pgm new_pgm      (*no usage for new_pgm -> can remove*)
            | _ -> inst::(optimize_pgm _pgm)    (*have usage -> can't remove*)
        end
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
            | [] -> optimize_pgm new_pgm
            | _ -> inst::(optimize_pgm _pgm)
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
        | (_, FUNC_DEF(f, id_list, _)) when ((List.mem id id_list)||(f=id)) -> inst_::(find_id_usage _t_pgm id)
        | (_, CALL(x, f, id_list)) when ((List.mem id id_list)||(f=id)||(x=id)) -> inst_::(find_id_usage _t_pgm id)
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
and get_pgm_until_l t_pgm u_l = begin
	let rec find_b_pgm w_pgm = begin
		match w_pgm with
		| [] -> []
		| [(l, ins)] when l=u_l -> [(l, ins)]
		| (l, ins)::_ when l=u_l -> [(l, ins)]
		| t_inst::_w_pgm -> t_inst::(find_b_pgm _w_pgm)
	end in
    (find_b_pgm t_pgm)
end
in
optimize_pgm target
