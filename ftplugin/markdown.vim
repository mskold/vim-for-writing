" Check so we don't load stuff again
if exists("g:writemode")
    finish
endif
let g:writemode = 1

let g:writemode_outputdir = get(g:, 'writemode_outputdir', "~/")

setlocal nonumber
setlocal linespace=5           " Make lines a little airier
setlocal autowrite             " Save files when switching buffers etc

" Common writerly combos
abbreviate *** #### · · ·
" Set GUI environment
if has("gui_running")
    setlocal background=light
    setlocal guifont=Menlo:h15     " Set a bigger font
    setlocal columns=120
    setlocal lines=40
endif

" Compile functions
command! MakePDF call MakePDFFunction()
command! MakeWordDoc call MakeWordDocFunction()
command! MakeEpub call MakeEpubFunction()
command! MailBackup call BackupDocumentToMailFunction()

" Writes current buffer to a tempfile and creates proper en-dashes and
" typographic quotes without having to change the source file
function! CopyFile()
    let tmpfile = tempname() . '.md'
    execute 'write ' . tmpfile
    let sedcmd = "!sed -i.sed 's/ -- / – /g;s/\"/”/g' ".tmpfile
    execute sedcmd
    return tmpfile
endfun

function! MakeEpubFunction()
    let filename = CopyFile()
    if exists("g:writemode_cssref")
        echo "Using CSS reference ".g:writemode_cssref
        let pandoccmd = "!pandoc -V lang=sw -t epub --epub-stylesheet=".expand(g:writemode_cssref)." --epub-chapter-level=3 -o ".g:writemode_outputdir.expand('%:t:r').".epub ".expand(filename)
    else
        echo "No CSS reference file specified."
        let pandoccmd = "!pandoc -V lang=sw -t epub --epub-chapter-level=3 -o ".g:writemode_outputdir.expand('%:t:r').".epub ".expand(filename)
    endif
    execute pandoccmd
    if has("mac")
        let opencmd = "!open ".g:writemode_outputdir
        execute opencmd
    endif
endfun

function! MakeWordDocFunction()
    let filename = CopyFile()
    if exists("g:writemode_docxref")
        echo "Using docx reference ".g:writemode_docxref
        let pandoccmd = "!pandoc -V lang=sw -t docx --reference-docx ".g:writemode_docxref." -o ".g:writemode_outputdir.expand('%:t:r').".docx ".expand(filename)
    else
        echo "No docx reference file specified."
        let pandoccmd = "!pandoc -V lang=sw -t docx -o ".g:writemode_outputdir.expand('%:t:r').".docx ".expand(filename)
    endif
    execute pandoccmd
    if has("mac")
        let opencmd = "!open ".g:writemode_outputdir
        execute opencmd
    endif
endfun

function! MakePDFFunction()
    let filename = CopyFile()
    let tmpfile = tempname() . '.html'

    if exists("g:writemode_cssref")
        echo "Using CSS reference ".g:writemode_cssref
        let pandoccmd = "!pandoc -V lang=sw -s -t html -c ".g:writemode_cssref." -o ".tmpfile." ".expand(filename)
    else
        echo "No CSS reference file specified."
        let pandoccmd = "!pandoc -V lang=sw -s -t html -o ".tmpfile." ".expand(filename)
    endif
    execute pandoccmd

    let wkhtmlcmd = "!wkhtmltopdf --margin-top 20 --margin-bottom 20 --margin-right 30 --margin-left 30 --page-size A4 --encoding utf-8 --footer-font-name \"Times New Roman\" --footer-spacing 10 --header-font-name \"Times New Roman\" --header-font-size 9 --header-spacing 10 --header-right \"".expand('%:t:r')." / Markus Sköld\" --footer-center \"[page]\" ".tmpfile." ".g:writemode_outputdir.expand('%:t:r').".pdf"
    execute wkhtmlcmd
    if has("mac")
        let opencmd = "!open ".g:writemode_outputdir
        execute opencmd
    endif
endfunction

function! BackupDocumentToMailFunction()
    if exists("g:writemode_backup_emailaddress")
        let TIMESTAMP = strftime("%Y-%m-%d %H:%M:%S")
        let mailcommand = "!uuencode ".expand('%:p')." ".expand('%:t')." | mail -s \"[textbackup] ".expand('%:t:r')." ".TIMESTAMP."\" ".g:writemode_backup_emailaddress
        execute mailcommand
    else
        echo "No backup email address specified."
    endif
endfun

function! s:RenumberChaptersFunction()
    let chaptercounter = 1
    let linecounter = 1
    for line in getline(1, "$")
        if match(line, '^### ') >= 0
            " Replace that line and increase chapter counter
            call setline(linecounter, '### '.chaptercounter)
            let chaptercounter = chaptercounter + 1
        endif
        let linecounter = linecounter + 1
    endfor
endfun

:command! RenumberChapters call s:RenumberChaptersFunction()

