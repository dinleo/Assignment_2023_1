open Spvm
exception TypeError of string
exception Not_implemented of string
exception No_next_label of string
exception No_function of string
exception Arg_unmatched of string
exception No_list of string
exception Index_out_of_range of string

module Ptype = struct
type t =
    | PIntR of string
    | PStrR of string
    | PInt of int
    | PStr of string
    | PPtr of string
    | PList of string * (t list) (* original id assigned when generate from empty *)
    | PTuple of string * (t list)
    | PFunc of (id list) * program
    | PCond of (id * bop * id)
    | PNone
    | PMix
let join = fun a' b' -> begin match a', b' with
    | a, b when a=b -> a
    | PInt(a), PInt(b) when a!=b -> PIntR("")
    | PInt(_), PIntR(_) -> PIntR("")
    | PIntR(""), PInt(_) -> PIntR("")
    | PStr(a), PStr(b) when a!=b -> PStrR("")
    | PStr(_), PStrR(_) -> PStrR("")
    | PStrR(_), PStr(_) -> PStrR("")
    | _ -> PMix
    end
let rec to_string = function
    | PMix -> "PMix"
    | PIntR(s) -> "PInt Random from "^s
    | PStrR(s) -> "Pstr Random from "^s
    | PPtr(s) -> "PPtr("^s^")"
    | PInt(i) -> "PInt("^(string_of_int i)^")"
    | PStr(s) -> "PStr("^s^")"
    | PList(i, t1) -> "PList(<"^i^">"^(List.fold_left (fun acc x -> acc^", "^to_string x) "" t1)^")"
    | PTuple(i, t1) -> "PTuple(<"^i^">"^(List.fold_left (fun acc x -> acc^", "^to_string x) "" t1)^")"
    | PFunc(id_list, _) -> "PFunc("^(List.fold_left (fun acc x -> acc^", "^ x) "" id_list)^")"
    | PCond(i1, o, i2) -> "PCond("^i1^" "^(Spvm.string_of_bop o)^" "^i2^")"
    | PNone -> "PNone"
let eval_bop = fun t1 o t2 -> begin match t1, o, t2 with
    | PList(_, l1), ADD, PList(_, l2) -> PList("", l1@l2)
    | PTuple(_, l1), ADD, PTuple(_, l2) -> PTuple("", l1@l2)
    | PIntR(_), MUL, PInt 0 -> PInt (0)
    | PInt 0, MUL, PIntR(_) -> PInt (0)
    | PInt n1, AND, PIntR(_) when n1 = 0 -> PInt 0
    | PIntR(_), AND, PInt n1 when n1 = 0 -> PInt 0
    | PInt n1, OR, PIntR(_) when n1 != 0 -> PInt 1
    | PIntR(_), OR, PInt n1 when n1 != 0 -> PInt 1
    | PIntR(_), _, PInt _ -> PIntR("")
    | PInt _, _, PIntR(_) -> PIntR("")
    | PIntR(_), _, PIntR(_) -> PIntR("")
    | PStrR(_) , ADD, PStr _ -> PStrR("")
    | PStr _, ADD, PStrR(_) -> PStrR("")
    | PIntR(_) , MUL, PStr _ -> PStrR("")
    | PStr _, MUL, PIntR(_) -> PStrR("")
    | PInt _ , MUL, PStrR(_) -> PStrR("")
    | PStrR(_), MUL, PInt _ -> PStrR("")
    | PStrR(_), MUL, PIntR(_) -> PStrR("")
    | PIntR(_), MUL, PStrR(_) -> PStrR("")
    | PInt n1, ADD, PInt n2 -> PInt (n1+n2)
    | PInt n1, SUB, PInt n2 -> PInt (n1-n2)
    | PInt n1, MUL, PInt n2 -> PInt (n1*n2)
    | PInt n1, DIV, PInt n2 -> PInt (n1/n2)
    | PInt n1, MOD, PInt n2 -> PInt (let r = n1 mod n2 in if r < 0 then r + n2 else r)
    | PInt n1, POW, PInt n2 -> PInt (pow n1 n2)
    | PInt n1, LT, PInt n2 -> if n1 < n2 then PInt 1 else PInt 0
    | PInt n1, LE, PInt n2 -> if n1 <= n2 then PInt 1 else PInt 0
    | PInt n1, GT, PInt n2 -> if n1 > n2 then PInt 1 else PInt 0
    | PInt n1, GE, PInt n2 -> if n1 >= n2 then PInt 1 else PInt 0
    | PInt n1, EQ, PInt n2 -> if n1 = n2 then PInt 1 else PInt 0
    | PInt n1, NEQ, PInt n2 -> if n1 != n2 then PInt 1 else PInt 0
    | PInt n1, AND, PInt n2 -> if n1 != 0 && n2 != 0 then PInt 1 else PInt 0
    | PInt n1, OR, PInt n2 -> if n1 != 0 || n2 != 0 then PInt 1 else PInt 0
    | PInt _, EQ, PNone -> PInt 0
    | PNone, EQ, PInt _ -> PInt 0
    | PNone, EQ, PNone -> PInt 1
    | PStr s1, ADD, PStr s2 -> PStr (s1 ^ s2)
    | PInt n, MUL, PStr s
    | PStr s, MUL, PInt n ->
        let rec repeat s n =
        if n <= 0 then "" else s ^ repeat s (n-1) in
        PStr (repeat s n)
    | _ -> raise (TypeError ("b_operation type not matched: "^(to_string t1)^(Spvm.string_of_bop o)^(to_string t2)))
    end
