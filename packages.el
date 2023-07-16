;; packages.el --- Manages Doom's packages -*- no-byte-compile: t; -*-
;;
;;; Commentary:
;;
;; Specifies additional packages to install, any additional packages should be
;; added to Doom using this file. You must run `doom sync` from the command line
;; and restart Emacs, or `doom/reload' to enable the changes made here.
;;
;; To install PACKAGENAME from MELPA, ELPA or Emacsmirror use:
;;
;;   (package! package-name)
;;
;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;;
;;   (package! package-name
;;     :recipe (:host github :repo "username/repo"))
;;
;; When the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;;
;;   (package! package-name
;;     :recipe (:host github :repo "username/repo"
;;              :files ("some-file.el" "src/lisp/*.el")))
;;
;; To disable a package included with Doom use the `:disable' property:
;;
;;   (package! builtin-package :disable t)
;;
;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;;
;;   (package! builtin-package-1 :recipe (:nonrecursive t))
;;   (package! builtin-package-2 :recipe (:repo "myfork/package"))
;;
;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279):
;;
;;   (package! builtin-package :recipe (:branch "develop"))
;;
;; Use `:pin' to specify a particular commit to install:
;;
;;   (package! builtin-package :pin "1a2b3c4d5e")
;;
;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin one or more packages:
;;
;;   (unpin! pinned-package-1 pinned-package-2 ...)
;;
;; To unpin all packages (which isn't recommended because it's likely to break
;; things) write the following:
;;
;;   (unpin! t)
;;
;; Code:

(package! org-modern)
(package! org-appear)
(package! valign)

;;; packages.el ends here
