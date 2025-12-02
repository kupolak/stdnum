let test_compact () =
  let test_cases =
    [
      ("213.123.432-1", "2131234321")
    ; ("213 123 432 - 1", "2131234321")
    ; ("2131234321", "2131234321")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Co.Nit.compact input in
      Alcotest.(check string) ("compact_" ^ input) expected result)
    test_cases

let test_calc_check_digit () =
  let test_cases =
    [
      ("213123432", "1")
    ; ("213123435", "1")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Co.Nit.calc_check_digit input in
      Alcotest.(check string) ("check_digit_" ^ input) expected result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("213.123.432-1", "2131234321")
    ; ("2131234351", "2131234351")
    ; ("800003122-6", "8000031226")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Co.Nit.validate input in
      Alcotest.(check string) ("validate_" ^ input) expected result)
    test_cases

let test_validate_errors () =
  let invalid_cases =
    [
      ("2131234", Co.Nit.Invalid_length)
    ; ("213123435A", Co.Nit.Invalid_format)
    ; ("2131234350", Co.Nit.Invalid_checksum)
    ]
  in
  List.iter
    (fun (input, expected_exception) ->
      Alcotest.check_raises ("validate_error_" ^ input) expected_exception
        (fun () -> ignore (Co.Nit.validate input)))
    invalid_cases

let test_is_valid () =
  let valid_numbers =
    [
      "213.123.432-1"
    ; "2131234351"
    ; "15.252.525-0"
    ; "800003122-6"
    ; "890000062-6"
    ; "900206480-2"
    ]
  in
  List.iter
    (fun input ->
      let result = Co.Nit.is_valid input in
      Alcotest.(check bool) ("is_valid_" ^ input) true result)
    valid_numbers

let test_format () =
  let test_cases =
    [
      ("2131234321", "213.123.432-1")
    ; ("12345678909", "12.345.678-909")
    ]
  in
  List.iter
    (fun (input, expected) ->
      let result = Co.Nit.format input in
      Alcotest.(check string) ("format_" ^ input) expected result)
    test_cases

let suite =
  [
    ("compact", `Quick, test_compact)
  ; ("calc_check_digit", `Quick, test_calc_check_digit)
  ; ("validate", `Quick, test_validate)
  ; ("validate_errors", `Quick, test_validate_errors)
  ; ("is_valid", `Quick, test_is_valid)
  ; ("format", `Quick, test_format)
  ]

let () = Alcotest.run "Co.Nit" [ ("suite", suite) ]
