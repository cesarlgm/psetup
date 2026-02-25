{smcl}
{* *! version 1.0  2025}{...}
{viewerjumpto "Syntax" "create_references##syntax"}{...}
{viewerjumpto "Description" "create_references##description"}{...}
{viewerjumpto "Options" "create_references##options"}{...}
{viewerjumpto "Remarks" "create_references##remarks"}{...}
{viewerjumpto "Examples" "create_references##examples"}{...}

{title:Title}
{phang}
{bf:create_references} {hline 2} Create symbolic links or copies from another project's output

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:create_references}{cmd:,}
{opt opath(str)}
[{opt file(str)}
{opt ipath(str)}
{opt copy}]

{synoptset 14 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt opath(str)}}path to the source project's output directory{p_end}
{syntab:Optional}
{synopt:{opt file(str)}}name of the manifest file (without extension); default is {bf:input_manifest}{p_end}
{synopt:{opt ipath(str)}}path to the local input directory; default is {bf:./input}{p_end}
{synopt:{opt copy}}copy files instead of creating symbolic links{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{bf:create_references} reads a manifest file and creates symbolic links (or
file copies) from a source project's output directory into the current
project's {it:input/} directory. This allows one project to consume the
outputs of another without duplicating files.

{pstd}
The command generates a script ({it:./temp/links.ps1}) and executes it. On
Windows the script uses PowerShell ({cmd:New-Item -ItemType SymbolicLink} or
{cmd:Copy-Item}); on macOS it uses shell commands ({cmd:ln -sfn} or
{cmd:cp -rf}).

{pstd}
The temporary directory ({it:./temp/}) must exist before calling this command.
Use {help clean_folders} to create it.

{marker remarks}{...}
{title:Remarks: manifest file format}

{pstd}
The manifest is a plain-text, semicolon-delimited file with one entry per
line:

{phang2}{it:destination_name}{cmd:;}{it:origin_name}

{pstd}
{it:destination_name} is the name the link or copy will have inside
{it:./input/}. {it:origin_name} is the filename (or subdirectory) inside
{opt opath()}. Lines beginning with {cmd:#} are treated as comments and
ignored.

{pstd}
Example manifest ({it:input_manifest.txt}):

{phang2}{cmd:# Wage data from the main analysis project}{p_end}
{phang2}{cmd:wages_clean.dta;wages_clean.dta}{p_end}
{phang2}{cmd:emp_panel.dta;employment_panel_v2.dta}{p_end}

{marker options}{...}
{title:Options}

{phang}
{opt opath(str)} absolute or relative path to the directory in the source
project that contains the files to be linked or copied. Typically this is the
{it:output/} directory of another project.

{phang}
{opt file(str)} name of the manifest file, without the {it:.txt} extension.
Default is {cmd:input_manifest}, so the command looks for
{it:./input_manifest.txt}.

{phang}
{opt ipath(str)} path to the local directory where links or copies are placed.
Default is {cmd:./input}.

{phang}
{opt copy} copies files instead of creating symbolic links. Use this when the
filesystem does not support symlinks or when portability across machines is
required.

{marker examples}{...}
{title:Examples}

{pstd}Create symbolic links using the default manifest:{p_end}
{phang2}{cmd:. create_references, opath("C:/projects/main_analysis/output")}{p_end}

{pstd}Copy files using a custom manifest and input path:{p_end}
{phang2}{cmd:. create_references, opath("C:/projects/main_analysis/output") file(my_manifest) ipath(./data/input) copy}{p_end}

{title:Also see}
{psee}{help clean_folders}{p_end}

{title:Author}
{pstd}César Garro-Marín, University of Edinburgh, cgarrom@ed.ac.uk
