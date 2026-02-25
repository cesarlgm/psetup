{smcl}
{* *! version 1.0  2025}{...}
{viewerjumpto "Syntax" "clean_folders##syntax"}{...}
{viewerjumpto "Description" "clean_folders##description"}{...}
{viewerjumpto "Options" "clean_folders##options"}{...}
{viewerjumpto "Examples" "clean_folders##examples"}{...}

{title:Title}
{phang}
{bf:clean_folders} {hline 2} Erase and recreate project working directories

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:clean_folders}{cmd:,}
{opt folder(str)}
[{opt tempfname(str)}
{opt outfname(str)}
{opt noout}
{opt subfolders}]

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt folder(str)}}path to the parent project directory{p_end}
{syntab:Optional}
{synopt:{opt tempfname(str)}}name of the temporary subfolder; default is {bf:temporary}{p_end}
{synopt:{opt outfname(str)}}name of the output subfolder; default is {bf:output}{p_end}
{synopt:{opt noout}}skip erasing and recreating the output folder{p_end}
{synopt:{opt subfolders}}create fig/, tab/, and text/ subdirectories inside the output folder{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{bf:clean_folders} deletes and recreates the {it:temporary} and {it:output}
working directories inside {opt folder()}. Running this at the top of a
do-file ensures a clean slate before producing new outputs.

{pstd}
The command is cross-platform: on Windows it uses {cmd:rmdir /S /Q} and
{cmd:mkdir}; on macOS it uses {cmd:rm -rf} and {cmd:mkdir -p}.

{pstd}
{bf:Warning:} all existing content in the targeted directories is permanently
deleted. Use {opt noout} to protect the output directory.

{marker options}{...}
{title:Options}

{phang}
{opt folder(str)} the root directory of the project, supplied as an absolute
or relative path. The temp and output directories are created as direct
subdirectories of this path.

{phang}
{opt tempfname(str)} name for the temporary directory. Default is
{cmd:temporary}.

{phang}
{opt outfname(str)} name for the output directory. Default is {cmd:output}.

{phang}
{opt noout} skips deletion and recreation of the output directory. A warning
message is displayed. The temporary directory is still cleaned.

{phang}
{opt subfolders} after creating the output directory, also creates three
subdirectories: {it:fig/}, {it:tab/}, and {it:text/}. These correspond to
the conventional locations for figures, tables, and inline text numbers.

{marker examples}{...}
{title:Examples}

{pstd}Clean both directories:{p_end}
{phang2}{cmd:. clean_folders, folder("C:/projects/mypaper")}{p_end}

{pstd}Clean and create standard output subdirectories:{p_end}
{phang2}{cmd:. clean_folders, folder("C:/projects/mypaper") subfolders}{p_end}

{pstd}Use custom directory names and preserve the output folder:{p_end}
{phang2}{cmd:. clean_folders, folder("C:/projects/mypaper") tempfname(temp) noout}{p_end}

{title:Also see}
{psee}{help create_references}{p_end}

{title:Author}
{pstd}César Garro-Marín, University of Edinburgh, cgarrom@ed.ac.uk
