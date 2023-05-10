(*
open Spy
open Lib.Util
open Spvm
*)

let temp_var_index = ref 0
let label_index = ref 1
let new_temp_var() = temp_var_index := !temp_var_index + 1; ".t" ^ (string_of_int !temp_var_index)
let new_label() = label_index := !label_index + 1; !label_index

exception Not_Implemented of string 
exception Error of string (* raise when syntax is beyond Spy *)

let translate : Spy.program -> Spvm.program = fun p ->
let rec translate_expr expr =
    let _ = print_endline("expr: " ^ Spy.print_expr expr) in
    ( match expr with
    | Spy.BoolOp(op, exprs) ->
        let spvm_op = (match op with
            | Spy.And -> Spvm.AND
            | Spy.Or -> Spvm.OR
        ) in
        let spvm_exprs = List.map translate_expr exprs in
        (match spvm_exprs with
            | [] -> raise (Error "translate_expr: empty exprs")
            | hd::tl -> (
                let tmp1 = new_temp_var() in
                let head_cmds, head_id = hd in
                let cmds = (List.fold_left (fun acc elem ->
                    let elem_cmds, elem_id = elem in
                    acc @ elem_cmds @ [(new_label(), Spvm.ASSIGNV(tmp1, spvm_op, tmp1, elem_id))]
                ) (head_cmds@[(new_label(), Spvm.COPY(tmp1, head_id))]) tl
                ) in
                (cmds, tmp1)
            )
        )
    | Spy.BinOp(e1, op, e2) ->
        let spvm_op = (match op with
            | Spy.Add -> Spvm.ADD
            | Spy.Sub -> Spvm.SUB
            | Spy.Mult -> Spvm.MUL
            | Spy.Div -> Spvm.DIV
            | Spy.Mod -> Spvm.MOD
            | Spy.Pow -> Spvm.POW
        ) in
        let tmp1 = new_temp_var() in
        let cmds1, id1 = (translate_expr e1) in
        let cmds2, id2 = (translate_expr e2) in
        let cmds = cmds1 @ cmds2 @ [(new_label(), Spvm.ASSIGNV(tmp1, spvm_op, id1, id2))] in
        (cmds, tmp1)
    | Spy.UnaryOp(op, e) ->
        let spvm_op = (match op with
            | Spy.Not -> Spvm.NOT
            | Spy.UAdd -> Spvm.UPLUS
            | Spy.USub -> Spvm.UMINUS
        ) in
        let cmds1, id1 = (translate_expr e) in
        let tmp1 = new_temp_var() in
        let cmds = cmds1 @ [(new_label(), Spvm.ASSIGNU(tmp1, spvm_op, id1))] in
        (cmds, tmp1)
    | Spy.IfExp(e1, e2, e3) ->
        let cmds1, id1 = translate_expr e1 in
        let _, id2 = translate_expr e2 in
        let cmds3, id3 = translate_expr e3 in
        let tmp1 = new_temp_var() in
        let lb1 = new_label() in
        let lb2 = new_label() in
        let cmds = cmds1 @ [
            (lb1, Spvm.CJUMP(id1, lb2));
            (lb2, Spvm.COPY(tmp1, id2));
        ] @ cmds3 @ [(new_label(), Spvm.COPY(tmp1, id3))] in
        (cmds, tmp1)
(*    | Spy.ListComp(e1, cl)*)
    | Spy.Compare(e1, cp, e2) ->
        let spvm_op = (match cp with
            | Spy.Eq -> Spvm.EQ
            | Spy.NotEq -> Spvm.NEQ
            | Spy.Lt -> Spvm.LT
            | Spy.LtE -> Spvm.LE
            | Spy.Gt -> Spvm.GT
            | Spy.GtE -> Spvm.GE
        ) in
        let tmp1 = new_temp_var() in
        let cmds1, id1 = (translate_expr e1) in
        let cmds2, id2 = (translate_expr e2) in
        let cmds = cmds1 @ cmds2 @ [(new_label(), Spvm.ASSIGNV(tmp1, spvm_op, id1, id2))] in
        (cmds, tmp1)
    | Spy.Call(e1, exprs) ->
        let arg_cmds, arg_ids =
            List.fold_left (fun (acc_cmds, acc_ids) arg_expr ->
            let arg_cmd, arg_id = translate_expr arg_expr in
            acc_cmds @ arg_cmd, acc_ids @ [arg_id]
            ) ([], []) exprs in
        ( match e1 with
            | Spy.Name("print") -> (
                let tmp_blk = new_temp_var() in
                let blank_cmds = [(new_label(), Spvm.COPYS(tmp_blk, " "))] in
                let print_cmds =
                    List.fold_left (fun acc_cmds arg_id ->
                    acc_cmds @ [(new_label(),Spvm.WRITE(arg_id));(new_label(),Spvm.WRITE(tmp_blk))]) blank_cmds arg_ids
                in
                let tmp_enter = new_temp_var() in
                let tmp_none = new_temp_var() in
                let cmds = arg_cmds @ print_cmds @ [(new_label(), Spvm.COPYS(tmp_enter, "\n"));(new_label(), Spvm.WRITE(tmp_enter));(new_label(), Spvm.COPYN(tmp_none))] in
                (cmds, tmp_none)
            )
            | _ -> (
                let tmp1 = new_temp_var() in
                let lb1 = new_label() in
                let func_cmds, func_id = translate_expr e1 in
                let cmds = func_cmds @ arg_cmds @ [(lb1, Spvm.CALL(tmp1, func_id, arg_ids))] in
                (cmds, tmp1)
            )
        )
    | Spy.Constant(c) ->
        let tmp1 = new_temp_var() in
        let lb1 = new_label() in
        let const_spvm = (match c with
            | Spy.CInt(i) -> Spvm.COPYC(tmp1, i)
            | Spy.CString(s) -> Spvm.COPYS(tmp1, s)
            | Spy.CBool(true) -> Spvm.COPYC(tmp1, 1)
            | Spy.CBool(false) -> Spvm.COPYC(tmp1, 0)
            | Spy.CNone -> Spvm.COPYN(tmp1)
        ) in
        let cmds = [(lb1, const_spvm)] in
        (cmds, tmp1)
(*    | Spy.Attribute(e1, id)*)
    | Spy.Subscript(e1, e2) ->
        let cmds1, id1 = (translate_expr e1) in
        let cmds2, id2 = (translate_expr e2) in
        let tmp1 = new_temp_var() in
        let cmds = cmds1 @ cmds2 @ [
            (new_label(), Spvm.ITER_LOAD(tmp1, id1, id2))
        ] in
        (cmds, tmp1)
    | Spy.Name(id) ->
        let tmp1 = new_temp_var() in
        let lb1 = new_label() in
        let cmds = [(lb1, Spvm.COPY(tmp1, id))] in
        (cmds, tmp1)
    | Spy.List(exprs) ->
        let list_head_tmp = new_temp_var() in
        let lb1 = new_label() in
        let cmds = List.fold_left (fun acc elem ->
            let elem_cmds, elem_id = translate_expr elem in
            acc @ elem_cmds @ [(new_label(), Spvm.LIST_APPEND(list_head_tmp, elem_id))]
        ) [(lb1, Spvm.LIST_EMPTY(list_head_tmp))] exprs in
        (cmds, list_head_tmp)
    | Spy.Tuple(exprs) ->
        let tuple_head_tmp = new_temp_var() in
        let lb1 = new_label() in
        let cmds = List.fold_right (fun elem acc ->
            let elem_cmds, elem_id = translate_expr elem in
            acc @ elem_cmds @ [(new_label(), Spvm.TUPLE_INSERT(tuple_head_tmp, elem_id))]
        ) exprs [(lb1, Spvm.TUPLE_EMPTY(tuple_head_tmp))] in
        (cmds, tuple_head_tmp)
(*    | Spy.Lambda(args, body) ->*)
    | _ -> raise (Not_Implemented ("expr: "^(Spy.print_expr expr)))
) in
let rec translate_stmt (s:Spy.stmt): Spvm.program =
    let _ = print_endline("stmt: " ^ Spy.print_stmt s) in
    (match s with
    | Spy.FunctionDef(name, args, body) ->
        let body_cmds = List.fold_left (fun spvm_instrs stmt ->
        let stmt_cmds = translate_stmt stmt in
        spvm_instrs @ stmt_cmds
        ) [] body
        in
        [(new_label(), Spvm.FUNC_DEF(name, args, body_cmds))]
    | Spy.Return(res) ->
        let rcmds, rids = (match res with
            | None ->
                let tmp1 = new_temp_var() in
                [(new_label(), Spvm.COPYN(tmp1))], tmp1
            | Some(expr) -> (translate_expr expr)
        ) in
        (rcmds @ [(new_label()), Spvm.RETURN(rids)])
    | Spy.Assign(targets, value) ->
        let val_cmds, val_id = translate_expr value in
        let rec get_tar_cmds explist idx list_id = (match explist with
            | [] -> []
            | Spy.Name(id)::tl ->
                let idx_tmp = new_temp_var() in
                [(new_label(), Spvm.COPYC(idx_tmp, idx));
                 (new_label(), Spvm.ITER_LOAD(id, list_id, idx_tmp))] @ (get_tar_cmds tl (idx+1) list_id)
            | Spy.List(exprs)::tl | Spy.Tuple(exprs)::tl ->
                let inner_list_id = new_temp_var() in
                let idx_tmp = new_temp_var() in
                [(new_label(), Spvm.COPYC(idx_tmp, idx));
                (new_label(), Spvm.ITER_LOAD(inner_list_id, list_id, idx_tmp))]
                @ (get_tar_cmds exprs 0 inner_list_id) @ (get_tar_cmds tl (idx+1) list_id)
            | _ -> raise (Error "Assignment not supported in Spy")
        ) in
        let target_cmds = (match targets with
            | [Spy.Name(id)] -> [(new_label(), Spvm.COPY(id, val_id))]
            | [Spy.List(exprs_list)] | [Spy.Tuple(exprs_list)] -> (get_tar_cmds exprs_list 0 val_id)
            | exprs_list -> (get_tar_cmds exprs_list 0 val_id)
        ) in
        (val_cmds @ target_cmds)
    | Spy.AugAssign(e1, op, e2) ->
        let assign_stmt = Spy.Assign([e1], Spy.BinOp(e1, op, e2)) in
        translate_stmt(assign_stmt)
(*    | Spy.For(iter, seq, body) ->*)
    | Spy.While(cond, prog) ->
        let start_lb = (new_label()) in
        let end_lb = (new_label()) in
        let start_cmd = [(start_lb, Spvm.SKIP)] in
        let ends_cmd = [(end_lb, Spvm.SKIP)] in
        let cond_cmd, cond_id = translate_expr cond in
        let prog_cmds = (List.fold_left (fun acc_stmts stmt ->
            let stmt_cmds = translate_stmt stmt in
            acc_stmts @ stmt_cmds
        ) [] prog) in
        let goto_cmd = [(new_label(), Spvm.UJUMP(start_lb))] in
        let loop_cmd = [(new_label(), Spvm.CJUMPF(cond_id, end_lb))] in
        start_cmd @ cond_cmd @ loop_cmd @ prog_cmds @ goto_cmd @ ends_cmd
    | Spy.If(cond, t_prog, f_prog) ->
        let false_lb = new_label() in
        let end_lb = new_label() in
        let cond_cmds, cond_id = translate_expr cond in
        let t_cmds = ((List.fold_left (fun acc_stmts stmt ->
            let stmt_cmds = translate_stmt stmt in
            acc_stmts @ stmt_cmds
        ) [] t_prog)) in
        let f_cmds = ((List.fold_left (fun acc_stmts stmt ->
            let stmt_cmds = translate_stmt stmt in
            acc_stmts @ stmt_cmds
        ) [] f_prog)) in
        let cmds = cond_cmds @ [
            (new_label(), Spvm.CJUMPF(cond_id, false_lb))
        ] @ t_cmds @ [
            (new_label(), Spvm.UJUMP(end_lb)); (false_lb, Spvm.SKIP)
        ] @ f_cmds @ [
            (end_lb, Spvm.SKIP)
        ] in
        cmds
    | Spy.Assert(e1) ->
        let cmds1, id1 = translate_expr e1 in
        let lb1 = new_label() in
        let lb2 = new_label() in
        let cmds = cmds1 @ [
        (lb1, Spvm.CJUMP(id1, lb2));
        (lb2, Spvm.ASSERT(id1));
        ] in
        cmds
    | Spy.Expr(e1) ->
        let cmds, id1 = translate_expr e1 in
        let lb1 = new_label() in
        let tmp1 = new_temp_var() in
        cmds @ [(lb1, Spvm.COPY(tmp1, id1))]
(*    | Spy.Break ->*)
(*    | Spy.Continue ->*)
(*    | Spy.Pass ->*)
    | _ -> raise (Not_Implemented ("stmt: "^(Spy.print_stmt s)))
) in
let eop = [(new_label(), Spvm.HALT)] in
let program = List.fold_left (fun prog stmt ->
let spvm_stmt = translate_stmt stmt in
prog @ spvm_stmt) [] p in
[1, Spvm.SKIP] @ program @ eop
