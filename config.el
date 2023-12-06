;;; config.el --- Doom's main user config file -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; Doom's main configuration file, where "99.9% of your private configuration
;; should go": this file loads after all other Doom modules. Doom provides the
;; following functions/macros for configuration:
;;
;;  1. `use-package!', to configure packages
;;  2. `add-load-path' for adding directories to the `load-path', which are
;;      relative to this file. Emacs searches the `load-path' when you load
;;      packages with `require' or `use-package'.
;;  3. `map!' for binding keys.
;;  4. `after!' to execute code that must load after a particular package
;;
;; In general, when reconfiguring a package that's included by Doom you'll want
;; to wrap it within an `after!' black, otherwise Doom's defaults may override
;; your settings. The exceptions to this rule are as follows:
;;
;;  - Setting doom variables; these begin with 'doom-' or '+'.
;;  - Setting file/directory variables: e.g., `org-directory'.
;;  - Setting variables that directly tell you they must be set before their
;;    package is loaded (e.g., calling a mode hook in the ":init" portion of a
;;    `use-package' expression.
;;
;;; Code:

;;; User Settings
;; ----------------------------------------------------------------------
;; Certain functionality uses this information to identify you: GPG
;; configuration, email clients, file templates and snippets, etc. It is
;; optional.
;; (setq! user-full-name "John Doe"
;;        user-mail-address "john@doe.com")

;;; Doom Settings
;; ----------------------------------------------------------------------
(setq! doom-theme 'doom-one
       ;; NOTE: There are five variables for configuring Doom's fonts:
       ;;      `doom-font', `doom-serif-font', `doom-variable-pitch-font',
       ;;      `doom-big-font', and `doom-unicode-font'.
       ;;
       ;; NOTE: Set `doom-font' to a font which is monospace and includes
       ;;       italics (e.g., Source Code Pro).
       doom-font (font-spec :family "Source Code Pro" :size 12)
       doom-variable-pitch-font (font-spec :family "Source Sans 3" :size 12)
       doom-unicode-font (font-spec :family "Noto Color Emoji"))

;; Adjusts the opacity of frames: both active and inactive.
(add-to-list 'default-frame-alist '(alpha . (90 90)))

;;; Package Configuration
;; ----------------------------------------------------------------------
(use-package! neotree
  :custom
  ;; Enables icons from all-the-icons in neotree.
  (doom-themes-neotree-file-icons t))

(use-package! projectile
  :custom
  (projectile-project-search-path '(("~/Work/" . 1)
                                    ("~/Projects/" . 1)))
  :config
  (when (equal projectile-project-search-path nil)
    (projectile-discover-projects-in-search-path)))

;; TODO: Add custom keybindings to lsp-mode.
(use-package! lsp
  :custom
  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-icons-enable t))

;; TODO: Get `hl-todo-mode' to activate in `org-mode'.
(use-package! hl-todo
  :config
  (global-hl-todo-mode))

;;; Text Editing
;; ----------------------------------------------------------------------
(setq! display-line-numbers-type t)
(setq-default fill-column 80)
(add-hook! '(text-mode-hook prog-mode-hook) #'display-fill-column-indicator-mode)

;;; Knowledge Management
;; ----------------------------------------------------------------------
(after! org
  ;; Custom org-mode-specific font faces.
  (defface pkms/org-link-id '((t :inherit link :bold nil :underline nil))
    "Face for `org-mode' links prefixed with 'id:'."
    :group 'org-faces)
  (defface pkms/org-link-cite
    '((t :inherit link :bold nil :underline nil :foreground "#98be65"))
    "Face for `org-mode' links prefixed with 'cite:'."
    :group 'org-faces)
  (custom-theme-set-faces 'user
    '(org-document-title ((t . ((:height 1.4 :underline nil)))))
    '(org-level-1        ((t . ((:inherit outline-1 :height 1.3)))))
    '(org-level-2        ((t . ((:inherit outline-2 :height 1.2)))))
    '(org-level-3        ((t . ((:inherit outline-3 :height 1.1)))))
    '(org-link
      ((t . ((:inherit link :bold nil :underline nil :foreground "#dcaeea"))))))
  ;; Sets org-mode link fonts.
  (org-link-set-parameters "id" :face 'pkms/org-link-id)
  (org-link-set-parameters "cite" :face 'pkms/org-link-cite)
  ;; NOTE: `org-directory' should be the directory for PKMS notes ("entires").
  (setq! org-directory "~/Research/processing/"
         org-startup-folded nil
         org-startup-indented nil
         org-startup-with-latex-preview t
         org-startup-with-inline-images t
         ;; TODO: Edit border character string to premit the zero width space
         ;;       character (I believe this will enable nested emphasis).
         org-emphasis-regexp-components '("-[:space:]('\"{—"
                                          "-[:space:].,:!?;'\")}\\[—"
                                          "[:space:]"
                                          "."
                                          3)
         org-pretty-entities t
         org-hide-emphasis-markers t
         org-fontify-quote-and-verse-blocks t
         org-cycle-include-plain-lists 'integrate
         org-format-latex-options (plist-put org-format-latex-options :scale 0.9)))

(after! org-roam
  (setq! org-roam-directory (file-truename "~/Research/notes/")
         org-roam-capture-templates
         `(("d" "Knowledge node template." plain "%?"
            :target
            (file+head+olp
             "${slug}_%<%Y%m%d%H%M%S>.org"
             ,(string-join `("#+FILETAGS: @subject 📝 🌰"
                             "#+TITLE: ${title}"
                             ,(concat (make-string 80 ?-) "\n"))
                           "\n")
             (,(string-join `("References"
                              ,(concat (make-string 80 ?-) "\n"))
                            "\n")))
            :unnarrowed t))
         org-roam-node-display-template
         (format "${doom-hierarchy:*} %s"
                 (propertize "${doom-tags: 56}" 'face 'org-tag))))

(use-package! org-modern
  :after org
  :custom
  (org-modern-list '((?- . "•") (?+ . "➤")))
  (org-modern-tag nil)
  (org-modern-table nil)
  (org-modern-horizontal-rule nil)
  (org-modern-internal-target '("" t ""))
  :config
  (global-org-modern-mode))

;; BUG: Experiencing an issue with `org-appear' package.
;; (use-package! org-appear
;;   :after org
;;   :custom
;;   (org-appear-autoemphasis t)
;;   (org-appear-autolinks t)
;;   (org-appear-inside-latex t)
;;   :hook
;;   (org-mode . org-appear-mode))

(use-package! valign
  :after org
  :hook
  (org-mode . valign-mode))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; TODO: Configure citation workflow.
;; (setq! org-cite-csl-styles-dir "~/Zotero/styles")
;; (setq! citar-bibliography '("~/Research/zotero.bib"))
;; (require 'oc-csl-activate)
;; (setq org-cite-activate-processor 'csl-activate)
;; (add-hook 'org-mode-hook (lambda () (cursor-sensor-mode 1)))

;;; Processes: After Init
;; ----------------------------------------------------------------------
(defun user/after-init-hook ()
  "Executes code that must be loaded after Emacs executes init.el"
  (solaire-global-mode -1))

(defun user/disable-visual-line-mode ()
  (visual-line-mode -1))

(after! which-key
  (setq which-key-idle-delay 0.25))

(after! vterm
  (set-popup-rule! "*doom:vterm-popup:*"
    :size 0.25 :vslot -4 :select t :quit nil :ttl 0))

(add-hook! after-init-hook #'user/after-init-hook)

;;; config.el ends here
