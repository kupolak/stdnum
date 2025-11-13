(** Handelsregisternummer (German company register number).

    The number consists of the court where the company has registered, the type
    of register and the registration number.

    The type of the register is either HRA or HRB where the letter "B" stands for
    HR section B, where limited liability companies and corporations are entered
    (GmbH's and AG's). There is also a section HRA for business partnerships
    (OHG's, KG's etc.). In other words: businesses in section HRB are limited
    liability companies, while businesses in HRA have personally liable partners.

    More information:
    - https://www.handelsregister.de/
    - https://en.wikipedia.org/wiki/German_Trade_Register
    - https://offeneregister.de/ *)

open Tools

exception Invalid_format
exception Invalid_component

(* Known German courts *)
let german_courts =
  [
    "Aachen"
  ; "Altenburg"
  ; "Amberg"
  ; "Ansbach"
  ; "Apolda"
  ; "Arnsberg"
  ; "Arnstadt Zweigstelle Ilmenau"
  ; "Arnstadt"
  ; "Aschaffenburg"
  ; "Augsburg"
  ; "Aurich"
  ; "Bad Hersfeld"
  ; "Bad Homburg v.d.H."
  ; "Bad Kreuznach"
  ; "Bad Oeynhausen"
  ; "Bad Salzungen"
  ; "Bamberg"
  ; "Bayreuth"
  ; "Berlin (Charlottenburg)"
  ; "Bielefeld"
  ; "Bochum"
  ; "Bonn"
  ; "Braunschweig"
  ; "Bremen"
  ; "Chemnitz"
  ; "Coburg"
  ; "Coesfeld"
  ; "Cottbus"
  ; "Darmstadt"
  ; "Deggendorf"
  ; "Dortmund"
  ; "Dresden"
  ; "Duisburg"
  ; "Düren"
  ; "Düsseldorf"
  ; "Eisenach"
  ; "Erfurt"
  ; "Eschwege"
  ; "Essen"
  ; "Flensburg"
  ; "Frankfurt am Main"
  ; "Frankfurt/Oder"
  ; "Freiburg"
  ; "Friedberg"
  ; "Fritzlar"
  ; "Fulda"
  ; "Fürth"
  ; "Gelsenkirchen"
  ; "Gera"
  ; "Gießen"
  ; "Gotha"
  ; "Greiz"
  ; "Göttingen"
  ; "Gütersloh"
  ; "Hagen"
  ; "Hamburg"
  ; "Hamm"
  ; "Hanau"
  ; "Hannover"
  ; "Heilbad Heiligenstadt"
  ; "Hildburghausen"
  ; "Hildesheim"
  ; "Hof"
  ; "Homburg"
  ; "Ingolstadt"
  ; "Iserlohn"
  ; "Jena"
  ; "Kaiserslautern"
  ; "Kassel"
  ; "Kempten (Allgäu)"
  ; "Kiel"
  ; "Kleve"
  ; "Koblenz"
  ; "Korbach"
  ; "Krefeld"
  ; "Köln"
  ; "Königstein"
  ; "Landau"
  ; "Landshut"
  ; "Langenfeld"
  ; "Lebach"
  ; "Leipzig"
  ; "Lemgo"
  ; "Limburg"
  ; "Ludwigshafen a.Rhein (Ludwigshafen)"
  ; "Lübeck"
  ; "Lüneburg"
  ; "Mainz"
  ; "Mannheim"
  ; "Marburg"
  ; "Meiningen"
  ; "Memmingen"
  ; "Merzig"
  ; "Montabaur"
  ; "Mönchengladbach"
  ; "Mühlhausen"
  ; "München"
  ; "Münster"
  ; "Neubrandenburg"
  ; "Neunkirchen"
  ; "Neuruppin"
  ; "Neuss"
  ; "Nordhausen"
  ; "Nürnberg"
  ; "Offenbach am Main"
  ; "Oldenburg (Oldenburg)"
  ; "Osnabrück"
  ; "Ottweiler"
  ; "Paderborn"
  ; "Passau"
  ; "Pinneberg"
  ; "Potsdam"
  ; "Pößneck Zweigstelle Bad Lobenstein"
  ; "Pößneck"
  ; "Recklinghausen"
  ; "Regensburg"
  ; "Rostock"
  ; "Rudolstadt Zweigstelle Saalfeld"
  ; "Rudolstadt"
  ; "Saarbrücken"
  ; "Saarlouis"
  ; "Schweinfurt"
  ; "Schwerin"
  ; "Siegburg"
  ; "Siegen"
  ; "Sondershausen"
  ; "Sonneberg"
  ; "St. Ingbert (St Ingbert)"
  ; "St. Wendel (St Wendel)"
  ; "Stadthagen"
  ; "Stadtroda"
  ; "Steinfurt"
  ; "Stendal"
  ; "Stralsund"
  ; "Straubing"
  ; "Stuttgart"
  ; "Suhl"
  ; "Sömmerda"
  ; "Tostedt"
  ; "Traunstein"
  ; "Ulm"
  ; "Völklingen"
  ; "Walsrode"
  ; "Weiden i. d. OPf."
  ; "Weimar"
  ; "Wetzlar"
  ; "Wiesbaden"
  ; "Wittlich"
  ; "Wuppertal"
  ; "Würzburg"
  ; "Zweibrücken"
  ]

(* Normalize court name for comparison *)
let to_min court =
  let normalized = ref "" in
  String.iter
    (fun c ->
      let c_lower = Char.lowercase_ascii c in
      if c_lower >= 'a' && c_lower <= 'z' then
        normalized := !normalized ^ String.make 1 c_lower)
    court;
  !normalized

(* Build court lookup table *)
let courts_table =
  let table = Hashtbl.create 200 in
  (* Add all courts *)
  List.iter (fun court -> Hashtbl.add table (to_min court) court) german_courts;
  (* Add aliases *)
  let aliases =
    [
      ("Allgäu", "Kempten (Allgäu)")
    ; ("Bad Homburg", "Bad Homburg v.d.H.")
    ; ("Berlin", "Berlin (Charlottenburg)")
    ; ("Charlottenburg", "Berlin (Charlottenburg)")
    ; ("Charlottenburg (Berlin)", "Berlin (Charlottenburg)")
    ; ("Kaln", "Köln")
    ; ("Kempten", "Kempten (Allgäu)")
    ; ( "Ludwigshafen am Rhein (Ludwigshafen)"
      , "Ludwigshafen a.Rhein (Ludwigshafen)" )
    ; ("Ludwigshafen am Rhein", "Ludwigshafen a.Rhein (Ludwigshafen)")
    ; ("Ludwigshafen", "Ludwigshafen a.Rhein (Ludwigshafen)")
    ; ("Oldenburg", "Oldenburg (Oldenburg)")
    ; ("St. Ingbert", "St. Ingbert (St Ingbert)")
    ; ("St. Wendel", "St. Wendel (St Wendel)")
    ; ("Weiden in der Oberpfalz", "Weiden i. d. OPf.")
    ; ("Weiden", "Weiden i. d. OPf.")
    ; ("Paderborn früher Höxter", "Paderborn")
    ]
  in
  List.iter
    (fun (alias, court) -> Hashtbl.add table (to_min alias) court)
    aliases;
  table

(* Company form to registry type mapping *)
let company_form_registry_types =
  [
    ("e.K.", "HRA")
  ; ("e.V.", "VR")
  ; ("Verein", "VR")
  ; ("OHG", "HRA")
  ; ("KG", "HRA")
  ; ("KGaA", "HRB")
  ; ("Vor-GmbH", "HRB")
  ; ("GmbH", "HRB")
  ; ("UG", "HRB")
  ; ("UG i.G.", "HRB")
  ; ("AG", "HRB")
  ; ("e.G.", "GnR")
  ; ("PartG", "PR")
  ]

(* Split number into court, registry, number, and optional qualifier *)
let split number =
  let number = Utils.clean number "" |> String.trim in
  (* Try format: "COURT, REGISTRY NUMBER [QUALIFIER]" - case insensitive *)
  let court_pattern =
    Str.regexp_case_fold
      "^\\(.*\\),?[ \t]*\\(HRA\\|HRB\\|PR\\|GnR\\|VR\\)[ \
       \t]+\\([1-9][0-9]*\\)\\([ \t]+\\([A-Za-z]+\\)\\)?$"
  in
  (* Try format: "REGISTRY NUMBER [QUALIFIER], COURT" - case insensitive *)
  let registry_pattern =
    Str.regexp_case_fold
      "^\\(HRA\\|HRB\\|PR\\|GnR\\|VR\\)[ \t]+\\([1-9][0-9]*\\)\\([ \
       \t]+\\([A-Za-z]+\\)\\)?\\(,\\)?[ \t]*\\(.*\\)$"
  in
  if Str.string_match court_pattern number 0 then
    let court = Str.matched_group 1 number |> String.trim in
    let registry = Str.matched_group 2 number in
    let num = Str.matched_group 3 number in
    let qualifier =
      try Some (Str.matched_group 5 number) with Not_found -> None
    in
    (court, registry, num, qualifier)
  else if Str.string_match registry_pattern number 0 then
    let registry = Str.matched_group 1 number in
    let num = Str.matched_group 2 number in
    let qualifier =
      try Some (Str.matched_group 4 number) with Not_found -> None
    in
    let court = Str.matched_group 6 number |> String.trim in
    (court, registry, num, qualifier)
  else raise Invalid_format

let compact number =
  let court, registry, num, qualifier = split number in
  String.concat " "
    (List.filter
       (fun s -> s <> "")
       [
         court; registry; num; (match qualifier with Some q -> q | None -> "")
       ])

let validate ?company_form number =
  let court_input, registry, num, qualifier = split number in
  (* Lookup normalized court name *)
  let court =
    try Hashtbl.find courts_table (to_min court_input)
    with Not_found -> raise Invalid_component
  in
  (* Validate company form if provided *)
  (match company_form with
  | Some form ->
      let expected_registry =
        try List.assoc form company_form_registry_types
        with Not_found -> raise Invalid_component
      in
      if registry <> expected_registry then raise Invalid_component
  | None -> ());
  String.concat " "
    (List.filter
       (fun s -> s <> "")
       [
         court; registry; num; (match qualifier with Some q -> q | None -> "")
       ])

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_component -> false
