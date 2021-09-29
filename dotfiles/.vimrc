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

" redraw/refresh window on focus
augroup redraw_on_refocus
  au FocusGained * :redraw!
augroup END

" mouse mode in tmux
set mouse=a
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

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload')

" ***** Functional
" Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
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
Plug 'vim-scripts/groovyindent-unix' " groovy indentation
Plug '~/.fzf'
Plug 'tibabit/vim-templates'
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
for coc_plugin in [
      \ 'git@github.com:coc-extensions/coc-svelte.git',
      \ 'git@github.com:fannheyward/coc-markdownlint.git',
      \ 'git@github.com:josa42/coc-docker.git',
      \ 'git@github.com:neoclide/coc-css.git',
      \ 'git@github.com:neoclide/coc-html.git',
      \ 'git@github.com:neoclide/coc-json.git',
      \ 'git@github.com:neoclide/coc-pairs.git',
      \ 'git@github.com:pappasam/coc-jedi.git',
      \ 'git@github.com:neoclide/coc-rls.git',
      \ 'git@github.com:neoclide/coc-snippets.git',
      \ 'git@github.com:neoclide/coc-tsserver.git',
      \ 'git@github.com:neoclide/coc-yaml.git',
      \ ]
    Plug coc_plugin, {
          \ 'do': 'yarn install --frozen-lockfile' }
endfor

" ****** THEMES
Plug 'NLKNguyen/papercolor-theme'
Plug 'kristijanhusak/defx-icons'

