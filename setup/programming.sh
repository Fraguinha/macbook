# zsh
source ~/.zshrc && compaudit | xargs chmod g-w

# cron
crontab <<EOF
SHELL=/bin/zsh
HOME=/Users/fraguinha
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
00 17 * * * { cd ~/GitHub/macbook && ./update.sh && ./commit.sh } &> /dev/null
10 17 * * * { brew update && brew upgrade && brew upgrade --cask && brew cleanup } &> /dev/null
20 17 * * * { opam update && opam upgrade -y && opam clean } &> /dev/null
30 17 * * * { rustup update } &> /dev/null
EOF

# python
pip3 install virtualenv
pip3 install pytest
pip3 install pylint
pip3 install pwntools
pip3 install pip-chill
pip3 install numpy
pip3 install jupyter
pip3 install flask
pip3 install coverage
pip3 install autopep8

# ocaml
opam init
opam install -y utop
opam install -y ocamlformat
opam install -y ocaml-lsp-server
opam install -y ocaml-base-compiler
opam install -y merlin
opam install -y core

# rust
rustup-init

# neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# vscode
code \
    --install-extension vscjava.vscode-maven \
    --install-extension vscjava.vscode-java-test \
    --install-extension vscjava.vscode-java-pack \
    --install-extension vscjava.vscode-java-dependency \
    --install-extension vscjava.vscode-java-debug \
    --install-extension VisualStudioExptTeam.vscodeintellicode \
    --install-extension tomoki1207.pdf \
    --install-extension SonarSource.sonarlint-vscode \
    --install-extension rust-lang.rust \
    --install-extension redhat.java \
    --install-extension ocamllabs.ocaml-platform \
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
    --install-extension haskell.haskell \
    --install-extension GitLab.gitlab-workflow \
    --install-extension GitHub.vscode-pull-request-github \
    --install-extension GitHub.github-vscode-theme \
    --install-extension fredhappyface.x8664assembly \
    --install-extension ecmel.vscode-html-css \
    --install-extension Dart-Code.flutter \
    --install-extension Dart-Code.dart-code \
    --install-extension asvetliakov.vscode-neovim
