silent! call plug#begin('~/.config/nvim/plugged')
Plug 'fatih/vim-go'

Plug 'mhinz/vim-startify'
Plug 'bling/vim-bufferline'

Plug 'preservim/nerdtree' |
			\ Plug 'Xuyuanp/nerdtree-git-plugin' |
			\ Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mbbill/undotree'

Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'preservim/nerdcommenter'

Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-easy-align'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'gennaro-tedesco/nvim-peekup'

Plug 'morhetz/gruvbox'

Plug 'alec-gibson/nvim-tetris'
call plug#end()

lua <<EOF
local tclose = require('telescope.actions').close
require('telescope').setup{
  defaults = {
    prompt_prefix = "> ",
    mappings = {
      i = {
          ["<ESC>"] = tclose,
          ["<A-c>"] = tclose
      }
    }
  }
}

local npconf = require('nvim-peekup.config')
npconf.on_keystroke["delay"] = ''
npconf.on_keystroke["paste_reg"] = "+"
EOF

let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []
let g:go_jump_to_error = 0
let g:go_auto_sameids = 0
let g:go_doc_keywordprg_enabled = 0

let g:go_bin_path = $HOME . "/.go/bin"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

let g:go_snippet_engine = "ultisnips"

let g:coc_global_extensions = [
    \ 'coc-pairs',
    \ 'coc-pyright',
    \ 'coc-sh',
    \ 'coc-calc',
	\ 'coc-snippets',
    \ 'coc-spell-checker'
  \ ]

let g:coc_snippet_next = '<tab>'

let g:gruvbox_italic = 1

let g:peekup_paste_before = '"P'
let g:peekup_paste_after = '"p'

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDUsePlaceHolders = 0

let g:NERDTreeGitStatusUseNerdFonts = 1

let g:bufferline_rotate = 2

let g:lightline = {
	\ 'colorscheme': 'gruvbox',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'cocstatus': 'coc#status'
	\ },
	\ }

au User CocStatusChange,CocDiagnosticChange call lightline#update()

nmap <C-q> :NERDTreeToggle<CR>
imap <C-q> <C-o>:NERDTreeToggle<CR>
nmap <A-u> :UndotreeToggle<CR><C-w>h
vmap == <plug>NERDCommenterToggle
nmap == <plug>NERDCommenterToggle
noremap <plug>(slash-after) zz

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
						\: "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>r <Plug>(coc-rename)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

vmap <leader>a <Plug>(coc-codeaction-selected)<CR>
nmap <leader>a <Plug>(coc-codeaction-selected)<CR>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nnoremap <silent><nowait><expr> <C-z> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-z>"
nnoremap <silent><nowait><expr> <C-a> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-a>"
inoremap <silent><nowait><expr> <C-z> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <silent><nowait><expr> <C-a> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-z> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-z>"
vnoremap <silent><nowait><expr> <C-a> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-a>"

nnoremap d "_d
vnoremap d "_d

nnoremap dx dd
vnoremap dx dd<ESC>
vnoremap dd "_dd<ESC>

nnoremap D "_D
vnoremap D "_D

nnoremap c "_c
vnoremap c "_c

nnoremap X "_x
vnoremap X "_x

inoremap <C-e> <ESC>

nnoremap <C-s> :up<CR>
inoremap <C-s> <C-o>:up<CR>

nnoremap <leader>; A;<ESC>
vnoremap <leader>; $A;<ESC>

nnoremap <A-]> :set list!<CR>
inoremap <A-]> <C-o>:set list!<CR>

nnoremap <C-l> :noh<CR>

nnoremap <C-w><A-s> :set syntax=

nnoremap <A-m> :mes<CR>

tnoremap <ESC> <C-\><C-N>
tmap <A-h> <ESC><C-w>h
tmap <A-j> <ESC><C-w>j
tmap <A-k> <ESC><C-w>k
tmap <A-l> <ESC><C-w>l
inoremap <A-h> <ESC><C-w>hi
inoremap <A-j> <ESC><C-w>ji
inoremap <A-k> <ESC><C-w>ki
inoremap <A-l> <ESC><C-w>li
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

tmap <A-Left> <A-h>
tmap <A-Down> <A-j>
tmap <A-Up> <A-k>
tmap <A-Right> <A-l>
imap <A-Left> <A-h>
imap <A-Down> <A-j>
imap <A-Up> <A-k>
imap <A-Right> <A-l>
nmap <A-Left> <A-h>
nmap <A-Down> <A-j>
nmap <A-Up> <A-k>
nmap <A-Right> <A-l>