let eval_uop = fun o v -> match o, v with
    | UPLUS, PInt n -> PInt (n)
    | UMINUS, PInt n -> PInt (-n)
    | NOT, PInt n -> if n = 0 then PInt 1 else PInt 0
    | _, PIntR(_) -> PIntR("")
    | _ -> raise (TypeError "u_operation type not matched")
let iter_store n v lst =
    List.mapi (fun i x -> if i = n then v else x) lst
let rec range a b =
    if a >= b then []
    else PInt(a) :: range (a + 1) b
end

module PMem = struct
module LocMap = Map.Make(String)
type t = Ptype.t LocMap.t
let empty = LocMap.empty
let add = LocMap.add
let rec find k m =
    let v = try LocMap.find k m with _ -> Ptype.PNone in
    match v with
    | Ptype.PPtr(s) -> (find s m)
    | _ -> v
let join m1 m2 =
    LocMap.fold (fun m1_k m1_v m2_acc -> add m1_k (Ptype.join m1_v (find m1_k m2_acc)) m2_acc) m1 m2
let print m =
    LocMap.iter (fun k v -> print_endline (k ^ " |-> " ^ Ptype.to_string v)) m
let rec deep_copy lst m =
    List.map (fun x ->
        let v = begin match x with
            | Ptype.PPtr(s) -> find s m
            | ty -> ty
        end in
        begin match v with
            | Ptype.PList(_, p_list) -> Ptype.PList("", deep_copy p_list m)
            | Ptype.PTuple(_, p_list) -> Ptype.PTuple("", deep_copy p_list m)
            | ty -> ty
        end) lst
let eval_cond id1 op id2 m =
    let t_id1 = find id1 m in
    let t_id2 = find id2 m in
    begin match (t_id1, t_id2) with
        | (Ptype.PInt(i), Ptype.PIntR(_)) ->
        begin match op with
            | LT -> (add id2 (Ptype.PInt(i+1)) m)
            | LE -> (add id2 (Ptype.PInt(i)) m)
            | GT -> (add id2 (Ptype.PInt(i-1)) m)
            | GE -> (add id2 (Ptype.PInt(i)) m)
            | EQ -> (add id2 (Ptype.PInt(i)) m)
            | NEQ when i!=0 -> (add id2 (Ptype.PInt(0)) m)
            | _ -> m
        end
        | (Ptype.PIntR(_), Ptype.PInt(i)) ->
        begin match op with
            | LT -> (add id1 (Ptype.PInt(i-1)) m)
            | LE -> (add id1 (Ptype.PInt(i)) m)
            | GT -> (add id1 (Ptype.PInt(i+1)) m)
            | GE -> (add id1 (Ptype.PInt(i)) m)
            | EQ -> (add id1 (Ptype.PInt(i)) m)
            | NEQ when i!=0 -> (add id1 (Ptype.PInt(0)) m)
            | _ -> m
        end
        | _ -> m
    end
