call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', {'do':'GoUpdateBinaries'}
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()
filetype plugin indent on

set expandtab

set hlsearch "검색어 하이라이팅
set nu "줄번호
set autoindent "자동 들여쓰기
set scrolloff=2
set wildmode=longest,list
set ts=4 "tab 크기 
set sts=4 "st select
set sw=1 " 스크롤바 너비
set autowrite " 다른 파일로 넘어갈 때 자동 저장
set autoread " 작업 중인 파일 외부에서 변경됬을 경우 자동으로 불러옴
set cindent " C언어 자동 들여쓰기
set bs=eol,start,indent
set history=256
set laststatus=2 " 상태바 표시 항상
set shiftwidth=4 " 자동 들여쓰기 너비 설정
set showmatch " 일치하는 괄호 하이라이팅
set smartcase " 검색시 대소문자 구별
set smarttab
set smartindent
set softtabstop=4
set tabstop=4
set ruler " 현재 커서 위치 표시
set clipboard=unnamed 
set incsearch
syntax on
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set encoding=UTF-8

"----------------------------------------------------------------------"
" gruvbox 설정
"----------------------------------------------------------------------"
set background=dark
let g:gruvbox_contrast_dark = 'soft'
"let g:gruvbox_contrast_light = 'soft'
"let g:gruvbox_transparent_bg = '1'
let g:gruvbox_italic = 1
"let g:gruvbox_underline=1
"let g:gruvbox_undercurl=1
"let g:gruvbox_termcolors=16
"let g:gruvbox_number_column='aqua'
"let g:gruvbox_sign_column='aqua'
"let g:gruvbox_color_column='aqua'

" Force to use underline for spell check results
augroup SpellUnderline
autocmd!
autocmd ColorScheme *
\ highlight SpellBad
\   cterm=Underline
\   ctermfg=NONE
\   ctermbg=NONE
\   term=Reverse
\   gui=Undercurl
\   guisp=Red
autocmd ColorScheme *
\ highlight SpellCap
\   cterm=Underline
\   ctermfg=NONE
\   ctermbg=NONE
\   term=Reverse
\   gui=Undercurl
\   guisp=Red
autocmd ColorScheme *
\ highlight SpellLocal
\   cterm=Underline
\   ctermfg=NONE
\   ctermbg=NONE
\   term=Reverse
\   gui=Undercurl
\   guisp=Red
autocmd ColorScheme *
\ highlight SpellRare
\   cterm=Underline
\   ctermfg=NONE
\   ctermbg=NONE
\   term=Reverse
\   gui=Undercurl
\   guisp=Red
augroup END
set termguicolors
colorscheme gruvbox

nnoremap <F8> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <F9> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree and leave the cursor in it.
autocmd VimEnter * NERDTree

set guifont=DroidSansMono\ Nerd\ Font:h11
