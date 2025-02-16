#!/usr/bin/env bash

# this script installs all my tools and applications.
# PREREQUISITE: homebrew needs to be already installed
# # Install homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# eval "$(/opt/homebrew/bin/brew shellenv)"

brew install mas

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."

# essentials
brew install --cask ghostty
brew install tmux
brew install bat  # https://github.com/sharkdp/bat (replace cat)
brew install git  # version on MacOs is oldish
brew install git-delta  # https://github.com/dandavison/delta  (replace diff)
brew install curl
brew install wget
brew install autossh
brew install jq
brew install tree
brew install broot  # https://github.com/Canop/broot (replace tree)
brew install dua-cli  # https://github.com/Byron/dua-cli (replace ncdu)
brew install eza  # https://github.com/eza-community/eza (replace ls)
brew install fzf  # https://github.com/sharkdp/fd (replace find)
brew install zoxide


# utilities
brew install xz
brew install zsh-syntax-highlighting
brew install pure
brew install colordiff
brew install micromamba
brew install podman
brew install pocketbase
brew install tealdeer  # tldr (in Rust)
brew install btop

# DBs & tools
brew install ghostscript
brew install imagemagick
brew install duckdb
brew install sqlite

# tools
brew install arc # the Arc browser
brew install yt-dlp
brew install vlc
brew install exiftool
brew install transmission-cli
# minio for OSN
brew install minio/stable/mc

# Python echosystem
brew install pipx

# R ecosystem
brew install r
brew install rstudio
brew install rig

# quarto, pandoc & Co.
brew install pandoc
brew install lua
brew install typst
brew install qvm

# OpenSky Network and ADS-B
brew install trino
brew install rtl_433
brew install dump1090-mutability
brew install soapyrtlsdr
brew install xoolive/homebrew/jet1090

# Rust
brew install rustup-init

## Taps
echo "Tapping Brew..."
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae

## Taps
echo "Tapping Brew..."
brew tap FelixKratz/formulae
brew tap koekeishiya/formulae
brew install skhd
brew install sketchybar

# Cask installations
brew install --cack alfred
brew install --cask calibre
brew install --cask transmission
brew install --cask zotero
brew install --cask zoom

# Fonts
brew install --cask font-fira-code
brew install --cask font-monaspace

# MacOS settings


# Start Services
echo "Starting Services (grant permissions)..."
brew services start skhd
brew services start sketchybar