" ***** Syntax Highlighters
Plug 'hdima/python-syntax'
Plug 'fatih/vim-go', { 'do': ':silent GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
Plug 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
Plug 'hashivim/vim-vagrant'
Plug 'hashivim/vim-terraform'
Plug 'rhadley-recurly/vim-terragrunt'
Plug 'hashivim/vim-vaultproject'
" Plug 'jvirtanen/vim-hcl'
Plug 'pearofducks/ansible-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'lepture/vim-jinja'
Plug 'google/vim-searchindex'
Plug 'rust-lang/rust.vim'
Plug 'aklt/plantuml-syntax'
Plug 'martinda/Jenkinsfile-vim-syntax'  "Jenkinsfile
Plug 'nginx/nginx', { 'rtp': 'contrib/vim' }

" ***** AUTO
Plug 'pappasam/vim-filetype-formatter'
Plug 'godlygeek/tabular'
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'

" ***** PREVIEWERS
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

call plug#end()

" }}}
" Functions ----- {{{
" General: spacesurround and pairs {{{

" Helper functions to format surrounding text as I type
" The function is: Surround<Key>, where key is the intended mapping key

" 1. Add two spaces around cursor when pressing space bar.
" 2. Spaces will be deleted if cursor is in middle with 1 space on either side.
"     For example: ( | ), pressing <bs> or <c-w> should delete surrounding
"     spaces
let s:surround_spaces = {
      \ '()': 1,
      \ '[]': 1,
      \ '{}': 1,
      \ }

function! SurroundSpace()
  let line_this = getline('.')
  let col_this = col('.')
  let char_left = line_this[col_this - 2]
  let char_right = line_this[col_this - 1]
  let left_right = char_left . char_right
  if has_key(s:surround_spaces, left_right)
    call feedkeys("\<space>\<space>\<left>", 'ni')
  else
    call feedkeys("\<space>", 'ni')
  endif
endfunction

" delete surround items if surrounding cursor with no space
" for example: (|)
" when pressing delete, surrounding parentheses will be deleted
let s:surround_delete = {
      \ "''": 1,
      \ '""': 1,
      \ '()': 1,
      \ '[]': 1,
      \ '{}': 1,
      \ }

function! SurroundBackspace()
  let line_this = getline('.')
  let col_this = col('.')
  let char_left = line_this[col_this - 3]
  let char_left_mid = line_this[col_this - 2]
  let char_right_mid = line_this[col_this - 1]
  let char_right = line_this[col_this]
  let mid_left_right = char_left_mid . char_right_mid
  let left_right = char_left . char_right
  if has_key(s:surround_delete, mid_left_right)
    call feedkeys("\<bs>\<right>\<bs>", 'ni')
  elseif mid_left_right != '  '
    call feedkeys("\<bs>", 'ni')
  elseif has_key(s:surround_spaces, left_right)
    execute "normal! \<right>di" . left_right[1]
  else
    call feedkeys("\<bs>", 'ni')
  endif
endfunction
" }}}
" Plug settings for Status Line (powerline, airline) ----------------- {{{
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2
let g:airline#extensions#branch#enabled = 1

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
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

" Package: defx {{{

" Override <C-w>H to delete defx buffers
nnoremap <C-w>H <cmd>windo if &filetype == 'defx' <bar> close <bar> endif<CR><C-w>H

let g:custom_defx_state = tempname()

let g:defx_ignored_files = join([
      \ '*.aux',
      \ '*.egg-info/',
      \ '*.o',
      \ '*.out',
      \ '*.pdf',
      \ '*.pyc',
      \ '*.toc',
      \ '.*',
      \ '__pycache__/',
      \ 'build/',
      \ 'dist/',
      \ 'docs/_build/',
      \ 'fonts/',
      \ 'node_modules/',
      \ 'pip-wheel-metadata/',
      \ 'plantuml-images/',
      \ 'site/',
      \ 'target/',
      \ 'venv.bak/',
      \ 'venv/',
      \ ], ',')

let g:custom_defx_mappings = [
      \ ['!             ', "defx#do_action('execute_command')"],
      \ ['*             ', "defx#do_action('toggle_select_all')"],
      \ [';             ', "defx#do_action('repeat')"],
      \ ['<2-LeftMouse> ', "defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')"],
      \ ['<C-g>         ', "defx#do_action('print')"],
      \ ['<C-h>         ', "defx#do_action('resize', 31)"],
      \ ['<C-i>         ', "defx#do_action('open_directory')"],
      \ ['<C-o>         ', "defx#do_action('cd', ['..'])"],
      \ ['<C-r>         ', "defx#do_action('redraw')"],
      \ ['<C-t>         ', "defx#do_action('open', 'tabe')"],
      \ ['<C-v>         ', "defx#do_action('open', 'vsplit')"],
      \ ['<C-x>         ', "defx#do_action('drop', 'split')"],
      \ ['<CR>          ', "defx#do_action('drop')"],
      \ ['<RightMouse>  ', "defx#do_action('cd', ['..'])"],
      \ ['O             ', "defx#do_action('open_tree', 'recursive:3')"],
      \ ['p             ', "defx#do_action('preview')"],
      \ ['a             ', "defx#do_action('toggle_select')"],
      \ ['cc            ', "defx#do_action('copy')"],
      \ ['cd            ', "defx#do_action('change_vim_cwd')"],
      \ ['i             ', "defx#do_action('toggle_ignored_files')"],
      \ ['ma            ', "defx#do_action('new_file')"],
      \ ['md            ', "defx#do_action('remove')"],
      \ ['mm            ', "defx#do_action('rename')"],
      \ ['o             ', "defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')"],
      \ ['P             ', "defx#do_action('paste')"],
      \ ['q             ', "defx#do_action('quit')"],
      \ ['ss            ', "defx#do_action('multi', [['toggle_sort', 'TIME'], 'redraw'])"],
      \ ['t             ', "defx#do_action('open_tree', 'toggle')"],
      \ ['u             ', "defx#do_action('cd', ['..'])"],
      \ ['x             ', "defx#do_action('execute_system')"],
      \ ['yy            ', "defx#do_action('yank_path')"],
      \ ['~             ', "defx#do_action('cd')"],
      \ ]

function! s:autocmd_custom_defx()
  if !exists('g:loaded_defx')
    return
  endif
  call defx#custom#column('filename', {
        \ 'min_width': 100,
        \ 'max_width': 100,
        \ })
endfunction

function! s:open_defx_if_directory()
  if !exists('g:loaded_defx')
    echom 'Defx not installed, skipping...'
    return
  endif
  if isdirectory(expand(expand('%:p')))
    Defx `expand('%:p')`
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:filename:type:size:time
  endif
endfunction

function! s:defx_redraw()
  if !exists('g:loaded_defx')
    return
  endif
  call defx#redraw()
endfunction

function! s:defx_buffer_remappings() abort
  " Define mappings
  for [key, value] in g:custom_defx_mappings
    execute 'nnoremap <silent><buffer><expr> ' . key . ' ' . value
  endfor
  nnoremap <silent><buffer> ?
        \ :for [key, value] in g:custom_defx_mappings <BAR>
        \ echo '' . key . ': ' . value <BAR>
        \ endfor<CR>
endfunction

augroup custom_defx
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_defx()
  autocmd BufEnter * call s:open_defx_if_directory()
  autocmd BufLeave,BufWinLeave \[defx\]* silent call defx#call_action('add_session')
  autocmd FileType defx setlocal nonumber norelativenumber
