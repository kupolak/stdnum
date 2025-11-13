let test_compact () =
  let test_cases =
    [
      ("880320-0016", "880320-0016")
    ; ("8803200016", "880320-0016")
    ; ("19880320-0016", "19880320-0016")
    ; ("198803200016", "19880320-0016")
    ; ("880320 0016", "880320-0016")
    ; ("19880320:0016", "19880320-0016")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Se.Personnummer.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_valid () =
  let test_cases =
    [ "880320-0016"; "19880320-0016"; "811228-9841"; "890102-3286" ]
  in
  List.iter
    (fun input ->
      let result = Se.Personnummer.validate input in
      Alcotest.(check string) ("test_validate_valid_" ^ input) input result)
    test_cases

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Se.Personnummer.Invalid_checksum
    (fun () -> ignore (Se.Personnummer.validate "880320-0018"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Se.Personnummer.Invalid_length
    (fun () -> ignore (Se.Personnummer.validate "12345"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Se.Personnummer.Invalid_format
    (fun () -> ignore (Se.Personnummer.validate "88032000AB"))

let test_is_valid_true () =
  let test_cases = [ "880320-0016"; "811228-9841"; "890102-3286" ] in
  List.iter
    (fun input ->
      let result = Se.Personnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_true_" ^ input) true result)
    test_cases

let test_is_valid_false () =
  let test_cases = [ "880320-0018"; "12345"; "88032000AB" ] in
  List.iter
    (fun input ->
      let result = Se.Personnummer.is_valid input in
      Alcotest.(check bool) ("test_is_valid_false_" ^ input) false result)
    test_cases

let test_get_gender () =
  let test_cases =
    [ ("890102-3286", 'F'); ("811228-9841", 'F'); ("880320-0016", 'M') ]
  in
  List.iter
    (fun (input, expected_gender) ->
      let result = Se.Personnummer.get_gender input in
      Alcotest.(check char) ("test_get_gender_" ^ input) expected_gender result)
    test_cases

let test_get_birth_date () =
  (* Test that birth date extraction doesn't raise an exception *)
  let input = "880320-0016" in
  let result = Se.Personnummer.get_birth_date input in
  match result with
  | Some (_, tm) ->
      (* Verify the date components *)
      Alcotest.(check int) "year" 1988 (tm.Unix.tm_year + 1900);
      Alcotest.(check int) "month" 2 tm.Unix.tm_mon;
      (* March is month 2 (0-indexed) *)
      Alcotest.(check int) "day" 20 tm.Unix.tm_mday
  | None -> Alcotest.fail "Expected Some birth date, got None"

let test_format () =
  let test_cases =
    [
      ("8803200016", "880320-0016")
    ; ("880320-0016", "880320-0016")
    ; ("198803200016", "19880320-0016")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Se.Personnummer.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Se.Personnummer" [ ("suite", suite) ]
