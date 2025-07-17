# Developer Documentation

## Building Documentation

This project uses `odoc` for generating documentation from OCaml interface files.

### Prerequisites

Make sure you have `odoc` installed:
```bash
opam install odoc
```

### Building Documentation

To build the documentation:
```bash
make doc
```

This will generate HTML documentation in `_build/default/_doc/_html/`.

### Serving Documentation Locally

To serve the documentation locally on port 8080:
```bash
make doc-serve
```

This will start a Python HTTP server and open the documentation at http://localhost:8080

**Note:** You need Python 3 installed for the local server. Press Ctrl+C to stop the server.

### Documentation Guidelines

When writing documentation in `.mli` files:

1. **Module-level documentation**: Use `(** {1 Title} ... *)` at the top
2. **Function documentation**: Use `(** ... *)` before each function
3. **Parameters**: Use `@param name description`
4. **Return values**: Use `@return description`  
5. **Exceptions**: Use `@raise Exception description`
6. **Examples**: Use code blocks with `{[ ... ]}`

#### Example:
```ocaml
(** {1 Number Validation}
    
    This module validates identification numbers.
*)

(** [validate number] validates the given number.
    
    @param number The number to validate
    @return The cleaned and validated number
    @raise Invalid_format if the number is invalid
    
    {[validate "123-45-6789" = "123456789"]} *)
val validate : string -> string
```

### Documentation Structure

- `/` - Main library documentation
- `/stdnum/` - Main module
- `/stdnum/Stdnum/` - Core library documentation
- `/stdnum/Tools/` - Utility functions
- `/stdnum/Us/` - US numbers (when implemented)
- `/stdnum/Pl/` - Polish numbers (when implemented)

### Deployment

Documentation is automatically deployed to GitHub Pages when pushed to main branch via GitHub Actions.

## Development Workflow

1. Write/update `.mli` files with proper documentation
2. Run `make doc` to build locally
3. Run `make doc-serve` to preview at http://localhost:8080
4. Commit and push - documentation will be auto-deployed 