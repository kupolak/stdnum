let test_compact () =
  let test_cases =
    [
      ("6214 9832 0257", "621498320257")
    ; ("6214-9832-0257", "621498320257")
    ; (" 621498320257 ", "621498320257")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Jp.In_.compact input in
      Alcotest.(check string)
        (Printf.sprintf "test_compact_%s" input)
        expected_result result)
    test_cases

let test_format () =
  (* From Python doctest: format('621498320257') *)
  let result = Jp.In_.format "621498320257" in
  Alcotest.(check string) "test_format" "6214 9832 0257" result

let test_validate_valid () =
  (* From Python doctest: validate('6214 9832 0257') *)
  let result = Jp.In_.validate "6214 9832 0257" in
  Alcotest.(check string) "test_validate_valid" "621498320257" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('6214 9832 0258') - invalid check digit *)
  Alcotest.check_raises "Invalid Checksum" Jp.In_.Invalid_checksum (fun () ->
      ignore (Jp.In_.validate "6214 9832 0258"))

let test_validate_invalid_format () =
  (* From Python doctest: validate('6214 9832 025X') - invalid format *)
  Alcotest.check_raises "Invalid Format" Jp.In_.Invalid_format (fun () ->
      ignore (Jp.In_.validate "6214 9832 025X"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Jp.In_.Invalid_length (fun () ->
      ignore (Jp.In_.validate "62149832"))

let test_is_valid_true () =
  let result = Jp.In_.is_valid "6214 9832 0257" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Jp.In_.is_valid "6214 9832 0258" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Jp.In_" [ ("suite", suite) ]
