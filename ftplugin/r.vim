function! s:GetSID()
    return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\ze.*$')
endfunction
let s:SID = s:GetSID()
let s:skipflag = 'synIDattr(synID(line("."), col("."), 0), "name") =~ ''Comment\|String'''

function! s:Escape(command)
    let command = a:command
    let command = substitute(command, '\', '\\\', 'g')
    let command = substitute(command, '"', '\\"', "g")
    let command = substitute(command, "'", "'\\\\''", "g")
    return(command)
endfunction

function! s:CleanText(text)
    let text = substitute(a:text, '\(['."'".'"]\)\%([^\\]\|\\.\)\{-}\1','', 'g')
    let text = substitute(text, '#.*', '', '')
    while text =~ '\%((.*\)\@<=([^()]*)'
        let text = substitute(text, '\%((.*\)\@<=([^()]*)', 'foo', 'g')
    endwhile
    return text
endfunction

function! s:Rcmd(command)
    let command = a:command
    if exists("g:r_macvim_use32") && g:r_macvim_use32==1
        let app="R"
    else
        let app="R64"
    endif
    call system("osascript -e 'tell application \"". app ."\" to cmd \"" . s:Escape(a:command). "\"'" .
                \ " -e 'tell application \"System Events\" to tell process \"R\" to perform action \"AXRaise\" of window 1'")
endfunction

function! s:RSource()
    let filepath =  escape(expand("%:p"),'"')
    let command = "source(\"" . filepath . "\")"
    call s:Rcmd(command)
endfunction

function! s:RSendSelection()
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

function! s:RSendLine()
    let command = getline(".")
    let saved_pos = getpos('.')
    let lnum = line('.')
    call cursor(lnum,1)
    let cnum = searchpos('{\s*$', 'W', line('.'))[1]
    if cnum && !eval(s:skipflag)
        let [lnum2,cnum2] = searchpairpos('{', '', '}', 'W', s:skipflag)
        let lines = getline(lnum, lnum2)
        let command = join(lines, "\n")
    endif
    call s:Rcmd(command)
    call setpos('.', saved_pos)
endfunction

function! s:RChgWorkDir()
    let command = "setwd(\"". expand("%:p:h") . "/\")"
    call s:Rcmd(command)
endfunction!


function! s:RComment(sym)
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

au FileType r nnoremap <buffer><silent> <Plug>RSource     :call <SID>RSource()<CR>
au FileType r inoremap <buffer><silent> <Plug>RSource     <ESC>:call <SID>RSource()<CR>gi
au FileType r vnoremap <buffer><silent> <Plug>RSource     :<C-u>call <SID>RSource()<CR><ESC>:normal gv<CR>
au FileType r nnoremap <buffer><silent> <Plug>RSelection  :call <SID>RSendLine()<CR>
au FileType r inoremap <buffer><silent> <Plug>RSelection  <ESC>:call <SID>RSendLine()<CR>gi
au FileType r vnoremap <buffer><silent> <Plug>RSelection  :<C-u>call <SID>RSendSelection()<CR><ESC>:normal gv<CR>
au FileType r nnoremap <buffer><silent> <Plug>RChgWorkDir :call <SID>RChgWorkDir()<CR>
au FileType r inoremap <buffer><silent> <Plug>RChgWorkDir <ESC>:call <SID>RChgWorkDir()<CR>gi
au FileType r vnoremap <buffer><silent> <Plug>RChgWorkDir :<C-u>call <SID>RChgWorkDir()<CR><ESC>:normal gv<CR>
au FileType r nnoremap <buffer><silent> <Plug>RComment    :call <SID>RComment("#")<CR>
au FileType r inoremap <buffer><silent> <Plug>RComment    <ESC>:call <SID>RComment("#")<CR>gi
au FileType r vnoremap <buffer><silent> <Plug>RComment    :call <SID>RComment("#")<CR><ESC>:normal gv<CR>
