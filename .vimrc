" vim:fdm=marker
" Initial Global Settings ------------ {{{
set nocompatible
" Highlight search
set hlsearch
" }}}
" Line 80 Bar ----------------- {{{
if (exists('+colorcolumn'))
   set colorcolumn=80
   highlight ColorColumn ctermbg=9
endif
" }}}
" Plugs ----------------- {{{
call plug#begin('~/.vim/plugged')

" Requirement to use Vundle as vim plugin manager
Plug 'scrooloose/nerdtree'
Plug 'hdima/python-syntax'
Plug 'elzr/vim-json'
Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
Plug 'hashivim/vim-vagrant'
Plug 'pearofducks/ansible-vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tomasr/molokai'
Plug 'tpope/vim-eunuch'
Plug 'hashivim/vim-terraform'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/groovy.vim'
call plug#end()

" }}}
" Plug settings for powerline ----------------- {{{
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
" }}}
" Plug settings for Nerdtree ----------------- {{{
map F2 for Nerdtree
map <F2> :NERDTreeToggle<CR>
" }}}
" CTRL-SHIFT-V remap {{{
if &term =~ "xterm.*"
    let &t_ti = &t_ti . "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te
    function XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction
    map <expr> <Esc>[200~ XTermPasteBegin("i")
    imap <expr> <Esc>[200~ XTermPasteBegin("")
    vmap <expr> <Esc>[200~ XTermPasteBegin("c")
    cmap <Esc>[200~ <nop>
    cmap <Esc>[201~ <nop>
endif
" }}}
" Trailing whitespace ------------- {{{
function! <SID>StripTrailingWhitespaces()
    if exists('b:noStripWhitespace')
        return
    endif
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
augroup allfiles_trailingspace
    autocmd!
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
    autocmd FileType markdown let b:noStripWhitespace=1
augroup END
" }}}
" Syntax coloring ---------------- {{{
try
    set t_Co=256 " says terminal has 256 colors
    let g:molokai_original = 1
    let g:rehash256 = 1
    colorscheme molokai
catch
endtry
" }}}
" Indentation settings -------------- {{{
" For yaml files
augroup yaml
    filetype plugin indent on
    autocmd Filetype yaml setlocal indentkeys-=<:>
augroup END

augroup jenkinsfile
    autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
augroup END

" Highlights files past 120 colums in python
augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

augroup indentation_sr
    autocmd!
    autocmd BufRead,BufNewFile * setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
    autocmd Filetype * setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
    autocmd Filetype dot setlocal autoindent cindent
augroup END

augroup indentation_dot
    autocmd!
    autocmd Filetype dot :setlocal autoindent cindent
augroup END

augroup TabsNotSpaces
    autocmd!
    autocmd BufRead,BufNewFile *.otl :setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
    autocmd BufRead,BufNewFile *GNUmakefile,*makefile,*Makefile :setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
augroup END
" }}}
