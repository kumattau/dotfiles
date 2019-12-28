" ---------------------------------------------------------------------------
" encodings
" ---------------------------------------------------------------------------
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,euc-jisx0213,euc-jp,cp932
" ---------------------------------------------------------------------------
" stop loading when vim.tiny or vim.small
" ---------------------------------------------------------------------------
if !1 | finish | endif
" ---------------------------------------------------------------------------
" vim settings
" ---------------------------------------------------------------------------
set nocompatible			" vi非互換宣言
augroup vimrc | autocmd! | augroup END	" reset vimrc autocmd group
" ---------------------------------------------------------------------------
" vimrc の自動読み込み
" ---------------------------------------------------------------------------
" https://vim-jp.org/vim-users-jp/2009/09/18/Hack-74.html
" (airlineなど) autocmd から実行されないように nested をつける
augroup vimrc
    autocmd BufWritePost $MYVIMRC nested source %
augroup END
" ----------------------------------------------------------------------------
" search
" ----------------------------------------------------------------------------
set ignorecase				" 大文字/小文字を区別しない
set smartcase				" 大文字があるときだけ区別
set incsearch				" インクリメンタルサーチ
set wrapscan				" ファイルの先頭へループする
set hlsearch				" 検索文字をハイライトする
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR><Esc>|	" Esc 連打でハイライト無効
nnoremap <C-c><C-c> :<C-u>nohlsearch<CR><Esc>|	" C-c 連打でハイライト無効
" ----------------------------------------------------------------------------
" display
" ----------------------------------------------------------------------------
if has('gui_running')
    set title				" GUIのときのみタイトルを更新する
else
    set notitle				" zshのprecmdを表示するため更新しない
endif
set showmatch				" 対応する括弧をハイライト表示
set matchpairs& matchpairs+=<:>		" 対応する括弧に<>を追加
set matchtime=3				" 対応括弧のハイライト表示を3秒にする
set wrap				" 文字を折り返す
set scrolloff=4				" スクロール時に上下4行を見える様にする
set listchars=tab:>\ ,trail:_,nbsp:@	" 不可視文字を可視化
" ----------------------------------------------------------------------------
" edit
" ----------------------------------------------------------------------------
set shiftround				" インデント時にshiftwidth倍に丸める
set infercase				" 補完で大文字小文字を区別しない
set hidden				" バッファを閉じずに隠す(Undo履歴を残す)
set switchbuf=useopen			" 新しく開く代わりに既存バッファを開く
set backspace=indent,eol,start		" バックスペースで何でも消せるようにする
set textwidth=0				" 自動的に改行が入るのを無効化
set formatoptions=q			" (textwidthが設定されても)自動改行しない
if has('unix')
    cnoremap w!! w !sudo tee % >/dev/null|	" sudo root して保存 (for unix only)
endif
" インサートモード時は emacs like なキーバインド (あまり使わない)
inoremap <C-f> <Right>|			" C-f で左へ移動
inoremap <C-b> <Left>|			" C-b で右へ移動
inoremap <C-p> <Up>|			" C-p で上へ移動
inoremap <C-n> <Down>|			" C-n で下へ移動
inoremap <C-a> <Home>|			" C-a で行頭へ移動
inoremap <C-e> <End>|			" C-e で行末へ移動
inoremap <C-h> <BS>|			" C-h でバックスペース
inoremap <C-d> <Del>|			" C-d でデリート
inoremap <C-m> <CR>|			" C-m で改行
" ----------------------------------------------------------------------------
" undo/backup/swap/book/hist
" ----------------------------------------------------------------------------
if has('persistent_undo')
  set undofile				" 可能なら undo 履歴を永続的に保存する
  set undodir=~/.vim_undo		" undoファイルを.vim_undoににまとめる
  if !isdirectory(&undodir)		" ディレクトリがなかったら作成する
    call mkdir(&undodir, 'p')
  endif
endif
set backupdir=~/.vim_backup		" ~xxxを.vim_backupにまとめる
if !isdirectory(&backupdir)		" ディレクトリがなかったら作成する
  call mkdir(&backupdir, 'p')
endif
set directory=~/.vim_swapfile		" .xxx.swpを.vim_swapfileにまとめる
if !isdirectory(&directory)		" ディレクトリがなかったら作成する
  call mkdir(&directory, 'p')
endif
let g:netrw_home=expand('~/')		" .netrw{book,hist} を HOME に保存する
" ----------------------------------------------------------------------------
" ascii escape provision
" ----------------------------------------------------------------------------
nnoremap OA gi<Up>|			" 上矢印を有効に
nnoremap OB gi<Down>|			" 下矢印を有効に
nnoremap OC gi<Right>|			" 右矢印を有効に
nnoremap OD gi<Left>|			" 左矢印を有効に
" ----------------------------------------------------------------------------
" statusline
" ----------------------------------------------------------------------------
set showcmd				" コマンドをステータスラインに表示
" ----------------------------------------------------------------------------
" CJK multibyte
" ----------------------------------------------------------------------------
set ambiwidth=double			" 曖昧な幅の文字(○や□)は全角とする
" ----------------------------------------------------------------------------
" mouse
" ----------------------------------------------------------------------------
set mouse=a				" 全モードでマウスを有効にする
if !has('nvim') | set ttymouse=sgr | endif	" xterm over 223 columns
" ----------------------------------------------------------------------------
" window
" ----------------------------------------------------------------------------
set splitbelow				" ウィンドウ分割を(上でなく)下側に変更
set splitright				" ウィンドウ分割を(左でなく)右側に変更
nnoremap <C-h> <C-w>h|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-j> <C-w>j|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-k> <C-w>k|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-l> <C-w>l|			" Ctrl + hjkl でウィンドウ間を移動
nnoremap - <C-u>:sp<CR>|		" - で横分割
nnoremap <Bar> <C-u>:vsp<CR>|		" | で縦分割
" ----------------------------------------------------------------------------
" buffer
" ----------------------------------------------------------------------------
nnoremap < :bp<CR>|			" < でバッファを戻る
nnoremap > :bn<CR>|			" > でバッファを進む
" ----------------------------------------------------------------------------
" menu
" ----------------------------------------------------------------------------
set wildmenu				" メニューの補完
set wildmode=list:longest		" 全マッチを列挙し最長の文字列まで補完
" ----------------------------------------------------------------------------
" indent
" ----------------------------------------------------------------------------
set tabstop=8				" 互換のためタブは8のままにしておく
augroup vimrc
    autocmd FileType c          setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType sh         setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType awk        setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType xml        setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType vim        setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType html       setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType python     setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType fortran    setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType javascript setlocal expandtab shiftwidth=4 softtabstop=4
