(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-gtags-auto-update t)
 '(helm-gtags-suggested-key-mapping t)
 '(mlint-programs
   (quote
    ("" "" "" "/Applications/MATLAB_R2017a.app/bin/maci64/mlint" "" "")) t)
 '(package-selected-packages
   (quote
    (git-gutter-fringe+ slime dashboard doom-themes lsp-ui lsp-mode all-the-icons-dired helm-gtags gtags flycheck-pos-tip ace-jump-mode auto-virtualenvwrapper virtualenvwrapper dockerfile-mode vim-region mark-multiple spacegray-theme 0blayout perspeen col-highlight regex-tool diff-hl helm-smex helm-qiita zoom-window ac-helm shell-pop evil-leader visual-regexp-steroids ace-jump-helm-line ace-jump-buffer helm-projectile latex-math-preview ace-pinyin elpy popwin quickrun google-translate jedi tern-auto-complete js2-mode tern helm-descbinds helm-bind-key pandoc ac-emmet emmet-mode e2wm-R e2wm dired-avfs super-save dired-ranger all-the-icons helm-make ggtags c-eldoc function-args auto-complete-clang-async auto-complete-c-headers srefactor markdown-mode uimage page-break-lines julia-shell key-chord impatient-mode pangu-spacing dired-icon move-text esup ensime scala-mode crux openwith idle-require r-autoyas quick-preview gist dired-subtree evil-numbers evil-matchit evil-surround sort-words stripe-buffer dired-toggle dired-filter phi-search-dired htmlize ox-reveal exec-path-from-shell ripgrep projectile helm-ag dumb-jump electric-operator dired-k japanese-holidays yatemplate worf window-numbering swap-buffers omni-scratch free-keys ac-math dired-open dired-details ace-isearch helm-migemo helm-swoop which-key point-undo recentf-ext yatex yascroll win-switch web-mode volatile-highlights twittering-mode telephone-line tabbar sublimity stan-snippets smooth-scrolling smooth-scroll smartrep smartparens smart-mode-line smart-compile ruby-electric rainbow-mode rainbow-delimiters powerline-evil polymode path-headerline-mode paredit open-junk-file ob-ipython nlinum mustang-theme multiple-cursors multi-term minimap migemo matlab-mode markdown-preview-eww magit lispxmp kosmos-theme inf-ruby hlinum hl-line+ highlight-symbol helm-flycheck google-this flatland-theme fish-mode fill-column-indicator evil-multiedit ess-R-object-popup ess-R-data-view enh-ruby-mode ein dracula-theme diminish ddskk csv-mode colemak-evil chess babel-repl babel auto-yasnippet auto-save-buffers-enhanced auto-install auto-highlight-symbol anzu anything afternoon-theme addressbook-bookmark ac-haskell-process)))
 '(ruby-insert-encoding-magic-comment nil)
 '(shell-pop-shell-type
   (quote
    ("multi-term" "*terminal<1>*"
     (quote
      (lambda nil
        (multi-term))))))
 '(shell-pop-term-shell "/Users/ymattu/.pyenv/shims/xonsh")
 '(shell-pop-universal-key "C-t")
 '(shell-pop-window-position "bottom")
 '(shell-pop-window-size 30))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(col-highlight ((t (:inherit hl-line))))
 '(fa-face-hint ((t (:background "#3f3f3f" :foreground "#ffffff"))))
 '(fa-face-hint-bold ((t (:background "#3f3f3f" :weight bold))))
 '(fa-face-semi ((t (:background "#3f3f3f" :foreground "#ffffff" :weight bold))))
 '(fa-face-type ((t (:inherit (quote font-lock-type-face) :background "#3f3f3f"))))
 '(fa-face-type-bold ((t (:inherit (quote font-lock-type-face) :background "#999999" :bold t))))
 '(hl-line ((t (:background "#44475a"))))
 '(magit-diff-added ((t (:background "black" :foreground "green"))))
 '(magit-diff-added-highlight ((t (:background "white" :foreground "green"))))
 '(magit-diff-removed ((t (:background "black" :foreground "blue"))))
 '(magit-diff-removed-hightlight ((t (:background "white" :foreground "blue"))))
 '(magit-hash ((t (:foreground "red"))))
 '(markdown-header-face-1 ((t (:inherit org-level-1))))
 '(markdown-header-face-2 ((t (:inherit org-level-2))))
 '(markdown-header-face-3 ((t (:inherit org-level-3))))
 '(markdown-header-face-4 ((t (:inherit org-level-4))))
 '(markdown-header-face-5 ((t (:inherit org-level-5))))
 '(markdown-header-face-6 ((t (:inherit org-level-6))))
 '(stripe-hl-line ((t (:background "#d2e9ef" :foreground "black"))))
 '(web-mode-comment-face ((t (:foreground "#969896"))))
 '(web-mode-css-at-rule-face ((t (:foreground "#DFCF44"))))
 '(web-mode-css-property-name-face ((t (:foreground "#87CEEB"))))
 '(web-mode-css-pseudo-class ((t (:foreground "#DFCF44"))))
 '(web-mode-css-selector-face ((t (:foreground "#DFCF44"))))
 '(web-mode-doctype-face ((t (:foreground "#D78181"))))
 '(web-mode-html-attr-equal-face ((t (:foreground "#FFFFFF"))))
 '(web-mode-html-attr-name-face ((t (:foreground "#87CEEB"))))
 '(web-mode-html-tag-face ((t (:foreground "#4A8ACA"))))
 '(web-mode-server-comment-face ((t (:foreground "#969896")))))
