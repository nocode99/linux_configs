" Usage: toggle fold in Vim with 'za'. 'zR' to open all folds, 'zM' to close
" General: options {{{

" Enable filetype detection, plugin loading, and indentation loading
filetype plugin indent on

" Code Completion:
set completeopt=menuone,longest wildmode=longest:full wildmenu

" Messages:
" c = don't give |ins-completion-menu| messages; they're noisy
" I = ignore startup message
set shortmess+=c shortmess+=I

" Hidden Buffer: enable instead of having to write each buffer
set hidden

" Sign Column: always show it
set signcolumn=number

set cursorline

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set noswapfile

" Command Line Height: higher for display for messages
set cmdheight=2

" Line Wrapping: do not wrap lines by default
set nowrap linebreak

" Indentation:
set expandtab autoindent smartindent shiftwidth=2 softtabstop=2 tabstop=8

" Filename: for gf (@-@='@', see: https://stackoverflow.com/a/45244758)
set isfname+=@-@ isfname+=:

" Highlight Search: do that
" note: hlsearch and nohlsearch are defined in autocmd outside function
set incsearch inccommand=nosplit

" Spell Checking:
set spelllang=en_us

" Single Space After Punctuation: useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

set autoread

set grepprg=rg\ --vimgrep

" Paste: this is actually typed <C-/>, but term nvim thinks this is <C-_>
set pastetoggle=<C-_>

" Don't timeout on mappings
set notimeout

" Numbering:
set number

" Window Splitting: Set split settings (options: splitright, splitbelow)
set splitright

" Terminal Color Support: only set guicursor if truecolor
if $COLORTERM ==# 'truecolor'
  set termguicolors
else
  set guicursor=
endif

" Set Background: defaults to dark
set background=dark

" Colorcolumn:
set colorcolumn=80

" Status Line: specifics for custom status line
set laststatus=2 ttimeoutlen=50 noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" Updatetime: time Vim waits to do something after I stop moving
set updatetime=300

" Linux Dev Path: system libraries
set path+=/usr/include/x86_64-linux-gnu/

" Vim History: for command line; can't imagine that more than 100 is needed
set history=100

" Set the diff expression to EnhancedDiff
set diffopt+=internal,algorithm:patience

" Folding
set foldenable foldmethod=marker foldnestmax=1

" Redraw Window: whenever a window regains focus
augroup custom_redraw_on_refocus
  autocmd!
  autocmd FocusGained * redraw!
augroup end

augroup custom_incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  " autocmd CmdlineLeave /,\? set nohlsearch
augroup end

augroup custom_nginx
  autocmd!
  autocmd FileType nginx set iskeyword+=$
  autocmd FileType zsh,sh set iskeyword+=-
augroup end

" }}}
" General: package management {{{

" Available Commands:
"   PackagerStatus, PackagerInstall, PackagerUpdate, PackagerClean

