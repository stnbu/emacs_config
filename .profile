[[ -r ~/.bashrc ]] && . ~/.bashrc

GOPATH=~/gocode
PATH="$PATH:$GOPATH/"bin
PATH="$PATH:"~/gocode/bin
export GOPATH PATH
export VISUAL=nano ; export EDITOR=nano
alias grsm='go run ~/git/ck-www/server/main.go'
PATH="$PATH:/usr/local/Cellar/mongodb@3.6/3.6.8_1/bin"
PATH=~/bin:"$PATH"
