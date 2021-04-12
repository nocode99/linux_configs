# Script to set up Mac OSX dependencies

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Setup brew packages
PACKAGES=( asdf zplug tldr pipx gawk gpg xclip jq diff-so-fancy )
for package in "${PACKAGES[@]}";
do
  brew install $package
done
