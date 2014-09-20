" ------------------------------------------------------------------------------
" GUI specific setting
" ------------------------------------------------------------------------------
if has("gui_running")
  if has("win32") || has("win64")
    set guifont=MS_Gothic:h10:cSHIFTJIS " フォントを小さくする (windows)
  else
    set guifont=Monospace\ 10           " フォントを小さくする (not windows)
  endif
  set guioptions& guioptions-=T         " ツールバーを非表示
  if has("vim_starting")                " 起動時のみに動作させる(リロード対応)
    set columns=80 lines=48             " 84x26 より画面サイズを大きくする
  endif
endif
