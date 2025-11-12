let test_compact () =
  let test_cases =
    [
      ("ES B-58378431", "B58378431")
    ; ("B-58378431", "B58378431")
    ; ("54362315K", "54362315K")
    ; ("X-5253868-R", "X5253868R")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Es.Nif.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_cif () =
  (* From Python doctest: validate('B64717838') *)
  let result = Es.Nif.validate "B64717838" in
  Alcotest.(check string) "test_validate_cif" "B64717838" result

let test_validate_dni () =
  (* From Python doctest: validate('54362315K') - resident *)
  let result = Es.Nif.validate "54362315K" in
  Alcotest.(check string) "test_validate_dni" "54362315K" result

let test_validate_nie () =
  (* From Python doctest: validate('X-5253868-R') - foreign person *)
  let result = Es.Nif.validate "X-5253868-R" in
  Alcotest.(check string) "test_validate_nie" "X5253868R" result

let test_validate_klm_prefix () =
  (* From Python doctest: validate('M-1234567-L') - foreign person without NIE *)
  let result = Es.Nif.validate "M-1234567-L" in
  Alcotest.(check string) "test_validate_klm_prefix" "M1234567L" result

let test_validate_invalid_checksum () =
  (* From Python doctest: validate('B64717839') - invalid check digit *)
  Alcotest.check_raises "Invalid Checksum" Es.Nif.Invalid_checksum (fun () ->
      ignore (Es.Nif.validate "B64717839"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Es.Nif.Invalid_length (fun () ->
      ignore (Es.Nif.validate "B647178"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Es.Nif.Invalid_format (fun () ->
      ignore (Es.Nif.validate "B64A17838"))

let test_is_valid_cif () =
  let result = Es.Nif.is_valid "B64717838" in
  Alcotest.(check bool) "test_is_valid_cif" true result

let test_is_valid_dni () =
  let result = Es.Nif.is_valid "54362315K" in
  Alcotest.(check bool) "test_is_valid_dni" true result

let test_is_valid_nie () =
  let result = Es.Nif.is_valid "X5253868R" in
  Alcotest.(check bool) "test_is_valid_nie" true result

let test_is_valid_klm () =
  let result = Es.Nif.is_valid "M1234567L" in
  Alcotest.(check bool) "test_is_valid_klm" true result

let test_is_valid_false () =
  let result = Es.Nif.is_valid "B64717839" in
  Alcotest.(check bool) "test_is_valid_false" false result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_cif", `Quick, test_validate_cif)
  ; ("test_validate_dni", `Quick, test_validate_dni)
  ; ("test_validate_nie", `Quick, test_validate_nie)
  ; ("test_validate_klm_prefix", `Quick, test_validate_klm_prefix)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_cif", `Quick, test_is_valid_cif)
  ; ("test_is_valid_dni", `Quick, test_is_valid_dni)
  ; ("test_is_valid_nie", `Quick, test_is_valid_nie)
  ; ("test_is_valid_klm", `Quick, test_is_valid_klm)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Es.Nif" [ ("suite", suite) ]
