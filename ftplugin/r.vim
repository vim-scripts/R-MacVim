if exists("g:r_macvim_use32") && g:r_macvim_use32==1
    let s:bit=""
else
    let s:bit="64"
endif

function! s:Escape(command)
    let command = a:command
        let command = substitute(command, '\', '\\\', 'g')
        let command = substitute(command, '"', '\\"', "g")
        let command = substitute(command, "'", "'\\\\''", "g")
    return(command)
endfunction

function! s:Rcmd(command)
    let command = a:command
    call system("osascript -e 'tell application \"R". s:bit ."\" to cmd \"" . s:Escape(a:command). "\"'" .
                \ " -e 'tell application \"System Events\" to tell process \"R\" to perform action \"AXRaise\" of window 1'")
endfunction

function! b:RSource()
    let filepath =  escape(expand("%:p"),'"')
    let command = "source(\"" . filepath . "\")"
    call s:Rcmd(command)
endfunction

function! b:RSendSelection() 
    if line("'<") == line("'>")
        let i = col("'<") - 1
        let j = col("'>") - i
        let l = getline("'<")
        let command = strpart(l, i, j)
    else
        let lines = getline("'<", "'>")
        let command = join(lines, "\n") 
    endif
    call s:Rcmd(command)
endfunction

function! b:RSendLine()
        let command = getline(".")
    call s:Rcmd(command)
endfunction

function! b:RChgWorkDir()
    let command = "setwd(\"". expand("%:p:h") . "/\")"
    call s:Rcmd(command)
endfunction!


function! b:RComment(sym)
    let line = getline(".")
    if !empty(substitute(line, '^\s*\(.\{-}\)\s*$', '\1', ''))
        let firstchar = matchstr(line, '\v\s*\zs.\ze.*')  
        if firstchar != a:sym
            execute "normal! I". a:sym ." "
        else
            execute ':s/'. a:sym .'\s*\S\@=//'
        endif
    endif
endfunction


