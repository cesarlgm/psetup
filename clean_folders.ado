cap program drop clean_folders
program define clean_folders 
    syntax, folder(str) [tempfname(str) outfname(str) NOout SUBfolders]

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
        local delete_cmd="rmdir /S /Q"
        local mkdir_cmd="mkdir"
    }
    else if "`environment'"=="MacOSX" {
        local delete_cmd="rm -rf"
        local mkdir_cmd="mkdir -p"
    }

    di as txt "`temp_msg'"
    cap shell `delete_cmd' "`folder'/`tempfname'"
    shell `mkdir_cmd' "`folder'/`tempfname'"

    if "`subfolders'"!="" {
        di as txt "Creating subfolders in `folder'/`outfname'"
        shell `mkdir_cmd' "`folder'/`outfname'/fig"
        shell `mkdir_cmd' "`folder'/`outfname'/tab"
        shell `mkdir_cmd' "`folder'/`outfname'/text"
    }

    di as result "All forders have been cleaned"
end 