augroup END
" ----------------------------------------------------------------------------
" fortran specific
" ----------------------------------------------------------------------------
let fortran_free_source=1		" 自由形式を有効にする
let fortran_do_enddo=1			" doループのインデント
let fortran_indent_less=1		" プログラム単位のインデントを無効化
" ----------------------------------------------------------------------------
" clipboard
" ----------------------------------------------------------------------------
" https://pocke.hatenablog.com/entry/2014/10/26/145646
set clipboard&
set clipboard^=unnamedplus
" ----------------------------------------------------------------------------
" 256 and True Color (also supports tmux)
" ----------------------------------------------------------------------------
" https://qiita.com/yami_beta/items/ef535d3458addd2e8fbb
" https://github.com/tmux/tmux/issues/1246
set t_Co=256
if exists('termguicolors')
    if $TERM == 'screen-256color'
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
endif
" ----------------------------------------------------------------------------
" appearance
" ----------------------------------------------------------------------------
set background=dark			" 背景は暗め

if has('gui_running')
    if has('win32') || has('win64')
        set guifont=MS_Gothic:h12:cSHIFTJIS	" フォントを小さくする(windows)
    else
        set guifont=Monospace\ 12		" フォントを小さくする(not windows)
    endif
    set guioptions&
    set guioptions-=T			" ツールバーを非表示
    set guioptions-=m			" メニュバーを非表示
    set guioptions-=r		     	" 右スクロールバーを非表示
    set guioptions-=R			" 右スクロールバーを非表示
    set guioptions-=l			" 左スクロールバーを非表示
    set guioptions-=L			" 左スクロールバーを非表示
    set guioptions-=b			" 水平スクロールバーを非表示
    if has('vim_starting')		" 起動時のみに動作させる(リロード対応)
        set columns=80 lines=48		" 84x26 より画面サイズを大きくする
    endif
endif
" ----------------------------------------------------------------------------
" 背景透過
" ----------------------------------------------------------------------------
if !has('gui_running')
    function! s:transparent()
        highlight Normal      guibg=NONE ctermbg=NONE
        highlight NonText     guibg=NONE ctermbg=NONE
        highlight LineNr      guibg=NONE ctermbg=NONE
        highlight Folded      guibg=NONE ctermbg=NONE
        highlight EndOfBuffer guibg=NONE ctermbg=NONE
        highlight Special     guibg=NONE ctermbg=NONE
    endfunction
    autocmd vimrc ColorScheme * :call s:transparent()
endif
" ----------------------------------------------------------------------------
" カーソル下のhighlight情報を表示する
" ----------------------------------------------------------------------------
" https://qiita.com/pasela/items/903bb9f5ac1b9b17af2c
function! s:get_syn_id(transparent)
    let synid = synID(line('.'), col('.'), 1)
    return a:transparent ? synIDtrans(synid) : synid
endfunction
function! s:get_syn_name(synid)
    return synIDattr(a:synid, 'name')
endfunction
function! s:get_highlight_info()
    execute 'highlight ' . s:get_syn_name(s:get_syn_id(0))
    execute 'highlight ' . s:get_syn_name(s:get_syn_id(1))
endfunction
command! HighlightInfo call s:get_highlight_info()
" ----------------------------------------------------------------------------
" vim-plug
" ----------------------------------------------------------------------------
" https://github.com/junegunn/vim-plug/wiki/tips
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'sheerun/vim-polyglot'
Plug 'qpkorr/vim-renamer'
Plug 'Shougo/context_filetype.vim'
Plug 'osyo-manga/vim-precious'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
call plug#end()
" ----------------------------------------------------------------------------
" lightline.vim
" ----------------------------------------------------------------------------
set laststatus=2			" 常にステータスラインを表示
set noshowmode				" insertはstatuslineに表示するので消す
" ----------------------------------------------------------------------------
" indentline.vim
" ----------------------------------------------------------------------------
let g:indentLine_char = '￨'             " 縦線を'|'からUTF8のFFE8に変更
" ----------------------------------------------------------------------------
" molokai
" ----------------------------------------------------------------------------
" function! s:molokai_mod()		" 範囲指定とコメントを明るめに補正
"     highlight Visual  guibg=darkgray ctermbg=darkgray
"                     \ gui=reverse cterm=reverse term=reverse
"     highlight Comment guifg=gray ctermfg=gray
" endfunction
" autocmd vimrc ColorScheme molokai :call s:molokai_mod()
" colorscheme molokai			" popな配色
" ----------------------------------------------------------------------------
" gruvbox
" ----------------------------------------------------------------------------
if has('termguicolors')
    colorscheme gruvbox-material
    let g:lightline = {}
    let g:lightline.colorscheme = 'gruvbox_material'
else
    colorscheme gruvbox
    let g:lightline = {}
    let g:lightline.colorscheme = 'gruvbox'
endif
