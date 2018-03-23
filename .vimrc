" vim:fdm=marker
" Initial Global Settings ------------ {{{
set nocompatible
" Highlight search
set hlsearch
" Set split below
set splitbelow
" remove swap file
set noswapfile
" Set paste toggle
set pastetoggle=<C-_>
" }}}
" Set Number {{{
function! ToggleRelativeNumber()
  if &rnu
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

function! RNUInsertEnter()
  if &rnu
    let b:line_number_state = 'rnu'
    set norelativenumber
  else
    let b:line_number_state = 'nornu'
  endif
endfunction

function! RNUInsertLeave()
  if b:line_number_state == 'rnu'
    set relativenumber
  else
    set norelativenumber
  endif
endfunction

function! RNUBufEnter()
  if exists('b:line_number_state')
    if b:line_number_state == 'rnu'
      set relativenumber
    else
      set norelativenumber
    endif
  else
    set relativenumber
    let b:line_number_state = 'rnu'
  endif
endfunction

function! RNUBufLeave()
  if &rnu
    let b:line_number_state = 'rnu'
  else
    let b:line_number_state = 'nornu'
  endif
  set norelativenumber
endfunction

" Set mappings for relative numbers

" Toggle relative number status
nnoremap <silent><leader>r :call ToggleRelativeNumber()<CR>
augroup rnu_nu
  autocmd!
  " Don't have relative numbers during insert mode
  autocmd InsertEnter * :call RNUInsertEnter()
  autocmd InsertLeave * :call RNUInsertLeave()
  " Set and unset relative numbers when buffer is active
  autocmd BufNew,BufEnter * :call RNUBufEnter()
  autocmd BufLeave * :call RNUBufLeave()
  autocmd BufNewFile,BufRead,BufEnter * set number
augroup end
" }}}
" Line 100 Column and cursor highlighting ----------------- {{{
set cursorline
set cursorcolumn

if exists('+colorcolumn')
  set colorcolumn=80
"  highlight ColorColumn ctermbg=245 guibg=lightgrey
"  let &colorcolumn="80,".join(range(80,500),",")
"  highlight ColorColumn ctermbg=13
endif
"}}}
" Plugs ----------------- {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ***** Functional
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'hynek/vim-python-pep8-indent'
Plug 'majutsushi/tagbar'
Plug 't9md/vim-choosewin'
Plug 'jamshedVesuna/vim-markdown-preview'
Plug 'tpope/vim-commentary'
Plug 'davidhalter/jedi-vim'

" ****** THEMES
Plug 'NLKNguyen/papercolor-theme'
" Plug 'flazz/vim-colorschemes'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'tomasr/molokai'
" Plug 'morhetz/gruvbox'

" ***** Syntax Highlighters
Plug 'hdima/python-syntax'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
Plug 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
Plug 'hashivim/vim-vagrant'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-vaultproject'
Plug 'pearofducks/ansible-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'lepture/vim-jinja'
Plug 'google/vim-searchindex'
Plug 'rust-lang/rust.vim'

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
" Choosewin Settings {{{
nmap - <Plug>(choosewin)
" }}}
" Key Remappings {{{
" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>"
" }}}
" Plug Settings for TagBar {{{
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'ansible',
    \ 'kinds' : [
    \ 't:tasks'
    \ ],
    \ 'sort' : 0
\ }

let g:tagbar_type_terraform = {
    \ 'ctagstype' : 'terraform',
    \ 'kinds' : [
    \ 'r:resources',
    \ 'm:modules',
    \ 'o:outputs',
    \ 'v:variables',
    \ 'f:tfvars'
    \ ],
    \ 'sort' : 0
    \ }