function! s:packager_init(packager) abort
  call a:packager.add('https://github.com/kristijanhusak/vim-packager', {'type': 'opt'})

  " Autocompletion And IDE Features:
  call a:packager.add('https://github.com/neoclide/coc.nvim.git', {'do': 'yarn install --frozen-lockfile'})

  " TreeSitter:
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter.git', {'do': ':TSUpdate'})
  call a:packager.add('https://github.com/lewis6991/spellsitter.nvim.git')
  call a:packager.add('https://github.com/nvim-treesitter/playground.git')
  call a:packager.add('https://github.com/windwp/nvim-ts-autotag.git')
  call a:packager.add('https://github.com/JoosepAlviste/nvim-ts-context-commentstring.git', {'requires': [
      \ 'https://github.com/tpope/vim-commentary',
      \ ]})

  " Tree:
  call a:packager.add('https://github.com/kyazdani42/nvim-tree.lua.git', {'requires': [
      \ 'https://github.com/kyazdani42/nvim-web-devicons.git',
      \ ]})

  " General:
  call a:packager.add('https://github.com/unblevable/quick-scope')
  call a:packager.add('https://github.com/windwp/nvim-autopairs.git')
  call a:packager.add('https://github.com/machakann/vim-sandwich')
  call a:packager.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:packager.add('https://github.com/t9md/vim-choosewin')

  " Fuzzy Finder:
  call a:packager.add('https://github.com/nvim-telescope/telescope.nvim.git', {'requires': [
      \ 'https://github.com/nvim-lua/plenary.nvim.git',
      \ ]})

  " Git:
  call a:packager.add('https://github.com/tpope/vim-fugitive')
  call a:packager.add('https://github.com/lewis6991/gitsigns.nvim.git')

  " Previewers:
  call a:packager.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})
  call a:packager.add('https://github.com/weirongxu/plantuml-previewer.vim', {'requires': [
      \ 'https://github.com/tyru/open-browser.vim',
      \ ]})

  " Code Formatters:
  call a:packager.add('https://github.com/pappasam/vim-filetype-formatter')

  " Syntax Theme:
  call a:packager.add('https://github.com/folke/tokyonight.nvim')
  call a:packager.add('https://github.com/LunarVim/lunar.nvim')

  " Syntax Highlighting & Indentation:
  call a:packager.add('https://github.com/evanleck/vim-svelte.git', {'requires': [
      \ 'https://github.com/cakebaker/scss-syntax.vim.git',
      \ 'https://github.com/groenewege/vim-less.git',
      \ 'https://github.com/leafgarland/typescript-vim.git',
      \ 'https://github.com/othree/html5.vim.git',
      \ 'https://github.com/pangloss/vim-javascript.git',
      \ ]})
  call a:packager.add('https://github.com/Vimjas/vim-python-pep8-indent')
  call a:packager.add('https://github.com/Yggdroot/indentLine')
  call a:packager.add('https://github.com/aklt/plantuml-syntax.git')
  call a:packager.add('https://github.com/chr4/nginx.vim.git')
  " terraform
  call a:packager.add('https://github.com/hashivim/vim-hashicorp-tools')
  call a:packager.add('https://github.com/hashivim/vim-terraform')
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'), {
      \ 'window_cmd': 'edit',
      \ })

" }}}
" General: key mappings {{{

let mapleader = ','

function! s:default_key_mappings()
  " Coc: settings for coc.nvim
  nmap     <silent>        <C-]> <Plug>(coc-definition)
  nnoremap <silent>        <C-k> <Cmd>call CocActionAsync('doHover')<CR>
  inoremap <silent>        <C-s> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
  nnoremap <silent>        <C-w>f <Cmd>call coc#float#jump()<CR>
  nmap     <silent>        <leader>st <Plug>(coc-type-definition)
  nmap     <silent>        <leader>si <Plug>(coc-implementation)
  nmap     <silent>        <leader>su <Plug>(coc-references)
  nmap     <silent>        <leader>sr <Plug>(coc-rename)
  nmap     <silent>        <leader>sa v<Plug>(coc-codeaction-selected)
  vmap     <silent>        <leader>sa <Plug>(coc-codeaction-selected)
  nnoremap <silent>        <leader>sn <Cmd>CocNext<CR>
  nnoremap <silent>        <leader>sp <Cmd>CocPrev<CR>
  nnoremap <silent>        <leader>sl <Cmd>CocListResume<CR>
  nnoremap <silent>        <leader>sc <Cmd>CocList commands<cr>
  nnoremap <silent>        <leader>so <Cmd>CocList -A outline<cr>
  nnoremap <silent>        <leader>sw <Cmd>CocList -A -I symbols<cr>
  inoremap <silent> <expr> <c-space> coc#refresh()
  inoremap <silent> <expr> <CR> pumvisible() ? '<CR>' : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'
  nnoremap                 <leader>d <Cmd>call CocActionAsync('diagnosticToggle')<CR>
  nnoremap                 <leader>D <Cmd>call CocActionAsync('diagnosticPreview')<CR>
  nmap     <silent>        ]g <Plug>(coc-diagnostic-next)
  nmap     <silent>        [g <Plug>(coc-diagnostic-prev)

  " Toggle gitsigns
  nnoremap <silent> <leader>g <Cmd>GitsignsToggle<CR>

  " Escape: also clears highlighting
  nnoremap <silent> <esc> <Cmd>noh<return><esc>

  " J: unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " SearchBackward: remap comma to single quote
  nnoremap ' ,

  " MoveVisual: up and down visually only if count is specified before
  nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j v:count == 0 ? 'gj' : 'j'

  " TogglePluginWindows:
  nnoremap <silent> <space>j <Cmd>NvimTreeFindFileToggle<CR>
  nnoremap <silent> <space>J <Cmd>NvimTreeToggle<CR>
  nnoremap <silent> <space>l <Cmd>call <SID>coc_toggle_outline()<CR>

  " IndentLines: toggle if indent lines is visible
  nnoremap <silent> <leader>i <Cmd>IndentLinesToggle<CR>

  " Telescope: create shortcuts for finding stuff
  nnoremap <silent> <C-p><C-p> <Cmd>Telescope find_files hidden=true<CR>
  nnoremap <silent> <C-p><C-b> <Cmd>Telescope buffers<CR>
  nnoremap <silent> <C-n><C-n> <Cmd>Telescope live_grep<CR>
  nnoremap <silent> <C-n><C-w> <Cmd>Telescope grep_string<CR>

  " FiletypeFormat: remap leader f to do filetype formatting
  nnoremap <silent> <leader>f <Cmd>FiletypeFormat<cr>
  vnoremap <silent> <leader>f :FiletypeFormat<cr>

  " Sandwich: plugin-recommended mappings
  nmap s <Nop>
  xmap s <Nop>

  " Open GitHub ssh url
  nnoremap gx <Cmd>call <SID>gx_improved()<CR>

  " Clipboard Copy: Visual mode copy is pretty simple
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y

  " Auto-execute all filetypes
  let &filetype=&filetype

  " choosewin
  nmap \ <Plug>(choosewin)

endfunction

call s:default_key_mappings()

augroup custom_remap_man_help
  autocmd!
  autocmd FileType man,help nnoremap <buffer> <silent> <C-]> <C-]>
