let test_compact () =
  let test_cases =
    [
      ("RO 185 472 90", "RO18547290")
    ; ("185 472 90", "18547290")
    ; ("RO18547290", "RO18547290")
    ; ("1630615123457", "1630615123457")
    ; ("163 061 512 3457", "1630615123457")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ro.Cf.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid_cui () =
  let test_cases =
    [
      "RO18547290" (* VAT CUI/CIF with RO prefix *)
    ; "18547290" (* Non-VAT CUI/CIF *)
    ; "RO 185 472 90" (* VAT with spaces *)
    ; "185 472 90" (* Non-VAT with spaces *)
    ; "19" (* Minimum length CUI *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cf.validate input in
      Alcotest.(check string)
        ("test_validate_valid_cui_" ^ input)
        (Ro.Cf.compact input) result)
    test_cases

let test_validate_valid_cnp () =
  let test_cases =
    [
      "1630615123457" (* CNP - 13 digits *)
    ; "163 061 512 3457" (* CNP with spaces *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cf.validate input in
      Alcotest.(check string)
        ("test_validate_valid_cnp_" ^ input)
        (Ro.Cf.compact input) result)
    test_cases

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Ro.Cf.Invalid_length (fun () ->
      ignore (Ro.Cf.validate "1"))

let test_validate_invalid_length_too_long () =
  Alcotest.check_raises "Invalid Length" Ro.Cf.Invalid_length (fun () ->
      ignore (Ro.Cf.validate "12345678901234"))

let test_validate_invalid_cui_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ro.Cf.Invalid_checksum (fun () ->
      ignore (Ro.Cf.validate "RO185 472 91"))

let test_validate_invalid_cnp_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ro.Cf.Invalid_checksum (fun () ->
      ignore (Ro.Cf.validate "1630615123458"))

let test_is_valid_true () =
  let test_cases =
    [
      "RO18547290" (* VAT CUI *)
    ; "18547290" (* Non-VAT CUI *)
    ; "1630615123457" (* CNP *)
    ; "19" (* Min length CUI *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cf.is_valid input in
      Alcotest.(check bool) ("test_is_valid_true_" ^ input) true result)
    test_cases

let test_is_valid_false () =
  let test_cases =
    [
      "1" (* Too short *)
    ; "12345678901234" (* Too long *)
    ; "RO185 472 91" (* Invalid CUI checksum *)
    ; "1630615123458" (* Invalid CNP checksum *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cf.is_valid input in
      Alcotest.(check bool) ("test_is_valid_false_" ^ input) false result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid_cui", `Quick, test_validate_valid_cui)
  ; ("test_validate_valid_cnp", `Quick, test_validate_valid_cnp)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "test_validate_invalid_length_too_long"
    , `Quick
    , test_validate_invalid_length_too_long )
  ; ( "test_validate_invalid_cui_checksum"
    , `Quick
    , test_validate_invalid_cui_checksum )
  ; ( "test_validate_invalid_cnp_checksum"
    , `Quick
    , test_validate_invalid_cnp_checksum )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Ro.Cf" [ ("suite", suite) ]
