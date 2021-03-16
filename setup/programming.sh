# zsh
source ~/.zshrc && compaudit | xargs chmod g-w

# cron
crontab <<EOF
SHELL=/bin/zsh
HOME=/Users/fraguinha
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
00 17 * * * { brew update && brew upgrade && brew upgrade --cask && brew cleanup } &> /dev/null
05 17 * * * { opam update && opam upgrade -y && opam clean } &> /dev/null
10 17 * * * { rustup update } &> /dev/null
00 18 * * * { cd ~/GitHub/macbook && ./update.sh && ./commit.sh } &> /dev/null
EOF

# python
pip3 install -U virtualenv
pip3 install -U pytest
pip3 install -U pylint
pip3 install -U pwntools
pip3 install -U pip-chill
pip3 install -U numpy
pip3 install -U jupyter
pip3 install -U flask
pip3 install -U coverage
pip3 install -U autopep8

# ocaml
opam init
opam switch create default 4.12.0
opam install -y utop
opam install -y ocamlformat
opam install -y ocaml-lsp-server
opam install -y ocaml-base-compiler
opam install -y merlin
opam install -y core

# neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

# vscode
code \
    --install-extension vscjava.vscode-maven \
    --install-extension vscjava.vscode-java-test \
    --install-extension vscjava.vscode-java-pack \
    --install-extension vscjava.vscode-java-dependency \
    --install-extension vscjava.vscode-java-debug \
    --install-extension VisualStudioExptTeam.vscodeintellicode \
    --install-extension streetsidesoftware.code-spell-checker-portuguese \
    --install-extension streetsidesoftware.code-spell-checker \
    --install-extension SonarSource.sonarlint-vscode \
    --install-extension rust-lang.rust \
    --install-extension redhat.java \
    --install-extension ocamllabs.ocaml-platform \
    --install-extension ms-vsliveshare.vsliveshare-pack \
    --install-extension ms-vsliveshare.vsliveshare-audio \
    --install-extension ms-vsliveshare.vsliveshare \
    --install-extension ms-vscode.hexeditor \
    --install-extension ms-vscode.cpptools \
    --install-extension ms-vscode-remote.remote-ssh-edit \
    --install-extension ms-vscode-remote.remote-ssh \
    --install-extension ms-vscode-remote.remote-containers \
    --install-extension ms-toolsai.jupyter \
    --install-extension ms-python.vscode-pylance \
    --install-extension ms-python.python \
    --install-extension ms-azuretools.vscode-docker \
    --install-extension justusadam.language-haskell \
    --install-extension JHeilingbrunner.vscode-gnupg-tool \
    --install-extension James-Yu.latex-workshop \
    --install-extension haskell.haskell \
    --install-extension GitLab.gitlab-workflow \
    --install-extension GitHub.vscode-pull-request-github \
    --install-extension GitHub.github-vscode-theme \
    --install-extension fredhappyface.x8664assembly \
    --install-extension ecmel.vscode-html-css \
    --install-extension Dart-Code.flutter \
    --install-extension Dart-Code.dart-code \
    --install-extension asvetliakov.vscode-neovim
