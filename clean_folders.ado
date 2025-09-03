cap program drop clean_folders
program define clean_folders 
    syntax, folder(str) [tempfname(str) outfname(str) NOout]

    if "`tempfname'"=="" {
        local tempfname temporary
    }
    if "`outfname'"=="" {
        local outfname output
    }


    local environment="`c(os)'"

    local temp_msg="Erasing and creating `folder'/`tempfname'"
    local out_msg="Erasing and creating `folder'/`outfname'"
    local warn_msg="Warning: output folder was left intact"

    if "`environment'"=="Windows" {
        // For Windows
        di as txt "`temp_msg'"
        cap shell rmdir /S /Q "`folder'/`tempfname'"
        shell mkdir "`folder'/`tempfname'"
        if "`noout'"=="" {
            di as txt "`out_msg'"
            cap shell rmdir /S /Q "`folder'/`outfname'"
            shell mkdir "`folder'/`outfname'"
        }
        else {
            di as error "`warn_msg'"
        }
    }
    else if "`environment'"=="MacOSX" {
        // For macOS/Linux
        di as txt "`temp_msg'"
        cap shell rm -rf "`folder'/`tempfname'"
        shell mkdir -p "`folder'/`tempfname'"
        if "`noout'"=="" {
            di as txt "`out_msg'"
            cap shell rm -rf "`folder'/`outfname'"
            shell mkdir -p "`folder'/`outfname'"
        }
        else {
            di as error "`warn_msg'"
        }
    }
end 