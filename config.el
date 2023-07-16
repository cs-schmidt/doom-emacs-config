;;; config.el --- Doom's main user config file -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; Doom's primary configuration file, where 99.9% of your private configuration
;; should be written. This file loads after all other Doom modules have loaded.
;;
;; Doom provides the following functions/macros for configuration:
;;
;;  - `use-package!' for configuring packages
;;  - `after!' for running code after a package has loaded
;;  - `add-load-path' for adding directories to the `load-path', which are
;;    relative to this file. Emacs searches the `load-path' when you load
;;    packages with `require' or `use-package'.
;;  - `load!' for loading external elisp files relative to this one
;;  - `map!' for binding new keys
;;
;; In general, whenever you reconfigure a package that's included by Doom you'll
;; want to wrap it in an `after!' block, otherwise Doom's defaults may override
;; your settings. The exceptions to this rule are as follows:
;;
;;  - Setting doom variables (these start with 'doom-' or '+').
;;  - Setting file/directory variables (e.g., `org-directory').
;;  - Setting variables which explicitly tell you to set them before their
;;    package is loaded.
;;
;;; Code:

;;;; Setup
;; ----------------------------------------------------------------------
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Ethan Schmidt"
      user-mail-address "es.schmidt.cs@gmail.com")

;;;; Styling
;; ----------------------------------------------------------------------
(setq doom-theme 'doom-spacegrey)

;; Sets the default opacity across both active and inactive frames.
(add-to-list 'default-frame-alist '(alpha . (95 95)))

;; Sets the fonts used by Doom. There are five (optional) variables for
;; controlling Doom's fonts:
;;
;;  - `doom-font': The primary font to use.
;;  - `doom-variable-pitch-font': A non-monospace font (used where applicable).
;;  - `doom-big-font': Used for `doom-big-font-mode'.
;;  - `doom-unicode-font': Used for unicode glyphs.
;;  - `doom-serif-font': Used for the `fixed-pitch-serif' face.
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;;
(setq doom-font (font-spec :family "Source Code Pro" :size 13 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 12))

;;;; UI
;; ----------------------------------------------------------------------
(use-package! treemacs
  :init
  (setq +treemacs-git-mode 'deferred)
  :config
  (with-eval-after-load 'doom-themes
    (doom-themes-treemacs-config))
  :custom
  (doom-themes-treemacs-theme "doom-colors")
  (treemacs-width 30))

;;;; Editing
;; ----------------------------------------------------------------------
;; Sets the type of line numbering used by `display-line-numbers-mode'. If set
;; to `nil' line numbers are disabled. For relative numbering, set this to
;; `relative'. (default t)
(setq display-line-numbers-type t)

;; Sets the `fill-column' and enables `display-fill-column-indicator-mode' in
;; a list of desired major modes.
(setq-default fill-column 80)
(add-hook! '(text-mode-hook prog-mode-hook)
           #'display-fill-column-indicator-mode)

;;;; Org Mode
;; ----------------------------------------------------------------------
;; Sets the default location where org files are created. It must be set before
;; org loads.
(setq org-directory "~/org/")

;;; config.el ends here
