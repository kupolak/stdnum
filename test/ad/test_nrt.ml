let test_compact () =
  let test_cases =
    [
      ("A700555R", "A-700555-R")
    ; ("A700747F", "A-700747-F")
    ; ("A705321C", "A-705321-C")
    ; ("A710646J", "A-710646-J")
    ; ("D800044K", "D-800044-K")
    ; ("F000429F", "F-000429-F")
    ; ("L701412V", "L-701412-V")
    ; ("L709222X", "L-709222-X")
    ; ("L711847V", "L-711847-V")
    ; ("U801585U", "U-801585-U")
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ad.Nrt.format input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let test_is_valid () =
  let test_cases =
    [
      ("A700071W", true)
    ; ("A700527F", true)
    ; ("A700555R", true)
    ; ("A700747F", true)
    ; ("A701315C", true)
    ; ("A701485T", true)
    ; ("A702792H", true)
    ; ("A703168T", true)
    ; ("A704683Z", true)
    ; ("A704834X", true)
    ; ("A705321C", true)
    ; ("A706010J", true)
    ; ("A707871V", true)
    ; ("A710646J", true)
    ; ("D059888N", true)
    ; ("D800044K", true)
    ; ("D800383X", true)
    ; ("F000429F", true)
    ; ("F037945M", true)
    ; ("F044646J", true)
    ; ("F175669X", true)
    ; ("F221117V", true)
    ; ("F245998L", true)
    ; ("L701412V", true)
    ; ("L702597Z", true)
    ; ("L706185U", true)
    ; ("L707969P", true)
    ; ("L709222X", true)
    ; ("L709418H", true)
    ; ("L709811C", true)
    ; ("L709869T", true)
    ; ("L710605S", true)
    ; ("L711019X", true)
    ; ("L711063H", true)
    ; ("L711847V", true)
    ; ("L712255G", true)
    ; ("L712456J", true)
    ; ("L713298F", true)
    ; ("O801585O", true)
    ; ("U132950X", true)
    ; ("U186013P", true)
    ; ("U800301M", true)
    ; ("U800428R", true)
    ; ("U800584Z", true)
    ; ("U801585U", true)
    ; ("U801663B", true)
    ; ("U801667X", true)
    ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Ad.Nrt.is_valid input in
      Alcotest.(check bool) ("test_is_valid_" ^ input) expected_result result)
    test_cases

let suite =
  [
    ("test_is_valid", `Quick, test_is_valid)
  ; ("test_compact", `Quick, test_compact)
  ]

let () = Alcotest.run "Al.Nipt" [ ("suite", suite) ]
