# `zsh` setup

The list and order of [startup files for zsh][zshug] (Ch 2) are (`ZDOTDIR` if not set defaults to `HOME`):

1. `/etc/zshenv`  
  Always run for every zsh. (not present on my MBP)
1. `$ZDOTDIR/.zshenv`  
  Usually run for every zsh (see below).
1. `/etc/zprofile`  
  Run for login shells.
1. `$ZDOTDIR/.zprofile`  
  Run for login shells.
1. `/etc/zshrc`  
  Run for interactive shells.
1. `$ZDOTDIR/.zshrc`  
  Run for interactive shells.
1. `/etc/zlogin`  
  Run for login shells. (not present on my MBP)
1. `$ZDOTDIR/.zlogin`  
  Run for login shells.


## `/etc/zshenv` and `$ZDOTDIR/.zshenv`
`/etc/zshenv` does not exist on macOS.

`$ZDOTDIR/.zshenv` is for user-defined env variables, it is run by every shell invocation.
I added sourcing of `.zprofile` for non-interactive, non-login shells.


## `/etc/zprofile` and `$ZDOTDIR/.zprofile`
`/etc/zprofile` on macOS executes
```shell
$ eval `/usr/libexec/path_helper -s`
```
that sets and exports the system-wide `PATH` and `MANPATH`



[zshug]: <https://zsh.sourceforge.io/Guide/> "zsh user Guide"

