From Coq Require Import
     Ascii
     Basics
     Decimal
     HexString
     List
     NArith
     String
     ZArith.
Import ListNotations.
Local Open Scope bool_scope.
Local Open Scope string_scope.
Local Open Scope program_scope.

Class Show A := { show : A -> string }.

Instance Show__unit : Show unit :=
  { show := const "tt" }.

Instance Show__bool : Show bool :=
  { show b :=
      match b with
      | true  => "true"
      | false => "false"
      end }.

Fixpoint show_uint (n : uint) : string :=
  match n with
  | Nil  => ""
  | D0 n => String "0" (show_uint n)
  | D1 n => String "1" (show_uint n)
  | D2 n => String "2" (show_uint n)
  | D3 n => String "3" (show_uint n)
  | D4 n => String "4" (show_uint n)
  | D5 n => String "5" (show_uint n)
  | D6 n => String "6" (show_uint n)
  | D7 n => String "7" (show_uint n)
  | D8 n => String "8" (show_uint n)
  | D9 n => String "9" (show_uint n)
  end.

Instance Show__uint : Show uint :=
  { show := show_uint }.

Instance Show__nat : Show nat :=
  { show := show ∘ Nat.to_uint }.

Instance Show__int : Show int :=
  { show n :=
      match n with
      | Pos n => show n
      | Neg n => String "-" (show n)
      end }.

Instance Show__Z : Show Z :=
  { show := show ∘ Z.to_int }.

Instance Show__N : Show N :=
  { show := show ∘ Z.of_N }.

Definition ascii_of_digit (n : nat) : ascii :=
  ascii_of_nat ((n mod 10) + 48 (* 0 *)).

Definition octal_string_of_nat (n : nat) : string :=
  let n0 : ascii := ascii_of_digit n in
  let n1 : ascii := ascii_of_digit (n / 10) in
  let n2 : ascii := ascii_of_digit (n / 100) in
  string_of_list_ascii [n2; n1; n0].

Fixpoint escape_string (s : string) : string :=
  match s with
  | "" => ""
  | String c s' =>
    (if ascii_dec c "009" then
       "\t"
     else if ascii_dec c "010" then
       "\n"
     else if ascii_dec c "013" then
       "\r"
     else if ascii_dec c """" then
       "\"""
     else if ascii_dec c "\" then
       "\\"
     else
       let n : nat := nat_of_ascii c in
       if (n <? 32) || (126 <? n) then
         "\" ++ octal_string_of_nat n
       else String c "")
      ++ escape_string s'
end.

Instance Show__string : Show string :=
  { show s := String """" (escape_string s ++ """") }.

Fixpoint contents {A} (s : A -> string) (l : list A) : string :=
  match l with
    | []  => ""
    | [h] => s h ++ ""
    | h::t => s h ++ "; " ++ contents s t
  end.

Instance Show__list {A} `{Show A} : Show (list A) :=
  { show l := String "[" (contents show l ++ "]") }.

Instance Show__pair {A B} `{Show A} `{Show B} : Show (A * B) :=
  { show p :=
      let (a,b) := p in
      String "(" (show a) ++
      String "," (show b) ++ ")" }.

Instance Show__option {A} `{Show A} : Show (option A) :=
  { show x :=
      match x with
      | Some a => "Some " ++ show a
      | None   => "None"
      end }.
