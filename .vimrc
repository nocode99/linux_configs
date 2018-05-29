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
" set mapleader
let mapleader = ","
" let maplocalleader = "\\"

" Set line numbers
set number
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

" Autoinstall vim-plug for vim and neovim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'

" ****** THEMES
Plug 'NLKNguyen/papercolor-theme'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" Plug 'flazz/vim-colorschemes'
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
Plug 'aklt/plantuml-syntax'
Plug 'vim-syntastic/syntastic'

" ***** AUTO
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'juliosueiras/vim-terraform-completion'
call plug#end()

" }}}
" Plug settings for Status Line (powerline, airline) ----------------- {{{
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
let g:airline#extensions#branch#enabled = 1
" }}}
" Choosewin Settings {{{
nmap \ <Plug>(choosewin)
" }}}
" Key Remappings {{{
" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>"
" }}}
" Plug Settings for TagBar {{{
nnoremap <silent> <space>l :TagbarToggle <CR>

let g:tagbar_map_showproto = '`'
let g:tagbar_show_linenumbers = -1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1
let g:tagbar_sort = 0  " order by order in sort file
let g:tagbar_case_insensitive = 1
let g:tagbar_width = 50
let g:tagbar_silent = 1
let g:tagbar_foldlevel = 0
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
      \'.terraform$[[dir]]',
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
    let g:airline_theme = 'papercolor
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
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType terraform setlocal commentstring=#%s
autocmd FileType plantuml setlocal commentstring='%s
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
    autocmd BufNewFile,BufRead *.yaml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead *.yml set filetype=yaml.ansible
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
" ansible Syntax {{{
let g:ansible_unindent_after_newline = 1

let g:ansible_attribute_highlight = "ob"

let g:ansible_extra_keywords_highlight = 1
" }}}
" terraform Syntax {{{
let g:terraform_align = 1

let g:terraform_fold_sections = 1

let g:terraform_remap_spacebar = 1
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
" autocomplete settings {{{

"A comma separated list of options for Insert mode completion
"   menuone  Use the popup menu also when there is only one match.
"            Useful when there is additional information about the
"            match, e.g., what file it comes from.

"   longest  Only insert the longest common text of the matches.  If
"            the menu is displayed you can use CTRL-L to add more
"            characters.  Whether case is ignored depends on the kind
"            of completion.  For buffer text the 'ignorecase' option is
"            used.

"   preview  Show extra information about the currently selected
"            completion in the preview window.  Only works in
"            combination with 'menu' or 'menuone'.
" courtesy of pappasam
set completeopt=menuone,longest,preview

" Omnicompletion:
" <C-@> is signal sent by terminal when pressing <C-Space>
" Need to include <C-Space> as well for neovim sometimes
inoremap <C-@> <C-x><C-o>
inoremap <C-space> <C-x><C-o>

let g:jedi#auto_vim_configuration = 0
let g:jedi#goto_command = "<C-]>"
let g:jedi#documentation_command = "<leader>sd"
let g:jedi#usages_command = "<leader>su"
let g:jedi#rename_command = "<leader>sr"


augroup vimscript_complete
  autocmd!
  autocmd FileType vim nnoremap <buffer> <C-]> yiw:help <C-r>"<CR>
  autocmd FileType vim inoremap <buffer> <C-@> <C-x><C-v>
  autocmd FileType vim inoremap <buffer> <C-space> <C-x><C-v>
augroup END

let g:virtual_auto_activate = 1

" Syntatistic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
" let g:terraform_registry_module_completion = 0

" Terraform
augroup terraform_complete
  autocmd FileType terraform setlocal omnifunc=terraformcomplete#Complete
augroup END
" }}}
