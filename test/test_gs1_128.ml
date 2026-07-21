let test_compact () =
  let test_cases =
    [ ("(01)38425876095074(17)181119(37)1 ", "013842587609507417181119371") ]
  in
  List.iter
    (fun (input, expected_result) ->
      let result = Stdnum.Gs1_128.compact input in
      Alcotest.(check string) ("test_compact_" ^ input) expected_result result)
    test_cases

let suite = [ ("test_compact", `Quick, test_compact) ]
let () = Alcotest.run "Stdnum.Gs1_128" [ ("suite", suite) ]
