
(** Lex and parse a file into its AST.  *)
let get_ast filename = 
    let file = open_in filename in
    let try_wrap () =
        let lexbuf = Lexing.from_channel file in
        try
            let result = Parser.main Lexer.tokenize lexbuf in
            Printf.printf "Parsing completed\n";
            close_in file;
            result
        with
            | Parsing_globals.Syntax_error (ln, ch) ->
                Printf.printf "Syntax error in %s at line: %d, char: %d\n" filename ln ch;
                close_in file;
                Abstract_syntax.AST []
            | Parser.Error ->
                let ln, ch = Lexer.pos_info lexbuf in
                Printf.printf "Parsing error in %s at line: %d, char: %d\n" filename ln ch;
                close_in file;
                Abstract_syntax.AST []
    in
    try_wrap ()


(** The main function of the compiler *)
let () =
    if Array.length Sys.argv <> 2 then
        Printf.printf "%s" ("Usage: " ^ Sys.argv.(0) ^ " <filename>\n")
    else
    (* Tokenize the file and exit *)
    let filename = Sys.argv.(1) in
    let ast = get_ast filename in
    if ast <> Abstract_syntax.AST [] then
    begin
    let simpler_ast = Simplifications.simplify ast in
    let type_and_scope_errs = Type_and_scope_checking.chk_type_and_scope simpler_ast in
    if type_and_scope_errs <> [] then
        begin
        (fun _ -> ()) (List.map (fun s -> Printf.printf "Error: %s\n" s) 
                                type_and_scope_errs);
        exit 1
        end;
    Printf.printf "Here's the pretty printed result of parsing the given file:\n";
    Printf.printf "%s\n\n" (Abstract_syntax.prettyPrint_Tree ast);
    Printf.printf "Here's a pretty printed result of translating:\n";
    let intrm = Intermediate_tree.intermediate_of_ast simpler_ast in
    Printf.printf "%s\n\n" (Intermediate_tree.prettyPrint_Tree intrm);
    Printf.printf "Here's a run of the interpretor\n";
    (fun _ -> ()) (Interpretor.interp_tree intrm);
    Printf.printf "\n";
    exit 0
    end
