let test_compact () =
  let result = Dk.Cvr.compact " DK 13585628 " in
  Alcotest.(check string) "test_compact" "13585628" result

let test_checksum () =
  let result = Dk.Cvr.checksum "13585628" in
  Alcotest.(check int) "test_checksum" 0 result

let test_validate () =
  let result = Dk.Cvr.validate "DK 13585628" in
  Alcotest.(check string) "test_validate" "13585628" result

let test_validate_invalid_checksum () =
  try
    ignore (Dk.Cvr.validate "DK 13585627");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Dk.Cvr.Invalid_checksum -> ()

let test_validate_invalid_format () =
  try
    ignore (Dk.Cvr.validate "013585628");
    Alcotest.fail "Expected Invalid_format exception"
  with Dk.Cvr.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("DK 13585628", true)
    ; ("DK 13585627", false)
    ; ("13585628", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Dk.Cvr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_checksum", `Quick, test_checksum)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Dk.Cvr" [ ("suite", suite) ]
