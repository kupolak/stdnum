(** {1 Adoption Taxpayer Identification Number (ATIN)}

    This module provides functions to validate U.S. Adoption Taxpayer Identification Numbers.
    
    An Adoption Taxpayer Identification Number (ATIN) is a temporary nine-digit number 
    issued by the United States IRS for a child for whom the adopting parents cannot 
    obtain a Social Security Number.
    
    {2 Format}
    - 9 digits total with specific pattern: 9XX-93-XXXX
    - First digit: must be 9
    - Digits 4-5: must be 93
    - Always formatted with dashes for official use
    
    {2 Example}
    {[
      let valid_atin = "900-93-0000" in
      assert (is_valid valid_atin);
      assert (validate valid_atin = "900-93-0000")
    ]}
*)

(** Exception raised when the ATIN format is invalid *)
exception Invalid_format

(** Regular expression for matching ATINs with pattern 9XX-93-XXXX
    
    This regex validates:
    - Starts with 9
    - Followed by any two digits
    - Then "-93-"
    - Ending with any four digits *)
val atin_re : Str.regexp

(** [validate number] validates and returns the ATIN in standard format.
    
    @param number The ATIN to validate (must include dashes)
    @return The validated ATIN in format 9XX-93-XXXX
    @raise Invalid_format if the ATIN is not valid
    
    {[validate "900-93-0000" = "900-93-0000"]} *)
val validate : string -> string

(** [is_valid number] checks if the ATIN is valid.
    
    @param number The ATIN to check
    @return [true] if valid, [false] otherwise
    
    {[is_valid "900-93-0000" = true]} *)
val is_valid : string -> bool

(** [format_number number] formats the ATIN to standard presentation.
    
    @param number The ATIN to format
    @return The formatted ATIN as 9XX-93-XXXX
    
    {[format_number "900930000" = "900-93-0000"]} *)
val format_number : string -> string
