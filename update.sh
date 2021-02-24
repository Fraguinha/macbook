#!/usr/bin/env zsh

#
# This script updates the scripts files inside the setup folder used to
# bootstrap MacOS with the packages currently installed on the system
#

### Homebrew


## taps.sh
brew tap | xargs -I '{}' echo 'brew tap {}' > setup/homebrew/taps.sh
chmod +x setup/homebrew/taps.sh


## formulas.sh
brew leaves | sed -e 's/@.*//' -e 's|\(.*/\)*||' | xargs -I '{}' echo 'brew install {}' > setup/homebrew/formulas.sh
chmod +x setup/homebrew/formulas.sh


## casks.sh
brew list --cask | xargs -I '{}' echo 'brew install --cask {}' > setup/homebrew/casks.sh
chmod +x setup/homebrew/casks.sh



### App Store


## appstore.sh
mas list | awk '{ printf("%s # %s\n", $1, $2) }' | xargs -I '{}' echo 'mas install {}' > setup/appstore.sh



### Programming.sh


## Cron

# remove previous crontab configuration
sed -i '' -e "0$(sed -n '/^crontab <<EOF/=' setup/programming.sh),0$(sed -n '/^EOF/=' setup/programming.sh)d" setup/programming.sh

# add current crontab configuration
{ echo 'crontab <<EOF'; crontab -l; echo 'EOF' } | tail -r | xargs -I '{}' sed -i '' -e '/^# cron/a\
{}' setup/programming.sh


## Opam

# remove previous switch
sed -i '' -e '/opam switch create.*$/d' setup/programming.sh

# add latest switch
opam switch list-available | grep "ocaml-base-compiler.*Official release" | \
awk '{ printf("%s\n", $2) }' | tail -n 1 | xargs -I '{}' sed -i '' -e '/^opam init/a\
opam switch create default {}' setup/programming.sh

# remove previous package list
sed -i '' -e '/opam install -y.*$/d' setup/programming.sh

# add current package list
opam list -s --roots | xargs -I '{}' sed -i '' -e '/^opam switch create/a\
opam install -y {}' setup/programming.sh


## Python

# remove previous package list
sed -i '' -e '/pip3 install -U.*$/d' setup/programming.sh

# add current package list
pip-chill --no-version | xargs -I '{}' sed -i '' -e '/^# python/a\
pip3 install -U {}' setup/programming.sh


## VSCode extensions

# remove previous extension list
sed -i '' -e '/--install-extension.*$/d' setup/programming.sh

# add current extension list
code --list-extensions | xargs -I '{}' sed -i '' -e '/^code \\/a\
\ \ \ \ --install-extension {} \\' setup/programming.sh

# remove last '\'
sed -i '' -e "$(sed -n '/--install-extension/=' setup/programming.sh | tail -n 1)"'s/ \\//' setup/programming.sh
