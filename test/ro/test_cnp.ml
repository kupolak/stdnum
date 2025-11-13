let test_compact () =
  let test_cases =
    [
      ("1630615123457", "1630615123457")
    ; ("163 061 512 3457", "1630615123457")
    ; ("163-061-512-3457", "1630615123457")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ro.Cnp.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_get_birth_date () =
  let test_cases =
    [
      ("1630615123457", (1963, 6, 15)) (* Male, born June 15, 1963 *)
    ; ("2990101121231", (1999, 1, 1)) (* Female, born Jan 1, 1999 *)
    ; ("5000229121230", (2000, 2, 29)) (* Male, born Feb 29, 2000 - leap year *)
    ]
  in
  List.iter
    (fun (input, expected) ->
      let year, month, day = Ro.Cnp.get_birth_date input in
      Alcotest.(check (triple int int int))
        ("test_get_birth_date_" ^ input)
        expected (year, month, day))
    test_cases

let test_get_birth_date_invalid () =
  Alcotest.check_raises "Invalid Date" Ro.Cnp.Invalid_component (fun () ->
      ignore (Ro.Cnp.get_birth_date "1632215123457"))

(* Invalid: Feb 22 doesn't exist... actually it does, let's use Feb 30 *)
let test_get_birth_date_invalid_feb30 () =
  Alcotest.check_raises "Invalid Date Feb 30" Ro.Cnp.Invalid_component
    (fun () -> ignore (Ro.Cnp.get_birth_date "1630230123457"))

let test_get_county () =
  let test_cases =
    [ ("1630615123457", "Cluj"); ("1630615401233", "Bucuresti") ]
  in
  List.iter
    (fun (input, expected) ->
      let county = Ro.Cnp.get_county input in
      Alcotest.(check string) ("test_get_county_" ^ input) expected county)
    test_cases

let test_get_county_invalid () =
  Alcotest.check_raises "Invalid County" Ro.Cnp.Invalid_component (fun () ->
      ignore (Ro.Cnp.get_county "1630615993454"))

let test_validate_valid () =
  let test_cases =
    [
      "1630615123457"
    ; "163 061 512 3457"
    ; "2990101121231" (* Female, 1999 *)
    ; "5000229121230" (* Male, 2000, leap year *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cnp.validate input in
      Alcotest.(check string)
        ("test_validate_valid_" ^ input)
        (Ro.Cnp.compact input) result)
    test_cases

let test_validate_invalid_first_digit () =
  Alcotest.check_raises "Invalid First Digit" Ro.Cnp.Invalid_component
    (fun () -> ignore (Ro.Cnp.validate "0800101221142"))

let test_validate_invalid_date () =
  Alcotest.check_raises "Invalid Date" Ro.Cnp.Invalid_component (fun () ->
      ignore (Ro.Cnp.validate "1632215123457"))

let test_validate_invalid_county () =
  Alcotest.check_raises "Invalid County" Ro.Cnp.Invalid_component (fun () ->
      ignore (Ro.Cnp.validate "1630615993454"))

let test_validate_invalid_checksum () =
  Alcotest.check_raises "Invalid Checksum" Ro.Cnp.Invalid_checksum (fun () ->
      ignore (Ro.Cnp.validate "1630615123458"))

let test_validate_invalid_length () =
  Alcotest.check_raises "Invalid Length" Ro.Cnp.Invalid_length (fun () ->
      ignore (Ro.Cnp.validate "163061512345"))

let test_validate_invalid_format () =
  Alcotest.check_raises "Invalid Format" Ro.Cnp.Invalid_format (fun () ->
      ignore (Ro.Cnp.validate "163061512345A"))

let test_is_valid_true () =
  let test_cases = [ "1630615123457"; "163 061 512 3457"; "2990101121231" ] in
  List.iter
    (fun input ->
      let result = Ro.Cnp.is_valid input in
      Alcotest.(check bool) ("test_is_valid_true_" ^ input) true result)
    test_cases

let test_is_valid_false () =
  let test_cases =
    [
      "0800101221142" (* invalid first digit *)
    ; "1632215123457" (* invalid date *)
    ; "1630615993454" (* invalid county *)
    ; "1630615123458" (* invalid checksum *)
    ]
  in
  List.iter
    (fun input ->
      let result = Ro.Cnp.is_valid input in
      Alcotest.(check bool) ("test_is_valid_false_" ^ input) false result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_date_invalid", `Quick, test_get_birth_date_invalid)
  ; ( "test_get_birth_date_invalid_feb30"
    , `Quick
    , test_get_birth_date_invalid_feb30 )
  ; ("test_get_county", `Quick, test_get_county)
  ; ("test_get_county_invalid", `Quick, test_get_county_invalid)
  ; ("test_validate_valid", `Quick, test_validate_valid)
  ; ( "test_validate_invalid_first_digit"
    , `Quick
    , test_validate_invalid_first_digit )
  ; ("test_validate_invalid_date", `Quick, test_validate_invalid_date)
  ; ("test_validate_invalid_county", `Quick, test_validate_invalid_county)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_is_valid_true", `Quick, test_is_valid_true)
  ; ("test_is_valid_false", `Quick, test_is_valid_false)
  ]

let () = Alcotest.run "Ro.Cnp" [ ("suite", suite) ]
