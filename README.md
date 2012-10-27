# R-MacVim
A simple R plugin for MacVim.

## What is it?
- It is a R plugin for MacVim.
 
- It allows you to send selected words, lines and blocks to R (by CMD+r).

- It also allows you to source the whole R file (by CMD+R). 

- It also allows you to comment or uncomment single or multiple lines (by CMD+3).

- It also allows you to change your working directory (by CMD+d).

- Key maps are changable (see below).

- For development and bug reports:
 http://github.com/randy3k/r-macvim

- Stable updates will be uploaded to:
 http://www.vim.org/scripts/script.php?script_id=4215

- This plugin aims at being simple. For more plugins, see:
 Vim-R-plugin: http://www.vim.org/scripts/script.php?script_id=2628

## Installation

- Copy the file r.vim to ~/.vim/ftplugin/

- Check if ~/.vimrc exists (this is a file), if not:

        touch ~/.vimrc

- Add the followings to your .vimrc file:

        au FileType r map <buffer><silent> <D-R> <Plug>RSource
        au FileType r imap <buffer><silent> <D-R> <Plug>RSource
        au FileType r map <buffer><silent> <D-r> <Plug>RSelection
        au FileType r imap <buffer><silent> <D-r> <Plug>RSelection
        au FileType r map <buffer><silent> <D-d> <Plug>RChgWorkDir
        au FileType r imap <buffer><silent> <D-d> <Plug>RChgWorkDir
        au FileType r map <buffer><silent> <D-3> <Plug>RComment
        au FileType r imap <buffer><silent> <D-3> <Plug>RComment


- if you want to use R.app instead of R64.app, also add the following to your .vimrc file:

        let g:r_macvim_use32 = 1
