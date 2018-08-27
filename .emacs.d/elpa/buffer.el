;;; buffer.el --- Temporal buffer for fast boot

(defun buffer-mode ()
  "Buffer Mode"
  (interactive)
  (setq mode-name "Buffer")
  (setq major-mode 'buffer-mode)
;;  (setq buffer-mode-map (make-keymap))
;;  (use-local-map buffer-mode-map)
  (run-hooks 'buffer-mode-hook))

(provide 'buffer)

;;; buffer.el ends here

