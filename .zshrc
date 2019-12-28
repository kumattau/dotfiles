# ------------------------------------------------------------------------------
# common
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8			# 日本語設定
autoload -U is-at-least			# zsh バージョン切り分けモジュール
# ------------------------------------------------------------------------------
# local PATH
# ------------------------------------------------------------------------------
# if [ -e "$HOME/.local" ]
# then
#     export PATH="$HOME/.local:$PATH"
# fi
# ------------------------------------------------------------------------------
# PAGER
# ------------------------------------------------------------------------------
if which lv >/dev/null 2>&1
then
    export PAGER=lv
    export LV="-c -Outf8" 		# エスケープシーケンス解釈・UTF-8変換
fi
# ------------------------------------------------------------------------------
# EDITOR
# ------------------------------------------------------------------------------
if which vim >/dev/null 2>&1
then
    export EDITOR=vim
fi
# ------------------------------------------------------------------------------
# TERM
# ------------------------------------------------------------------------------
__export_best_term ()
{
    local term
    local prefix
    for term in "$@"
    do
        prefix=$(echo $term | cut -c1)
        if [ -f /lib/terminfo/$prefix/$term -o \
	     -f /usr/share/terminfo/$prefix/$term ]
        then
            export TERM=$term
            break
        fi
    done
}
__export_best_term screen-256color screen-color xterm-256color xterm-color xterm
# ------------------------------------------------------------------------------
# terminal color theme
# ------------------------------------------------------------------------------
# https://github.com/sona-tar/terminal-color-theme
__change_terminal_color_theme()
{
    local theme=$1
    if [ -e ~/.terminal-color-theme ]
    then
        source ~/.terminal-color-theme/color-theme-$theme/$theme.sh
    fi
}
__change_terminal_color_theme tangotango
# ------------------------------------------------------------------------------
# LS_COLORS
# ------------------------------------------------------------------------------
eval $(dircolors -b)

