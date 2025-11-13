let test_compact () =
  let test_cases =
    [
      ("CHE-100.155.212", "CHE100155212")
    ; ("CHE100155212", "CHE100155212")
    ; ("100.155.212", "CHE100155212")
    ; ("100155212", "CHE100155212")
    ; ("CHE 100 155 212", "CHE100155212")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Uid.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("10015521", "2"); ("11369031", "9") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Uid.calc_check_digit input in
      Alcotest.(check string)
        ("test_calc_check_digit_" ^ input)
        expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("CHE-100.155.212", "CHE100155212")
    ; ("100.155.212", "CHE100155212")
    ; ("CHE100155212", "CHE100155212")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Uid.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("CHE-100.155.212", true) (* Valid *)
    ; ("100.155.212", true) (* Valid without prefix *)
    ; ("CHE-100.155.213", false) (* Invalid checksum *)
    ; ("CHE-100.155.21", false) (* Too short *)
    ; ("CHE-100.155.2123", false) (* Too long *)
    ; ("ABC-100.155.212", false) (* Invalid prefix *)
    ; ("CHE-100.15A.212", false) (* Invalid format *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Uid.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("CHE100155212", "CHE-100.155.212")
    ; ("100.155.212", "CHE-100.155.212")
    ; ("CHE-100.155.212", "CHE-100.155.212")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ch.Uid.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Ch.Uid" [ ("suite", suite) ]
