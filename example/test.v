From Coq Require Import
     Ascii
     List
     String.
From Show Require Import
     Show.
Import ListNotations.
Open Scope string_scope.

Goal show None = "None".
Proof. reflexivity. Qed.

Goal show (Some tt) = "Some tt".
Proof. reflexivity. Qed.

Goal show (true, false) = "(true,false)".
Proof. reflexivity. Qed.

Goal show [1;2;3] = "[1; 2; 3]".
Proof. reflexivity. Qed.

Goal show (string_of_list_ascii
             [ascii_of_nat 10;
              ascii_of_nat 14;
              "a"%char;
              ascii_of_nat 127]) = """\n\014a\127""".
Proof. reflexivity. Qed.
