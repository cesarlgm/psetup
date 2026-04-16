/*
*=====================================================================================
*PROJECT: SKILL USE IN JOBS: THE ROLE FO EDUCATION AND TECHNOLOGY
*Authors: Cavounidis, Garro-Marín, Lang, and Malhotra
*=====================================================================================

*DESCRIPTION: this dofile creates references to files in other output folder
*=====================================================================================
*/


cap program drop create_references
program define create_references,
    syntax, opath(str) [file(str) ipath(str) COpy]

    *Creating code creation of references
    create_pw_ref, opath("`opath'") file("`file'") `copy' ipath(`ipath')

    execute_references

    write_error_report
end


cap program drop read_reference_file
program define read_reference_file
    syntax, [file(str)]

    if "`file'"=="" {
        local file "input_manifest"
    }
    import delimited "./`file'.txt", varnames(nonames) stringcols(_all) delimiter(";") clear
    drop if substr(v1, 1, 1) == "#"

    rename v1 destination
    rename v2 origin
end


cap program drop get_reference_line
program define get_reference_line, rclass
    syntax, line(string) opath(str) [COpy ipath(str)]

    if "`ipath'"=="" {
        local ipath "./input"
    }

    local environment="`c(os)'"

    local ref_dest=destination[`line']
    local ref_orig=origin[`line']

    if "`copy'"=="" {
        if "`environment'"=="Windows" {
            local cmd0="if (Test-Path -LiteralPath '`ipath'/`ref_dest'') { Remove-Item -Recurse -Force -LiteralPath '`ipath'/`ref_dest'' };"
            local cmd1="New-Item -ItemType SymbolicLink -Path"
            local cmd2=" -Target"
            local cmd3=" -Force"
        }
        else if "`environment'"=="MacOSX" {
            local cmd0="rm -f '`ipath'/`ref_dest'';"
            local cmd1="ln -sfn"
            local cmd2=""
            local cmd3=""
        }
        return local ref_line `"`cmd0' `cmd1' '`ipath'/`ref_dest'' `cmd2' '`opath'/`ref_orig''  `cmd3'"'
    }
    else {
        if "`environment'"=="Windows" {
            local cmd0="if (Test-Path -LiteralPath '`ipath'/`ref_dest'') { Remove-Item -Recurse -Force -LiteralPath '`ipath'/`ref_dest'' };"
            local cmd1="Copy-Item -Recurse -Force"
        }
        else if "`environment'"=="MacOSX" {
            local cmd0="rm -rf '`ipath'/`ref_dest'';"
            local cmd1="cp -rf"
        }
        return local ref_line `"`cmd0' `cmd1'  '`opath'/`ref_orig''  '`ipath'/`ref_dest'' "'
    }
end


cap program drop create_pw_ref
program define create_pw_ref,
    syntax, opath(str) [file(str) COpy ipath(str)]

    local environment="`c(os)'"

    read_reference_file, file("`file'")

    local n_references=_N

    file open fh using "./temp/links.ps1", write text replace

    * Header: clear previous error file
    if "`environment'"=="Windows" {
        file write fh `"Remove-Item -Force './temp/copy_errors.txt' -ErrorAction SilentlyContinue"' _n
    }
    else if "`environment'"=="MacOSX" {
        file write fh `"rm -f ./temp/copy_errors.txt"' _n
    }

    forvalues file_line=1/`n_references' {
        get_reference_line, line(`file_line') opath("`opath'") `copy' ipath(`ipath')
        local ref_dest = destination[`file_line']

        if "`environment'"=="Windows" {
            file write fh `"try { `r(ref_line)' -ErrorAction Stop } catch { '`ref_dest'' | Out-File -FilePath './temp/copy_errors.txt' -Append -Encoding UTF8 }"' _n
        }
        else if "`environment'"=="MacOSX" {
            file write fh `"`r(ref_line)' || echo '`ref_dest'' >> ./temp/copy_errors.txt"' _n
        }
    }

    file close fh

end


cap program drop execute_references
program define execute_references,
    syntax, [tempname(str)]

     if "`tempname'"=="" {
        local tempname "temp"
    }

    local environment="`c(os)'"


    if "`environment'"=="Windows" {
        shell powershell -ExecutionPolicy Bypass -File "./`tempname'/links.ps1"
    }
    else if "`environment'"=="MacOSX" {
        shell sh "./`tempname'/links.ps1"
    }
end


cap program drop write_error_report
program define write_error_report
    syntax, [outfile(str)]

    if "`outfile'"=="" {
        local outfile "./temp/copy_errors.md"
    }

    cap confirm file "./temp/copy_errors.txt"
    if _rc != 0 {
        di as text "All files copied/linked successfully."
        exit
    }

    preserve
    import delimited "./temp/copy_errors.txt", varnames(nonames) stringcols(_all) clear
    cap drop if missing(v1) | v1 == ""
    local n_errors = _N

    if `n_errors' == 0 {
        restore
        di as text "All files copied/linked successfully."
        exit
    }

    file open mdfh using "`outfile'", write text replace
    file write mdfh "# Copy/Link Errors" _n _n
    file write mdfh "`n_errors' file(s) could not be copied or linked:" _n _n

    forvalues i=1/`n_errors' {
        local errfile = v1[`i']
        file write mdfh "- `errfile'" _n
    }

    file close mdfh
    restore

    di as error "`n_errors' file(s) could not be copied. See `outfile' for details."
end
