let test_compact () =
  let test_cases =
    [
      ("91110000600037341L", "91110000600037341L")
    ; ("91 110000 600037341L", "91110000600037341L")
    ; ("91-110000-600037341L", "91110000600037341L")
    ; ("91 110000 600037 341L", "91110000600037341L")
    ; ("  91110000600037341L  ", "91110000600037341L")
    ; ("91-1-1-0-0-0-0-6-0-0-0-3-7-3-4-1-L", "91110000600037341L")
    ; ("91110000600037341l", "91110000600037341L")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Uscc.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_validate_no_leading_space () =
  (* Test that leading/trailing spaces are handled *)
  let result = Cn.Uscc.validate "  91110000600037341L  " in
  Alcotest.(check string) "validate_with_spaces" "91110000600037341L" result

let test_validate_lowercase_conversion () =
  (* Test that lowercase letters are converted to uppercase *)
  let result = Cn.Uscc.validate "91110000600037341l" in
  Alcotest.(check string) "lowercase_letter" "91110000600037341L" result

let test_validate_mixed_separators () =
  (* Test various separator patterns *)
  let result = Cn.Uscc.validate "9-1 1-1 0000 600037341L" in
  Alcotest.(check string) "mixed_separators" "91110000600037341L" result

let test_validate_valid () =
  let test_cases =
    [
      ("91110000600037341L", "91110000600037341L")
    ; ("91 110000 600037341L", "91110000600037341L")
    ; ("121200004013590816", "121200004013590816")
    ; ("911522010783762860", "911522010783762860")
    ; ("91152201078377449P", "91152201078377449P")
    ; ("9115220107837941X1", "9115220107837941X1")
    ; ("91152201078382010M", "91152201078382010M")
    ; ("911522010783917502", "911522010783917502")
    ; ("91152201078394644D", "91152201078394644D")
    ; ("91152201078395188Q", "91152201078395188Q")
    ; ("91310112087994932F", "91310112087994932F")
    ; ("91310115MA1K3BTP2B", "91310115MA1K3BTP2B")
    ; ("91310116052958608G", "91310116052958608G")
    ; ("91310116076409427L", "91310116076409427L")
    ; ("913101203509708598", "913101203509708598")
    ; ("913205056082348768", "913205056082348768")
    ; ("91340600MA2PBM9HXD", "91340600MA2PBM9HXD")
    ; ("91340600MA2PBMA74B", "91340600MA2PBMA74B")
    ; ("91340600MA2PBN188W", "91340600MA2PBN188W")
    ; ("91371082775260043P", "91371082775260043P")
    ; ("914112810713741814", "914112810713741814")
    ; ("9144030071526726XG", "9144030071526726XG")
    ; ("91620100719023721L", "91620100719023721L")
    ; ("91620105224521729E", "91620105224521729E")
    ; ("91620105556273987U", "91620105556273987U")
    ; ("91620105556284969Y", "91620105556284969Y")
    ; ("91620105556287545F", "91620105556287545F")
    ; ("91620105571630591E", "91620105571630591E")
    ; ("91620105585923360D", "91620105585923360D")
    ; ("91620105665404165K", "91620105665404165K")
    ; ("9162010567592034XQ", "9162010567592034XQ")
    ; ("91620105750906995R", "91620105750906995R")
    ; ("91620105750935948X", "91620105750935948X")
    ; ("91620105756580826D", "91620105756580826D")
    ; ("91620105767728304H", "91620105767728304H")
    ; ("91620105784023285J", "91620105784023285J")
    ; ("91620105789620900B", "91620105789620900B")
    ; ("91620105794891756D", "91620105794891756D")
    ; ("91620105L015101280", "91620105L015101280")
    ; ("92340602MA2PBQAH7E", "92340602MA2PBQAH7E")
    ; ("92340602MA2PEL3T3X", "92340602MA2PEL3T3X")
    ; ("92340602MA2PEL605A", "92340602MA2PEL605A")
    ; ("92340602MA2UK2TH6F", "92340602MA2UK2TH6F")
    ; ("92340602MA2UK33127", "92340602MA2UK33127")
    ; ("92340603MA2PBMCG0U", "92340603MA2PBMCG0U")
    ; ("92340603MA2PBMD304", "92340603MA2PBMD304")
    ; ("92340603MA2PBMQL04", "92340603MA2PBMQL04")
    ; ("92340603MA2PBMUF7M", "92340603MA2PBMUF7M")
    ; ("92340603MA2PBN17X5", "92340603MA2PBN17X5")
    ; ("92340603MA2PBN2W0N", "92340603MA2PBN2W0N")
    ; ("92340603MA2PBNK461", "92340603MA2PBNK461")
    ; ("92340603MA2PBNLR0R", "92340603MA2PBNLR0R")
    ; ("92340603MA2PBQ7J4K", "92340603MA2PBQ7J4K")
    ; ("92340603MA2PBQ7X9E", "92340603MA2PBQ7X9E")
    ; ("92340603MA2PBQFT7J", "92340603MA2PBQFT7J")
    ; ("92340603MA2PBQGB6M", "92340603MA2PBQGB6M")
    ; ("92340603MA2PBQHD9N", "92340603MA2PBQHD9N")
    ; ("92340603MA2PBQUC3U", "92340603MA2PBQUC3U")
    ; ("92340603MA2PBQX04X", "92340603MA2PBQX04X")
    ; ("92340603MA2PBQY862", "92340603MA2PBQY862")
    ; ("92340603MA2PEL613K", "92340603MA2PEL613K")
    ; ("92340603MA2PELE65C", "92340603MA2PELE65C")
    ; ("92340603MA2PELFF5B", "92340603MA2PELFF5B")
    ; ("92340603MA2PELHL72", "92340603MA2PELHL72")
    ; ("92340603MA2PEM480D", "92340603MA2PEM480D")
    ; ("92340603MA2PEN9F2E", "92340603MA2PEN9F2E")
    ; ("92340603MA2PENAP06", "92340603MA2PENAP06")
    ; ("92340603MA2PENCQ1M", "92340603MA2PENCQ1M")
    ; ("92340603MA2PEP42XF", "92340603MA2PEP42XF")
    ; ("92340603MA2PEPBN6L", "92340603MA2PEPBN6L")
    ; ("92340603MA2PEPM83M", "92340603MA2PEPM83M")
    ; ("92340603MA2UJXYJ3P", "92340603MA2UJXYJ3P")
    ; ("92340603MA2UJY0W68", "92340603MA2UJY0W68")
    ; ("92340603MA2UJY2M7F", "92340603MA2UJY2M7F")
    ; ("92340603MA2UJYUM57", "92340603MA2UJYUM57")
    ; ("92340603MA2UK0KQ72", "92340603MA2UK0KQ72")
    ; ("92340603MA2UK0ME1G", "92340603MA2UK0ME1G")
    ; ("92340603MA2UK0T79E", "92340603MA2UK0T79E")
    ; ("92340603MA2UK1NC4L", "92340603MA2UK1NC4L")
    ; ("92340603MA2UK1PX9B", "92340603MA2UK1PX9B")
    ; ("92340603MA2UK1TD00", "92340603MA2UK1TD00")
    ; ("92340603MA2UK1UE56", "92340603MA2UK1UE56")
    ; ("92340603MA2UK28G4G", "92340603MA2UK28G4G")
    ; ("92340603MA2UK2P79U", "92340603MA2UK2P79U")
    ; ("92340603MA2UK2WX6M", "92340603MA2UK2WX6M")
    ; ("92340603MA2UK2XD94", "92340603MA2UK2XD94")
    ; ("92340603MA2UK31A3N", "92340603MA2UK31A3N")
    ; ("92340603MA2UK3CP6U", "92340603MA2UK3CP6U")
    ; ("92340603MA2UK3D673", "92340603MA2UK3D673")
    ; ("92340603MA2UK3DF0N", "92340603MA2UK3DF0N")
    ; ("92340603MA2UK3DT5H", "92340603MA2UK3DT5H")
    ; ("92340604MA2PBME53K", "92340604MA2PBME53K")
    ; ("92340604MA2PBMQK2P", "92340604MA2PBMQK2P")
    ; ("92340604MA2PBMXF6C", "92340604MA2PBMXF6C")
    ; ("92340604MA2PBNDT64", "92340604MA2PBNDT64")
    ; ("92340604MA2PBNKR4Y", "92340604MA2PBNKR4Y")
    ; ("92340604MA2PBNQNXM", "92340604MA2PBNQNXM")
    ; ("92340604MA2PBNR83C", "92340604MA2PBNR83C")
    ; ("92340604MA2PBNUL9N", "92340604MA2PBNUL9N")
    ; ("92340604MA2PBNWH99", "92340604MA2PBNWH99")
    ; ("92340604MA2PBNXH5J", "92340604MA2PBNXH5J")
    ; ("92340604MA2PBP1U3Y", "92340604MA2PBP1U3Y")
    ; ("92340604MA2PBP7U1T", "92340604MA2PBP7U1T")
    ; ("92340604MA2PBPHC8R", "92340604MA2PBPHC8R")
    ; ("92340604MA2PBPXJ71", "92340604MA2PBPXJ71")
    ; ("92340604MA2PEM4L7X", "92340604MA2PEM4L7X")
    ; ("92340604MA2PEM5Q4E", "92340604MA2PEM5Q4E")
    ; ("92340604MA2PENA300", "92340604MA2PENA300")
    ; ("92340604MA2UJYCE59", "92340604MA2UJYCE59")
    ; ("92340604MA2UJYPN1K", "92340604MA2UJYPN1K")
    ; ("92340604MA2UK03G7D", "92340604MA2UK03G7D")
    ; ("92340604MA2UK04L4X", "92340604MA2UK04L4X")
    ; ("92340604MA2UK07529", "92340604MA2UK07529")
    ; ("92340604MA2UK08Y65", "92340604MA2UK08Y65")
    ; ("92340621MA2PBKRXXG", "92340621MA2PBKRXXG")
    ; ("92340621MA2PBL318W", "92340621MA2PBL318W")
    ; ("92340621MA2PBLW63G", "92340621MA2PBLW63G")
    ; ("92340621MA2PBLWT1Y", "92340621MA2PBLWT1Y")
    ; ("92340621MA2PBLX27E", "92340621MA2PBLX27E")
    ; ("92340621MA2PBM6286", "92340621MA2PBM6286")
    ; ("92340621MA2PBMA318", "92340621MA2PBMA318")
    ; ("92340621MA2PBMKK45", "92340621MA2PBMKK45")
    ; ("92340621MA2PBMNMXM", "92340621MA2PBMNMXM")
    ; ("92340621MA2PBMUH3D", "92340621MA2PBMUH3D")
    ; ("92340621MA2PBN0KXX", "92340621MA2PBN0KXX")
    ; ("92340621MA2PBN145R", "92340621MA2PBN145R")
    ; ("92340621MA2PBN1962", "92340621MA2PBN1962")
    ; ("92340621MA2PBN1H1T", "92340621MA2PBN1H1T")
    ; ("92340621MA2PBN559X", "92340621MA2PBN559X")
    ; ("92340621MA2PBNFH07", "92340621MA2PBNFH07")
    ; ("92340621MA2PBNJ232", "92340621MA2PBNJ232")
    ; ("92340621MA2PBNTY9Y", "92340621MA2PBNTY9Y")
    ; ("92340621MA2PBP431L", "92340621MA2PBP431L")
    ; ("92340621MA2PELD34J", "92340621MA2PELD34J")
    ; ("92340621MA2PELFR3H", "92340621MA2PELFR3H")
    ; ("92340621MA2UJRKE7N", "92340621MA2UJRKE7N")
    ; ("92340621MA2UJRL762", "92340621MA2UJRL762")
    ; ("92340621MA2UJT9WXP", "92340621MA2UJT9WXP")
    ; ("92340621MA2UJTCK0M", "92340621MA2UJTCK0M")
    ; ("92340621MA2UJTM785", "92340621MA2UJTM785")
    ; ("92340621MA2UJTQ22E", "92340621MA2UJTQ22E")
    ; ("92340621MA2UJTTF8R", "92340621MA2UJTTF8R")
    ; ("92340621MA2UJTY74U", "92340621MA2UJTY74U")
    ; ("92340621MA2UJW4UXQ", "92340621MA2UJW4UXQ")
    ; ("92340621MA2UJW690P", "92340621MA2UJW690P")
    ; ("92340621MA2UJW703D", "92340621MA2UJW703D")
    ; ("92340621MA2UJWA961", "92340621MA2UJWA961")
    ; ("92340621MA2UJWCT2H", "92340621MA2UJWCT2H")
    ; ("92340621MA2UJWEE2G", "92340621MA2UJWEE2G")
    ; ("92340621MA2UJWFB49", "92340621MA2UJWFB49")
    ; ("92340621MA2UJWGB0J", "92340621MA2UJWGB0J")
    ; ("92340621MA2UJWYPX8", "92340621MA2UJWYPX8")
    ; ("92340621MA2UJX6C8T", "92340621MA2UJX6C8T")
    ; ("92340621MA2UJX968M", "92340621MA2UJX968M")
    ; ("92340621MA2UJXLD1M", "92340621MA2UJXLD1M")
    ; ("92340621MA2UJY477E", "92340621MA2UJY477E")
    ; ("92340621MA2UJYE11E", "92340621MA2UJYE11E")
    ; ("92340621MA2UJYG57G", "92340621MA2UJYG57G")
    ; ("92340621MA2UK02XXW", "92340621MA2UK02XXW")
    ; ("92340621MA2UK08G9K", "92340621MA2UK08G9K")
    ; ("92340621MA2UK0DA11", "92340621MA2UK0DA11")
    ; ("92340621MA2UK0G256", "92340621MA2UK0G256")
    ; ("92340621MA2UK0J08Q", "92340621MA2UK0J08Q")
    ; ("92340621MA2UK0JX8N", "92340621MA2UK0JX8N")
    ; ("92340621MA2UK0KR5Y", "92340621MA2UK0KR5Y")
    ; ("92340621MA2UK1JY92", "92340621MA2UK1JY92")
    ; ("92340621MA2UK1L38E", "92340621MA2UK1L38E")
    ; ("92340621MA2UK1MK35", "92340621MA2UK1MK35")
    ; ("92340621MA2UK1MN8P", "92340621MA2UK1MN8P")
    ; ("92340621MA2UK1PRX7", "92340621MA2UK1PRX7")
    ; ("92340621MA2UK22G6N", "92340621MA2UK22G6N")
    ; ("92340621MA2UK25H3F", "92340621MA2UK25H3F")
    ; ("92340621MA2UK2BU8B", "92340621MA2UK2BU8B")
    ; ("92340621MA2UK2CD59", "92340621MA2UK2CD59")
    ; ("92340621MA2UK2EP62", "92340621MA2UK2EP62")
    ; ("92340621MA2UK2GJXF", "92340621MA2UK2GJXF")
    ; ("92340621MA2UK2Q24Y", "92340621MA2UK2Q24Y")
    ; ("92340621MA2UK2XX21", "92340621MA2UK2XX21")
    ; ("92340621MA2UK30C35", "92340621MA2UK30C35")
    ; ("92340621MA2UK338XJ", "92340621MA2UK338XJ")
    ; ("92340621MA2UK3C369", "92340621MA2UK3C369")
    ; ("92340621MA2UK3CE6L", "92340621MA2UK3CE6L")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Uscc.validate input in
      Alcotest.(check string) ("test_validate_" ^ input) expected_result result)
    test_cases

let test_validate_invalid_length () =
  try
    ignore (Cn.Uscc.validate "12345");
    Alcotest.fail "Expected Invalid_length exception"
  with Cn.Uscc.Invalid_length -> ()

let test_validate_invalid_format_first_8 () =
  try
    ignore (Cn.Uscc.validate "A1110000600037341L");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_format_chars () =
  try
    ignore (Cn.Uscc.validate "9111000060003IOZSV");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_format_i () =
  try
    ignore (Cn.Uscc.validate "91110000600037341I");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_format_o () =
  try
    ignore (Cn.Uscc.validate "91110000600037341O");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_format_z () =
  try
    ignore (Cn.Uscc.validate "91110000600037341Z");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_format_s () =
  try
    ignore (Cn.Uscc.validate "91110000600037341S");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_format_v () =
  try
    ignore (Cn.Uscc.validate "91110000600037341V");
    Alcotest.fail "Expected Invalid_format exception"
  with Cn.Uscc.Invalid_format -> ()

let test_validate_invalid_checksum () =
  try
    ignore (Cn.Uscc.validate "91110000600037341N");
    Alcotest.fail "Expected Invalid_checksum exception"
  with Cn.Uscc.Invalid_checksum -> ()

let test_is_valid () =
  let test_cases =
    [
      ("91110000600037341L", true)
    ; ("91 110000 600037341L", true)
    ; ("121200004013590816", true)
    ; ("911522010783762860", true)
    ; ("91152201078377449P", true)
    ; ("91371082775260043P", true)
    ; ("914112810713741814", true)
    ; ("9144030071526726XG", true)
    ; ("91620100719023721L", true)
    ; ("12345", false)
    ; ("A1110000600037341L", false)
    ; ("9111000060003IOZSV", false)
    ; ("91110000600037341N", false)
    ; ("91110000600037341I", false)
    ; ("91110000600037341O", false)
    ; ("91110000600037341Z", false)
    ; ("91110000600037341S", false)
    ; ("91110000600037341V", false)
    ; ("", false)
    ; ("911100006000373", false)
    ; ("911100006000373411", false)
    ; ("9111000060003734LL", false)
    ; ("91 1 1 0 0 0 0 6 0 0 0 3 7 3 4 1 L", true)
    ; ("9-1-1-1-0-0-0-0-6-0-0-0-3-7-3-4-1-L", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Uscc.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let test_format_valid () =
  let test_cases =
    [
      ("91110000600037341L", "91110000600037341L")
    ; ("91 110000 600037341L", "91110000600037341L")
    ; ("91-110000-600037341L", "91110000600037341L")
    ; ("91-1-1-0-0-0-0-6-0-0-0-3-7-3-4-1-L", "91110000600037341L")
    ; ("  91110000600037341L  ", "91110000600037341L")
    ; ("121200004013590816", "121200004013590816")
    ; ("911522010783762860", "911522010783762860")
    ; ("91152201078377449P", "91152201078377449P")
    ; ("9115220107837941X1", "9115220107837941X1")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Uscc.format input in
      Alcotest.(check string) ("test_format_" ^ input) expected_result result)
    test_cases

let test_is_valid_all_alphabet_chars () =
  (* Test that all valid alphabet characters are recognized *)
  let test_cases =
    [
      ("91310115MA1K3BTP2B", true) (* Contains A, M, K, T, P, B *)
    ; ("91340600MA2PBM9HXD", true) (* Contains M, P, B, H, X, D *)
    ; ("92340603MA2PBQUC3U", true) (* Contains M, P, B, Q, U, C *)
    ; ("9162010567592034XQ", true) (* Contains X, Q *)
    ; ("91620105750906995R", true) (* Contains R *)
    ; ("91620105750935948X", true) (* Contains X *)
    ; ("91620105756580826D", true) (* Contains D *)
    ; ("91620105767728304H", true) (* Contains H *)
    ; ("91620105784023285J", true) (* Contains J *)
    ; ("91620105789620900B", true) (* Contains B *)
    ; ("9144030071526726XG", true) (* Contains X, G *)
    ; ("92340602MA2UK33127", true) (* Contains M, P, B, U, K *)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Cn.Uscc.is_valid input in
      Alcotest.(check bool) ("alphabet_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("compact", `Quick, test_compact)
  ; ("validate_valid", `Quick, test_validate_valid)
  ; ("validate_no_leading_space", `Quick, test_validate_no_leading_space)
  ; ("validate_lowercase_conversion", `Quick, test_validate_lowercase_conversion)
  ; ("validate_mixed_separators", `Quick, test_validate_mixed_separators)
  ; ("validate_invalid_length", `Quick, test_validate_invalid_length)
  ; ( "validate_invalid_format_first_8"
    , `Quick
    , test_validate_invalid_format_first_8 )
  ; ("validate_invalid_format_chars", `Quick, test_validate_invalid_format_chars)
  ; ("validate_invalid_format_i", `Quick, test_validate_invalid_format_i)
  ; ("validate_invalid_format_o", `Quick, test_validate_invalid_format_o)
  ; ("validate_invalid_format_z", `Quick, test_validate_invalid_format_z)
  ; ("validate_invalid_format_s", `Quick, test_validate_invalid_format_s)
  ; ("validate_invalid_format_v", `Quick, test_validate_invalid_format_v)
  ; ("validate_invalid_checksum", `Quick, test_validate_invalid_checksum)
  ; ("is_valid", `Quick, test_is_valid)
  ; ("is_valid_all_alphabet_chars", `Quick, test_is_valid_all_alphabet_chars)
  ; ("format_valid", `Quick, test_format_valid)
  ]

let () = Alcotest.run "Cn.Uscc" [ ("suite", suite) ]
