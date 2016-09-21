" My own markdown folding script

function! MarkdownFolds()
    let thisline = getline(v:lnum)
    if match(thisline, '^#') >= 0 " Treats all levels of headings as equal
        return ">1"
    else
        return "="
    endif
endfunction
setlocal foldmethod=expr
setlocal foldexpr=MarkdownFolds()

function! MarkdownFoldText()
    let selection = getline(v:foldstart+1, v:foldend)
    let wordcount = 0
    for line in selection
        for word in split(line)
            let wordcount = wordcount + 1
        endfor
    endfor
    if getline(v:foldstart+1) =~ '^<!--'
        let synopsis=getline(v:foldstart+1)
        let synopsis=substitute(synopsis, '<!-- ', '[', '')
        let synopsis=substitute(synopsis, ' -->', ']', '')
        let firstline=getline(v:foldstart).' '.synopsis
        " Substract words in synopsis from wordcount
        for word in split(synopsis)
            let wordcount = wordcount - 1
        endfor
    else
        let firstline=getline(v:foldstart)
    endif
    return firstline.' (~'.wordcount.' ord)' 
endfunction
setlocal foldtext=MarkdownFoldText()


