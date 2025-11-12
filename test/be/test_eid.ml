let test_compact () =
  let test_cases =
    [
      ("000-0011032-71", "000001103271")
    ; ("591-1917064-58", "591191706458")
    ; (" 000-0011032-71 ", "000001103271")
    ; ("000.0011032.71", "000001103271")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Be.Eid.compact input in
      Alcotest.(check string)
        (Printf.sprintf "test_compact_%s" input)
        expected_result result)
    test_cases

let test_format () =
  (* From Python doctest: format('591191706458') *)
  let result = Be.Eid.format "591191706458" in
  Alcotest.(check string) "test_format" "591-1917064-58" result

let test_validate_valid () =
  (* From Python doctest: validate('000-0011032-71') *)
  let result = Be.Eid.validate "000-0011032-71" in
  Alcotest.(check string) "test_validate_valid" "000001103271" result

let test_validate_valid_2 () =
  (* From Python doctest: validate('591-1917064-58') *)
  let result = Be.Eid.validate "591-1917064-58" in
  Alcotest.(check string) "test_validate_valid_2" "591191706458" result

let test_validate_valid_3 () =
  (* From Python doctest: validate('591-2010999-97') *)
  let result = Be.Eid.validate "591-2010999-97" in
  Alcotest.(check string) "test_validate_valid_3" "591201099997" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('000-0011032-25') - invalid checksum *)
  Alcotest.check_raises "Invalid Checksum" Be.Eid.Invalid_checksum (fun () ->
      ignore (Be.Eid.validate "000-0011032-25"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Be.Eid.Invalid_length (fun () ->
      ignore (Be.Eid.validate "000-001103"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Be.Eid.Invalid_format (fun () ->
      ignore (Be.Eid.validate "000-0011032-7A"))

let test_validate_zero () =
  (* Number must be > 0 *)
  Alcotest.check_raises "Invalid Format" Be.Eid.Invalid_format (fun () ->
      ignore (Be.Eid.validate "000000000000"))

let test_is_valid_true () =
  let result = Be.Eid.is_valid "000-0011032-71" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_true_2 () =
  let result = Be.Eid.is_valid "591-1917064-58" in
  Alcotest.(check bool) "test_is_valid_true_2" true result

let test_is_valid_false () =
  let result = Be.Eid.is_valid "000-0011032-25" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_valid_2", `Quick, test_validate_valid_2)
  ; ("test_validate_valid_3", `Quick, test_validate_valid_3)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_zero", `Quick, test_validate_zero)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_true_2", `Quick, test_is_valid_true_2)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Be.Eid" [ ("suite", suite) ]
