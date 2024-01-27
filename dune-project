(lang dune 3.13)

(name stdnum)

(generate_opam_files true)

(source
 (github kupolak/stdnum))

(authors "Jakub Polak")

(maintainers "Jakub Polak"
)
(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name stdnum)
 (synopsis "Ocaml library to provide functions to handle, parse and validate standard numbers.")
 (description "The stdnum library in OCaml provides functions for handling, parsing,
  and validating standard numbers. It can be used for identifiers like PESEL, NIP, REGON.")
 (depends ocaml dune alcotest)
 (tags
  (validation, identity-card-validation standards utils check checker)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
