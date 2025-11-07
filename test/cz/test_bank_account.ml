let test_valid_numbers () =
  let numbers =
    [
      "34278-0727558021/0100" (* Valid example from spec *)
    ; "000000-0000000019/0800" (* Minimal valid format *)
    ; "100001-0000000027/0100" (* Full prefix *)
    ]
  in
  List.iter
    (fun n ->
      Alcotest.(check bool)
        (n ^ " should be valid") true
        (Cz.Bank_account.is_valid n))
    numbers

let test_invalid_checksum_prefix () =
  Alcotest.check_raises "should raise Invalid_checksum for invalid prefix"
    Cz.Bank_account.Invalid_checksum (fun () ->
      ignore (Cz.Bank_account.validate "4278-0727558021/0100"))

let test_invalid_checksum_root () =
  Alcotest.check_raises "should raise Invalid_checksum for invalid root"
    Cz.Bank_account.Invalid_checksum (fun () ->
      ignore (Cz.Bank_account.validate "34278-0727558022/0100"))

let test_invalid_bank () =
  Alcotest.check_raises "should raise Invalid_bank for bank code 0000"
    Cz.Bank_account.Invalid_bank (fun () ->
      ignore (Cz.Bank_account.validate "34278-0727558021/0000"))

let test_invalid_format_no_slash () =
  Alcotest.check_raises "should raise Invalid_format for missing slash"
    Cz.Bank_account.Invalid_format (fun () ->
      ignore (Cz.Bank_account.validate "34278-0727558021"))

let test_invalid_format_no_dash () =
  Alcotest.check_raises "should raise Invalid_format for missing dash"
    Cz.Bank_account.Invalid_format (fun () ->
      ignore (Cz.Bank_account.validate "342780727558021/0100"))

let test_invalid_format_letters () =
  Alcotest.check_raises "should raise Invalid_format for non-digits"
    Cz.Bank_account.Invalid_format (fun () ->
      ignore (Cz.Bank_account.validate "3427A-0727558021/0100"))

let test_compact () =
  Alcotest.(check string)
    "should compact and pad correctly" "034278-0727558021/0100"
    (Cz.Bank_account.compact "34278-727558021/0100")

let test_format () =
  Alcotest.(check string)
    "should format correctly" "034278-0727558021/0100"
    (Cz.Bank_account.format "34278-727558021/0100")

let test_valid_padded () =
  Alcotest.(check string)
    "should validate and return padded format" "034278-0727558021/0100"
    (Cz.Bank_account.validate "34278-0727558021/0100")

let suite =
  [
    ("valid numbers", `Quick, test_valid_numbers)
  ; ("invalid checksum (prefix)", `Quick, test_invalid_checksum_prefix)
  ; ("invalid checksum (root)", `Quick, test_invalid_checksum_root)
  ; ("invalid bank code", `Quick, test_invalid_bank)
  ; ("invalid format (no slash)", `Quick, test_invalid_format_no_slash)
  ; ("invalid format (no dash)", `Quick, test_invalid_format_no_dash)
  ; ("invalid format (letters)", `Quick, test_invalid_format_letters)
  ; ("compact function", `Quick, test_compact)
  ; ("format function", `Quick, test_format)
  ; ("validate returns padded", `Quick, test_valid_padded)
  ]

let () = Alcotest.run "Cz.Bank_account" [ ("suite", suite) ]