augroup end

augroup custom_remap_defx
  autocmd!
  autocmd FileType defx call s:defx_buffer_remappings()
  autocmd FileType defx nmap     <buffer> <silent> gp <Plug>(defx-git-prev)
  autocmd FileType defx nmap     <buffer> <silent> gn <Plug>(defx-git-next)
  autocmd FileType defx nmap     <buffer> <silent> gs <Plug>(defx-git-stage)
  autocmd FileType defx nmap     <buffer> <silent> gu <Plug>(defx-git-reset)
  autocmd FileType defx nmap     <buffer> <silent> gd <Plug>(defx-git-discard)
  autocmd FileType defx nnoremap <buffer> <silent> <C-l> <cmd>ResizeWindowWidth<CR>
augroup end
" }}}

" " Plug settings for Nerdtree ----------------- {{{
" map F2 for Nerdtree
" map <F2> :NERDTreeToggle<CR>
" let g:NERDTreeMapOpenInTab = '<C-t>'
" let g:NERDTreeMapOpenInTabSilent = ''
" let g:NERDTreeMapOpenSplit = '<C-s>'
" let g:NERDTreeMapOpenVSplit = '<C-v>'
" let g:NERDTreeShowLineNumbers = 1
" let g:NERDTreeCaseSensitiveSort = 0
" let g:NERDTreeWinPos = 'left'
" let g:NERDTreeWinSize = 31
" let g:NERDTreeAutoDeleteBuffer = 1
" let g:NERDTreeSortOrder = ['*', '\/$']
" let g:NERDTreeIgnore=[
"       \'venv$[[dir]]',
"       \'.terraform$[[dir]]',
"       \'__pycache__$[[dir]]',
"       \'.egg-info$[[dir]]',
"       \'node_modules$[[dir]]',
"       \'elm-stuff$[[dir]]',
"       \'\.aux$[[file]]',
"       \'\.toc$[[file]]',
"       \'\.pdf$[[file]]',
"       \'\.out$[[file]]',
"       \'\.o$[[file]]',
"       \]

" function! NERDTreeToggleCustom()
"     if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
"       " if NERDTree is open in window in current tab...
"       exec 'NERDTreeClose'
"     else
"       exec 'NERDTree %'
"     endif
" endfunction

" function! s:CloseIfOnlyControlWinLeft()
"   if winnr("$") != 1
"     return
"   endif
"   if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
"         \ || &buftype == 'quickfix'
"     q
"   endif
" endfunction

" augroup CloseIfOnlyControlWinLeft
"   au!
"   au BufEnter * call s:CloseIfOnlyControlWinLeft()
" augroup END
" " }}}
" vim-go settings ------------------ {{{
let g:go_template_autocreate = 0
" }}}
" vim-commentary ------------------ {{{
autocmd Filetype terraform setlocal commentstring=#\ %s
au BufRead,BufNewFile *.hcl set filetype=hcl
autocmd Filetype hcl setlocal commentstring=#\ %s
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
" PaperColor settings---------------- {{{
let g:PaperColor_Theme_Options = {}
let g:PaperColor_Theme_Options['theme'] = {
      \     'default': {
      \       'allow_bold': 1,
      \       'allow_italic': 1
      \     }
      \ }
let g:PaperColor_Theme_Options = {
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

try
    syntax on
    set termguicolors
    set t_Co=256 " says terminal has 256 colors
    set background=dark
    colorscheme PaperColor
    " Set background to black
    "highlight Normal ctermbg=NONE
    let g:airline_theme = 'papercolor'
catch
endtry

" }}}
" defx-icon settings {{{

" }}}
" vim-go settings {{{
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Open :GoDeclsDir with ctrl-g
" nmap <C-g> :GoDeclsDir<cr>
" imap <C-g> <esc>:<C-u>GoDeclsDir<cr>


augroup go
  autocmd!

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
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

let g:vim_markdown_folding_disabled=1
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

let g:terraform_fold_sections = 0

let g:terraform_fmt_on_save = 1
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

" " Omnicompletion:
" " <C-@> is signal sent by terminal when pressing <C-Space>
" " Need to include <C-Space> as well for neovim sometimes
" inoremap <C-@> <C-x><C-o>
" inoremap <C-space> <C-x><C-o>

" let g:jedi#auto_vim_configuration = 0
" let g:jedi#goto_command = "<C-]>"
" let g:jedi#documentation_command = "<leader>sd"
" let g:jedi#usages_command = "<leader>su"
" let g:jedi#rename_command = "<leader>sr"


