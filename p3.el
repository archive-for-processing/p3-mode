;;; arduino-cli.el --- arduino-cli command wrapper -*- lexical-binding: t -*-

;; Copyright © 2019

;; Author: Love Lagerkvist
;; URL: https://github.com/motform/arduino-cli-mode
;; Package-Requires: ((emacs "25"))
;; Created: 2019-11-16
;; Keywords: extensions processing

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package contains a wrapper for the Processing 3 command line tool.
;; It requires P3 with CLI tools enabled, which can be installed through
;; https://github.com/processing/processing/wiki/Command-Line

;;; Code:
(require 'cc-vars)

;;; Customization

(defgroup p3 nil
  "Processing 3 functions and settings."
  :group 'tools
  :prefix "p3-")

(defcustom p3-mode-keymap-prefix (kbd "C-c C-p")
  "Arduino-cli keymap prefix."
  :group 'p3
  :type 'string)


;;; Internal functions
(defun p3--runcmd (cmd &rest path)
  "Run arduino-cli CMD in PATH (if provided) and print as message."
  (let* ((default-directory (if path (car path) default-directory))
         (cmd (concat "processing-java sketch=" default-directory " " cmd))
         (out (shell-command-to-string cmd)))
    (message out)))


;;; User commands
(defun p3-run ()
  "Preprocess, compile, and run a sketch."
  (interactive)
  (p3--runcmd "--run"))

(defun p3-build ()
  "Preprocess and compile a sketch into .class files."
  (interactive)
  (p3--runcmd "--build"))

(defun p3-present ()
  "Preprocess, compile, and run a sketch in presentation mode."
  (interactive)
  (p3--runcmd "--present"))

(defun p3-export ()
  "Export a sketch."
  (interactive)
  (p3--runcmd "--present"))


;;; Minor mode
(defvar p3-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "r") #'p3-run)
    (define-key map (kbd "b") #'p3-build)
    (define-key map (kbd "p") #'p3-present)
    (define-key map (kbd "e") #'p3-export)
    map)
  "Keymap for p3-mode commands after `p3-mode-keymap-prefix'.")
(fset 'p3-command-map p3-command-map)

(defvar p3-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map p3-mode-keymap-prefix 'p3-command-map)
    map)
  "Keymap for p3-mode.")


;;;###autoload
;; Borrowed from https://github.com/ptrv/processing2-emacs/
(define-derived-mode p3-mode
  java-mode "p3"
  "Major mode for Processing 3.
\\{java-mode-map}"
  (setq-local c-basic-offset 2)
  (setq-local tab-width 2)
  (setq-local indent-tabs-mode nil)
  (c-set-offset 'substatement-open '0))

;; TODO add font-lock from ptrv's mode?

(add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))

;; (define-minor-mode p3-mode
;;   "Processing 3 integration for Emacs."
;;   :lighter " p3-mode"
;;   :keymap p3-mode-map
;;   :group 'p3
;;   :require 'p3)


(provide 'p3-mode)
;;; p3.el ends here
