" Only do this when not yet done for this buffer
if exists("b:did_r_ftplugin")
    finish
endif

" Don't load another plugin for this buffer
let b:did_r_ftplugin = 1


function! s:GetSID()
    return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\ze.*$')
endfunction
let s:SID = s:GetSID()
let s:skipflag = 'synIDattr(synID(line("."), col("."), 0), "name") =~ ''Comment\|String'''

function! s:Escape(command)
    let command = a:command
    let command = substitute(command, '\', '\\\\', 'g')
    let command = substitute(command, '"', '\\"', 'g')
    let command = substitute(command, "'", "'\\\\''", 'g')
    return(command)
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
    let filepath =  escape(expand("%:p"),'"\')
    let command = 'source("' . filepath . '")'
    call s:Rcmd(command)
endfunction

function! s:RSend(mode)
    if a:mode =~ 'n\|i'
        let command = getline(".")
        let saved_pos = getpos('.')
        let lnum = line('.')
        call cursor(lnum,1)
        let cnum = searchpos('{\s*\(#.*\)\=$', 'W', line('.'))[1]
        if cnum && !eval(s:skipflag)
            let [lnum2,cnum2] = searchpairpos('{', '', '}', 'W', s:skipflag)
            let lines = getline(lnum, lnum2)
            let command = join(lines, "\n")
        endif
        call setpos('.', saved_pos)
    elseif line("'<") == line("'>")
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

function! s:RChgWorkDir()
    let command = 'setwd("'. escape(expand("%:p:h"), '"\') . '")'
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


" key mappings
nnoremap <buffer><silent> <Plug>RSource     :call <SID>RSource()<CR>
inoremap <buffer><silent> <Plug>RSource     <ESC>:call <SID>RSource()<CR>gi
vnoremap <buffer><silent> <Plug>RSource     :<C-u>call <SID>RSource()<CR><ESC>:normal gv<CR>
nnoremap <buffer><silent> <Plug>RSend       :call <SID>RSend('n')<CR>
inoremap <buffer><silent> <Plug>RSend       <ESC>:call <SID>RSend('i')<CR>gi
vnoremap <buffer><silent> <Plug>RSend       :<C-u>call <SID>RSend('v')<CR><ESC>:normal gv<CR>
nnoremap <buffer><silent> <Plug>RChgWorkDir :call <SID>RChgWorkDir()<CR>
inoremap <buffer><silent> <Plug>RChgWorkDir <ESC>:call <SID>RChgWorkDir()<CR>gi
vnoremap <buffer><silent> <Plug>RChgWorkDir :<C-u>call <SID>RChgWorkDir()<CR><ESC>:normal gv<CR>
nnoremap <buffer><silent> <Plug>RComment    :call <SID>RComment("#")<CR>
inoremap <buffer><silent> <Plug>RComment    <ESC>:call <SID>RComment("#")<CR>gi
vnoremap <buffer><silent> <Plug>RComment    :call <SID>RComment("#")<CR><ESC>:normal gv<CR>

if !exists('g:r_macvim_RSource')     | let g:r_macvim_RSource = '<D-R>'     | endif
if !exists('g:r_macvim_RSend')       | let g:r_macvim_RSend = '<D-r>'       | endif
if !exists('g:r_macvim_RChgWorkDir') | let g:r_macvim_RChgWorkDir = '<D-d>' | endif
if !exists('g:r_macvim_RComment')    | let g:r_macvim_RComment = '<D-3>'    | endif

exe 'map <buffer><silent> '  . g:r_macvim_RSource     . ' <Plug>RSource'
exe 'imap <buffer><silent> ' . g:r_macvim_RSource     . ' <Plug>RSource'
exe 'map <buffer><silent> '  . g:r_macvim_RSend       . ' <Plug>RSend'
exe 'imap <buffer><silent> ' . g:r_macvim_RSend       . ' <Plug>RSend'
exe 'map <buffer><silent> '  . g:r_macvim_RChgWorkDir . ' <Plug>RChgWorkDir'
exe 'imap <buffer><silent> ' . g:r_macvim_RChgWorkDir . ' <Plug>RChgWorkDir'
exe 'map <buffer><silent> '  . g:r_macvim_RComment    . ' <Plug>RComment'
exe 'imap <buffer><silent> ' . g:r_macvim_RComment    . ' <Plug>RComment'