" augroup vimscript_complete
"   autocmd!
"   autocmd FileType vim nnoremap <buffer> <C-]> yiw:help <C-r>"<CR>
"   autocmd FileType vim inoremap <buffer> <C-@> <C-x><C-v>
"   autocmd FileType vim inoremap <buffer> <C-space> <C-x><C-v>
" augroup END

" let g:virtual_auto_activate = 1

" Syntatistic Config for terraform autocomplete
" REQUIREMENTS:
" apt install ruby-dev
" gem install json neovim
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
" let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
" let g:terraform_registry_module_completion = 0

" vim-filetype-formatter settings
let g:vim_filetype_formatter_commands = {
      \ 'python': 'black -q -',
      \ 'rust': 'rustfmt'
      \}

" Plugin: Markdown-preview.vim {{{
let g:mkdp_browser = 'firefox'
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0

" set to 1, the vim will just refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it just can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle'
      \ }

" }}}
" Plugin: Preview Compiled Stuff in Viewer {{{

function! _Preview()
  if &filetype ==? 'rst'
    exec 'terminal restview %'
    exec "normal \<C-O>"
  elseif &filetype ==? 'markdown'
    " from markdown-preview.vim
    exec 'MarkdownPreview'
  elseif &filetype ==? 'dot'
    " from wmgraphviz.vim
    exec 'GraphvizInteractive'
  elseif &filetype ==? 'plantuml'
    " from plantuml-previewer.vim
    exec 'PlantumlOpen'
  else
    echo 'Preview not supported for this filetype'
  endif
endfunction
command! Preview call _Preview()

" }}}
" better-whitespace settings {{{
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
" }}}

" coc settings {{{
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" }}}
" General: mappings {{{

let mapleader = ','

