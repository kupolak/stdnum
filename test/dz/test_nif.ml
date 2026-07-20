let test_compact () =
  let result = Dz.Nif.compact " 408 020 000 150 039 " in
  Alcotest.(check string) "test_compact" "408020000150039" result

let test_validate () =
  let result = Dz.Nif.validate "416001000000007" in
  Alcotest.(check string) "test_validate_15" "416001000000007" result;
  let result2 = Dz.Nif.validate "41201600000606600001" in
  Alcotest.(check string) "test_validate_20" "41201600000606600001" result2

let test_validate_invalid_length () =
  try
    ignore (Dz.Nif.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Dz.Nif.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Dz.Nif.validate "X1600100000000V");
    Alcotest.fail "Expected Invalid_format exception"
  with Dz.Nif.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("416001000000007", true)
    ; ("408 020 000 150 039", true)
    ; ("41201600000606600001", true)
    ; ("000 216 001 808 337 13010", true)
    ; ("12345", false)
    ; ("X1600100000000V", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Dz.Nif.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let result = Dz.Nif.format "408 020 000 150 039" in
  Alcotest.(check string) "test_format" "408020000150039" result

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Stdnum.Dz.Nif" [ ("suite", suite) ]
