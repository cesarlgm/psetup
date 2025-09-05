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
    syntax, opath(str) [file(str) COpy]

    *Creating code creation of references
    create_pw_ref, opath("`opath'") file("`file'") `copy'

    execute_references
end 


cap program drop read_reference_file
program define read_reference_file
    syntax, [file(str)]

    if "`file'"=="" {
        local file "input_manifest"
    }
    import delimited "./`file'.txt", varnames(nonames) stringcols(_all) clear
    rename v1 destination
    rename v2 origin 
end 


cap program drop get_reference_line
program define get_reference_line, rclass
    syntax, line(string) opath(str) [COpy]

    local environment="`c(os)'"

    local ref_dest=destination[`line']
    local ref_orig=origin[`line']

    if "`copy'"=="" {
        if "`environment'"=="Windows" {
            local cmd1="New-Item -ItemType SymbolicLink -Path"
            local cmd2=" -Target"
            local cmd3=" -Force"
        }
        else if "`environment'"=="MacOSX" {
            //!This bit might fail
            local cmd1="ln -sfn"
            local cmd2=""
            local cmd3=""
        }
        return local ref_line `"`cmd1' ./input/`ref_dest' `cmd2' '`opath'/`ref_orig''  `cmd3'"'
    }
    else {
        if "`environment'"=="Windows" {
            local cmd1="Copy-Item -Recurse -Force"
        }
        else if "`environment'"=="MacOSX" {
            //!This bit might fail
            local cmd1="cp -rf"
        }
        return local ref_line `"`cmd1' ./input/`ref_dest'  '`opath'/`ref_orig'' "'
    }
end 


cap program drop create_pw_ref
program define create_pw_ref, 
    syntax, opath(str) [file(str) COpy]

    local environment="`c(os)'"
    
    read_reference_file, file("`file'")

    local n_references=_N

    file open fh using "./temp/links.ps1", write text replace

    forvalues file_line=1/`n_references' {
        get_reference_line, line(`file_line') opath("`opath'")
        file write fh `"`r(ref_line)'"' _n
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