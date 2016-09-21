" Check so we don't load stuff again
if exists("g:writemode")
    finish
endif
let g:writemode = 1

" Global variables used by compile functions (you may want to change these)
let OUTPUTDIR = "~/Dropbox/Skrivande/_kompilerat/"
let CSS = "~/dev/compile-story/style/manuscript.css"
let DOCXREF = "~/dev/compile-story/style/reference.docx"

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
    let pandoccmd = "!pandoc -V lang=sw -t epub --epub-stylesheet=".expand(g:CSS)." --epub-chapter-level=3 -o ".g:OUTPUTDIR.expand('%:t:r').".epub ".expand(filename)
    execute pandoccmd
    if has("mac")
        let opencmd = "!open ".g:OUTPUTDIR
        execute opencmd
    endif
endfun

function! MakeWordDocFunction()
    let filename = CopyFile()
    let pandoccmd = "!pandoc -V lang=sw -t docx --reference-docx ".g:DOCXREF." -o ".g:OUTPUTDIR.expand('%:t:r').".docx ".expand(filename)
    execute pandoccmd
    if has("mac")
        let opencmd = "!open ".g:OUTPUTDIR
        execute opencmd
    endif
endfun

function! MakePDFFunction()
    let filename = CopyFile()
    let tmpfile = tempname() . '.html'

    let pandoccmd = "!pandoc -V lang=sw -s -t html -c ".g:CSS." -o ".tmpfile." ".expand(filename)
    execute pandoccmd

    let wkhtmlcmd = "!wkhtmltopdf --margin-top 20 --margin-bottom 20 --margin-right 30 --margin-left 30 --page-size A4 --encoding utf-8 --footer-font-name \"Times New Roman\" --footer-spacing 10 --header-font-name \"Times New Roman\" --header-font-size 9 --header-spacing 10 --header-right \"".expand('%:t:r')." / Markus Sköld\" --footer-center \"[page]\" ".tmpfile." ".g:OUTPUTDIR.expand('%:t:r').".pdf"
    execute wkhtmlcmd
    if has("mac")
        let opencmd = "!open ".g:OUTPUTDIR
        execute opencmd
    endif
endfunction

function! BackupDocumentToMailFunction()
    let TIMESTAMP = strftime("%Y-%m-%d %H:%M:%S")
    let mailcommand = "!uuencode ".expand('%:p')." ".expand('%:t')." | mail -s \"[textbackup] ".expand('%:t:r')." ".TIMESTAMP."\" mskold@gmail.com"
    execute mailcommand
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

