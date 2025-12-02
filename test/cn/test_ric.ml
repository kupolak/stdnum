let test_compact () =
  let test_cases =
    [
      ("360426199101010071", "360426199101010071")
    ; ("44011320141005001x", "44011320141005001X")
    ; ("44011320141005001X", "44011320141005001X")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Ric.compact input in
      Alcotest.(check string) "test_compact" expected_result result)
    test_cases

let test_calc_check_digit () =
  let test_cases = [ ("36042619910101007", "1"); ("44011320141005001", "X") ] in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Ric.calc_check_digit input in
      Alcotest.(check string) "test_calc_check_digit" expected_result result)
    test_cases

let test_get_birth_date () =
  let test_cases =
    [
      ("360426199101010071", (1991, 1, 1))
    ; ("44011320141005001X", (2014, 10, 5))
    ; ("412723199010050012", (1990, 10, 5))
    ; ("110102199101010078", (1991, 1, 1))
    ; ("120110198012010073", (1980, 12, 1))
    ; ("120110199212010072", (1992, 12, 1))
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Ric.get_birth_date input in
      Alcotest.(check (Alcotest.triple Alcotest.int Alcotest.int Alcotest.int))
        "test_get_birth_date" expected_result result)
    test_cases

let test_get_birth_place () =
  let test_cases =
    [
      ("360426199101010071", ("江西省", "德安县"))
    ; ("44011320141005001X", ("广东省", "番禺区"))
    ; ("412723199010050012", ("河南省", "商水县"))
    ; ("110102199101010078", ("北京市", "西城区"))
    ; ("120110198012010073", ("天津市", "东郊区")) (* before 1991 *)
    ; ("120110199212010072", ("天津市", "东丽区")) (* after 1991 *)
    ]
  in
  List.iter
    (fun (input, (expected_province, expected_county)) ->
      let result = Cn.Ric.get_birth_place input in
      Alcotest.(check string)
        "test_get_birth_place_province" expected_province result.province;
      Alcotest.(check string)
        "test_get_birth_place_county" expected_county result.county)
    test_cases

let test_validate () =
  let test_cases =
    [
      ("360426199101010071", "360426199101010071")
    ; ("44011320141005001x", "44011320141005001X")
    ; ("44011320141005001X", "44011320141005001X")
    ; ("412723199010050012", "412723199010050012")
    ; ("110102199101010078", "110102199101010078")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Ric.validate input in
      Alcotest.(check string) "test_validate" expected_result result)
    test_cases

let test_validate_invalid_format () =
  try
    ignore (Cn.Ric.validate "T60426199101010078");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Ric.Invalid_format -> ()

let test_validate_invalid_length () =
  try
    ignore (Cn.Ric.validate "3604261991010100");
    Alcotest.fail "Expected Invalid_length exception"
  with Cn.Ric.Invalid_length -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Cn.Ric.validate "36042619910102009X");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Cn.Ric.Invalid_checksum -> ()

let test_validate_invalid_date () =
  try
    ignore (Cn.Ric.validate "360426199113010079");
    Alcotest.fail "Expected Invalid_component exception"
  with Cn.Ric.Invalid_component -> ()

let test_validate_invalid_location () =
  try
    ignore (Cn.Ric.validate "990426199112010079");
    Alcotest.fail "Expected Invalid_component exception"
  with Cn.Ric.Invalid_component -> ()

let test_validate_county_not_registered_yet () =
  (* County was not registered yet at birth year *)
  try
    ignore (Cn.Ric.validate "110111198012010078");
    Alcotest.fail "Expected Invalid_component exception"
  with Cn.Ric.Invalid_component -> ()

let test_validate_county_deregistered () =
  (* County was deregistered at birth year *)
  try
    ignore (Cn.Ric.validate "110201199312010077");
    Alcotest.fail "Expected Invalid_component exception"
  with Cn.Ric.Invalid_component -> ()

let test_is_valid () =
  let test_cases =
    [
      ("360426199101010071", true)
    ; ("44011320141005001x", true)
    ; ("44011320141005001X", true)
    ; ("412723199010050012", true)
    ; ("110102199101010078", true)
    ; ("120110198012010073", true) (* Temporal: before 1991 *)
    ; ("120110199212010072", true) (* Temporal: after 1991 *)
    ; (* Invalid format *)
      ("T60426199101010078", false)
    ; (* Invalid length *)
      ("3604261991010100", false)
    ; (* Invalid checksum *)
      ("36042619910102009X", false)
    ; (* Invalid date *)
      ("360426199113010079", false)
    ; (* Invalid location *)
      ("990426199112010074", false)
    ; (* County not registered yet *)
      ("110111198012010078", false)
    ; (* County deregistered *)
      ("110201199312010077", false)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Ric.is_valid input in
      Alcotest.(check bool) "test_is_valid" expected_result result)
    test_cases

let test_format () =
  let test_cases =
    [
      ("360426199101010071", "360426199101010071")
    ; ("44011320141005001x", "44011320141005001X")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Ric.format input in
      Alcotest.(check string) "test_format" expected_result result)
    test_cases

let suite =
  [
    ("test_compact", `Quick, test_compact)
  ; ("test_calc_check_digit", `Quick, test_calc_check_digit)
  ; ("test_get_birth_date", `Quick, test_get_birth_date)
  ; ("test_get_birth_place", `Quick, test_get_birth_place)
  ; ("test_validate", `Quick, test_validate)
  ; ("test_validate_invalid_format", `Quick, test_validate_invalid_format)
  ; ("test_validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ("test_validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("test_validate_invalid_date", `Quick, test_validate_invalid_date)
  ; ("test_validate_invalid_location", `Quick, test_validate_invalid_location)
  ; ( "test_validate_county_not_registered_yet"
    , `Quick
    , test_validate_county_not_registered_yet )
  ; ( "test_validate_county_deregistered"
    , `Quick
    , test_validate_county_deregistered )
  ; ("test_is_valid", `Quick, test_is_valid)
  ; ("test_format", `Quick, test_format)
  ]

let () = Alcotest.run "Cn.Ric" [ ("suite", suite) ]
