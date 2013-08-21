# ------------------------------------------------------------------------------
# common
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8			# 日本語設定
autoload -U is-at-least			# zsh バージョン切り分けモジュール
export PAGER=lv				# ページャを lv に設定
export LV="-c -Outf8"			# エスケープシーケンス解釈・UTF-8変換
# ------------------------------------------------------------------------------
# TERM
# ------------------------------------------------------------------------------
__export_best_term () {
  for term in $*
  do
    prfx=$(echo $term | cut -c1)
    if [ -f /lib/terminfo/$prfx/$term -o -f /usr/share/terminfo/$prfx/$term ]
    then
      export TERM=$term
      break
    fi
  done
}
__export_best_term screen-256color xterm-256color xterm-color xterm
# ------------------------------------------------------------------------------
# COLOR THEME (https://github.com/sona-tar/terminal-color-theme)
# ------------------------------------------------------------------------------
autoload -U colors; colors					# カラー機能
[ -e ~/.dircolors ] && eval $(dircolors -b ~/.dircolors)	# dircolors 読込
if [ -e ~/.terminal-color-theme ]
then
  COLOR_THEME=molokai
  source ~/.terminal-color-theme/color-theme-${COLOR_THEME}/${COLOR_THEME}.sh
  eval $(dircolors)
