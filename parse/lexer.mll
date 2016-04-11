{
 open Parser        (* The type token is defined in parser.mli *)
}

let digit = ['0'-'9']
let character = ['A'-'z' '_']
let flt = ((digit+ '.' digit*) | (digit* '.' digit+))
let str_internal = ([^'"']|("\\\""))* as str
rule tokenize = parse
    | [' ' '\t']      { tokenize lexbuf }     (* skip blanks *)

    | digit+ as lxm                   { INT_LIT (lxm) }
    | flt as lxm                      { FLOAT_LIT (lxm) }
    | '"' (str_internal as str) '"'   { STRING_LIT str }
    | "true"                          { TRUE }
    | "false"                         { FALSE }
    
    | "int"     { INT_T }     
    | "float"   { FLOAT_T }
    | "bool"    { BOOL_T }
    | "string"  { STRING_T }

    | "&"       { BAND }
    | "|"       { BOR }
    | '^'       { BXOR }
    | "<<"      { BLEFT }
    | ">>"      { BRIGHT }
    | '~'       { BNOT }
    | "&&"      { LAND }
    | "and"     { LAND }
    | "||"      { LOR }
    | "or"      { LOR }
    | '!'       { LNOT }
    | "not"     { LNOT }
    | "=="      { EQ }
    | "is"      { EQ }
    | '<'       { GREATER }
    | '>'       { LESS }
    | '+'       { PLUS }
    | '-'       { MINUS }
    | '*'       { TIMES }
    | '/'       { DIV }
    | '%'       { MOD }
    | "**"      { POW }
    | '='       { ASSIGN }

    | "if"      { IF }
    | "else"    { ELSE }
    | "for"     { FOR }
    | "while"   { WHILE }

    | character+ as ident   { IDENT ident }

    | '('       { LPAREN }
    | ')'       { RPAREN }
    | '{'       { LCURLY }
    | '}'       { RCURLY }
    | '['       { LSQUARE }
    | ']'       { RSQUARE }
    | ';'       { SEMICOLON }
    | "func"    { FUNCDEF }
    | ['\n' ]   { EOL }
    (* etc *)
    | eof       { EOF }
    | _         { SYNTAX_ERROR }

{
let tokstr = function
  | INT_LIT i -> "(INT_LIT " ^ (i) ^ ")"
  | FLOAT_LIT f -> "(FLOAT_LIT " ^ (f) ^ ")"
  | STRING_LIT str -> "(STRING_LIT \"" ^ str ^ "\")"
  | TRUE -> "TRUE"
  | FALSE -> "FALSE"

  | INT_T -> "INT_T"
  | FLOAT_T -> "FLOAT_T"
  | BOOL_T -> "BOOL_T"
  | STRING_T -> "STRING_T"

  | BAND -> "BAND"
  | BOR  -> "BOR"
  | BXOR -> "BXOR"
  | BLEFT -> "BLEFT"
  | BRIGHT -> "BRIGHT"
  | BNOT -> "BNOT"
  | LAND -> "LAND"
  | LOR -> "LOR"
  | LNOT -> "LNOT"
  | EQ -> "EQ"
  | LESS -> "LESS"
  | GREATER -> "GREATER"
  | PLUS -> "PLUS"
  | MINUS -> "MINUS"
  | TIMES -> "TIMES"
  | DIV -> "DIV"
  | MOD -> "MOD"
  | POW -> "POW"
  | ASSIGN -> "ASSIGN"

  | IF -> "IF"
  | ELSE -> "ELSE"
  | FOR -> "FOR"
  | WHILE -> "WHILE"

  | IDENT str -> "(IDENT " ^ str ^ ")"

  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | LCURLY -> "LCURLY"
  | RCURLY -> "RCURLY"
  | LSQUARE -> "LSQUARE"
  | RSQUARE -> "RSQUARE"
  | SEMICOLON -> "SEMICOLON"
  | FUNCDEF -> "FUNCDEF"
  | EOL -> "EOL\n"
  | EOF -> "EOF"
  | SYNTAX_ERROR -> "Syntax error. An error probably should have been raised\n"

}