# https://github.com/trapd00r/LS_COLORS
__export_ls_colors_by_dircolors()
{
    if [ -e ~/.dircolors ]
    then
        eval $(dircolors -b ~/.dircolors)
    fi
}
# https://github.com/sharkdp/vivid
__export_ls_colors_by_vivid()
{
    local theme=$1
    if which vivid >/dev/null 2>&1
    then
        export LS_COLORS="$(vivid generate $theme)"
    fi
}
# __export_ls_colors_by_dircolors
# __export_ls_colors_by_vivid solarized-dark
# ------------------------------------------------------------------------------
# プロンプト
# ------------------------------------------------------------------------------
# 文字列に明るい色を割り当てる
# http://kakurasan.ehoh.net/summary/palette.color256.term.html
# https://stackoverflow.com/questions/15682537/ansi-color-specific-rgb-sequence-bash
__str2color_256b() {
    local arg="$1"
    local cmd

    local i
    local j

    local key

    for cmd in sha1sum md5sum cksum sum
    do
        if which $cmd >/dev/null 2>&1
        then
            break
        fi
    done

    key=""
    for ((j = 0; j < 100; j++))
    do
        key="$key$arg"

        local sig=$(echo "$key" | $cmd | awk '{print $1}')
        local len=$(printf "$sig" | wc -c)

        for ((i = 1; i + 2 <= len; i++))
        do
            local R=$(($(printf "%d" "0x"$(echo $sig | cut -c$((i + 0)))) % 6))
            local G=$(($(printf "%d" "0x"$(echo $sig | cut -c$((i + 1)))) % 6))
            local B=$(($(printf "%d" "0x"$(echo $sig | cut -c$((i + 2)))) % 6))
            # グレースケールは省く
            if ((R == G && G == B))
            then
                continue
            fi
            # 青系はディレクトリの配色と被るので省く
            if ((R < B || G < B))
            then
                continue
            fi
            # GBR 値の合計が大きい(明るい)場合、採用する
            local sum=$((R + G + B))
            if ((9 <= sum && sum <= 12))
            then
                echo $((16 + 36 * R + 6 * G + B))
                return 0
            fi
        done
    done

    return 1
}
# https://gist.github.com/XVilka/8346728
__str2color_true() {
    local arg="$1"
    local cmd

    local i
    local j

    local key

    for cmd in sha1sum md5sum cksum sum
    do
        if which $cmd >/dev/null 2>&1
        then
            break
        fi
    done

    key=""
    for ((j = 0; j < 100; j++))
    do
        key="$key$arg"

        local sig=$(echo "$key" | $cmd | awk '{print $1}')
        local len=$(printf "$sig" | wc -c)

        for ((i = 1; i + 5 <= len; i++))
        do
            local R=$(printf "%d" "0x"$(echo $sig | cut -c$((i + 0)),$((i + 1))))
            local G=$(printf "%d" "0x"$(echo $sig | cut -c$((i + 2)),$((i + 3))))
            local B=$(printf "%d" "0x"$(echo $sig | cut -c$((i + 4)),$((i + 5))))
            # グレースケールは省く
            if ((R == G && G == B))
            then
                continue
            fi
            # 青系はディレクトリの配色と被るので省く
            if ((R < B || G < B))
            then
                continue
            fi
            # GBR 値の合計が大きい(明るい)場合、採用する
            if ((128 < R && 128 < G && 128 < B))
            then
                echo "$R;$G;$B"
                return 0
            fi
        done
    done

    return 1
}
# 配色テスト関数(引数の文字列をカラー番号に変換して色付きで表示)
__print_str2color() {
    local str
    local col
    local lbl
    for str in "$@"
    do
        col="$(__str2color_256b $str)"
        lbl="$(printf "%3d %s" $col $str)"
        echo -e "\e[38;5;${col}m${lbl}\e[m"

        col="$(__str2color_true $str)"
        lbl="$(printf "%s %s" $col $str)"
        echo -e "\e[38;2;${col}m${lbl}\e[m"
    done
}
#local __clr=$'%{\e[38;5;'$(__str2color_256b ${HOST%%.*})'m%}'
local __clr=$'%{\e[38;2;'$(__str2color_true ${HOST%%.*})'m%}'
local __rst=$'%{\e[m%}'
PROMPT="%n@%m:%~$ "			# debian 風 (user@host:path$)
PROMPT="$__clr$PROMPT$__rst"		# ホスト名で色をつける
PROMPT="%B$PROMPT%b"			# 全体をboldする
unset __clr
unset __rst
# ------------------------------------------------------------------------------
# キーバインド
# ------------------------------------------------------------------------------
bindkey -e				# Emacs キーバインド (リセットされる)
bindkey "^[u" undo			# Esc+u でアンドゥ
bindkey "^[r" redo			# Esc-r でリドゥ
# ------------------------------------------------------------------------------
# 補完
# ------------------------------------------------------------------------------
autoload -U compinit; compinit -u	# 強力な補完機能
setopt auto_cd				# ディレクトリ名のみでcd
setopt correct				# コマンドの間違いを修正する
setopt list_packed			# 候補を詰めて表示する
setopt nolistbeep			# 補完時のビープ音を無効にする
setopt list_types			# 保管候補の表示で ls -F
setopt auto_param_keys			# カッコの対応などを自動的に補完する
setopt auto_param_slash			# ディレクトリの末尾に / 付加
setopt auto_remove_slash		# スペースで / を削除
#autoload predict-on; predict-on	# コマンドの先方予測 (*表示が煩わしい*)
setopt complete_aliases			# 補完する前にオリジナルコマンドに展開
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}	# カラー表示
setopt noautoremoveslash		# パスの最後の / を自動削除しない
setopt auto_pushd			# cd でディレクトリスタックに自動保存
setopt pushd_ignore_dups		# 重複してディレクトリスタック保存しない
setopt magic_equal_subst		# 引数の = 以降も補完する
setopt auto_menu			# 補完キー連打で自動で補完
setopt auto_list			# 複数の補完を一行で表示する
setopt complete_in_word			# カーソル位置で補完
setopt glob_complete			# glob を展開しない
setopt numeric_glob_sort		# 辞書順ではなく数字順に並べる
setopt mark_dirs			# ディレクトリにマッチした場合 / を追加
autoload -U bashcompinit; bashcompinit -u	# bash 補完サポート
# ------------------------------------------------------------------------------
# 履歴
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history			# 履歴ファイルの保存場所
HISTSIZE=100000000			# 履歴ファイルの最大サイズ
SAVEHIST=100000000			# 履歴ファイルの最大サイズ
setopt auto_pushd			# 移動したディレクトリを自動でpush
setopt hist_expand			# 保管時にヒストリを自動的に展開する
setopt hist_ignore_dups			# 直前と同じ履歴を保存しない
setopt hist_ignore_all_dups		# 重複した履歴を保存しない
setopt append_history			# 複数の履歴を追加で保存
setopt inc_append_history		# 履歴をインクリメンタルに追加
setopt hist_save_no_dups		# 古いコマンドと同じものは無視
setopt hist_no_store			# historyコマンドは履歴に登録しない
setopt hist_reduce_blanks		# 空白を詰めて保存
setopt hist_expire_dups_first		# 履歴削除時に重複行を優先して削除
setopt share_history			# 履歴をプロセスで共有する
setopt hist_verify			# 履歴選択後、実行前に編集可能にする
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
# ウィンドウタイトルの更新
# ------------------------------------------------------------------------------
precmd()
{
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}
# ------------------------------------------------------------------------------
# その他
# ------------------------------------------------------------------------------
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'	# Ctrl-W で / は区切り文字とする
setopt re_match_pcre 2>/dev/null	# (可能なら) PCRE 互換の正規表現を使う
setopt brace_ccl			# {1-9A-Za-z}で文字範囲を展開
setopt no_beep				# ビープ音を鳴らさないようにする
setopt long_list_jobs			# jobs -l で表示
setopt multios				# 複数のリダイレクトやパイプに対応
setopt print_eightbit			# 8ビット目を通す(日本語対応)
# ------------------------------------------------------------------------------
# zmv (see. http://mollifier.hatenablog.com/entry/20101227/p1)
# ------------------------------------------------------------------------------
autoload -U zmv
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
# auto-fu (https://github.com/hchbaw/auto-fu.zsh.git)
# ------------------------------------------------------------------------------
if [ -e ~/.zsh/auto-fu.zsh ]
then
    source ~/.zsh/auto-fu.zsh/auto-fu.zsh
    function zle-line-init() { auto-fu-init }
    zle -N zle-line-init
    zstyle ':completion:*' completer _oldlist _complete
    zstyle ':auto-fu:var' postdisplay $''
