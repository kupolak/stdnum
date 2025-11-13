let test_compact () =
  let test_cases =
    [ ("000307052", "000307052"); ("009CVD", "009CVD"); ("009 CVD", "009CVD") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_from_base32 () =
  let test_cases = [ ("009CVD", "000307052"); ("000000", "000000000") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.from_base32 input in
      Alcotest.(check string)
        ("test_from_base32_" ^ input)
        expected_result result)
    test_cases

let test_to_base32 () =
  let test_cases = [ ("000307052", "009CVD"); ("000000000", "000000") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.to_base32 input in
      Alcotest.(check string) ("test_to_base32_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("00030705", "2"); ("00000000", "0") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate_base10 () =
  let test_cases = [ ("000307052", "000307052") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.validate_base10 input in
      Alcotest.(check string)
        ("test_validate_base10_" ^ input)
        expected_result result)
    test_cases

let test_validate_base32 () =
  let test_cases = [ ("009CVD", "000307052") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.validate_base32 input in
      Alcotest.(check string)
        ("test_validate_base32_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases = [ ("000307052", "000307052"); ("009CVD", "000307052") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("000307052", true) (* Valid BASE10 *)
    ; ("009CVD", true) (* Valid BASE32 *)
    ; ("000307051", false) (* Invalid checksum *)
    ; ("100307052", false) (* First digit not 0 *)
    ; ("00030705", false) (* Invalid length *)
    ; ("009CVDA", false) (* Invalid length for BASE32 *)
    ; ("00030705A", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = It_stdnum.Aic.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_from_base32", `Quick, test_from_base32)
  ; ("test_to_base32", `Quick, test_to_base32)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate_base10", `Quick, test_validate_base10)
  ; ("test_validate_base32", `Quick, test_validate_base32)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "It_stdnum.Aic" [ ("suite", suite) ]