function! s:default_key_mappings()
  " Coc: settings for coc.nvim
  nmap     <silent>        <C-]> <Plug>(coc-definition)
  nmap     <silent>        <C-LeftMouse> <Plug>(coc-definition)
  nnoremap <silent>        <C-k> <cmd>call <SID>show_documentation()<CR>
  inoremap <silent>        <C-s> <cmd>call CocActionAsync('showSignatureHelp')<CR>
  nmap     <silent>        <leader>st <Plug>(coc-type-definition)
  nmap     <silent>        <leader>si <Plug>(coc-implementation)
  nmap     <silent>        <leader>su <Plug>(coc-references)
  nmap     <silent>        <leader>sr <Plug>(coc-rename)
  nmap     <silent>        <leader>sa v<Plug>(coc-codeaction-selected)
  vmap     <silent>        <leader>sa <Plug>(coc-codeaction-selected)
  nnoremap <silent>        <leader>sn <cmd>CocNext<CR>
  nnoremap <silent>        <leader>sp <cmd>CocPrev<CR>
  nnoremap <silent>        <leader>sl <cmd>CocListResume<CR>
  nnoremap <silent>        <leader>sc <cmd>CocList commands<cr>
  nnoremap <silent>        <leader>so <cmd>CocList -A outline<cr>
  nnoremap <silent>        <leader>sw <cmd>CocList -A -I symbols<cr>
  inoremap <silent> <expr> <c-space> coc#refresh()

  nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  nnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"
  inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-e>"
  inoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-y>"
  vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  vnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"

  imap     <silent> <expr> <C-l> coc#expandable() ? "<Plug>(coc-snippets-expand)" : "\<C-y>"
  inoremap <silent> <expr> <CR> pumvisible() ? '<CR>' : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'
  nnoremap                 <leader>d <cmd>call CocActionAsync('diagnosticToggle')<CR>
  nnoremap                 <leader>D <cmd>call CocActionAsync('diagnosticPreview')<CR>
  nmap     <silent>        ]g <Plug>(coc-diagnostic-next)
  nmap     <silent>        [g <Plug>(coc-diagnostic-prev)

  " Pairs: Utilities for dealing with pairs
  " NOTE: <C-w><C-p> gets you in, and out, of floating windows
  inoremap <silent>        <space>  <cmd>call SurroundSpace()<CR>
  inoremap <silent>        <bs>     <cmd>call SurroundBackspace()<CR>
  inoremap <silent>        <C-h>    <cmd>call SurroundBackspace()<CR>
  inoremap <silent>        <C-w>    <cmd>call SurroundCw()<CR>
  inoremap <silent>        }        <cmd>call SurroundPairCloseJump('{' , '}' )<CR>
  inoremap <silent>        )        <cmd>call SurroundPairCloseJump('(' , ')' )<CR>
  inoremap <silent>        ]        <cmd>call SurroundPairCloseJump('\[', '\]')<CR>

  " Escape: also clears highlighting
  nnoremap <silent> <esc> :noh<return><esc>

  " J: unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " SearchBackward: remap comma to single quote
  nnoremap ' ,

  " Exit: Preview, Help, QuickFix, and Location List
  inoremap <silent> <C-c> <Esc>:pclose <BAR> cclose <BAR> lclose <CR>a
  nnoremap <silent> <C-c> :pclose <BAR> cclose <BAR> lclose <CR>

  " InsertModeHelpers: Insert one line above after enter
  inoremap <M-CR> <CR><C-o>O

  " MoveVisual: up and down visually only if count is specified before
  nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j v:count == 0 ? 'gj' : 'j'

  " Macro Repeater:
  " Enable calling a function within the mapping for @
  nnoremap <expr> <plug>@init AtInit()
  " A macro could, albeit unusually, end in Insert mode.
  inoremap <expr> <plug>@init "\<c-o>".AtInit()
  nnoremap <expr> <plug>qstop QStop()
  inoremap <expr> <plug>qstop "\<c-o>".QStop()
  " The following code allows pressing . immediately after
  " recording a macro to play it back.
  nmap <expr> @ AtReg()
  " Finally, remap q! Recursion is actually useful here I think,
  " otherwise I would use 'nnoremap'.
  nmap <expr> q QStart()

  " MoveTabs: goto tab number. Same as Firefox
  nnoremap <A-1> 1gt
  nnoremap <A-2> 2gt
  nnoremap <A-3> 3gt
  nnoremap <A-4> 4gt
  nnoremap <A-5> 5gt
  nnoremap <A-6> 6gt
  nnoremap <A-7> 7gt
  nnoremap <A-8> 8gt
  nnoremap <A-9> 9gt

  " Substitute: replace word under cursor
  nnoremap <leader><leader>s yiw:%s/\<<C-R>0\>//g<Left><Left>
  vnoremap <leader><leader>s y:%s/<C-R>0//g<Left><Left>

  " IndentComma: placing commas one line down; usable with repeat operator '.'
  nnoremap <silent> <Plug>NewLineComma f,wi<CR><Esc>
        \:call repeat#set("\<Plug>NewLineComma")<CR>
  nmap <leader><CR> <Plug>NewLineComma

  " Jinja2Toggle: the following mapping toggles jinja2 for any filetype
  nnoremap <silent> <leader><leader>j <cmd>Jinja2Toggle<CR>

  " ToggleRelativeNumber: uses custom functions
  nnoremap <silent> <leader>R <cmd>ToggleNumber<CR>
  nnoremap <silent> <leader>r <cmd>ToggleRelativeNumber<CR>

  " TogglePluginWindows:
  nnoremap <silent> <space>j <cmd>Defx
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:space:filename:type
        \ -direction=topleft
        \ -search=`expand('%:p')`
        \ -session-file=`g:custom_defx_state`
        \ -ignored-files=`g:defx_ignored_files`
        \ -split=vertical
        \ -toggle
        \ -floating-preview
        \ -vertical-preview
        \ -preview-height=50
        \ -preview-width=85
        \ -winwidth=31
        \ -root-marker=''
        \ <CR>
  nnoremap <silent> <space>J <cmd>Defx `expand('%:p:h')`
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:space:filename:type
        \ -direction=topleft
        \ -search=`expand('%:p')`
        \ -ignored-files=`g:defx_ignored_files`
        \ -split=vertical
        \ -floating-preview
        \ -vertical-preview
        \ -preview-height=50
        \ -preview-width=85
        \ -winwidth=31
        \ -root-marker=''
        \ <CR>
  nnoremap <silent> <space>l <cmd>Vista!!<CR>
  nnoremap <silent> <space>L <cmd>Vista focus<CR>
  nnoremap <silent> <space>u <cmd>UndotreeToggle<CR>

  " Override <C-w>H to delete defx buffers
  nnoremap <C-w>H <cmd>windo if &filetype == 'defx' <bar> close <bar> endif<CR><C-w>H

  " IndentLines: toggle if indent lines is visible
  nnoremap <silent> <leader>i <cmd>IndentLinesToggle<CR>

  " ResizeWindow: up and down; relies on custom functions
  nnoremap <silent> <leader><leader>h <cmd>ResizeWindowHeight<CR>
  nnoremap <silent> <leader><leader>w <cmd>ResizeWindowWidth<CR>

  " Sandwich: below mappings address the issue raised here:
  " https://github.com/machakann/vim-sandwich/issues/62
  xmap s  <Nop>
  omap s  <Nop>
  xmap ib <Plug>(textobj-sandwich-auto-i)
  omap ib <Plug>(textobj-sandwich-auto-i)
  xmap ab <Plug>(textobj-sandwich-auto-a)
  omap ab <Plug>(textobj-sandwich-auto-a)
  xmap iq <Plug>(textobj-sandwich-query-i)
  omap iq <Plug>(textobj-sandwich-query-i)
  xmap aq <Plug>(textobj-sandwich-query-a)
  omap aq <Plug>(textobj-sandwich-query-a)

  " FZF: create shortcuts for finding stuff
  nnoremap <silent> <C-p><C-p> <cmd>call <SID>fzf_avoid_defx('Files')<CR>
  nnoremap <silent> <C-p><C-b> <cmd>call <SID>fzf_avoid_defx('Buffers')<CR>
  nnoremap          <C-n><C-n> yiw:Rg <C-r>"<CR>
  vnoremap          <C-n><C-n> y:Rg <C-r>"<CR>

  " FiletypeFormat: remap leader f to do filetype formatting
  nnoremap <silent> <leader>f <cmd>FiletypeFormat<cr>
  vnoremap <silent> <leader>f :FiletypeFormat<cr>

  " " " Open Browser: override netrw
  " " nmap gx <Plug>(openbrowser-smart-search)
  " " vmap gx <Plug>(openbrowser-smart-search)

  " " GitMessenger:
  " nmap <leader>sg <Plug>(git-messenger)

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Mouse Configuration: remaps mouse to work better in terminal

  " Out Jump List: <C-RightMouse> already mapped to something like <C-t>
  nnoremap <RightMouse> <C-o>

  " Clipboard Copy: Visual mode copy is pretty simple
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y

  " Mouse Copy: system copy mouse characteristics
  vnoremap <RightMouse> "+y

  " Mouse Paste: make it come from the system register
  nnoremap <MiddleMouse> "+<MiddleMouse>

  " Scrolling Dropdown: dropdown scrollable + click to select highlighted
  inoremap <expr> <S-ScrollWheelUp>   pumvisible() ? '<C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p>' : '<Esc><S-ScrollWheelUp>'
  inoremap <expr> <S-ScrollWheelDown> pumvisible() ? '<C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n>' : '<Esc><S-ScrollWheelDown>'
  inoremap <expr> <ScrollWheelUp>     pumvisible() ? '<C-p>' : '<Esc><ScrollWheelUp>'
  inoremap <expr> <ScrollWheelDown>   pumvisible() ? '<C-n>' : '<Esc><ScrollWheelDown>'
  inoremap <expr> <LeftMouse>         pumvisible() ? '<CR><Backspace>' : '<Esc><LeftMouse>'

  " Auto-execute all filetypes
  let &filetype=&filetype