let eval_un_cond id1 op id2 m =
    let t_id1 = find id1 m in
    let t_id2 = find id2 m in
    begin match (t_id1, t_id2) with
        | (Ptype.PInt(i), Ptype.PIntR(_)) ->
        begin match op with
            | LT -> (add id2 (Ptype.PInt(i)) m)
            | LE -> (add id2 (Ptype.PInt(i-1)) m)
            | GT -> (add id2 (Ptype.PInt(i)) m)
            | GE -> (add id2 (Ptype.PInt(i+1)) m)
            | EQ when i!=0 -> (add id2 (Ptype.PInt(0)) m)
            | NEQ when i!=0 -> (add id2 (Ptype.PInt(i)) m)
            | _ -> m
        end
        | (Ptype.PIntR(_), Ptype.PInt(i)) ->
        begin match op with
            | LT -> (add id2 (Ptype.PInt(i)) m)
            | LE -> (add id2 (Ptype.PInt(i+1)) m)
            | GT -> (add id2 (Ptype.PInt(i)) m)
            | GE -> (add id2 (Ptype.PInt(i-1)) m)
            | EQ when i!=0 -> (add id2 (Ptype.PInt(0)) m)
            | NEQ when i!=0 -> (add id2 (Ptype.PInt(i)) m)
            | _ -> m
        end
        | _ -> m
    end
end

let rec try_mem
= fun _ -> true

