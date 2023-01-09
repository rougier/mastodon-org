;;; mastodon-dashboard.el --- Mastodon dashboard -*- lexical-binding: t -*-

;; Copyright (C) 2023 Nicolas P. Rougier

;; Maintainer: Nicolas P. Rougier <Nicolas.Rougier@inria.fr>
;; URL: https://github.com/rougier/mastodon-org
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: org, social, mastodon

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <https://www.gnu.org/licenses/>.
;;
;; Example implementaton of a dashboard using mastodon-org links
;; You'll need to copy of the two dasboard files to your emacs
;; directory and rename it "mastodon.org". You can of course write
;; your own.
(require 'sideframe)
(require 'nano-theme)
(require 'mastodon-org)

(defun mastodon-dashboard ()
  "Open a mastodon dashboard on in a side frame."

  (interactive)
  (let ((file (expand-file-name "mastodon.org" user-emacs-directory))
        (frame (sideframe-make 'left 32 'dark `((foreground-color . ,nano-dark-foreground)
                                                (background-color . ,nano-dark-background)))))
    (with-selected-frame frame
      (find-file file)
      (hl-line-mode)
      (read-only-mode)
      (set-window-dedicated-p nil t))))

(provide 'mastodon-dashboard)
