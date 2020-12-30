(column-number-mode 1)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(require 'package)
(setq-default frames-only-mode t
              indent-tabs-mode nil
              package-archives nil
              package-enable-at-startup nil)
(package-initialize)
(eval-when-compile
  (require 'use-package))
(load-theme 'wombat)
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)
(global-set-key (kbd "s-u") 'revert-buffer)
(setq-default fill-column 80)
(use-package crux
  :demand
  :config (global-set-key (kbd "C-a") 'crux-move-beginning-of-line))
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))
(use-package idris-mode
  :config
  (setq idris-interpreter-path "idris2")
  :mode ("\\.idr\\'"))
(use-package nix-mode
  :mode ("\\.nix\\'"))
(use-package smex
  :demand
  :config
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))
(use-package whitespace-cleanup-mode
  :demand
  :config (global-whitespace-cleanup-mode t))
