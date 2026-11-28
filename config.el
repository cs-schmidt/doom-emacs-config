;;; config.el --- Doom's main user config file -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; Doom's main configuration file, where "99.9% of your private configuration should go":
;; this file loads after all other Doom modules. Doom provides the following
;; functions/macros for configuration:
;;
;;  1. `use-package!', to configure packages
;;  2. `add-load-path' for adding directories to the `load-path', which are relative to
;;      this file. Emacs searches the `load-path' when you load packages with `require' or
;;      `use-package'.
;;  3. `map!' for binding keys.
;;  4. `after!' to execute code that must load after a particular package
;;
;; In general, when reconfiguring a package that's included by Doom you'll want to wrap it
;; within an `after!' black, otherwise Doom's defaults may override your settings. The
;; exceptions to this rule are as follows:
;;
;;  - Setting doom variables; these begin with 'doom-' or '+'.
;;  - Setting file/directory variables: e.g., `org-directory'.
;;  - Setting variables that directly tell you they must be set before their package is
;;    loaded (e.g., calling a mode hook in the ":init" portion of a `use-package'
;;    expression.
;;
;;; Code:

;;; User Settings
;; ----------------------------------------------------------------------
;; Certain functionality uses this information to identify you: GPG configuration, email
;; clients, file templates and snippets, etc. It is optional.
;; (setq! user-full-name "John Doe"
;;        user-mail-address "john@doe.com")

;;; Doom Settings
;; ----------------------------------------------------------------------

;; Adjusts frame opacity independent of foreground elements (e.g., text).
(add-to-list 'default-frame-alist '(alpha-background . 85))

(setopt doom-theme 'doom-one
        ;; NOTE: `doom-font' should be a monospace font that supports italics.
        doom-font (font-spec :family "Source Code Pro" :size 12)
        doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 12)
        doom-unicode-font (font-spec :family "Noto Color Emoji"))

;;; Package Configuration
;; ----------------------------------------------------------------------

(after! projectile
  (setq projectile-project-search-path '(("~/Career/" . 3)
                                         ("~/Education/" . 3)
                                         ("~/Finance/" . 3)))
  (projectile-discover-projects-in-search-path))

(after! lsp
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-headerline-breadcrumb-icons-enable t))

(after! hl-todo
  (setq hl-todo-exclude-modes nil)
  (global-hl-todo-mode))

;;; Text Editing
;; ----------------------------------------------------------------------

(setq-default evil-shift-width 2
              fill-column 90)

(add-hook! '(text-mode-hook prog-mode-hook)
           #'display-fill-column-indicator-mode)

;;; Knowledge Management
;; ----------------------------------------------------------------------

(setq org-directory "~/Education/kms/vault-org/"
      ;; TODO: Edit border character string to premit the zero width space character (I
      ;;       believe this will enable nested emphasis).
      org-emphasis-regexp-components '("-[:space:]('\"{—"
                                       "-[:space:].,:!?;'\")}\\[—"
                                       "[:space:]"
                                       "."
                                       3))

(after! org
  (defface pkms/org-link-id '((t :inherit link :bold nil :underline nil))
    "Face for `org-mode' links prefixed with 'id:'."
    :group 'org-faces)
  (defface pkms/org-link-cite
    '((t :inherit link :bold nil :underline nil :foreground "#98be65"))
    "Face for `org-mode' links prefixed with 'cite:'."
    :group 'org-faces)
  (custom-set-faces!
    '(org-document-title :height 1.4 :underline nil)
    '(org-level-1        :inherit outline-1 :height 1.3)
    '(org-level-2        :inherit outline-2 :height 1.2)
    '(org-level-3        :inherit outline-3 :height 1.1)
    `(org-link
      :inherit link :bold nil :underline nil :foreground ,(doom-color 'violet)))

  ;; Sets fonts for `org-mode' links.
  (org-link-set-parameters "id" :face 'pkms/org-link-id)
  (org-link-set-parameters "cite" :face 'pkms/org-link-cite)

  (setopt org-startup-folded 'showeverything
          org-startup-indented nil
          org-startup-with-latex-preview t
          org-startup-with-inline-images t
          org-pretty-entities t
          org-hide-emphasis-markers t
          org-fontify-quote-and-verse-blocks t
          org-cycle-include-plain-lists 'integrate
          org-format-latex-options (plist-put org-format-latex-options :scale 0.9)))

(after! org-roam
  (setopt org-roam-directory org-directory
          org-roam-capture-templates
          `(("d" "Knowledge node template." plain
             ,(string-join `("%?"
                             ""
                             "* References"
                             ,(make-string 80 ?-))
                           "\n")
             :target (file+head
                      "${slug}_%<%Y%m%d%H%M%S>.org"
                      ,(string-join `("#+FILETAGS: @subject 📝 🌰"
                                      "#+TITLE: ${title}"
                                      ,(make-string 80 ?-))
                                    "\n"))
             :unnarrowed t))
          org-roam-node-display-template
          (format "${doom-hierarchy:*} %s"
                  (propertize "${doom-tags: 56}" 'face 'org-tag))))

(use-package! org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-list '((?- . "•") (?+ . "➤")))
  (org-modern-tag nil)
  (org-modern-table nil)
  (org-modern-horizontal-rule nil)
  (org-modern-internal-target '("" t ""))
  :config
  (custom-set-faces!
    `(org-modern-internal-target
      :inherit link :bold nil :underline nil :foreground ,(doom-color 'yellow))))

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autolinks t)
  (org-appear-autoemphasis t)
  (org-appear-inside-latex t))

(use-package! valign
  :hook (org-mode . valign-mode))

(use-package! org-roam-ui
  :commands (org-roam-ui-open org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;;; Processes: After Init
;; ----------------------------------------------------------------------

(after! which-key
  (setq which-key-idle-delay 0.25))

(after! vterm
  (set-popup-rule! "*doom:vterm-popup:*"
    :size 0.25 :vslot -4 :select t :quit nil :ttl 0))

;;; config.el ends here
