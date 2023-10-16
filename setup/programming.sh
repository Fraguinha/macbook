#!/bin/sh

# zsh
# shellcheck source=/dev/null
. ~/.zshrc && compaudit | xargs chmod g-w

# cron
crontab <<CRON
SHELL=/bin/zsh
HOME=/Users/fraguinha
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
00 17 * * * { brew update && brew upgrade && brew autoremove && brew cleanup } &> /dev/null
05 17 * * * { opam update; opam upgrade -y; opam clean } &> /dev/null
10 17 * * * { rustup update } &> /dev/null
00 18 * * * { source $HOME/.variables.zsh; cd $HOME/$WORKSPACE/macbook && ./update.sh; ./commit.sh } &> /dev/null
CRON

# ocaml
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh | sh

opam init
opam switch create default 5.1.0
opam install -y vscoq-language-server
opam install -y utop
opam install -y ocamlformat-rpc
opam install -y ocamlformat
opam install -y ocaml-lsp-server
opam install -y ocaml-base-compiler
opam install -y js_of_ocaml-ppx
opam install -y js_of_ocaml
opam install -y coq

# haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# rust
curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh

# java
curl --proto '=https' --tlsv1.2 -sSf https://get.sdkman.io | bash

sdk install java
sdk install maven

# javascript
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

nvm install-latest-npm
nvm install node
npm install --location=global vercel
npm install --location=global npm
npm install --location=global eslint
npm install --location=global corepack

# python
pip3 install -U qscintilla
pip3 install -U python-lsp-jsonrpc
pip3 install -U python-dateutil
pip3 install -U pyqtwebengine
pip3 install -U pyqtpurchasing
pip3 install -U pyqtnetworkauth
pip3 install -U pyqtdatavisualization
pip3 install -U pyqtchart
pip3 install -U pyqt3d
pip3 install -U pylint
pip3 install -U pluggy
pip3 install -U pip-chill
pip3 install -U jedi
pip3 install -U grequests
pip3 install -U docstring-to-markdown
pip3 install -U autopep8
