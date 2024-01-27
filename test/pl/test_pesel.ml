let test_compact () =
  let test_cases =
    [ ("PL123-456-789", "123456789"); ("PL987654321", "987654321") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Pesel.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_get_birth_date () =
  let test_cases =
    [
      ( "88070534567"
      , Some
          (Int64.of_float
             (fst
                (Unix.mktime
                   {
                     Unix.tm_year = 1988 - 1900
                   ; tm_mon = 6
                   ; tm_mday = 5
                   ; tm_hour = 0
                   ; tm_min = 0
                   ; tm_sec = 0
                   ; tm_wday = 0
                   ; tm_yday = 0
                   ; tm_isdst = false
                   }))) )
    ; ( "66090876543"
      , Some
          (Int64.of_float
             (fst
                (Unix.mktime
                   {
                     Unix.tm_year = 1966 - 1900
                   ; tm_mon = 8
                   ; tm_mday = 8
                   ; tm_hour = 0
                   ; tm_min = 0
                   ; tm_sec = 0
                   ; tm_wday = 0
                   ; tm_yday = 0
                   ; tm_isdst = false
                   }))) )
    ; ( "71051112358"
      , Some
          (Int64.of_float
             (fst
                (Unix.mktime
                   {
                     Unix.tm_year = 1971 - 1900
                   ; tm_mon = 4
                   ; tm_mday = 11
                   ; tm_hour = 0
                   ; tm_min = 0
                   ; tm_sec = 0
                   ; tm_wday = 0
                   ; tm_yday = 0
                   ; tm_isdst = false
                   }))) )
    ; ( "55082034561"
      , Some
          (Int64.of_float
             (fst
                (Unix.mktime
                   {
                     Unix.tm_year = 1955 - 1900
                   ; tm_mon = 7
                   ; tm_mday = 20
                   ; tm_hour = 0
                   ; tm_min = 0
                   ; tm_sec = 0
                   ; tm_wday = 0
                   ; tm_yday = 0
                   ; tm_isdst = false
                   }))) )
    ; ( "78120298734"
      , Some
          (Int64.of_float
             (fst
                (Unix.mktime
                   {
                     Unix.tm_year = 1978 - 1900
                   ; tm_mon = 11
                   ; tm_mday = 2
                   ; tm_hour = 0
                   ; tm_min = 0
                   ; tm_sec = 0
                   ; tm_wday = 0
                   ; tm_yday = 0
                   ; tm_isdst = false
                   }))) )
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Pesel.get_birth_date input in
      let result = Option.map (fun (secs, _) -> Int64.of_float secs) result in
      Alcotest.(check (option int64))
        ("test_get_birth_date_" ^ input)
        expected_result result)
    test_cases

let test_get_gender () =
  let test_cases =
    [
      ("52071412345", 'M')
    ; ("46050167890", 'F')
    ; ("55082034561", 'M')
    ; ("62123198765", 'M')
    ; ("71051112358", 'F')
    ; ("88070534567", 'M')
    ; ("90010112349", 'M')
    ; ("78120298734", 'F')
    ; ("66090876543", 'M')
    ; ("73050512378", 'F')
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Pesel.get_gender input in
      Alcotest.(check char) ("test_get_gender_" ^ input) expected_result result)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("PL06230322345", "06230322345")
    ; ("PL25040866779", "25040866779")
    ; ("PL65110476367", "65110476367")
    ; ("PL25040866779", "25040866779")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Pesel.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("56020974595", true)
    ; ("46050167890", true)
    ; ("123456789", false) (* Invalid length *)
    ; ("PL12345678901", false) (* Invalid length *)
    ; ("PL123456789A", false) (* Invalid format *)
    ; ("PL1234567891", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Pl.Pesel.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_gender", `Quick, test_get_gender)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_is_valid", `Quick, test_is_valid)
  ]

let () = Alcotest.run "test_pesel" [ ("suite", suite) ]