" }}}
" Plug settings for Nerdtree ----------------- {{{
map F2 for Nerdtree
map <F2> :NERDTreeToggle<CR>
let g:NERDTreeMapOpenInTab = '<C-t>'
let g:NERDTreeMapOpenInTabSilent = ''
let g:NERDTreeMapOpenSplit = '<C-s>'
let g:NERDTreeMapOpenVSplit = '<C-v>'
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeCaseSensitiveSort = 0
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 31
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeSortOrder = ['*', '\/$']
let g:NERDTreeIgnore=[
      \'venv$[[dir]]',
      \'__pycache__$[[dir]]',
      \'.egg-info$[[dir]]',
      \'node_modules$[[dir]]',
      \'elm-stuff$[[dir]]',
      \'\.aux$[[file]]',
      \'\.toc$[[file]]',
      \'\.pdf$[[file]]',
      \'\.out$[[file]]',
      \'\.o$[[file]]',
      \]

function! NERDTreeToggleCustom()
    if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
      " if NERDTree is open in window in current tab...
      exec 'NERDTreeClose'
    else
      exec 'NERDTree %'
    endif
endfunction

function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        \ || &buftype == 'quickfix'
    q
  endif
endfunction

augroup CloseIfOnlyControlWinLeft
  au!
  au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END
" }}}
" vim-go settings ------------------ {{{
let g:go_template_autocreate = 0
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
" Colorscheme---------------- {{{
try
    set t_Co=256 " says terminal has 256 colors
    set background=dark
    colorscheme PaperColor
    " Set background to black
    "highlight Normal ctermbg=NONE
    let g:airline_theme='papercolor'
catch
endtry
let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

" }}}
" vim-commentary settings {{{
autocmd FileType * setlocal commentstring=#\ %s
" }}}
" Indentation settings -------------- {{{
" Global Indents
augroup indentation_global
  autocmd!
  autocmd Filetype * setlocal expandtab sw=2 sts=4 ts=8
  autocmd Filetype python,c setlocal sw=4 sts=4 ts=8
augroup END

" Ansible indent
augroup yaml_autocmds
    autocmd BufNewFile,BufRead *.yaml set filetype=ansible
    autocmd BufNewFile,BufRead *.yml set filetype=ansible
augroup END

"golang indentation
augroup golang_autocmds
    autocmd BufNewFile,BufRead *.go :setlocal ts=8 sts=0 sw=8 noexpandtab
augroup END

augroup indentation_dot
    autocmd!
    autocmd Filetype dot :setlocal autoindent cindent
augroup END

augroup TabsNotSpaces
    autocmd!
    autocmd BufRead,BufNewFile *.otl :setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
    autocmd BufRead,BufNewFile *GNUmakefile,*makefile,*Makefile :setlocal ts=4 sts=0 sw=4 noexpandtab
augroup END
" }}}
" MACOSX SETTINGS {{{
if has('macunix')
  set backspace=indent,eol,start
endif
" }}}
" Key Remappings {{{
nnoremap T gT
nnoremap t gt
" }}}
" Terraform Syntax {{{
let g:terraform_align=1
" Use spacebar to fold/unfold resources
let g:terraform_remap_spacebar=1
" }}}
" python Syntax {{{

" Python: highlighting
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

" Highlight self and cls keyword in class definitions
augroup python_syntax
  autocmd!
  autocmd FileType python syn keyword pythonBuiltinObj self
  autocmd FileType python syn keyword pythonBuiltinObj cls
augroup end

" }}}
" javascript Syntax {{{
augroup javascript_complete
  autocmd!
  autocmd FileType javascript nnoremap <buffer> <C-]> :TernDef<CR>
augroup END
" Javascript:
let g:javascript_plugin_flow = 1

" Javascript: Highlight this keyword in object / function definitions
augroup javascript_syntax
  autocmd!
  autocmd FileType javascript syn keyword jsBooleanTrue this
  autocmd FileType javascript.jsx syn keyword jsBooleanTrue this
augroup end


" JSX: for .js files in addition to .jsx
 let g:jsx_ext_required = 0
" }}}
" jedi-vim recognize venv {{{
let g:virtual_auto_activate = 1
nmap - <Plug>(choosewin)
" }}}
