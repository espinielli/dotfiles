# Installation of a new machine (osx) #
The installation of a new machine from scratch is simple, just follow these steps:

1. get and install homebrew

	```bash
	$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
	```
1. install git (in order to retrieve dotfiles repo from github)

	```bash
	$ brew install git
	$ cd $HOME
	$ mkdir git
	```
1. clone the dotfiles repo as detailed [here](http://espinielli.github.io/dotfiles/README.md.html#cloning).
1. install npm
1. now install the apps (and installe cask too)

	```bash
	# install apps via homebrew & python and packages
	$ source .brew
	```
1. define machine name in file `.hostname`

