;;; growl.el --- Emacs interface to Growl via growlnotify

;; Copyright (C) 2014, 2105, 2016  Mike McLean

;; Author: Mike McLean <mike.mclean@pobox.com>

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;

;;; Code:

(unless (executable-find "growlnotify")
  (error "growl-for-emacs requires that you install the `growlnotify' program."))

(defvar growlnotify-command
  (executable-find "growlnotify") "The path to growlnotify")

(defsubst growl-ensure-quoted-string (arg)
  (shell-quote-argument
   (cond ((null arg) "")
         ((stringp arg) arg)
         (t (format "%s" arg)))))

;;;###autoload
(defun growl (title message &optional sticky identifier)
  "Shows a message through the growl notification system using
 `growlnotify-command` as the program. Set `sticky' to `t' for a
 sticky message. Set `identifier' to a string for coalescing
 using the `-d' option of `growl-notify'."
  (shell-command
     (concat "growlnotify -a Emacs -n Emacs"
             (if sticky " -s" "")
             (if identifier (concat " -d" (growl-ensure-quoted-string identifier)) "")
             " " (growl-ensure-quoted-string title)
             (if message
                 (concat " -m" (growl-ensure-quoted-string message))
               ""))
     (get-buffer-create " *growl output*"))
  t)


(provide 'growl-for-emacs)
;;; growl-for-emacs.el ends here
