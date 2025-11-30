let test_compact () =
  let test_cases =
    [
      ("732 829 320 00074", "73282932000074")
    ; ("73282932000074", "73282932000074")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("73282932000074", "73282932000074")
    ; ("732 829 320 00074", "73282932000074")
    ; ("40483304800006", "40483304800006")
    ; ("40483304800014", "40483304800014")
    ; ("55200844300004", "55200844300004")
    ; ("55200844300012", "55200844300012")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_checksum () =
  try
    ignore (Fr.Siret.validate "73282932000079");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Fr.Siret.Invalid_checksum -> ()

let test_validate_invalid_length () =
  try
    ignore (Fr.Siret.validate "7328293200007");
    Alcotest.fail "Expected Invalid_length exception"
  with Fr.Siret.Invalid_length -> ()

let test_validate_invalid_format () =
  try
    ignore (Fr.Siret.validate "7328293200007A");
    Alcotest.fail "Expected Invalid_format exception"
  with Fr.Siret.Invalid_format -> ()

let test_is_valid () =
  let test_cases =
    [
      ("73282932000074", true)
    ; ("732 829 320 00074", true)
    ; ("73282932000079", false) (* bad checksum *)
    ; ("7328293200007", false) (* wrong length *)
    ; ("7328293200007A", false) (* invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_to_siren () =
  let test_cases =
    [ ("732 829 320 00074", "732 829 320"); ("73282932000074", "732829320") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.to_siren input in
      Alcotest.(check string) "test_to_siren" expected_result result)
    test_cases

let test_to_tva () =
  let test_cases =
    [
      ("732 829 320 00074", "44 732 829 320"); ("73282932000074", "44732829320")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.to_tva input in
      Alcotest.(check string) "test_to_tva" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("73282932000074", "732 829 320 00074")
    ; ("732829320 00074", "732 829 320 00074")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let test_la_poste_special () =
  (* La Poste special validation: sum of digits must be divisible by 5 *)
  let test_cases =
    [
      ("35600000000048", true) (* Head office - uses Luhn *)
    ; ("35600000000001", true) (* Sum = 15, divisible by 5 *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Fr.Siret.is_valid input in
      Alcotest.(check bool) "test_la_poste_special" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_to_siren", `Quick, test_to_siren)
  ; ("test_to_tva", `Quick, test_to_tva)
  ; ("test_format", `Quick, test_format)
  ; ("test_la_poste_special", `Quick, test_la_poste_special)
  ]

let () = Alcotest.run "Fr.Siret" [ ("suite", suite) ]
