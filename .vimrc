set nocompatible			" vi 非互換(宣言)
scriptencoding utf-8			" vimrcのエンコーディング
" ------------------------------------------------------------------------------
" plugin (NeoBundle) (1st phase, minimal)
" ------------------------------------------------------------------------------
filetype plugin indent off		" Required by Neobundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'wombat256.vim'
filetype plugin indent on		" Required by Neobundle
" ------------------------------------------------------------------------------
" color
" ------------------------------------------------------------------------------
syntax on				" カラー表示
set t_Co=256				" ターミナルで256色対応
colorscheme wombat256mod		" 256色対応 wombat
" ------------------------------------------------------------------------------
" search
" ------------------------------------------------------------------------------
set ignorecase				" 大文字/小文字を区別しない
set smartcase				" 大文字があるときだけ区別
set incsearch				" インクリメンタルサーチ
set nowrapscan				" ファイルの先頭へループしない
set hlsearch				" 検索文字をハイライトする
nmap <Esc><Esc> :nohlsearch<CR><Esc>	" Esc 連打でハイライト無効
" ------------------------------------------------------------------------------
" display
" ------------------------------------------------------------------------------
set showmatch				" 対応する括弧をハイライト表示
set matchtime=3				" 対応括弧のハイライト表示を3秒にする
set wrap				" 文字を折り返す
set list				" 不可視文字を可視化
set listchars=tab:»\ ,trail:˷,nbsp:▫	" タグを可視化
" ------------------------------------------------------------------------------
" edit
" ------------------------------------------------------------------------------
set shiftround				" インデント時にshiftwidthの倍数に丸める
set infercase				" 補完で大文字小文字を区別しない
set hidden				" バッファを閉じずに隠す(Undo履歴を残す)
set switchbuf=useopen			" 新しく開く代わりに既存バッファを開く
set backspace=indent,eol,start		" バックスペースで何でも消せるようにする
set textwidth=0				" 自動的に改行が入るのを無効化
" ------------------------------------------------------------------------------
" ascii escape provision
" ------------------------------------------------------------------------------
nnoremap OA gi<Up>
nnoremap OB gi<Down>
nnoremap OC gi<Right>
nnoremap OD gi<Left>
" ------------------------------------------------------------------------------
" disable old vi function
" ------------------------------------------------------------------------------
set nobackup				" ~xxxを作成しない
set noswapfile				" .xxx.swpを作成しない
set visualbell t_vb=			" スクリーンベルを無効化
" ------------------------------------------------------------------------------
" statusline
" ------------------------------------------------------------------------------
set laststatus=2			" 常にステータスラインを表示
set showcmd				" コマンドをステータスラインに表示
" ------------------------------------------------------------------------------
" CJK multibyte
" ------------------------------------------------------------------------------
set ambiwidth=double			" ○や□を2バイト文字と判断する
" ------------------------------------------------------------------------------
" window
" ------------------------------------------------------------------------------
" set splitright			" ウィンドウ分割を(左でなく)右側に変更
" set splitbelow			" ウィンドウ分割を(上でなく)下側に変更
" ------------------------------------------------------------------------------
" indent
" ------------------------------------------------------------------------------
set tabstop=8				" 互換のためタブは8文字のままにしておく
augroup vimrc
autocmd! FileType c       setlocal           shiftwidth=4 softtabstop=4
autocmd! FileType sh      setlocal expandtab shiftwidth=2 softtabstop=2
autocmd! FileType awk     setlocal expandtab shiftwidth=2 softtabstop=2
autocmd! FileType python  setlocal expandtab shiftwidth=4 softtabstop=4
autocmd! FileType fortran setlocal expandtab shiftwidth=2 softtabstop=2
augroup END
" ------------------------------------------------------------------------------
" fortran specific
" ------------------------------------------------------------------------------
let fortran_free_source=1		" 自由形式を有効にする
let fortran_do_enddo=1			" doループのインデント
let fortran_indent_less=1		" プログラム単位のインデントを無効化
" ------------------------------------------------------------------------------
" plugin (NeoBundle) (2nd phase, mainly)
" ------------------------------------------------------------------------------
filetype plugin indent off		" Required by Neobundle
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin'  : 'make -f make_cygwin.mak',
    \ 'mac'     : 'make -f make_mac.mak',
    \ 'unix'    : 'make -f make_unix.mak',
  \ },
\ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'jtratner/vim-flavored-markdown'
NeoBundle 'suan/vim-instant-markdown'
NeoBundle 'Lokaltog/vim-powerline'		" かっこいいステータスライン
NeoBundle 'vim-scripts/trailing-whitespace'	" trailing-whitespace を赤色表示
" ------------------------------------------------------------------------------
" vimfiler
" ------------------------------------------------------------------------------
NeoBundle 'Shougo/vimfiler', {'depends' : ['Shougo/unite.vim']}
nnoremap <Leader>e :VimFilerExplorer<CR>	" \r でファイラを開く
let g:vimfiler_safe_mode_by_default=0		" safe mode を無効にして開く
" ------------------------------------------------------------------------------
" YankRing
" ------------------------------------------------------------------------------
NeoBundle 'vim-scripts/YankRing.vim'
let g:yankring_history_file='.yankring_history' " 履歴ファイルを隠す
set clipboard& clipboard+=unnamedplus,unnamed	" Yank でクリップボードへコピー
" ------------------------------------------------------------------------------
" neocomplete
" ------------------------------------------------------------------------------
NeoBundle 'Shougo/neocomplete.vim'		" <Expr><C-n> で補完
let g:neocomplete#enable_at_startup=1		" 起動時に有効化
let g:neocomplete#enable_smart_case=1		" 大文字小文字の賢い補完
" A
" ------------------------------------------------------------------------------
" quickrun
" ------------------------------------------------------------------------------
NeoBundle 'thinca/vim-quickrun'			" \r で script 実行(非同期)
let g:quickrun_config = {
\  '*' : {'runmode': 'async:remote:vimproc'},
\}
" ------------------------------------------------------------------------------
" gundo
" ------------------------------------------------------------------------------
NeoBundle 'sjl/gundo.vim'			" git reflog のような履歴管理
nnoremap <Leader>g :GundoToggle<CR>		" \g でトグル
" ------------------------------------------------------------------------------
" vim-ref (man, pydoc, webpage reference)
" ------------------------------------------------------------------------------
NeoBundle 'thinca/vim-ref'
" webdict サイト定義
let g:ref_source_webdict_sites = {
\  'je'  : { 'url': 'http://dictionary.infoseek.ne.jp/jeword/%s' },
\  'ej'  : { 'url': 'http://dictionary.infoseek.ne.jp/ejword/%s' },
\  'wiki': { 'url': 'http://ja.wikipedia.org/wiki/%s'            },
\  'alc' : { 'url': 'http://eow.alc.co.jp/%s/UTF-8/'             },
\}
let g:ref_source_webdict_sites.default = 'alc'	" デフォルトサイト
let g:ref_source_webdict_cmd = 'w3m -dump %s'	" w3m で出力(lynxより見やすい)
"出力に対するフィルタ。最初の数行を削除
function! g:ref_source_webdict_sites.je.filter(output)
  return join(split(a:output, "\n")[15:], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
  return join(split(a:output, "\n")[15:], "\n")
endfunction
function! g:ref_source_webdict_sites.alc.filter(output)
  return join(split(a:output, "\n")[35:], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
  return join(split(a:output, "\n")[17:], "\n")
endfunction
" ショートカット
nmap <Leader>rj :<C-u>Ref webdict je<Space>	" \rj で和英
nmap <Leader>re :<C-u>Ref webdict ej<Space>	" \re で英和
nmap <Leader>ra :<C-u>Ref webdict alc<Space>	" \ra で alc
nmap <Leader>rw :<C-u>Ref webdict wiki<Space>	" \rw でwikipedia
" <Space>K で webdict (alc) で検索 (visual/normal 両対応)
nnoremap <silent> <Space>K :<C-u>call ref#jump('normal', 'webdict')<CR>
vnoremap <silent> <Space>K :<C-u>call ref#jump('visual', 'webdict')<CR>
" ------------------------------------------------------------------------------
" vim-jedi (python code completion)
" ------------------------------------------------------------------------------
" NeoBundle 'davidhalter/jedi-vim'
let g:jedi#auto_initialize=0			" 自動初期化
let g:jedi#auto_vim_configuration=0		" preview抑止のため自動設定無効
let g:jedi#popup_select_first=0			" 最初の候補を選択しない
let g:jedi#popup_on_dot=0			" .(dot)でpopupさせない
let g:jedi#rename_command='<Leader>R'		" quickrunと被るため大文字(\R)に
let g:jedi#goto_command='<Leader>G'		" gundoと被るため大文字(\G)に
" ------------------------------------------------------------------------------
" multi-lang/python syntax checker
" ------------------------------------------------------------------------------
NeoBundle 'tpope/vim-pathogen'			" syntastic に必要
NeoBundle 'scrooloose/syntastic'		" live multi-lang syntax checker
let g:syntastic_enable_signs=0			" 左端 tips (ガタつくので非表示)
call pathogen#infect()				" syntastic 初期化
" NeoBundle 'nvie/vim-flake8'			" static python syntax checker

filetype plugin indent on		" Required by Neobundle