# Diagram and possible generalization
A nice diagram and possible generalization for different shells comes from
[this blog post](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html)
and [its companion repo](https://heptapod.host/flowblok/shell-startup).

The possible paths are:
* ${\mathbf{\color{red}RED \longrightarrow}}$: login, interactive
* ${\mathbf{\color{orange}ORANGE \longrightarrow}}$: login, non-interactive
* ${\mathbf{\color{green}GREEN \longrightarrow}}$: non-login, interactive
* ${\mathbf{\color{blue}BLUE \longrightarrow}}$: non-login, non-interactive


![Alt text](https://g.gravizo.com/source/<custom_mark>?<url_source_url_encoded>

![Alt text](https://g.gravizo.com/source/custom_mark10?https%3A%2F%2Fraw.githubusercontent.com%2Fespinielli%2Fdotfiles%2F.zsh-config%2Fmaster%2FREADME.md)
<details> 
<summary></summary>
custom_mark10
digraph {
//    {rank=same;
//    bash
//    zsh
//    sh
//    }

    bash_login [label="login"]
    bash_non_login [label="non-login"]
    bash_interactive [label="interactive"]
    bash_non_interactive [label="non-interactive"]

    bash_remote [label="remote shell\n(running under rsh/ssh)"]
    bash_local [label="normal shell"]

    sh_login [label="login"]
    sh_non_login [label="non-login"]
    sh_interactive [label="interactive"]
    sh_non_interactive [label="non-interactive"]

    zsh_login [label="login"]
    zsh_non_login [label="non-login"]
    zsh_interactive [label="interactive"]
    zsh_non_interactive [label="non-interactive"]

    bash_running [label="running..."]
    sh_running [label="running..."]
    zsh_running [label="running..."]

    // order here is important, see below
    etc_profile [ordering=in]
    {rank=same;
    dot_bash_profile
    dot_bash_login
    dot_profile
    }

    etc_bashrc [label="/etc/bash.bashrc"]
    etc_profile [label="/etc/profile"]
    etc_zshenv [label="/etc/zshenv"]

    dot_bash_login [label="~/.bash_login"]
    dot_bash_logout [label="~/.bash_logout"]
    dot_bash_profile [label="~/.bash_profile"]
    dot_bashrc [label="~/.bashrc"]
    dot_profile [label="~/.profile"]
    dot_zlogin [label="~/.zlogin"]
    dot_zlogout [label="~/.zlogout"]
    {rank=same;
    dot_zprofile [label="~/.zprofile"]
    dot_zshrc [label="~/.zshrc"]
    }
    dot_zshenv [label="~/.zshenv"]

    env [label="$ENV"]
    bash_env [label="$BASH_ENV"]

    // BASH

    // PATH: bash, login, interactive
    edge [color=red, style=solid]
    bash -> bash_local
    bash_local -> bash_login
    bash_login -> bash_interactive
    bash_interactive -> etc_profile

    // order important, see above
    etc_profile -> dot_bash_profile
    etc_profile -> dot_bash_login
    etc_profile -> dot_profile

    dot_bash_profile -> bash_running
    dot_bash_login -> bash_running
    dot_profile -> bash_running

    bash_running -> dot_bash_logout

    // PATH: bash, login, non-interactive
    edge [color=orange, style=solid]
    bash -> bash_local
    bash_local -> bash_login
    bash_login -> bash_non_interactive
    bash_non_interactive -> etc_profile

    // order important, see above
    etc_profile -> dot_bash_profile
    etc_profile -> dot_bash_login
    etc_profile -> dot_profile

    dot_bash_profile -> bash_env
    dot_bash_login -> bash_env
    dot_profile -> bash_env

    bash_env -> bash_running

    bash_running -> dot_bash_logout

    // PATH: bash, non-login, interactive
    edge [color=green, style=solid]
    bash -> bash_local
    bash_local -> bash_non_login
    bash_non_login -> bash_interactive
    bash_interactive -> etc_bashrc
    etc_bashrc -> dot_bashrc

    dot_bashrc -> bash_running

    // PATH: bash, non-login, non-interactive
    edge [color=blue, style=solid]
    bash -> bash_local
    bash_local -> bash_non_login
    bash_non_login -> bash_non_interactive
    bash_non_interactive -> bash_env

    // PATH: bash, remote, login, interactive
    edge [color=purple, style=solid]
    bash -> bash_remote
    bash_remote -> bash_login
    bash_login -> bash_interactive
    bash_interactive -> etc_profile
    etc_profile -> etc_bashrc

    // order important, see above
    etc_bashrc -> dot_bash_profile
    etc_bashrc -> dot_bash_login
    etc_bashrc -> dot_profile

    dot_bash_profile -> bash_running
    dot_bash_login -> bash_running
    dot_profile -> bash_running

    bash_running -> dot_bash_logout

    // PATH: bash, remote, login, non-interactive
    edge [color=black, style=solid]
    bash -> bash_remote
    bash_remote -> bash_login
    bash_login -> bash_non_interactive

    bash_non_interactive -> etc_profile

    // order important, see above
    etc_profile -> dot_bash_profile
    etc_profile -> dot_bash_login
    etc_profile -> dot_profile

    dot_bash_profile -> bash_env
    dot_bash_login -> bash_env
    dot_profile -> bash_env

    bash_env -> bash_running

    // PATH: bash, remote, non-login, interactive
//    edge [color=cyan, style=solid]
//    bash -> bash_remote
//    bash_remote_shell -> dot_bashrc
//
//    dot_bashrc -> bash_running

    // PATH: bash, remote, non-login, non-interactive
    edge [color=grey, style=solid]
    bash -> bash_remote
    bash_remote -> bash_non_login
    bash_non_login -> bash_non_interactive

    bash_non_interactive -> etc_bashrc
    etc_bashrc -> dot_bashrc

    dot_bashrc -> bash_running

    // ZSH

    // PATH: zsh, login, interactive
    edge [color=red, style=solid]
    zsh -> zsh_login
    zsh_login -> zsh_interactive

    zsh_interactive -> etc_zshenv
    etc_zshenv -> dot_zshenv
    dot_zshenv -> dot_zprofile
    dot_zprofile -> dot_zshrc
    dot_zshrc -> dot_zlogin

    dot_zlogin -> zsh_running

    zsh_running -> dot_zlogout

    // PATH: zsh, login, non-interactive
    edge [color=orange, style=solid]
    zsh -> zsh_login
    zsh_login -> zsh_non_interactive

    zsh_non_interactive -> etc_zshenv
    etc_zshenv -> dot_zshenv
    dot_zshenv -> dot_zprofile
    dot_zprofile -> dot_zlogin

    dot_zlogin -> zsh_running

    zsh_running -> dot_zlogout

    // PATH: zsh, non-login, interactive
    edge [color=green, style=solid]
    zsh -> zsh_non_login
    zsh_non_login -> zsh_interactive

    zsh_interactive -> etc_zshenv
    etc_zshenv -> dot_zshenv
    dot_zshenv -> dot_zshrc

    dot_zshrc -> zsh_running

    // PATH: zsh, non-login, non-interactive
    edge [color=blue, style=solid]
    zsh -> zsh_non_login
    zsh_non_login -> zsh_non_interactive

    zsh_non_interactive -> etc_zshenv
    etc_zshenv -> dot_zshenv

    dot_zshenv -> zsh_running

    // SH

    // PATH: sh, login, interactive
    edge [color=red, style=dashed]
    sh -> sh_login
    sh_login -> sh_interactive

    sh_interactive -> dot_profile
    dot_profile -> env

    dot_profile -> sh_running

    // PATH: sh, login, non-interactive
    edge [color=orange, style=dashed]
    sh -> sh_login
    sh_login -> sh_non_interactive

    sh_non_interactive -> dot_profile

    dot_profile -> sh_running

    // PATH: sh, non-login, interactive
    edge [color=green, style=dashed]
    sh -> sh_non_login
    sh_non_login -> sh_interactive

    sh_interactive -> env

    env -> sh_running

    // PATH: sh, non-login, non-interactive
    edge [color=blue, style=dashed]
    sh -> sh_non_login
    sh_non_login -> sh_non_interactive

    sh_non_interactive -> sh_running
}

custom_mark10
</details>

![zsh startup](zsh_dotfiles.png)


# Secretes
for now I keep a non version controlled file `.secret_keys`
