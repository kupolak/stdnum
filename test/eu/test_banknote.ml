let test_compact () =
  let result = Eu.Banknote.compact " P36007033744 " in
  Alcotest.(check string) "test_compact" "P36007033744" result

let test_validate () =
  let result = Eu.Banknote.validate "P36007033744" in
  Alcotest.(check string) "test_validate" "P36007033744" result

let test_validate_invalid_checksum () =
  try
    ignore (Eu.Banknote.validate "P36007033743");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Eu.Banknote.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases = [ ("P36007033744", true); ("P36007033743", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Eu.Banknote.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Eu.Banknote" [ ("suite", suite) ]
