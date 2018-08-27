;;; addressbook-bookmark-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "addressbook-bookmark" "addressbook-bookmark.el"
;;;;;;  (23236 12081 732769 522000))
;;; Generated autoloads from addressbook-bookmark.el

(autoload 'addressbook-turn-on-mail-completion "addressbook-bookmark" "\


\(fn)" nil nil)

(autoload 'addressbook-bookmark-set-1 "addressbook-bookmark" "\
Add contact repetitively until user say no.

When CONTACT arg is provided add only contact CONTACT and exit.

\(fn &optional CONTACT)" nil nil)

(autoload 'addressbook-gnus-sum-bookmark "addressbook-bookmark" "\
Record an addressbook bookmark from a gnus summary buffer.

\(fn)" t nil)

(autoload 'addressbook-mu4e-bookmark "addressbook-bookmark" "\
Record an addressbook bookmark from a mu4e view buffer.

\(fn)" t nil)

(autoload 'addressbook-bmenu-edit "addressbook-bookmark" "\
Edit an addresbook bookmark entry from bmenu list.

\(fn)" t nil)

(autoload 'addressbook-bookmark-jump "addressbook-bookmark" "\
Default handler to jump to an addressbook bookmark.

\(fn BOOKMARK)" nil nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; addressbook-bookmark-autoloads.el ends here