fi
# ------------------------------------------------------------------------------
# autojump (http://github.com/joelthelion/autojump.git)
# ------------------------------------------------------------------------------
if [ -e ~/.zsh/autojump ]
then
    path=(~/.zsh/autojump/bin $path)
    fpath=(~/.zsh/autojump/bin $fpath)
    source ~/.zsh/autojump/bin/autojump.zsh
fi
# ------------------------------------------------------------------------------
# zaw (https://github.com/zsh-users/zaw.git
# ------------------------------------------------------------------------------
if is-at-least 4.3.10 && [ -e ~/.zsh/zaw ]
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
# common alias
# ------------------------------------------------------------------------------
alias ls="ls --indicator=classify --literal --color=auto --time-style=long-iso --show-control-chars"
alias rm="rm -i"			# 削除時確認
alias cp="cp -ip"			# コピー時確認 mode/onwer/timestamp保存
alias mv="mv -i"			# 移動時確認
alias hs="history -E 1"			# 履歴の全検索
alias vi="vim"				# vi の代わりに vim を使う
alias view="vim -R"			# view の代わりに vim を使う
# ------------------------------------------------------------------------------
# pbcopy emulated by xsel
# ------------------------------------------------------------------------------
if which xsel >/dev/null 2>&1
then
    if ! which pbcopy >/dev/null 2>&1
    then
        alias="xsel --clipboard --input"
    fi
    if ! which pbpaste >/dev/null 2>&1
    then
        alias="xsel --clipboard --output"
    fi
fi
# ------------------------------------------------------------------------------
# wcwidth-cjk
# ------------------------------------------------------------------------------
# https://github.com/fumiyas/wcwidth-cjk
# if which wcwidth-cjk >/dev/null 2>&1
# then
#     solib="$(cd $(dirname $(which wcwidth-cjk))/../lib && pwd)/wcwidth-cjk.so"
#     if [ -f "$solib" ]
#     then
#         if [ -z "$LD_PRELOD" ]
#         then
#             export LD_PRELOAD="$solib"
#         else
#             export LD_PRELOAD="$solib:$LD_PRELOAD"
#         fi
#     fi
#     unset solib
# fi
# ------------------------------------------------------------------------------
# source local zshrc
# ------------------------------------------------------------------------------
test -e ~/.zshrc.local && source ~/.zshrc.local
local __hostname=${HOST%%.*}
local __platform=$(uname -s | tr A-Z a-z | sed 's/[^a-z]//g')
test -e ~/.zshrc.${__platform} && source ~/.zshrc.${__platform}
test -e ~/.zshrc.${__hostname} && source ~/.zshrc.${__hostname}
# ------------------------------------------------------------------------------
# 全ての設定が終わってから実行
# ------------------------------------------------------------------------------
typeset -U path cdpath fpath manpath	# パスの重複をなくす