tmap <A-C-h> <ESC><C-w>Hi
tmap <A-C-j> <ESC><C-w>Ji
tmap <A-C-k> <ESC><C-w>Ki
tmap <A-C-l> <ESC><C-w>Li
inoremap <A-C-h> <ESC><C-w>H
inoremap <A-C-j> <ESC><C-w>J
inoremap <A-C-k> <ESC><C-w>K
inoremap <A-C-l> <ESC><C-w>L
nnoremap <A-C-h> <C-w>H
nnoremap <A-C-j> <C-w>J
nnoremap <A-C-k> <C-w>K
nnoremap <A-C-l> <C-w>L

tmap <A-C-Left> <A-C-h>
tmap <A-C-Down> <A-C-j>
tmap <A-C-Up> <A-C-k>
tmap <A-C-Right> <A-C-l>
imap <A-C-Left> <A-C-h>
imap <A-C-Down> <A-C-j>
imap <A-C-Up> <A-C-k>
imap <A-C-Right> <A-C-l>
nmap <A-C-Left> <A-C-h>
nmap <A-C-Down> <A-C-j>
nmap <A-C-Up> <A-C-k>
nmap <A-C-Right> <A-C-l>

nmap <C-w><A-n> <C-s>:sil !$TERMINAL nvim % &<CR><A-d>

tmap <A-a> <ESC>:e 
tmap <A-n> <ESC>:bn<CR>
tmap <A-b> <ESC>:bp<CR>
tmap <A-d> <ESC>:bp<bar>sp<bar>bn<bar>bd!<CR>
tmap <A-c> <ESC>:bd!<CR>
nnoremap <A-a> :e 
nnoremap <A-n> :bn<CR>
nnoremap <A-b> :bp<CR>
nmap <A-d> <C-s><bar>:bp<bar>sp<bar>bn<bar>bd!<CR>
nnoremap <A-f><A-d> :bp<bar>sp<bar>bn<bar>bd!<CR>
nnoremap <A-c> <C-w>c

nnoremap <A-o> <C-w>o
nnoremap <A-v> <C-w>v
nnoremap <A-s> <C-w>s

nnoremap <A-t>v :wa<bar>vs<CR><C-w>l:term<CR>i
nmap <A-t><A-v> <A-t>v
nnoremap <A-t>s :wa<bar>sp<CR><C-w>j:term<CR>i
nmap <A-t><A-s> <A-t>s

au BufEnter *.go nmap <leader>t  <Plug>(go-test)
au BufEnter *.go nmap <leader>tt <Plug>(go-test-func)
au BufEnter *.go nmap <leader>c  <Plug>(go-coverage-toggle)

au BufEnter *.go nmap <leader>i  <Plug>(go-info)
au BufEnter *.go nmap <leader>ii  <Plug>(go-implements)
au BufEnter *.go nmap <leader>ci  <Plug>(go-describe)
au BufEnter *.go nmap <leader>cc  <Plug>(go-callers)

au BufEnter *.go nmap <A-r> :GoRun<CR>
au BufEnter *.go nmap <A-f><A-r> :GoRunForce<CR>
au BufEnter *.go nmap <A-g><A-i> :GoModInit 
au BufEnter *.go nmap <A-g><A-t> :GoModTidy<CR>
au BufEnter *.go nmap <A-i> :GoImpl<CR>

au TermOpen * setlocal nonu
au BufWinEnter,WinEnter term://* wa|star
au BufWinLeave,WinLeave term://* stopi

nnoremap <A-e> :sil !xdg-open %:p:h &<CR>

nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>

nnoremap <leader>ps :PlugSync<CR>

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

set updatetime=1000

set listchars=eol:$,tab:>·,trail:~,extends:>,precedes:<,space:␣

set tabstop=4
set shiftwidth=4
set noexpandtab

set noshowmode
set laststatus=2

set ignorecase
set smartcase

set signcolumn=number
set number

set hidden

set autochdir
set autowrite

set mouse=a
set clipboard+=unnamedplus

set inccommand=split

set termguicolors
silent! colorscheme gruvbox

hi NonText guifg=DarkGray
hi Normal guibg=NONE
hi CocErrorSign guifg=Red
hi CocWarningSign guifg=Orange
hi CocInfoSign guifg=Green
hi CocHintSign guibg=NONE

hi ExtraWhitespace guibg=DarkRed
mat ExtraWhitespace /\s\+$/

command! GoRunForce :!go run %
command! -nargs=+ GoModInit :!go mod init <args>
command! GoModTidy :!go mod tidy

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command! PlugSync :source $MYVIMRC | :PlugClean | :PlugInstall
command! H Telescope help_tags
command! Q q

cabbrev S %s
cabbrev hes .,$s
cabbrev shs 1,.s
