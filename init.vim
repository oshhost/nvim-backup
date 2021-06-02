call plug#begin('~/.config/nvim/plugged')

Plug 'mhinz/vim-startify'

Plug 'bling/vim-bufferline'

Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'preservim/nerdcommenter'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'

Plug 'morhetz/gruvbox' 

call plug#end()

let g:gruvbox_italic = 1

let g:rust_clip_command = 'xclip -selection clipboard'

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
let g:NERDUsePlaceHolders = 0

let g:coc_global_extensions = [
	\ 'coc-pyright',
	\ 'coc-rust-analyzer',
	\ 'coc-go',
	\ 'coc-sh',
	\ 'coc-kotlin',
	\ 'coc-calc'
  \ ]

let g:NERDTreeGitStatusUseNerdFonts = 1

let g:lightline = {
	\ 'colorscheme': 'jellybeans',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'cocstatus': 'coc#status'
	\ },
	\ }

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

nmap <C-q> :NERDTreeToggle<CR>
vmap == <plug>NERDCommenterToggle
nmap == <plug>NERDCommenterToggle

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

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
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

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nmap о j
nmap л k
nmap р h
nmap д l
nmap ш i
nmap ф a
nmap в d

nnoremap d "_d
vnoremap d "_d

nnoremap D "_D
vnoremap D "_D

nnoremap c "_c
vnoremap c "_c

nnoremap X "_x
vnoremap X "_x

nnoremap <C-l> :noh<CR><C-l>
inoremap <C-e> <ESC>

nnoremap <C-s> :up<CR>
inoremap <C-s> <C-o>:up<CR>

inoremap <leader>; <C-o>A;
nnoremap <leader>; A;<ESC>
vnoremap <leader>; $A;<ESC>

nnoremap <A-[> :set list<CR>
nnoremap <A-]> :set nolist<CR>

nnoremap <A-s> :set syntax=

nnoremap <A-a> :badd 
nnoremap <A-n> :bn<CR>
nnoremap <A-b> :bp<CR>
nnoremap <A-d> :w<bar>:bp<bar>sp<bar>bn<bar>bd!<CR>
tnoremap <A-d> :bp<bar>sp<bar>bn<bar>bd!<CR>
nnoremap <A-c> :clo<CR>
tnoremap <A-c> <C-\><C-N>:bd!<CR>

nnoremap <A-o> <C-w>o
nnoremap <A-t> :vs<CR><C-w>l:term<CR>i

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

set termguicolors
colorscheme gruvbox

hi NonText guifg=DarkGray
hi Normal guibg=NONE
hi CocErrorSign guifg=Red
hi CocWarningSign guifg=Orange
hi CocInfoSign guifg=Green
hi CocHintSign guibg=NONE

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
