let test_compact () =
  let test_cases =
    [
      (" 181/815/0815 5", "18181508155")
    ; ("181/815/08155", "18181508155")
    ; ("201/123/12340", "20112312340")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Stnr.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      (" 181/815/0815 5", "18181508155")
    ; ("201/123/12340", "20112312340")
    ; ("4151081508156", "4151081508156")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Stnr.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_with_region () =
  (* Valid for Sachsen *)
  let result1 = De.Stnr.validate ~region:De.Stnr.Sachsen "201/123/12340" in
  Alcotest.(check string) "test_validate_sachsen" "20112312340" result1;

  (* Valid for Thüringen *)
  let result2 = De.Stnr.validate ~region:De.Stnr.Thueringen "4151081508156" in
  Alcotest.(check string) "test_validate_thueringen" "4151081508156" result2;

  (* Invalid for Thüringen (wrong format) *)
  let invalid =
    try
      ignore (De.Stnr.validate ~region:De.Stnr.Thueringen "4151181508156");
      false
    with De.Stnr.Invalid_format -> true
  in
  Alcotest.(check bool) "test_validate_thueringen_invalid" true invalid

let test_is_valid () =
  let test_cases =
    [
      (" 181/815/0815 5", true) (* Valid *)
    ; ("201/123/12340", true) (* Valid *)
    ; ("4151081508156", true) (* Valid 13-digit *)
    ; ("4151181508156", false) (* Invalid format *)
    ; ("136695978", false) (* Too short *)
    ; ("12345678901234", false) (* Too long *)
    ; ("181815A8155", false) (* Invalid character *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Stnr.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format () =
  let test_cases = [ ("18181508155", "181/815/08155") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = De.Stnr.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_with_region", `Quick, test_validate_with_region)
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "De.Stnr" [ ("suite", suite) ]