fi
# ------------------------------------------------------------------------------
# プロンプト
# ------------------------------------------------------------------------------
# PROMPT="%n@%m$ "			# user@host$
# RPROMPT="[%~]"			# 現在のパスを右側に表示
PROMPT="%n@%m:%~$ "			# debian 風 (user@host:path$)
local csd=`hostname`			# hostnameとidでプロンプトに自動配色
local clr=$'%{\e[38;5;'"$(printf "%d\n" 0x$(echo $csd|md5sum|cut -c1-2))"'m%}'
local rst=$'%{\e[m%}'
PROMPT="%B$clr$PROMPT$rst%b"		# 全体をboldする
# ------------------------------------------------------------------------------
# 補完
# ------------------------------------------------------------------------------
autoload -U compinit; compinit -u	# 強力な補完機能
setopt auto_cd				# ディレクトリ名のみでcd
setopt correct				# コマンドの間違いを修正する
setopt list_packed			# 候補を詰めて表示する
setopt nolistbeep			# 補完時のビープ音を無効にする
setopt list_types			# 保管候補の表示で ls -F
setopt auto_param_slash			# ディレクトリの末尾に / 付加
setopt auto_remove_slash		# スペースで / を削除
#autoload predict-on; predict-on	# コマンドの先方予測 (*表示が煩わしい*)
setopt complete_aliases			# 補完する前にオリジナルコマンドに展開
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}	# カラー表示
setopt noautoremoveslash		# パスの最後の / を自動削除しない
setopt auto_pushd			# cd でディレクトリスタックに自動保存
setopt pushd_ignore_dups		# 重複してディレクトリスタック保存しない
setopt correct				# コマンドの間違いを修正する
setopt nolistbeep			# 補完時のビープ音を無効にする
# ------------------------------------------------------------------------------
# 履歴
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history			# 履歴ファイルの保存場所
HISTSIZE=100000000			# 履歴ファイルの最大サイズ
SAVEHIST=100000000			# 履歴ファイルの最大サイズ
setopt auto_pushd			# 移動したディレクトリを自動でpush
setopt hist_ignore_all_dups		# 重複した履歴を保存しない
setopt hist_save_no_dups		# 古いコマンドと同じものは無視
setopt hist_no_store			# historyコマンドは履歴に登録しない
setopt hist_reduce_blanks		# 空白を詰めて保存
setopt hist_expire_dups_first		# 履歴削除時に重複行を優先して削除
setopt share_history			# 履歴をプロセスで共有する
setopt hist_verify			# 履歴選択後、実行前に編集可能にする
setopt inc_append_history		# 履歴をインクリメンタルに追加
# ------------------------------------------------------------------------------
# 履歴の検索
# ------------------------------------------------------------------------------
autoload history-search-end		# コマンド履歴の検索(カーソルを行末へ)
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^P" history-beginning-search-backward-end	# Ctrl+P で前方検索する
bindkey "^N" history-beginning-search-forward-end 	# Ctrl+N で後方検索する
if is-at-least 4.3.10
then
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^S' history-incremental-pattern-search-forward
fi
# ------------------------------------------------------------------------------
# キーバインド
# ------------------------------------------------------------------------------
bindkey -e				# Emacs キーバインド
bindkey "^[u" undo			# Esc+u でアンドゥ
bindkey "^[r" redo			# Esc-r でリドゥ
# ------------------------------------------------------------------------------
# ウィンドウタイトルの更新
# ------------------------------------------------------------------------------
precmd() {
  echo -ne "\033]0;${HOST%%.*}:${PWD}\007"
}
# ------------------------------------------------------------------------------
# その他
# ------------------------------------------------------------------------------
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'	# Ctrl-W で / は区切り文字とする
setopt re_match_pcre 2>/dev/null	# (可能なら) PCRE 互換の正規表現を使う
setopt brace_ccl			# {1-9A-Za-z}で文字範囲を展開
# ------------------------------------------------------------------------------
# zmv (see. http://mollifier.hatenablog.com/entry/20101227/p1)
# ------------------------------------------------------------------------------
autoload -Uz zmv
alias zmv='noglob zmv -W'
# ------------------------------------------------------------------------------
# 最近移動したディレクトリを記録 cdr (zsh-4.3.15 以降)
# ------------------------------------------------------------------------------
if is-at-least 4.3.15
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 5000
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi
# ------------------------------------------------------------------------------
# alias (basic)
# ------------------------------------------------------------------------------
alias rm="rm -i"			# 削除時確認
alias cp="cp -ip"			# コピー時確認 mode/onwer/timestamp保存
alias mv="mv -i"			# 移動時確認
alias hs="history -E 1"			# 履歴の全検索
# ------------------------------------------------------------------------------
# auto-fu (https://github.com/hchbaw/auto-fu.zsh.git)
# ------------------------------------------------------------------------------
# if [ -e ~/.zsh/auto-fu.zsh ]
# then
#   source ~/.zsh/auto-fu.zsh/auto-fu.zsh
#   function zle-line-init() { auto-fu-init }
#   zle -N zle-line-init
#   zstyle ':completion:*' completer _oldlist _complete
#   zstyle ':auto-fu:var' postdisplay $''
# fi
# ------------------------------------------------------------------------------
# autojump (http://github.com/joelthelion/autojump.git)
# ------------------------------------------------------------------------------
# if [ -e ~/.zsh/autojump ]
# then
#   path=(~/.zsh/autojump/bin $path)
#   fpath=(~/.zsh/autojump/bin $fpath)
#   source ~/.zsh/autojump/bin/autojump.zsh
# fi
# ------------------------------------------------------------------------------
# zaw (https://github.com/zsh-users/zaw.git
# ------------------------------------------------------------------------------
if [ -e ~/.zsh/zaw ]
then
  source ~/.zsh/zaw/zaw.zsh
  zstyle ':filter-select' case-insensitive yes # 絞り込みをcase-insensitiveに
  zmodload zsh/parameter
  function zaw-src-dirstack() {
      : ${(A)candidates::=$dirstack}
      actions=("zaw-callback-execute"
               "zaw-callback-replace-buffer"
               "zaw-callback-append-to-buffer")
      act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
  }
  zaw-register-src -n dirstack zaw-src-dirstack

  bindkey '^g^j' zaw-cdr
  bindkey '^g^t' zaw-tmux
  bindkey '^g^h' zaw-history
  bindkey '^g^p' zaw-dirstack
  bindkey '^g^g' zaw-git-files
fi
# ------------------------------------------------------------------------------
# source local zshrc
# ------------------------------------------------------------------------------
test -e .zshrc.local && source .zshrc.local
local __hostname=$(hostname -s)
local __platform=$(uname -s | tr A-Z a-z | sed 's/[^a-z]//g')
test -e .zshrc.${__platform} && source .zshrc.${__platform}
test -e .zshrc.${__hostname} && source .zshrc.${__hostname}
# ------------------------------------------------------------------------------
# 全ての設定が終わってから実行
# ------------------------------------------------------------------------------
typeset -U path cdpath fpath manpath	# パスの重複をなくす