and find_next_label lb lst =
match lst with
    | [] -> raise (No_next_label (string_of_int lb))
    | (k, _) :: (k', _) :: _ when k = lb -> k'
    | _ :: tail -> find_next_label lb tail

and find
= fun k m -> PMem.find k m

and execute_prog : program -> PMem.t -> PMem.t
=fun prog init_m ->
    let (init_lb, _) = List.hd prog in
    let rec execute_block = fun c_lb e_lb m ->
    (* curr_label, end_label, next_label, jump_label *)
    if c_lb = e_lb then m
    else begin match (List.assoc c_lb prog) with
        | HALT -> m
        | inst' -> begin let n_lb = find_next_label c_lb prog in
        match inst' with
        | SKIP -> execute_block n_lb e_lb m
        | FUNC_DEF(f, id_list, body) -> execute_block (n_lb) (e_lb) (PMem.add f (Ptype.PFunc(id_list, body)) m)
        | RETURN(x) -> (PMem.add "@" (find x m) m)
        | CALL(x, f, arg_list) -> begin match (find f m) with
            | Ptype.PFunc(id_list, body) ->
                let rec id_arg_match =
                fun i_l a_l m -> begin match (i_l, a_l) with
                    | ([], []) -> m
                    | (i_hd::i_tl, a_hd::a_tl) -> id_arg_match (i_tl) (a_tl) (PMem.add i_hd (find (a_hd) m) m)
                    | _ -> raise (Arg_unmatched f)
                    end
                in
                let temp_mem1 = id_arg_match id_list arg_list m in
                let temp_mem2 = execute_prog body temp_mem1 in
                let ret_val = find "@" (temp_mem2) in
                let ret_val2 = begin match ret_val with
                    | Ptype.PList(_, p_list) -> Ptype.PList(x, PMem.deep_copy p_list temp_mem2)
                    | Ptype.PTuple(_, p_list) -> Ptype.PTuple(x, PMem.deep_copy p_list temp_mem2)
                    | _ -> ret_val
                end in
                let temp_mem3 = (PMem.add x ret_val2 m) in
                execute_block (n_lb) (e_lb) temp_mem3
            | _ -> raise (No_function f)
        end
        | UJUMP(j_lb) -> execute_block (j_lb) (e_lb) m
        | CJUMP(x, j_lb) ->
            let t_x = (find x m) in
            begin match t_x with
            | Ptype.PInt(0) -> (execute_block n_lb e_lb m)
            | Ptype.PInt(_) -> (execute_block j_lb e_lb m)
            | Ptype.PIntR(_) ->
                let c_m, u_m = begin match (PMem.find ("$"^x) m) with
                    | Ptype.PCond(id1, op, id2) -> (PMem.eval_cond id1 op id2 m), (PMem.eval_un_cond id1 op id2 m)
                    | _ -> m, m
                end in
                let m_jump = (execute_block j_lb e_lb c_m) in
                let m_u_jump = (execute_block n_lb e_lb u_m) in
                PMem.join m_jump m_u_jump
            | _ -> raise (TypeError "CJUMP not int typer")
            end
        | CJUMPF(x, j_lb) ->
            let t_x = (find x m) in
            begin match t_x with
            | Ptype.PInt(0) -> (execute_block j_lb e_lb m)
            | Ptype.PInt(_) -> (execute_block n_lb e_lb m)
            | Ptype.PIntR(_) ->
                let u_m, c_m = begin match (PMem.find ("$"^x) m) with
                    | Ptype.PCond(id1, op, id2) ->  (PMem.eval_un_cond id1 op id2 m), (PMem.eval_cond id1 op id2 m)
                    | _ -> m, m
                end in
                let m_jump = (execute_block j_lb e_lb u_m) in
                let m_u_jump = (execute_block n_lb e_lb c_m) in
                PMem.join m_jump m_u_jump
            | _ -> raise (TypeError "CJUMPF not int type")
            end
        | ASSERT(_) -> m
        | inst -> execute_block n_lb e_lb (eval_instr inst m)
        end
    end in
    execute_block (init_lb) (-1) (init_m)
and eval_instr : instr -> PMem.t -> PMem.t
=fun inst m -> match inst with
| RANGE(x, l, h) ->
    let t_l = (find l m) in
    let t_h = (find h m) in
    begin match (t_l, t_h) with
    | (Ptype.PInt(n_l), Ptype.PInt(n_h)) -> PMem.add x (Ptype.PList(x, Ptype.range n_l n_h)) m
    | _ -> raise (TypeError "RANGE not int type")
    end
| LIST_EMPTY(x) -> PMem.add x (Ptype.PList(x, [])) m
| LIST_APPEND(x, y) ->
    let t_x = (find x m) in
    let t_y = (find y m) in
    begin match t_x with
        | Ptype.PList(arr_x, p_list) ->
            let new_list = begin match t_y with
                | Ptype.PList(arr_y, _)
                | Ptype.PTuple(arr_y, _) -> Ptype.PList(arr_x, p_list@[Ptype.PPtr(arr_y)])
                | _ -> Ptype.PList(arr_x, p_list@[t_y])
            end in
            (PMem.add arr_x new_list m)
        | _ -> raise (No_list x)
    end
| LIST_INSERT(x, y) ->
    let t_x = (find x m) in
    let t_y = (find y m) in
    begin match t_x with
        | Ptype.PList(arr_x, p_list) ->
            let new_list = begin match t_y with
                | Ptype.PList(arr_y, _)
                | Ptype.PTuple(arr_y, _) -> Ptype.PList(arr_x, [Ptype.PPtr(arr_y)]@p_list)
                | _ -> Ptype.PList(arr_x, [t_y]@p_list)
            end in
            (PMem.add arr_x new_list m)
        | _ -> raise (No_list x)
    end
| LIST_REV(x) ->
    let t_x = (find x m) in
    begin match t_x with
        | Ptype.PList(_, p_list) -> PMem.add x (Ptype.PList(x, (List.rev p_list))) m
        | _ -> raise (No_list x)
    end
| TUPLE_EMPTY(x) -> PMem.add x (Ptype.PTuple(x, [])) m
| TUPLE_INSERT(x, y) ->
    let t_x = (find x m) in
    let t_y = (find y m) in
    begin match t_x with
        | Ptype.PTuple(arr_x, p_list) ->
            let new_tuple = begin match t_y with
                | Ptype.PList(arr_y, _)
                | Ptype.PTuple(arr_y, _) -> Ptype.PTuple(arr_x, [Ptype.PPtr(arr_y)]@p_list)
                | _ -> Ptype.PTuple(arr_x, [t_y]@p_list)
            end in
            (PMem.add arr_x new_tuple m)
        | _ -> raise (No_list x)
    end
| ITER_LOAD(x, a ,i) ->
    let t_a = (find a m) in
    let t_i = (find i m) in
    let nth, n, a_k, a_list = begin match (t_a, t_i) with
        | (Ptype.PList(a_key, p_list), Ptype.PInt(n_i))
        | (Ptype.PTuple(a_key, p_list), Ptype.PInt(n_i)) ->
            let len_list = (List.length p_list) in
            if n_i < len_list
            then (List.nth p_list n_i), n_i, a_key, p_list
            else raise (Index_out_of_range a)
        | _ -> raise (No_list a)
    end in
    begin match nth with (* if nth is raw List or tuple, replace it to pointer *)
        | Ptype.PList(k, n_list)
        | Ptype.PTuple(k, n_list) ->
            let new_k = begin match k with
                | "" -> (a_k)^"@"^(string_of_int n)
                | _ -> k
            end in
            let m2 = begin match nth with
                | Ptype.PList(_) -> PMem.add new_k (Ptype.PList(new_k, n_list)) m
                | Ptype.PTuple(_) -> PMem.add new_k (Ptype.PTuple(new_k, n_list)) m
                | _ -> m
            end in
            let a_list2 = (Ptype.iter_store n (Ptype.PPtr(new_k)) a_list) in
            let m3 = begin match t_a with
                | Ptype.PList(_) -> PMem.add a_k (Ptype.PList(a_k, a_list2)) m2
                | Ptype.PTuple(_) -> PMem.add a_k (Ptype.PTuple(a_k, a_list2)) m2
                | _ -> m2
            end in
            (PMem.add x (Ptype.PPtr(new_k)) m3)
        | _ -> PMem.add x nth m
    end
| ITER_STORE(a, i, y) ->
    let t_a = (find a m) in
    let t_i = (find i m) in
    let t_y = (find y m) in
    let new_list, new_m = begin match (t_a, t_i) with
        | (Ptype.PList(a_key, p_list), Ptype.PInt(n))
        | (Ptype.PTuple(a_key, p_list), Ptype.PInt(n)) ->
            let len_list = (List.length p_list) in
            if n < len_list
            then
                let new_k = (a_key)^"@"^(string_of_int n) in
                let p_list2 = begin match t_y with
                    | Ptype.PList(_)
                    | Ptype.PTuple(_) -> (Ptype.iter_store n (Ptype.PPtr(new_k)) p_list)
                    | _ -> (Ptype.iter_store n t_y p_list)
                end in
                let m2 = begin match t_y with
                    | Ptype.PList("", y_list) -> PMem.add new_k (Ptype.PList(new_k, y_list)) m
                    | Ptype.PTuple("", y_list) -> PMem.add new_k (Ptype.PTuple(new_k, y_list)) m
                    | _ -> m
                end in
                (p_list2 , m2)
            else raise (Index_out_of_range a)
        | _ -> raise (No_list a)
    end in
    begin match t_a with
        | Ptype.PList(arr_a, _) -> PMem.add (arr_a) (Ptype.PList(arr_a, new_list)) new_m
        | Ptype.PTuple(arr_a, _)-> PMem.add (arr_a) (Ptype.PTuple(arr_a, new_list)) new_m
        | _ -> raise (No_list a)
    end
| ITER_LENGTH(x, y) ->
    let t_y = (find y m) in
    begin match t_y with
        | Ptype.PTuple(_, p_list)
        | Ptype.PList(_, p_list) -> PMem.add x (Ptype.PInt(List.length p_list)) m
        | _ -> raise (No_list x)
    end
| ASSIGNV(x, o, y, z) ->
    let t_y = (find y m) in
    let t_z = (find z m) in
    let v = (Ptype.eval_bop (t_y) o (t_z)) in
    let c_m = begin match o with
        | EQ | LT | LE | GT | GE | NEQ ->
            let id_y, id_z = begin match (t_y, t_z) with
            | (Ptype.PIntR(o_y), Ptype.PIntR(o_z)) -> o_y, o_z
            | (Ptype.PIntR(o_y), _) -> o_y, z
            | (_, Ptype.PIntR(o_z)) -> y, o_z
            | _ -> y, z
            end in
            (PMem.add ("$"^x) (Ptype.PCond(id_y, o, id_z)) m)
        | _ -> m
    end in
    begin match v with
        | Ptype.PList(_, p_list) -> (PMem.add x (Ptype.PList(x, p_list)) c_m)
        | Ptype.PTuple(_, p_list) -> (PMem.add x (Ptype.PTuple(x, p_list)) c_m)
        | _ -> (PMem.add x v c_m)
    end
| ASSIGNC(x, o, y, n) ->
    let t_y = (find y m) in
    (PMem.add x (Ptype.eval_bop (t_y) (o) (Ptype.PInt(n))) m)
| ASSIGNU(x, o, y) ->
    let t_y = (find y m) in
    (PMem.add x (Ptype.eval_uop (o) (t_y)) m)
| COPY(x, y) ->
    let t_y = (find y m) in
    begin match t_y with
        | Ptype.PList(arr_a, _)
        | Ptype.PTuple(arr_a, _) -> PMem.add x (Ptype.PPtr(arr_a)) m
        | Ptype.PIntR(_) -> PMem.add x (Ptype.PIntR(y)) m
        | Ptype.PStrR(_) -> PMem.add x (Ptype.PStrR(y)) m
        | _ -> PMem.add x t_y m
    end
| COPYC(x, n) -> PMem.add x (Ptype.PInt(n)) m
| COPYS(x, s) -> PMem.add x (Ptype.PStr(s)) m
| COPYN(x) -> PMem.add x (Ptype.PNone) m
| READ(x) -> PMem.add x (Ptype.PStrR("")) m
| WRITE(_) -> m
| INT_OF_STR(x, y) ->
    let t_y = (find y m) in
    begin match t_y with
        | Ptype.PStr(s) -> PMem.add x (Ptype.PInt(int_of_string s)) m
        | Ptype.PStrR(_) -> PMem.add x (Ptype.PIntR("")) m
        | _ -> raise (TypeError "int() Operation not str type")
    end
| IS_INSTANCE(x, y, typ) ->
    let t_y = (find y m) in
    begin match (t_y, typ) with
        | (Ptype.PInt(_), "int")
        | (Ptype.PIntR(_), "int")
        | (Ptype.PStr(_), "str")
        | (Ptype.PStrR(_), "str")
        | (Ptype.PList(_, _), "list")
        | (Ptype.PTuple(_, _), "tuple") -> PMem.add x (Ptype.PInt(1)) m
        | _ -> PMem.add x (Ptype.PInt(0)) m
    end
| _ -> raise (Not_implemented "Not implemented instruction")

let analyze : Spy.program -> Spvm.program -> bool
=fun _ s_prog ->
(*let exe_m = (execute_prog s_prog PMem.empty) in*)
(*let _ = PMem.print exe_m in*)
try try_mem (execute_prog s_prog PMem.empty) with _ -> false