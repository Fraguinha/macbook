#!/bin/sh

#
# This script updates the scripts files inside the setup folder used to
# bootstrap MacOS with the packages currently installed on the system
#

### Homebrew

## taps.sh
brew tap | xargs -I '{}' echo 'brew tap {}' > setup/homebrew/taps.sh
chmod +x setup/homebrew/taps.sh

## formulas.sh
brew leaves | sed -e 's/@.*//' -e 's|\(.*/\)*||' | uniq | xargs -I '{}' echo 'brew install {}' > setup/homebrew/formulas.sh
chmod +x setup/homebrew/formulas.sh

## casks.sh
brew list --cask | xargs -I '{}' echo 'brew install --cask {}' > setup/homebrew/casks.sh
chmod +x setup/homebrew/casks.sh

### App Store

## appstore.sh
mas list | awk '{ printf("%s #", $1); $1=""; NF-=1; print $0 }' | xargs -I '{}' echo 'mas install {}' > setup/appstore.sh

### Programming.sh

## Cron

# remove previous crontab configuration
sed -i '' -e "0$(sed -n '/^crontab <<CRON/=' setup/programming.sh),0$(sed -n '/^CRON/=' setup/programming.sh)d" setup/programming.sh

# add current crontab configuration
{
  echo 'crontab <<CRON'
  crontab -l
  echo 'CRON'
} | tail -r | xargs -I '{}' sed -i '' -e '/^# cron/a\
{}' setup/programming.sh

## Opam

# remove previous switch
sed -i '' -e '/opam switch create.*$/d' setup/programming.sh

# add latest switch
opam switch list-available | grep "ocaml-base-compiler.*Official release" \
  | awk '{ printf("%s\n", $2) }' | tail -n 1 | xargs -I '{}' sed -i '' -e '/^opam init/a\
opam switch create default {}' setup/programming.sh

# remove previous package list
sed -i '' -e '/opam install -y.*$/d' setup/programming.sh

# add current package list
opam list -s --roots | xargs -I '{}' sed -i '' -e '/^opam switch create/a\
opam install -y {}' setup/programming.sh

# Javascript

# remove previous package list
sed -i '' -e '/npm install --location=global.*$/d' setup/programming.sh

# add current package list
npm list -g --depth 0 | awk '{ printf("%s\n", $2) }' | cut -d "@" -f 1 | xargs -I '{}' sed -i '' -e '/^nvm install node/a\
npm install --location=global {}' setup/programming.sh

## Python

# remove previous package list
sed -i '' -e '/pip3 install -U.*$/d' setup/programming.sh

# add current package list
pip-chill --no-version | xargs -I '{}' sed -i '' -e '/^# python/a\
pip3 install -U {}' setup/programming.sh
