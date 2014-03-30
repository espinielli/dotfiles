## how to remove keg-only warnings
```bash
$ brew cleanup
Warning: Skipping (old) keg-only: /usr/local/Cellar/...
...
```

Just execute

```bash
$ brew cleanup --force
```

## Where are the formulas for cask?

```bash
cd $(brew --prefix)/Library/Taps/phinze-cask
```