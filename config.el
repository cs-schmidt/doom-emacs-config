;;; config.el --- Doom's main user config file -*- lexical-binding: t; -*-
;;
;;; Commentary:
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
(setq doom-theme 'doom-badger)

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
(setq doom-font (font-spec :family "Source Code Pro" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 12))

;;;; Completion
;; ----------------------------------------------------------------------
(after! which-key
  (setq which-key-idle-delay 0.3))

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

;; TODO: Add custom keybindings to lsp-mode.
(use-package! lsp
  :custom
  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-icons-enable t))
;
;;;; Projectile
;; ----------------------------------------------------------------------
(after! projectile
  (setq! projectile-project-search-path '(("~/Work/personal-projects/" . 1)
                                           "~/Study/personal-knowledge-management/")))

;;;; Org Mode
;; ----------------------------------------------------------------------
;; Sets the default location where org files are created. It must be set before
;; org loads.
(setq org-directory "~/org/")

;; TODO: Improve matching in `org-emphasis-regexp-components', see `org-emph-re'
;;       to view the full regex `org-mode' uses to match emphasized text.
(after! org
  (defface zzz/org-link-id '((t :inherit org-link :bold nil :underline nil))
    "Face for `org-mode' links prefixed with 'id:'."
    :group 'org-faces)
  (org-link-set-parameters "id" :face 'zzz/org-link-id)
  (custom-theme-set-faces 'user
                          '(org-document-title ((t . ((:height 1.4 :underline nil)))))
                          '(org-level-1 ((t . ((:inherit outline-1 :height 1.3)))))
                          '(org-level-2 ((t . ((:inherit outline-2 :height 1.2)))))
                          '(org-level-3 ((t . ((:inherit outline-3 :height 1.1)))))
                          '(org-footnote ((t . ((:weight bold :underline nil))))))
  (setq! org-pretty-entities t
         org-fontify-quote-and-verse-blocks t
         org-startup-with-latex-preview t
         org-startup-folded t
         org-startup-indented nil
         org-emphasis-alist '(("*" (:foreground "#bb6dc4" :weight bold))
                              ("/" (:foreground "#2c9372" :slant italic))
                              ("_" (:underline t))
                              ("=" org-verbatim verbatim)
                              ("~" (:foreground "#cc5279" :background "#171c21"))
                              ("+" (:strike-through t)))
         org-hide-emphasis-markers t))

(use-package! org-modern
  :after org
  :init
  (global-org-modern-mode)
  :custom
  (org-modern-list '((?- . "•") (?+ . "➤")))
  (org-modern-tag nil)
  (org-modern-table nil)
  (org-modern-horizontal-rule nil))

(use-package! org-appear
  :after org
  :hook
  (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-inside-latex t))

(use-package! valign
  :after org
  :hook
  (org-mode . valign-mode))

;;;; Org Roam
;; ----------------------------------------------------------------------
(after! org-roam
  (setq! org-roam-directory (file-truename "~/Study/personal-knowledge-management/notes/")
         org-roam-node-display-template (format "${doom-hierarchy:*} %s"
                                                (propertize "${doom-tags:42}" 'face 'org-tag))
         org-roam-capture-templates `(("d" "Default capturing template." plain "%?"
                                       :target (file+head+olp
                                                "${slug}_%<%Y%m%d%H%M%S>.org"
                                                ,(string-join `("#+FILETAGS: <subject> 📝 🌰"
                                                                "#+TITLE: ${title}"
                                                                ,(make-string 80 ?-))
                                                              "\n")
                                                (,(concat "References\n"
                                                          (make-string 80 ?-))))
                                       :unarrowed t)))
  (org-roam-db-autosync-mode))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;;; config.el ends here
