let test_compact () =
  let test_cases =
    [
      ("0614-050707-104-8", "06140507071048")
    ; ("SV 0614-050707-104-8", "06140507071048")
    ; (" 0614 050707 104 8 ", "06140507071048")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Sv.Nit.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases =
    [
      ("0614-050707-104-8", "06140507071048")
    ; ("SV 0614-050707-104-8", "06140507071048")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Sv.Nit.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Sv.Nit.Invalid_checksum (fun () ->
      ignore (Sv.Nit.validate "0614-050707-104-0"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Sv.Nit.Invalid_length (fun () ->
      ignore (Sv.Nit.validate "12345678"))

let test_is_valid_true () =
  let result = Sv.Nit.is_valid "0614-050707-104-8" in
  Alcotest.(check bool) "test_is_valid_true" true result

let test_is_valid_false () =
  let result = Sv.Nit.is_valid "0614-050707-104-0" in
  Alcotest.(check bool) "test_is_valid_false" false result

let test_format () =
  let result = Sv.Nit.format "06140507071048" in
  Alcotest.(check string) "test_format" "0614-050707-104-8" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Sv.Nit" [ ("suite", suite) ]
