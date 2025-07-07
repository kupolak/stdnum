(** {1 Standard Number Validation Library}

    OCaml library to provide functions to handle, parse and validate standard numbers.
    
    This library supports validation of various standard numbers including:
    - National identification numbers
    - Tax identification numbers  
    - Bank account numbers
    - ISBN/ISSN codes
    - And many more
    
    {2 Organization}
    
    The library is organized by country/region modules:
    - Us - United States numbers (ATIN, etc.)
    - Pl - Polish numbers (PESEL, NIP, REGON, etc.)  
    - Al - Albanian numbers (NIPT)
    - Ad - Andorran numbers (NRT)
    - Ar - Argentine numbers (CBU)
    - Hu - Hungarian numbers (ANUM)
    
    And utility modules:
    - Tools - Common utility functions
    - Iso7064 - ISO 7064 checksum algorithms
    
    {2 Usage Examples}
    
    {3 Polish Numbers}
    {[
      (* Polish NIP (VAT number) validation *)
      let nip = "123-456-78-90" in
      if Pl.Nip.is_valid nip then
        Printf.printf "Valid NIP: %s\n" (Pl.Nip.format nip)
      else
        Printf.printf "Invalid NIP\n"
        
      (* Polish PESEL (national ID) validation *)
      let pesel = "44051401359" in
      try
        let validated = Pl.Pesel.validate pesel in
        Printf.printf "Valid PESEL: %s\n" (Pl.Pesel.format validated)
      with
      | Pl.Pesel.Invalid_format -> Printf.printf "Invalid PESEL format\n"
      | Pl.Pesel.Invalid_checksum -> Printf.printf "Invalid PESEL checksum\n"
        
      (* Polish REGON (business number) validation *)
      let regon = "123456785" in
      assert (Pl.Regon.is_valid regon);
      Printf.printf "Formatted REGON: %s\n" (Pl.Regon.format regon)
    ]}
    
    {3 US Numbers}
    {[
      (* US ATIN (Adoption Taxpayer ID) validation *)
      let atin = "900-93-0000" in
      if Us.Atin.is_valid atin then
        Printf.printf "Valid ATIN: %s\n" atin
      else
        Printf.printf "Invalid ATIN\n"
    ]}
    
    {3 Argentine Numbers}
    {[
      (* Argentine CBU (bank account) validation *)
      let cbu = "0170016212000012345678" in
      try
        let validated = Ar.Cbu.validate cbu in
        Printf.printf "Valid CBU: %s\n" (Ar.Cbu.format validated)
      with
      | Ar.Cbu.Invalid_format -> Printf.printf "Invalid CBU format\n"
      | Ar.Cbu.Invalid_checksum -> Printf.printf "Invalid CBU checksum\n"
    ]}
    
    {3 Albanian Numbers}
    {[
      (* Albanian NIPT (tax number) validation *)
      let nipt = "J91402501L" in
      if Al.Nipt.is_valid nipt then
        Printf.printf "Valid NIPT: %s\n" (Al.Nipt.format nipt)
      else
        Printf.printf "Invalid NIPT\n"
    ]}
    
    {3 Utility Functions}
    {[
      (* Using utility functions *)
      let number = "123-45-6789" in
      let cleaned = Tools.Utils.clean number "-" in
      Printf.printf "Cleaned: %s\n" cleaned; (* "123456789" *)
      
      let is_numeric = Tools.Utils.is_digits cleaned in
      Printf.printf "Is numeric: %b\n" is_numeric; (* true *)
    ]}
    
    {3 ISO 7064 Checksums}
    {[
      (* Using ISO 7064 checksum algorithms *)
      let number = "12345678" in
      let checksum = Iso7064.Mod_97_10.checksum number in
      Printf.printf "ISO 7064 MOD 97-10 checksum: %d\n" checksum;
      
      let with_check = Iso7064.Mod_37_2.checksum "ABCDEFGH" in
      Printf.printf "ISO 7064 MOD 37-2 checksum: %d\n" with_check
    ]}
    
    {2 Common Patterns}
    
    Most modules in this library follow a consistent interface:
    - [validate] - validates and returns normalized form, raises exception on invalid
    - [is_valid] - returns boolean, never raises exceptions
    - [format] - formats number to standard presentation
    - [compact] - removes formatting characters
    - [checksum] - calculates checksum (where applicable)
    
    {2 Error Handling}
    
    The library uses OCaml exceptions for error handling:
    - [Invalid_format] - number format is incorrect
    - [Invalid_length] - number has wrong length
    - [Invalid_checksum] - checksum validation failed
    
    Use [is_valid] functions for boolean checks without exceptions,
    or [validate] functions with proper exception handling.
*) 