let test_compact () =
  let result = Pe.Ruc.compact " 20512333797 " in
  Alcotest.(check string) "test_compact" "20512333797" result

let test_validate () =
  let result = Pe.Ruc.validate "20512333797" in
  Alcotest.(check string) "test_validate" "20512333797" result

let test_validate_invalid_checksum () =
  try
    ignore (Pe.Ruc.validate "20512333798");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Pe.Ruc.Invalid_checksum -> ()

let test_to_dni () =
  let result = Pe.Ruc.to_dni "10054148289" in
  Alcotest.(check string) "test_to_dni" "05414828" result

let test_is_valid () =
  let test_cases = [ ("20512333797", true); ("20512333798", false) ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Pe.Ruc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_to_dni", `Quick, test_to_dni)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "Stdnum.Pe.Ruc" [ ("suite", suite) ]
