silent! call plug#begin('~/.config/nvim/plugged')
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
Plug 'AndrewRadev/splitjoin.vim'

Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-easy-align'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'gennaro-tedesco/nvim-peekup'

Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'udalov/kotlin-vim', {'for': 'kotlin'}

Plug 'morhetz/gruvbox'

Plug 'alec-gibson/nvim-tetris'

call plug#end()

lua <<EOF
local tclose = require('telescope.actions').close
require('telescope').setup{
  defaults = {
    prompt_prefix = " 🔍 ",
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

let g:coc_global_extensions = [
    \ 'coc-pairs',
    \ 'coc-pyright',
    \ 'coc-kotlin',
    \ 'coc-rust-analyzer',
    \ 'coc-go',
    \ 'coc-sh',
    \ 'coc-calc'
  \ ]

let g:gruvbox_italic = 1

let g:rust_clip_command = 'xclip -selection clipboard'

let g:peekup_paste_before = '"P'
let g:peekup_paste_after = '"p'

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDUsePlaceHolders = 0

let g:NERDTreeGitStatusUseNerdFonts = 1

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
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nnoremap d "_d
vnoremap d "_d

nnoremap dx dd
vnoremap dx dd<ESC>
vnoremap dd dd<ESC>

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

nnoremap <C-l> :noh<CR>

nnoremap <C-w><A-s> :set syntax=

nnoremap <A-m> :mes<CR>

tnoremap <ESC> <C-\><C-N>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
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

nmap <A-i> <C-s>:sil !$TERMINAL nvim % &<CR><A-d>

nnoremap <A-a> :e 
nnoremap <A-n> :bn<CR>
nnoremap <A-b> :bp<CR>
nmap <A-d> <C-s><bar>:bp<bar>sp<bar>bn<bar>bd!<CR>
nnoremap <A-f><A-d> :bp<bar>sp<bar>bn<bar>bd!<CR>
nnoremap <A-c> <C-w>c

nnoremap <A-o> <C-w>o
nnoremap <A-v> <C-w>v
nnoremap <A-s> <C-w>s

tmap <A-a> <ESC>:e 
tmap <A-n> <ESC>:bn<CR>
tmap <A-b> <ESC>:bp<CR>
tmap <A-d> <ESC>:bp<bar>sp<bar>bn<bar>bd!<CR>
tmap <A-c> <ESC>:bd!<CR>

nnoremap <A-t>v :wa<bar>vs<CR><C-w>l:term<CR>i
nmap <A-t><A-v> <A-t>v
nnoremap <A-t>s :wa<bar>sp<CR><C-w>j:term<CR>i
nmap <A-t><A-s> <A-t>s

au TermOpen * setlocal nonu
au BufWinEnter,WinEnter term://* wa|star
au BufWinLeave,WinLeave term://* stopi

nnoremap <A-e> :sil !xdg-open %:p:h &<CR>

nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>

nnoremap <leader>ps :PlugSync<CR>

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

set updatetime=300

set listchars=eol:$,tab:>·,trail:~,extends:>,precedes:<,space:␣

set tabstop=4
set shiftwidth=0
set expandtab

set noshowmode
set laststatus=2

set ignorecase
set smartcase

set signcolumn=no
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

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command! PlugSync :source $MYVIMRC | :PlugClean | :PlugInstall
command! H Telescope help_tags
command! Q q
