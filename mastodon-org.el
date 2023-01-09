;;; mastodon-org.el --- Mastodon org links -*- lexical-binding: t -*-

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

;;; Commentary:
;; Setup a new org link type "mastodon"
;;
;; Usage is:
;;
;; - mastodon:home          : Load Home timelime
;; - mastodon:local         : Load Local timelime
;; - mastodon:federated     : Load Federated timelime
;; - mastodon:profile       : Load Profile
;; - mastodon:suggestions   : Load Suggestions
;; - mastodon:search        : Search for...

;; - mastodon:notifications : Show Notifications
;; - mastodon:favourites    : Show Favourited
;; - mastodon:bookmarks     : Show Bookmarked
;; - mastodon:filters       : Show Filters

;; - mastodon:toot-reply     : Reply to toot
;; - mastodon:toot-thread    : Show toot thread
;; - mastodon:toot-boost     : Boost toot
;; - mastodon:toot-bookmark  : Add toot to bookmark
;; - mastodon:toot-favourite : Add toot to favourite
;; - mastodon:toot-pin       : Pin toot
;; - mastodon:toot-vote      : Vote
;; - mastodon:toot-spoiler   : Toggle spoiler
;; - mastodon:toot-delete    : Delete toot
;;
;; - mastodon:user-profile   : Show user profile
;; - mastodon:user-follow    : Follow user
;; - mastodon:user-mute      : Mute user
;; - mastodon:user-block     : Block user

;; - mastodon:#xxx           : Show tag "xxx" timeline
;;
;;; NEWS:
;;
;; Version 0.1
;; - First implementation
;;
;;; Code:
(require 'org)

(org-link-set-parameters
 "mastodon"
 :follow 'mastodon-org-process)

(defun mastodon-org-process (what)
  "Process the WHAT argument. If there is a visible mastodon
window, this window will be used to process the command."

  (interactive)
  (let* ((buffers (cl-remove-if-not
                   #'(lambda (buffer)
                       (with-current-buffer buffer
                         (and (get-buffer-window buffer t)
                              (derived-mode-p 'mastodon-mode))))
                   (buffer-list)))
         (buffer (car buffers))
         (window (get-buffer-window buffer t))
         (frame (window-frame window)))

    ;; Because loading is asynchronous, we immediately select the
    ;; frame/window we want to use such as to make sure the page is
    ;; loaded where we want.
    (select-frame frame)
    (select-window window)
    
    (cond ((string= what "home")           (mastodon-tl--get-home-timeline))
          ((string= what "profile")        (mastodon-profile--my-profile))
          ((string= what "local")          (mastodon-tl--get-local-timeline))
          ((string= what "federated")      (mastodon-tl--get-federated-timeline))
          ((string= what "search")         (mastodon-search--search-query))
          
          ((string= what "filters")        (mastodon-tl--view-filters))
          ((string= what "bookmarks")      (mastodon-profile--view-bookmarks))
          ((string= what "favourites")     (mastodon-profile--view-favourites))
          ((string= what "notifications")  (mastodon-notifications-get))
          ((string= what "suggestions")    (mastodon-tl--get-follow-suggestions))

          ((string= what "toot-compose")   (mastodon-toot))
          ((string= what "toot-reply")     (mastodon-toot--reply))
          ((string= what "toot-boost")     (mastodon-toot--toggle-boost))
          ((string= what "toot-favourite") (mastodon-toot--toggle-favourite))
          ((string= what "toot-bookmark")  (mastodon-toot--bookmark-toot-toggle))

          ((string= what "toot-thread")    (mastodon-tl--thread))
          ((string= what "toot-spoiler")   (mastodon-tl--toggle-spoiler-text))
          ((string= what "toot-vote")      (mastodon-tl--poll-vote))
          ((string= what "toot-pin")       (mastodon-toot--pin-toot-toggle))
          ((string= what "toot-delete")    (mastodon-toot--delete-toot))

          ((string= what "user-profile")   (mastodon-profile--show-user))
          ((string= what "user-follow")    (mastodon-tl--follow-user))
          ((string= what "user-block")     (mastodon-tl--block-user))
          ((string= what "user-mute")      (mastodon-tl--mute-user))
          
          ((string= "#" (substring what 0 1))
           (mastodon-tl--show-tag-timeline (substring what 1))))))

(provide 'mastodon-org)
;;; mastodon-org.el ends here
