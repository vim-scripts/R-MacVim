# R-MacVim
A simple R plugin for MacVim.

## What is it?
- It is a R plugin for MacVim.
 
- It allows you to send selected lines, blocks or paragraph to R (by CMD+r).

- It also allows you to source the whole R file (by CMD+R). 

- It also allows you to comment or uncomment (by CMD+3).

- It also allows you to change your working directory (by CMD+d).

- Key maps are changable (see below).

- For development and bug report, visit
 http://github.com/randy3k/r-macvim

- Stable updates will be uploaded to
 http://www.vim.org/scripts/script.php?script_id=4215

- This plugin aims at being simple. For more plugins, see:
 Vim-R-plugin: http://www.vim.org/scripts/script.php?script_id=2628

## Installation

- Make sure ~/.vim exists, if not:

        mkdir ~/.vim

- Copy all the files to your .vim directory:

        tar --strip=1 -xzvf the_file -C ~/.vim/

- Check if ~/.vimrc exists, if not:

        touch ~/.vimrc

- Add the followings to your .vimrc file:

        au FileType r nnoremap <buffer><D-R> :call b:RSource()<CR>
        au FileType r inoremap <buffer><D-R> <ESC>:call b:RSource()<CR>gi
        au FileType r vnoremap <buffer><D-R> :<C-u>call b:RSource()<CR>gv
        au FileType r nnoremap <buffer><D-r> :call b:RSendLine()<CR>
        au FileType r inoremap <buffer><D-r> <ESC>:call b:RSendLine()<CR>gi
        au FileType r vnoremap <buffer><D-r> :<C-u>call b:RSendSelection()<CR>gv
        au FileType r nnoremap <buffer><D-d> :call b:RChgWorkDir()<CR>
        au FileType r inoremap <buffer><D-d> <ESC>:call b:RChgWorkDir()<CR>gi
        au FileType r vnoremap <buffer><D-d> :<C-u>call b:RChgWorkDir()<CR>gv
        au FileType r nnoremap <buffer><D-3> :call b:RComment("#")<CR>
        au FileType r inoremap <buffer><D-3> <ESC>:call b:RComment("#")<CR>gi

- if you want to use R.app instead of R64.app, also add the following to your .vimrc file:

        let g:r_macvim_use32 = 1