augroup end

augroup custom_remap_nvim_tree_lua
  autocmd!
  autocmd FileType NvimTree nnoremap <buffer> <silent> <C-l> <Cmd>NvimTreeResize +2<CR>
  autocmd FileType NvimTree nnoremap <buffer> <silent> <C-h> <Cmd>NvimTreeResize -2<CR>
augroup end

" }}}
" Package: language server protocol (LSP) with coc.nvim {{{

let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
let g:coc_start_at_startup = 1
let g:coc_filetype_map = {
      \ 'markdown.mdx': 'markdown',
      \ 'yaml.ansible': 'yaml',
      \ 'yaml.docker-compose': 'yaml',
      \ 'jinja.html': 'html',
      \ }

" Coc Global Extensions: automatically installed on Vim open
let g:coc_global_extensions = [
      \ '@yaegassy/coc-nginx',
      \ 'coc-css',
      \ 'coc-dictionary',
      \ 'coc-docker',
      \ 'coc-emoji',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-kotlin',
      \ 'coc-lists',
      \ 'coc-ltex',
      \ 'coc-lua',
      \ 'coc-markdownlint',
      \ 'coc-prisma',
      \ 'coc-pyright',
      \ 'coc-rls',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-svelte',
      \ 'coc-svg',
      \ 'coc-syntax',
      \ 'coc-texlab',
      \ 'coc-toml',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-word',
      \ 'coc-yaml',
      \ 'coc-yank',
      \ ]

" Note: coc-angular requires `npm install @angular/language-service` in
" project directory to stop coc from crashing. See:
" <https://github.com/iamcco/coc-angular/issues/47>

function! s:autocmd_custom_coc()
  if !exists("g:did_coc_loaded")
    return
  endif
  augroup custom_coc
    autocmd FileType coctree set nowrap
    autocmd FileType nginx let b:coc_additional_keywords = ['$']
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd User CocNvimInit call s:default_key_mappings()
  augroup end
endfunction

function! s:coc_toggle_outline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

augroup custom_coc
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_coc()
augroup end

" }}}
" Package: lua extensions for Neovim {{{

function! s:safe_require(package)
  try
    execute "lua require('" . a:package . "')"
  catch
    echom "Error with lua require('" . a:package . "')"
  endtry
endfunction

function! s:setup_lua_packages()
  call s:safe_require('config.colorizer')
  call s:safe_require('config.gitsigns')
  call s:safe_require('config.nvim-autopairs')
  call s:safe_require('config.nvim-tree')
  call s:safe_require('config.nvim-treesitter')
  call s:safe_require('config.nvim-ts-context-commentstring')
  call s:safe_require('config.nvim-web-devicons')
  call s:safe_require('config.spellsitter')
  call s:safe_require('config.telescope')
endfunction

call s:setup_lua_packages()

augroup custom_general_lua_extensions
  autocmd!
  autocmd FileType vim let &l:path .= ','.stdpath('config').'/lua'
  autocmd FileType vim setlocal
        \ includeexpr=substitute(v:fname,'\\.','/','g')
        \ suffixesadd^=.lua
augroup end

command! GitsignsToggle Gitsigns toggle_signs

" }}}
" General: syntax & colorscheme {{{

