let test_compact () =
  let test_cases =
    [
      ("185 472 90", "18547290")
    ; ("185-472-90", "18547290")
    ; ("RO 185 472 90", "18547290")
    ; ("ro 185 472 90", "18547290")
    ; ("RO18547290", "18547290")
    ; ("18547290", "18547290")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ro.Cui.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases =
    [
      "18547290"
    ; "185 472 90"
    ; "RO 185 472 90"
    ; "100000006" (* 9 digits *)
    ; "1000000004" (* 10 digits - maximum length *)
    ; "19" (* Minimum length: 2 digits *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cui.validate input in
      Alcotest.(check string)
        ("test_validate_valid_" ^ input)
        (Ro.Cui.compact input) result)
    test_cases

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ro.Cui.Invalid_checksum (fun () ->
      ignore (Ro.Cui.validate "185 472 91"))

let test_validate_invalid_format_leading_zero () =
  Alcotest.check_raises "Invalid Format" Ro.Cui.Invalid_format (fun () ->
      ignore (Ro.Cui.validate "018547290"))

let test_validate_invalid_format_non_digit () =
  Alcotest.check_raises "Invalid Format" Ro.Cui.Invalid_format (fun () ->
      ignore (Ro.Cui.validate "1854729A"))

let test_validate_invalid_length_too_short () =
  Alcotest.check_raises "Invalid Length" Ro.Cui.Invalid_length (fun () ->
      ignore (Ro.Cui.validate "1"))

let test_validate_invalid_length_too_long () =
  Alcotest.check_raises "Invalid Length" Ro.Cui.Invalid_length (fun () ->
      ignore (Ro.Cui.validate "12345678901"))

let test_is_valid_true () =
  let test_cases = [ "18547290"; "185 472 90"; "RO 185 472 90"; "19" ] in
  List.iter
    (fun input ->
      let result = Ro.Cui.is_valid input in
      Alcotest.(check bool) ("test_is_valid_true_" ^ input) true result)
    test_cases

let test_is_valid_false () =
  let test_cases =
    [ "185 472 91"; "018547290"; "1854729A"; "1"; "12345678901" ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cui.is_valid input in
      Alcotest.(check bool) ("test_is_valid_false_" ^ input) false result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ( "test_validate_invalid_format_leading_zero"
    , `Quick
    , test_validate_invalid_format_leading_zero )
  ; ( "test_validate_invalid_format_non_digit"
    , `Quick
    , test_validate_invalid_format_non_digit )
  ; ( "test_validate_invalid_length_too_short"
    , `Quick
    , test_validate_invalid_length_too_short )
  ; ( "test_validate_invalid_length_too_long"
    , `Quick
    , test_validate_invalid_length_too_long )
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Ro.Cui" [ ("suite", suite) ]
