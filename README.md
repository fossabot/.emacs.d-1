<div align="center">
    <h1><i>Fastiter Emacs</i></h1>
    simple Emacs configuration using custom tooling
</div>
<h3></h3>

This is my new Emacs configuration, after having given up my literate and evil-centric [old setup](https://github.com/leotaku/literate-emacs).
It uses my own [fi-emacs](https://github.com/leotaku/fi-emacs) to structure its init file in a file-centric and consistent manner.

+ init.el :: main configuration
+ lisp :: more specific configurations

+ early-init.el :: early loaded settings and packages
+ load-packages.el :: load all packages using [straight.el](https://github.com/raxod502/straight.el)
+ package-set.el :: all external packages
+ straight :: directory where straight.el stores its files.
  + versions/defaut.el :: lockfile for straight.el
+ var :: managed by [no-littering.el](https://github.com/emacscollective/no-littering)
+ etc :: managed by no-littering.el


The custom vi-like keybinding theme centers around [modalka](https://github.com/mrkkrp/modalka) and my own [theist-mode](https://github.com/leotaku/theist-mode).
Otherwise we use many great and helpful packages from the Emacs community. 
Simply visit [package-set.el](package-set.el) to find them.
