" vim:fdm=marker
" Initial Global Settings ------------ {{{
set nocompatible
" Highlight search
set hlsearch
" }}}
" Line 80 Column and cursor highlighting ----------------- {{{
set cursorline
set cursorcolumn

 if (exists('+colorcolumn'))
   let &colorcolumn="80,".join(range(80,500),",")
   highlight ColorColumn ctermbg=9
 endif
" }}}

" Plugs ----------------- {{{
call plug#begin('~/.vim/plugged')

" ***** Functional
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-eunuch'
Plug 'hynek/vim-python-pep8-indent'
" Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" ****** THEMES
Plug 'NLKNguyen/papercolor-theme'
" Plug 'tomasr/molokai'
" Plug 'morhetz/gruvbox'

" ***** Syntax Highlighters
Plug 'hdima/python-syntax'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
Plug 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
Plug 'hashivim/vim-vagrant'
Plug 'hashivim/vim-terraform'
Plug 'pearofducks/ansible-vim'
Plug 'lepture/vim-jinja'

" ***** AUTO
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/rainbow_parentheses.vim'
call plug#end()

" }}}
" Plug settings for Status Line (powerline, airline) ----------------- {{{
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
let g:airline#extensions#branch#enabled = 1
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
" Configure Rainbow ------------- {{{
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['{', '}'], ['(', ')'], ['[', ']']]
augroup rainbow_settings
  " Section to turn on rainbow parentheses
  autocmd!
  autocmd BufEnter,BufRead * :RainbowParentheses
  autocmd BufEnter,BufRead *.html,*.css :RainbowParentheses!
augroup END
" }}}
" PaperColor colorscheme---------------- {{{
try
    set t_Co=256 " says terminal has 256 colors
    set background=dark
    colorscheme PaperColor
    let g:airline_theme='papercolor'
catch
endtry
" }}}
" Molokai colorscheme---------------- {{{
"try
"   set t_Co=256 " says terminal has 256 colors
"   let g:molokai_original = 1
"   let g:rehash256 = 1
"catch
"endtry
" }}}
" Indentation settings -------------- {{{
" For yaml files
augroup yaml
    filetype plugin indent on
    autocmd Filetype yaml setlocal indentkeys-=<:>
augroup END

au BufNewFile, BufRead *.j2 set ft=jinja

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