endfunction

call s:default_key_mappings()

" Simple remap to update terraform lines to first class expressions
vnoremap <C-t> :'<,'>!tr -d '"{$}'<CR>
" lens.vim settings {{{
let g:lens#animate = 0
let g:lens#disabled_filetypes = ['nerdtree', 'fzf', 'defx']
" }}}
" Package: treesitter {{{

function s:init_treesitter()
  if !exists('g:loaded_nvim_treesitter')
    echom 'nvim-treesitter does not exist, skipping...'
    return
  endif
lua << EOF
-- nvim-treesitter/queries/python/injections.scm, with docstring
-- injections removed
local py_injections = [[
((call
  function: (attribute object: (identifier) @_re)
  arguments: (argument_list (string) @regex))
 (#eq? @_re "re")
 (#match? @regex "^r.*"))

(comment) @comment
]]
vim.treesitter.set_query('python', 'injections', py_injections)
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
      },
    },
  },
  ensure_installed = {
    'bash',
    'c',
    'css',
    'gdscript',
    'go',
    'graphql',
    'html',
    'java',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'julia',
    'ledger',
    'lua',
    'ocaml',
    'php',
    'python',
    'query',
    'regex',
    'rst',
    'ruby',
    'rust',
    'svelte',
    'toml',
    'tsx',
    'typescript',
}})
EOF
endfunction

augroup custom_treesitter
  autocmd!
  autocmd VimEnter * call s:init_treesitter()
augroup end

" }}}
