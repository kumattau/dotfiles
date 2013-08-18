# ------------------------------------------------------------------------------
# common
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8			# 日本語設定
export TERM=xterm-256color		# ターミナル256色
# ------------------------------------------------------------------------------
# color
# ------------------------------------------------------------------------------
autoload -U colors; colors		# カラー機能
[ -e ~/.dircolors ] && eval `dircolors -b ~/.dircolors`	# dircolors 読み込み
# ------------------------------------------------------------------------------
# プロンプト
# ------------------------------------------------------------------------------
# PROMPT="%n@%m$ "			# user@host$
# RPROMPT="[%~]"			# 現在のパスを右側に表示
PROMPT="%n@%m:%~$ "			# debian 風 (user@host:path$)
# ------------------------------------------------------------------------------
# 補完
# ------------------------------------------------------------------------------
autoload -U compinit; compinit -u	# 強力な補完機能
setopt auto_cd				# ディレクトリ名のみでcd
setopt correct				# コマンドの間違いを修正する
setopt list_packed			# 候補を詰めて表示する
setopt nolistbeep			# 補完時のビープ音を無効にする
#autoload predict-on; predict-on	# コマンドの先方予測 (*表示が煩わしい*)
setopt complete_aliases			# 補完する前にオリジナルコマンドに展開
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}	# カラー表示
setopt noautoremoveslash		# パスの最後の / を自動削除しない
# ------------------------------------------------------------------------------
# 履歴
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_histroy			# 履歴ファイルの保存場所
HISTSIZE=100000000			# 履歴ファイルの最大サイズ
SAVEHIST=100000000			# 履歴ファイルの最大サイズ
setopt auto_pushd			# 移動したディレクトリを自動でpush
setopt hist_ignore_dups			# 重複した履歴を保存しない
setopt share_history			# 履歴をプロセスで共有する
autoload history-search-end		# コマンド履歴の検索
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end	# Ctrl+P で前方検索する
bindkey "^N" history-beginning-search-forward-end 	# Ctrl+N で後方検索する
# ------------------------------------------------------------------------------
# キーバインド
# ------------------------------------------------------------------------------
bindkey -e				# Emacs キーバインド
# ------------------------------------------------------------------------------
# その他
# ------------------------------------------------------------------------------
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'	# Ctrl-W で / は区切り文字とする
setopt re_match_pcre			# PCRE 互換の正規表現を使う
# ------------------------------------------------------------------------------
# alias
# ------------------------------------------------------------------------------
alias la="ls -a"
alias ll="ls -l"
alias rm="rm -i"			# 削除時確認
alias cp="cp -ip"			# コピー時確認mode/onwer/timestamp保存
alias mv="mv -i"			# 移動時確認
alias hs="history -E -n 1"		# 履歴の全検索
# ------------------------------------------------------------------------------
# source local zshrc
# ------------------------------------------------------------------------------
_platform=`uname -s | tr A-Z a-z`
_hostname=`uname -n`
test -e .zshrc.${_platform} && source .zshrc.${_platform}
test -e .zshrc.${_hostname} && source .zshrc.${_hostname}

