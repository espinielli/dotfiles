# Dotfiles and machine configuration

Everything[^1] is under version control in GitHub and have done so to be able to install other machines in a reproducible way.

The software I need is typically installed via [Homebrew][brew], so it is quite MacOS oriented.
Installing from Apple Store could benefit from [mas](https://github.com/mas-cli/mas) but I haven't tried yet.

I store the instructions to do set my machines up in various files/scripts similarly to what
[Mathias Bynens][mathias] did.

[^1]: well almost, I am not yet decided on how to manage secrets...separate private repo?
  Then what about framework data/privacy leaks? What about personal mistakes?


# Dotfiles' Repo Setup

I use the [detached work tree approach][otherdwt] whereby I keep my GIT repo away from my HOME directory.


## ignoring, the global setup
The following is expecially needed for a dotfiles repo

* setup what to ignore:
  ```shell
  $ cd $HOME
  $ cat <<EOF
  # specific ignores
  .DS_Store
  *.pyc
  node_modules
  # do not ignore:
  !bin/
  EOF > $HOME/.gitignore_global
  ```
* and add it to the global git config in $HOME
  ```shell
  $ git config --global core.excludesfile $HOME/.gitignore_global
  ```

## Initial Setup: put your dotfiles under git ##
I got inspired by [this post][worktreeblog] (no more reacheable) and this is how I did it:

* create your git repo
  ```shell
  $ cd $HOME
  $ mkdir -p $HOME/.dotfiles
  ```
* make an alias, `home`, to manage this special repo
  ```shell
  $ echo "alias home='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
  $ source $HOME/.zshrc
  ```
* init the repo and start adding dotfiles
  ```shell
  $ home init
  $ home add $HOME/.bash_profile $HOME/.bashrc $HOME/.bash_aliases
  $ home commit -m 'Initial commit'
  $ home remote add origin git@github.com:espinielli/.dotfiles
  $ home push origin master
  ```

## set it up on a second/third/... machine
Now to use (and contribute) from a different machine

* backup your existing dot files
* clone the repo
  ```shell
  $ cd $HOME
  $ git clone https://github.com/espinielli/dotfiles.git /tmp/dotfiles.git
  ```
* move git repo configuration info in `$HOME/.dotfiles/`
  ```shell
  $ mv /tmp/dotfiles.git/.git $HOME/.dotfiles/
  ```
* enable `dotglob` and copy the dot files to `$HOME`
  ```shell
  $ setopt -s dotglob # in bash
  $ setopt globdots # in zsh
  $ mv -i /tmp/dotfiles.git/* $HOME
  ```
Finally properly configure what to ignore, see the ['ignoring' section](#ignoring) above.

Use `home ls-files` to list the version controlled dotfiles.


## Install applications
Execute
```shell
$HOME/.github/brew.sh
```

# Shell configuration

See [`.zsh-config`](../.zsh-config).

# References #

1. [Detached work tree][worktreeblog] approach.
1. I got inspired from [this][silas], [this][otherdwt] and [this][anotherdotfile] as well.


[worktreeblog]: http://sursolid.com/managing-home-dotfiles-with-git-and-github
[silas]: http://silas.sewell.org/blog/2009/03/08/profile-management-with-git-and-github/
[anotherdotfile]: http://gmarik.info/blog/2010/05/02/tracking-dotfiles-with-git
[xres]: https://github.com/altercation/solarized/blob/master/xresources-colors-solarized/Xresources
[osxsol]: https://github.com/altercation/solarized/tree/master/osx-terminal.app-colors-solarized
[brew]: http://mxcl.github.com/homebrew/ "homebrew"
[mathias]: https://github.com/mathiasbynens/dotfiles "Mathias Bynens' dotfiles"
[otherdwt]: https://www.electricmonk.nl/log/2015/06/22/keep-your-home-dir-in-git-with-a-detached-working-directory/
