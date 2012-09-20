if exists("b:did_r_indent")
    finish
endif
let b:did_r_indent = 1

setlocal indentkeys=0{,0},:,!^F,o,O,e
setlocal indentexpr=GetRIndent()


let b:lastindentline = 1
function! CleanText(text)
    let text = substitute(a:text, '\(['."'".'"]\)\([^\\]\|\\.\)\{-}\1','', 'g')
    let text = substitute(text, '#.*', '', '')
    return text
endfunction



function! RIndent(lnum_curr)
    let lnum_curr = a:lnum_curr
    let lnum_prev = prevnonblank(lnum_curr-1)
    let line_curr = getline(lnum_curr)
    let line_prev = getline(lnum_prev)
    let skipflag = 'synIDattr(synID(line("."), col("."), 0), "name") =~ "rComment\|rString"'

    if lnum_curr< b:lastindentline
        let b:lastindentline = 1
    endif

    call cursor(lnum_curr,1)
    let [lnum, col] = searchpairpos('{\|(','','}\|)','bnW', skipflag, b:lastindentline)
    let curchar = strpart(getline(lnum),col-1,1)
    if lnum == 0
        let b:lastindentline = lnum_curr
    endif

    if  curchar=="("
        return col
    endif

    let n = 0
    let line_prev = CleanText(line_prev)
    if line_prev =~ 'for\s*([^)]*)\s*$\|if\s*([^)]*)\s*$\|else\s*$\|while\s*([^)]*)\s*$\|function\s*([^)]*)\s*$'
        let n += 1
        if line_curr =~ '^\s*{'
            let n -= 1
        endif
        return indent(lnum_prev) + n * &sw
    endif


    if lnum != 0
        let n += 1
        if line_curr =~ '^\s*}'
            let n -= 1
        endif
        let indentstep = indent(lnum) + n * &sw
        if indentstep ==0
            let b:lastindentline = lnum_curr
        endif
        return indentstep
    else
        return 0
    endif
endfunction

function! GetRIndent()

    let lnum_curr = v:lnum

    return  RIndent(lnum_curr)
    return 0

endfunction