augroup custom_colorscheme
  autocmd!
  " typescriptParens are stupidly linked to 'Normal' in Neovim.
  " This causes problems with hover windows in coc and is solved here
  autocmd ColorScheme * highlight link typescriptParens cleared
  autocmd ColorScheme * highlight link ExtraWhitespace DiffText
  autocmd ColorScheme * highlight link HighlightedyankRegion Search
  autocmd ColorScheme * highlight link CocHighlightText Underlined

  autocmd ColorScheme * highlight CocErrorHighlight gui=undercurl
  autocmd ColorScheme * highlight CocWarningHighlight gui=undercurl
  autocmd ColorScheme * highlight CocInfoHighlight gui=undercurl
  autocmd ColorScheme * highlight CocHintHighlight gui=undercurl

  " autocmd ColorScheme lunar
  "   \ if &background == 'light' |
  "   \   execute 'highlight CocSearch guifg=#005f87' |
  "   \   execute 'highlight CocMenuSel guibg=#bcbcbc' |
  "   \ else |
  "   \   execute 'highlight CocSearch guifg=#5fafd7' |
  "   \   execute 'highlight CocMenuSel guibg=#585858' |
  "   \ endif
augroup end

try
  colorscheme tokyonight
catch
  echo 'An error occurred while configuring colorscheme'
endtry

" }}}
" General: filetype {{{

augroup custom_filetype_recognition
  autocmd!
  autocmd BufEnter *.asm set filetype=nasm
  autocmd BufEnter *.scm set filetype=query
  autocmd BufEnter *.cfg,*.ini,.coveragerc,*pylintrc,zoomus.conf set filetype=dosini
  autocmd BufEnter *.config,.cookiecutterrc set filetype=yaml
  autocmd BufEnter *.handlebars set filetype=html
  autocmd BufEnter *.hql,*.q set filetype=hive
  autocmd BufEnter *.js,*.gs set filetype=javascript
  autocmd BufEnter *.mdx set filetype=markdown
  autocmd BufEnter *.min.js set filetype=none
  autocmd BufEnter *.m,*.oct set filetype=octave
  autocmd BufEnter *.toml set filetype=toml
  autocmd BufEnter *.tsv set filetype=tsv
  autocmd BufEnter .envrc set filetype=sh
  autocmd BufEnter .gitignore,.dockerignore set filetype=conf
  autocmd BufEnter .jrnl_config,*.bowerrc,*.babelrc,*.eslintrc,*.slack-term,*.htmlhintrc,*.stylelintrc,*.firebaserc set filetype=json
  autocmd BufEnter Dockerfile.* set filetype=dockerfile
  autocmd BufEnter Makefile.* set filetype=make
  autocmd BufEnter poetry.lock,Pipfile set filetype=toml
  autocmd BufEnter tsconfig.json,*.jsonc,.markdownlintrc set filetype=jsonc
  autocmd BufEnter tmux-light.conf set filetype=tmux
  autocmd BufEnter .zshrc set filetype=sh
augroup end

" }}}
" General: indentation {{{

augroup custom_indentation
  autocmd!
  " Reset to 2 (something somewhere overrides...)
  autocmd Filetype markdown setlocal shiftwidth=2 softtabstop=2
  " 4 spaces per tab, not 2
  autocmd Filetype python,c,nginx,haskell,rust,kv,asm,nasm,gdscript3
        \ setlocal shiftwidth=4 softtabstop=4
  " Use hard tabs, not spaces
  autocmd Filetype make,tsv,votl,go,gomod
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
augroup end

" }}}
" General: statusline {{{

" Status Line
set laststatus=2
set statusline=
set statusline+=%#CursorLine#
set statusline+=\ %{mode()}
set statusline+=\ %*\  " Color separator + space
set statusline+=%{&paste?'[P]':''}
set statusline+=%{&spell?'[S]':''}
set statusline+=%r
set statusline+=%t
set statusline+=%m
set statusline+=%=
set statusline+=\ %v:%l/%L\  " column, line number, total lines
set statusline+=\ %y\  " file type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding

" Status Line
augroup custom_statusline
  autocmd!
  autocmd BufEnter NvimTree* setlocal statusline=\ NvimTree\ %#CursorLine#
augroup end

" }}}
" General: tabline {{{

function! CustomTabLine()
  " Initialize tabline string
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s ..= '%#TabLineSel#'
    else
      let s ..= '%#TabLine#'
    endif
    " set the tab page number (for mouse clicks)
    let s ..= '%' .. (i + 1) .. 'T'
    " the label is made by CustomTabLabel()
    let s ..= ' ' . (i + 1) . ':%{CustomTabLabel(' .. (i + 1) .. ')} '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s ..= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s ..= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction

function! CustomTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bname = bufname(buflist[winnr - 1])
  let bnamemodified = fnamemodify(bname, ':t')
  if bnamemodified == ''
    return '[NO NAME]'
  endif
  return bnamemodified
endfunction

set tabline=%!CustomTabLine()

" }}}
" General: environment variables {{{

" Path: add node_modules for language servers / linters / other stuff
let $PATH = $PWD . '/node_modules/.bin:' . $PATH

" }}}
" General: comment & text format options {{{

" Notes:
" commentstring: read by vim-commentary; must be one template
" comments: csv of comments.
" formatoptions: influences how Vim formats text
"   ':help fo-table' will get the desired result
augroup custom_comment_config
  autocmd!
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
augroup end

" }}}
" General: gx improved {{{

function! s:gx_improved()
  silent execute '!gio open ' . expand('<cfile>')
endfunction

" }}}
" General: terraform settings {{{

let g:terraform_align = 1

let g:terraform_fold_sections = 0

let g:terraform_fmt_on_save = 1
" }}}
" General: trailing whitespace {{{

function! s:trim_whitespace()
  let l:save = winsaveview()
  if &ft == 'markdown'
    " Replace lines with only trailing spaces
    %s/^\s\+$//e
    " Replace lines with exactly one trailing space with no trailing spaces
    %g/\S\s$/s/\s$//g
    " Replace lines with more than 2 trailing spaces with 2 trailing spaces
    %s/\s\s\s\+$/  /e
  else
    " Remove all trailing spaces
    %s/\s\+$//e
  endif
  call winrestview(l:save)
endfunction

command! TrimWhitespace call s:trim_whitespace()

augroup custom_fix_whitespace_save
  autocmd!
  autocmd BufWritePre * TrimWhitespace
augroup end

" }}}
" General: clean unicode {{{

" Replace unicode symbols with cleaned, ascii versions
function! s:clean_unicode()
  silent! %s/\u201d/"/g
  silent! %s/\u201c/"/g
  silent! %s/\u2019/'/g
  silent! %s/\u2018/'/g
  silent! %s/\u2014/-/g
  silent! %s/\u2026/.../g
  silent! %s/\u200b//g
endfunction
command! CleanUnicode call s:clean_unicode()

" }}}
" Package: markdown-preview.vim {{{

let g:mkdp_auto_start = v:false
let g:mkdp_auto_close = v:false

" set to 1, the vim will just refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = v:false

" set to 1, the MarkdownPreview command can be use for all files,
" by default it just can be use in markdown file
" default: 0
let g:mkdp_command_for_global = v:false

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
" Package: preview compiled stuff in viewer {{{

function! s:preview()
  if &filetype ==? 'rst'
    silent exec 'terminal restview %'
    silent exec "normal \<C-O>"
  elseif &filetype ==? 'markdown'
    " from markdown-preview.vim
    silent exec 'MarkdownPreview'
  elseif &filetype ==? 'plantuml'
    " from plantuml-previewer.vim
    silent exec 'PlantumlOpen'
  else
    silent !gio open '%:p'
  endif
endfunction

command! Preview call s:preview()

" }}}
" Package: misc global var config {{{

" Languages: configure location of host
let g:python3_host_prog = "$HOME/.asdf/shims/python"

" Configure clipboard explicitly. Speeds up startup
let g:clipboard = {
      \ 'name': 'xsel',
      \ 'copy': {
      \    '+': 'xsel --clipboard --input',
      \    '*': 'xsel --clipboard --input',
      \  },
      \ 'paste': {
      \    '+': 'xsel --clipboard --output',
      \    '*': 'xsel --clipboard --output',
      \ },
      \ 'cache_enabled': 0,
      \ }

" Netrw: disable completely
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:netrw_nogx = 1

" Man Pager
let g:man_hardwrap = v:true

" IndentLines:
let g:indentLine_enabled = v:false  " indentlines disabled by default

" QuickScope: great plugin helping with f and t
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 10000

" Makefile: global variable to prevent syntax highlighting of commands
let g:make_no_commands = 1

" vim-filetype-formatter:
let g:vim_filetype_formatter_verbose = v:false
let g:vim_filetype_formatter_ft_no_defaults = []
let g:vim_filetype_formatter_commands = {
      \ 'python': 'black -q - | isort -q - | docformatter -',
      \ }

" }}}
