;;; pdx.el --- Major mode for editing Paradox mod files

;; Copyright (C) 2024 Malte Lau Petersen
;; Copyright (C) 2016 Gabriel Radanne
;; Licensed under the GNU General Public License.

;; Authors: Malte Lau Petersen, Gabriel Radanne
;; Keywords: languages, paradox modding
;; Package-Requires: ((emacs "24.3"))
;; Version: 0.1.0
;; URL: https://github.com/maltelau/pdx.el

;; This file is *NOT* part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;;; Commentary:

;; Major mode to edit pdx script files

;;; Code:

(require 'rx)
(require 'lsp-mode)

(defgroup pdx nil
  "Major mode to edit Paradox modding files."
  :group 'languages)

(defcustom pdx-mode-hook nil
  "Hook called after `pdx-mode' is initialized."
  :type 'hook
  :group 'pdx)

;; (defvar pdx-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map "\C-c\C-t" 'stellaris-show-meta)
;;     map)
;;   "Keymap for Pdx major mode")

(defconst pdx-mode-quoted-string-re
  (rx (group (char ?\")
             (0+ (not (any ?\")))
             (char ?\"))))
(defconst pdx-mode-number-re
  (rx (group (optional ?\-)
             (1+ digit)
             (optional ?\. (1+ digit)))))

(defcustom pdx-mode-lsp-server-file
  "~/src/raw/cwtools-vscode/out/server/local/CWTools Server"
  "Path to cwtools lsp server binary."
  :type  '(string)
  :group 'pdx)

;; LSP mode settings
(add-to-list 'lsp-language-id-configuration
             '(pdx-mode . "pdx"))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection pdx-mode-lsp-server-file)
                  :major-modes '(pdx-mode)
                  :server-id 'pdx-cwtools
                  :request-handlers (ht ("getWordRangeAtPosition" #'ignore))))

(lsp-defcustom lsp-cwtools-trace-server "off"
  "Traces the communication between VSCode and the language server."
  :type '(choice (:tag off messages verbose))
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.trace.server")

(lsp-defcustom lsp-cwtools-localisation-languages ["English"]
  "The list of languages to validate localisation for."
  :type 'lsp-string-vector
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.localisation.languages")

(lsp-defcustom lsp-cwtools-localisation-generated-strings ":0 \"REPLACE_ME\""
  "The string used when generating localisation strings."
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.localisation.generated_strings")

(lsp-defcustom lsp-cwtools-errors-vanilla nil
  "Whether or not to show errors for vanilla files"
  :type 'boolean
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.errors.vanilla")

(lsp-defcustom lsp-cwtools-errors-ignore nil
  "Error codes to ignore, list of IDs"
  :type 'lsp-string-vector
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.errors.ignore")

(lsp-defcustom lsp-cwtools-errors-ignorefiles ["README.txt" "credits.txt" "credits_l_simp_chinese.txt" "reference.txt" "startup_info.txt"]
  "Files to ignore errors from, list of file names"
  :type 'lsp-string-vector
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.errors.ignorefiles")

(lsp-defcustom lsp-cwtools-experimental t
  "Whether or not to enable experimental features"
  :type 'boolean
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.experimental")
(lsp-defcustom lsp-cwtools-debug-mode t
  "Debug features for helping write rules"
  :type 'boolean
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.debug_mode")

(lsp-defcustom lsp-cwtools-logging-diagnostic nil
  "Whether to output diagnostic level logs"
  :type 'boolean
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.logging.diagnostic")

(lsp-defcustom lsp-cwtools-rules-version "latest"
  "Which version of rules to auto-update to.
  Manual will use the local path set in rules_folder"
  :type '(choice (:tag stable latest manual))
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.rules_version")

(lsp-defcustom lsp-cwtools-rules-folder nil
  "A folder containing custom rules to use"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.rules_folder")

(lsp-defcustom lsp-cwtools-ignore-patterns nil
  "File paths to ignore (not load into cwtools), list of glob patterns"
  :type 'lsp-string-vector
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.ignore_patterns")

(lsp-defcustom lsp-cwtools-cache-eu4 nil
  "The location of a vanilla EU4 installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.eu4")

(lsp-defcustom lsp-cwtools-cache-hoi4 nil
  "The location of a vanilla HOI4 installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.hoi4")

(lsp-defcustom lsp-cwtools-cache-stellaris nil
  "The location of a vanilla Stellaris installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.stellaris")

(lsp-defcustom lsp-cwtools-cache-ck2 nil
  "The location of a vanilla CK2 installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.ck2")

(lsp-defcustom lsp-cwtools-cache-imperator nil
  "The location of a vanilla I:R installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.imperator")

(lsp-defcustom lsp-cwtools-cache-vic2 nil
  "The location of a vanilla VIC2 installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.vic2")

(lsp-defcustom lsp-cwtools-cache-ck3 nil
  "The location of a vanilla CK3 installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.ck3")

(lsp-defcustom lsp-cwtools-cache-vic3 nil
  "The location of a vanilla VIC3 installation"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.cache.vic3")

(lsp-defcustom lsp-cwtools-graph-zoom-sensitivity 1
  "Control scroll wheel zoom sensitivity,
<1 reduces sensitivity, >1 increases sensitivity"
  :type 'number
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.graph.zoomSensitivity")

(lsp-defcustom lsp-cwtools-max-file-size 2
  "Maximum script file size to load in megabytes.
(warning, very large files can cause instability or invalid diagnostics)"
  :type 'number
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.maxFileSize")

(lsp-defcustom lsp-cwtools-localisation-replaceme nil
  "The text to create new localisation strings with,
should contain '%s' for the location of the id"
  :type 'string
  :group 'pdx-cwtools
  :package-version '(lsp-mode . "9.0.0")
  :lsp-path "cwtools.localisation.replaceme")

;; (defconst builtins
;;   '("yes" "no"))
;; (defconst pdx-mode-builtins-re
;;   (regexp-opt builtins 'symbols))

;; (defconst keywords
;;   '("trigger" "owner" "from" "prev" "limit"))
;; (defconst pdx-mode-keywords-re
;;   (regexp-opt keywords 'symbols))

;; Stellaris stuff
;; (defconst stellaris-effects-re
;;   (regexp-opt stellaris-effects 'symbols))
;; (defconst stellaris-triggers-re
;;   (regexp-opt stellaris-triggers 'symbols))

;; (defvar pdx-font-lock-keywords
;;   (list
;;    (list pdx-mode-quoted-string-re 1 font-lock-string-face)
;;    (list pdx-mode-builtins-re 1 font-lock-constant-face)
;;    (list pdx-mode-number-re 1 font-lock-constant-face)
;;    (list pdx-mode-keywords-re 1 font-lock-keyword-face)
;;    (list stellaris-effects-re 1 font-lock-type-face)
;;    (list stellaris-triggers-re 1 font-lock-builtin-face)
;;    )
;;   "Keyword highlighting specification for `pdx-mode'.")

;; (defun stellaris-show-meta ()
;;   "Show acceptable scope and targets"
;;   (interactive)
;;   (let* ((minibuffer-message-timeout nil)
;;          (cur-word (thing-at-point 'symbol t))
;;          (item (member-ignore-case cur-word stellaris-completions)))
;;     (if item
;;         (minibuffer-message (stellaris-meta (car item)))
;;       (minibuffer-message "No info for %s" cur-word)
;;       )))

;; (defvar pdx-syntax-table
;;   (let ((st (make-syntax-table)))

;;     (modify-syntax-entry ?\{ "(}" st)
;;     (modify-syntax-entry ?\} "){" st)

;;     ; Comment starts with # and ends in newline
;;     (modify-syntax-entry ?#  "<" st)
;;     (modify-syntax-entry ?\n ">" st)

;;     ;; Make things simpler with floating numbers
;;     (modify-syntax-entry ?. "_" st)

;;     st)
;;   "Syntax table for pdx-mode")

;; Indentation
;; Similar to json modes
;; (defconst pdx-grammar
;;   (smie-prec2->grammar
;;     (smie-bnf->prec2
;;      '((prim)
;;        (object ("{" decl "}"))
;;        (decl (prim "=" elem))
;;        (elem (object) (prim)))
;;      )))
;; (defun pdx-smie-rules (kind token)
;;   (pcase (cons kind token)
;;     (`(:elem . args) (- (current-indentation) (current-column)))
;;     (`(:elem . basic) tab-width)
;;     ))

(define-derived-mode pdx-mode c-mode "pdx"
  "Major mode for editing Pdx files."
  :group 'pdx

  ;; :syn;; tax-table pdx-syntax-table

  ;; (setq-local
  ;;  font-lock-defaults
  ;;  '(pdx-font-lock-keywords nil t))

  ;; Pdx files are indented with tabs
  (setq-default indent-tabs-mode t)

  ;; Comments
  (setq-local comment-start "#")
  (setq-local comment-end "")
  (setq-local comment-start-skip "#+\\s-*")

  ;; (smie-setup pdx-grammar #'pdx-smie-rules)
  (setq-local electric-indent-chars '( ?\n ?} ?{ ))

  (run-mode-hooks 'pdx-mode-hook))

(provide 'pdx-mode)
;;; pdx.el ends here
