let test_compact () =
  let test_cases =
    [
      ("5-8356-7825-6246", "5835678256246")
    ; ("5 8356 7825 6246", "5835678256246")
    ; (" 5835678256246 ", "5835678256246")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Jp.Cn.compact input in
      Alcotest.(check string)
        (Printf.sprintf "test_compact_%s" input)
        expected_result result)
    test_cases

let test_format () =
  (* From Python doctest: format('5835678256246') *)
  let result = Jp.Cn.format "5835678256246" in
  Alcotest.(check string) "test_format" "5-8356-7825-6246" result

let test_validate_valid () =
  (* From Python doctest: validate('5-8356-7825-6246') *)
  let result = Jp.Cn.validate "5-8356-7825-6246" in
  Alcotest.(check string) "test_validate_valid" "5835678256246" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('2-8356-7825-6246') - invalid check digit *)
  Alcotest.check_raises "Invalid Checksum" Jp.Cn.Invalid_checksum (fun () ->
      ignore (Jp.Cn.validate "2-8356-7825-6246"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Jp.Cn.Invalid_length (fun () ->
      ignore (Jp.Cn.validate "583567825"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Jp.Cn.Invalid_format (fun () ->
      ignore (Jp.Cn.validate "5835678256A46"))

let test_is_valid_true () =
  let result = Jp.Cn.is_valid "5-8356-7825-6246" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Jp.Cn.is_valid "2-8356-7825-6246" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_format", `Quick, test_format)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Jp.Cn" [ ("suite", suite) ]
