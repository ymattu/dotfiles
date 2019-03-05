;; --------------------------------------------------------
;; 外部プログラムで必要なもの
;; - R
;; - Julia
;; - Python (anaconda)
;; - Matlab
;; - Ruby
;; - Rust
;; - Scala → brew
;; - MacTeX

;; - Xcode(command line tools)

;; - Ricty Diminished
;; - Ricty Diminished for powerline
;; - フォント: https://github.com/domtronn/all-the-icons.el
;; - フォント: http://users.teilar.gr/~g1951d/
;; - cmigemo → brew
;; - fish → brew
;; - zsh → brew
;; - sbt → brew
;; - poppler → brew
;; - pdf-tools → brew
;; - node → brew
;; - tern → npm: http://blog.syati.info/post/emacsJavascript2/
;; - ripgrep → cargo
;; - rcodetools → gem
;; - rdefs → gem
;; - google-ime-skk → gem
;; - grip → pip (for matkdown preview)
;; - virtualenv → pip (for jedi)
;; - LilyPond
;; - gtags (brew)
;; ---------------------------------------------------------

; ----------------------------------------------------------
;; 基本的な設定
;; ---------------------------------------------------------
;;起動と基本動作----------------------------------
;; GC を潰して軽くする
(setq gc-cons-threshold (* gc-cons-threshold 10))

;; 起動時のサイズ,表示位置を指定
(setq initial-frame-alist
      (append (list
         '(width . 200)
         '(height . 60)
         '(top . 0)
         '(left . 0)
       )
              initial-frame-alist))

;; スクリーンの最大化
;; (set-frame-parameter nil 'fullscreen 'maximized)
;; フルスクリーン
;; (set-frame-parameter nil 'fullscreen 'fullboth)


;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)


;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq ring-bell-function 'ignore)

;; M-x exit で終了にする
(global-unset-key (kbd "C-x C-c"))
(defalias 'exit 'save-buffers-kill-terminal)


;; スタートアップメッセージを表示させない
;; (setq inhibit-startup-message t)
(setq initial-buffer-choice t)
(setq initial-scratch-message "") ;; This buffer 〜で始まる文章を表示しない
(setq initial-major-mode 'fundamental-mode) ;; buffer-mode で起動する

;; パスワード読み込み用
(defun my-lisp-load (filename)
  "Load lisp from FILENAME"
  (let ((fullname (expand-file-name (concat "spec/" filename) user-emacs-directory))
        lisp)
    (when (file-readable-p fullname)
      (with-temp-buffer
        (progn
          (insert-file-contents fullname)
          (setq lisp
                (condition-case nil
                    (read (current-buffer))
                  (error ()))))))
    lisp))


;; server-----------------------------------------
; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))

;; emacsclient の終了コマンド
(global-unset-key (kbd "C-x #"))
(global-set-key (kbd "C-x C-c") 'server-edit)

;; Tramp
(setq tramp-default-method "ssh")

;;パッケージ管理----------------------------------
;; MELPA の設定
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)

(add-to-list 'load-path "~/dotfiles/.emacs.d/elpa")

(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elpa/")    ; auto-install を elpa に変更
(auto-install-compatibility-setup)


;; `package-selected-packages` を in init.el に書かないで custom.el に書く
;; これは emacs 25.1 から
(load (setq custom-file (expand-file-name "custom.el" user-emacs-directory)))


;;キー設定----------------------------------------
;; Mac のときのキー設定
(when (eq system-type 'darwin)
  ;; 左 command を Meta キーにする
  (setq mac-command-modifier 'meta)
  ;; 右 command を Super キーにする
  (setq mac-right-command-modifier 'super)
  ;; 左 alt を alt キーにする
  (setq mac-option-modifier 'alt)
  ;; 右 alt を Hyper キーにする(英字配列のみ)
  (setq mac-right-option-modifier 'hyper)
  ;; fn キーを Hyper キーにする
  (setq ns-function-modifier 'hyper)
  )


;; keybind guide
; 3 つの表示方法どれか 1 つ選ぶ
(which-key-setup-side-window-bottom)    ;ミニバッファ
;; (which-key-setup-side-window-right)     ;右端
; (which-key-setup-side-window-right-bottom) ;両方使う

(defvar which-key-idle-delay 1.0) ;; 1 秒以上動かなければガイドを表示
(defvar which-key-frame-max-width 80)


(which-key-mode 1)


;; 現在のメジャーモード・マイナーモードにおいて空いているキーバインドをリスト
(global-set-key (kbd "s-f") 'free-keys)


;;テーマ------------------------------------------
(load-theme 'spacegray t)
;; (load-theme 'afternoon t)
(set-face-background 'region "#d2e9ef") ;選択範囲の色


;;表示系------------------------------------------
;;背景透明化
;; (if window-system
;;     (progn
;;       (set-frame-parameter nil 'alpha 95)))


;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))


;; 複数のディレクトリで同じファイル名のファイルを開いたときのバッファ名を調整する
(require 'uniquify)
; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "[^*]+")


;; 複数ウィンドウを禁止する
(setq ns-pop-up-frames nil)

;; active でない window の空 cursor を出さない
(setq cursor-in-non-selected-windows nil)

;; メニューバーを消す
(menu-bar-mode -1)

;; ツールバーを消す
(tool-bar-mode -1)

;; 列数を表示する
(column-number-mode t)


;; 行数を表示する
(global-nlinum-mode t)
;; (add-hook 'prog-mode-hook 'nlinum-mode)
(setq nlinum-format "%5d  ")


;; 0.03 秒後に現在行をハイライト
(require 'hl-line)
(defun global-hl-line-timer-function ()
  (global-hl-line-unhighlight-all)
  (let ((global-hl-line-mode t))
    (global-hl-line-highlight)))
(setq global-hl-line-timer
      (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
;; (cancel-timer global-hl-line-timer)

;; 現在行のハイライト色を設定
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:background "#44475a"))))
 '(magit-diff-added ((t (:background "black" :foreground "green"))))
 '(magit-diff-added-highlight ((t (:background "white" :foreground "green"))))
 '(magit-diff-removed ((t (:background "black" :foreground "blue"))))
 '(magit-diff-removed-hightlight ((t (:background "white" :foreground "blue"))))
 '(magit-hash ((t (:foreground "red"))))
 '(stripe-hl-line((t (:background "#d2e9ef" :foreground "black"))))
 )


;;カーソルの形を棒に
(add-to-list 'default-frame-alist '(cursor-type . bar))
;; カーソルの点滅
(blink-cursor-mode 1)


;; 対応する括弧を光らせる
(show-paren-mode 1)
(setq show-paren-delay 0.03) ;; 光らせるまでの秒数
(require 'paren)
; (set-face-background 'show-paren-match-face "blue")
(set-face-attribute 'show-paren-match nil :weight 'bold)


;; 画面右端で折り返さない
(setq-default truncate-lines t)
(setq truncate-partial-width-windows t)

;; A-l で折り返す/さないを変更
(global-set-key (kbd "A-l") 'toggle-truncate-lines)


;; スクロールした際のカーソルの移動行数
(setq scroll-conservatively 1)
;; スクロール開始のマージンの行数
(setq scroll-margin 10)
;; 1 画面スクロール時に重複させる行数
(setq next-screen-context-lines 10)
;; 1 画面スクロール時にカーソルの画面上の位置をなるべく変えない
(setq scroll-preserve-screen-position t)

;; カーソルを固定したままスクロール
(global-set-key (kbd "A-d") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "A-b") (lambda () (interactive) (scroll-down 1)))


;; フォント
(add-to-list 'default-frame-alist '(font . "Ricty Diminished for Powerline-14"))


;; 80 文字目に縦線
(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
; 縦線の幅
(setq fci-rule-width 1)
; 縦線の色
(setq fci-rule-color "gray30")
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)


;; シンタックスハイライトを少し変更
(set-face-foreground 'font-lock-function-name-face "#add8e6")
(set-face-foreground 'font-lock-constant-face "#40e0d0")


;; インライン画像表示の切り替え
(defun uimage-mode-toggle ()
  (interactive)
  (uimage-mode 'toggle))

(global-set-key (kbd "A-i") 'uimage-mode-toggle)


;; png, jpg などのファイルを画像として表示
(setq auto-image-file-mode t)


;; ^L の改行コードを破線で表示
(global-page-break-lines-mode 1)


;; 改行コード（^M）を改行に置き換え
(defun replace-line-feed-code()
  (interactive)
  (beginning-of-buffer)
  (replace-string "
" "
"))


;;言語系------------------------------------------------
;; 日本語設定
(set-locale-environment "utf-8")
(setenv "LANG"  "ja_JP.UTF-8")
(prefer-coding-system 'utf-8-unix)

;; 右から左に読む言語に対応させないことで高速化
(setq-default bidi-display-reordering nil)


;;入力系------------------------------------------------
;; タブにスペースを使用する
(setq-default tab-width 2 indent-tabs-mode nil)


;; C-k で行全体を削除する
(setq kill-whole-line t)
;; C-h で後方削除
(global-set-key "\C-h" 'delete-backward-char)


;; ファイル末尾で必ず改行
(setq require-final-newline t)


;; 自動改行を off にする
(setq text-mode-hook 'turn-off-auto-fill)


;; point-undo: カーソル位置を戻す
(require 'point-undo)
(global-set-key [f7] 'point-undo)
(global-set-key [M-f7] 'point-redo)


;; 編集箇所の履歴をたどる
(require 'goto-chg)
(global-set-key [f8] 'goto-last-change)
(global-set-key [M-f8] 'goto-last-change-reverse)


;; kill-ring 一覧を表示
(global-set-key (kbd "M-y") 'helm-show-kill-ring)


;; 現在の行またはリージョンを M-up と M-down で移動
(require 'move-text)
(global-set-key (kbd "A-j") 'move-text-down)
(global-set-key (kbd "A-k") 'move-text-up)


;; 全角と半角の間に自動でスペース
;; chinse-two-byte → japanese に置き換えるだけで日本語でも使える
(setq pangu-spacing-chinese-before-english-regexp
  (rx (group-n 1 (category japanese))
      (group-n 2 (in "a-zA-Z0-9"))))
(setq pangu-spacing-chinese-after-english-regexp
  (rx (group-n 1 (in "a-zA-Z0-9"))
      (group-n 2 (category japanese))))
;; 見た目ではなくて実際にスペースを入れる
(setq pangu-spacing-real-insert-separtor t)
;; text-mode やその派生モード(org-mode 等)のみに使いたいならこれ
(add-hook 'text-mode-hook 'pangu-spacing-mode)
;; すべてのメジャーモードに使ってみたい人はこれを
;; (global-pangu-spacing-mode 1)


;; エンコーディング指定プラグマを挿入する
(defun insert-encoding-pragma ()
  "Insert encoding pragma for each programming languages"
  (interactive)
  (save-excursion
    (let* ((charset-list '(("utf-8") ("euc-jp") ("shift_jis")))
          (completion-ignore-case t)
          (charset (completing-read "Charset: "
                           charset-list nil t "utf-8"))
          (pragma (concat "-*- coding:" charset " -*-")))
      (progn
          (beginning-of-line)
          (let ((region-begin (point)))
            (progn
              (insert pragma)
              (end-of-line)
              (let ((region-end (point)))
                (comment-region region-begin region-end))))))))


;;フィル管理・ログ系------------------------------
;; 無題のバッファを開く
(defun my/new-untitled-buffer ()
  "Create and switch to untitled buffer."
  (interactive)
  (switch-to-buffer (generate-new-buffer "Untitled")))

;; Alt+n に割り当てる
(global-set-key (kbd "A-n") 'my/new-untitled-buffer)


;; 試行錯誤用ファイルを開くための設定
(require 'open-junk-file)
; C-x C-z で試行錯誤ファイルを開く
(global-set-key (kbd "C-x C-z") 'open-junk-file)
; 新しいウィンドウを開かない
(setq open-junk-file-find-file-function 'find-file)


;; ffap: C-x C-f にカーソル位置のファイル・ URL を開く機能を追加する
(ffap-bindings)


;; recentf-ext: 最近使ったファイルを開く
; 最近のファイル 500 個を保存する
(setq recentf-max-saved-items 500)
; 最近使ったファイルに加えないファイルを
; 正規表現で指定する
(setq recentf-exclude
      '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)


;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; ログの記録行数を増やす
(setq message-log-max 10000)

;; 履歴をたくさん保存する
(setq history-length 1000)


;; 同じ内容を履歴に記録しないようにする
(setq history-delete-duplicates t)


;; 現在開いているファイルのパスを保存.
;; dired を開いているときはディレクトリパスを保存.
(defun my/get-curernt-path ()
  (if (equal major-mode 'dired-mode)
      default-directory
    (buffer-file-name)))

(defun my/copy-current-path ()
  (interactive)
  (let ((fPath (my/get-curernt-path)))
    (when fPath
      (message "stored path: %s" fPath)
      (kill-new (file-truename fPath)))))

(global-set-key (kbd "C-c 0") 'my/copy-current-path)


;; -----------------------------------------------
;; reveal-in-finder 現在のバッファーをファインダーで開く
;; http://d.hatena.ne.jp/kaz_yos/20140202/1391362618
;; Original: http://stackoverflow.com/questions/20510333/in-emacs-how-to-show-current-file-in-finder
;; 不可視ディレクトリ直下では使えない
(defun reveal-in-finder ()
  (interactive)
  (let ((path (buffer-file-name))
        dir file)
    (if path
        ;; if path has been successfully obtained.
        (progn (setq dir (file-name-directory path))
               (setq file (file-name-nondirectory path)))
      ;; if path is empty, there is no file name. Use the default-directory variable
      (setq dir (expand-file-name default-directory))
      )
    ;; (message (concat "Opening in Finder: " dir file))  ; Show the file name
    (reveal-in-finder-1 dir file)
    ))

(defun reveal-in-finder-1 (dir file)
  (let ((script
         (if file
             (concat
              "set thePath to POSIX file \"" (concat dir file) "\"\n"
              "tell application \"Finder\"\n"
              " set frontmost to true\n"
              " reveal thePath \n"
              "end tell\n"
              )
           (concat
            "set thePath to POSIX file \"" (concat dir) "\"\n"
            "tell application \"Finder\"\n"
            " set frontmost to true\n"
            " reveal thePath \n"
            "end tell\n"))))
    ;; (message script)  ; Show the script in the mini-buffer
    (start-process "osascript-getinfo" nil "osascript" "-e" script)
    ))

(global-set-key (kbd "C-c f") 'reveal-in-finder)


;; sudoで開きなおす
(defun reopen-with-sudo ()
  "Reopen current buffer-file with sudo using tramp."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (find-alternate-file (concat "/sudo::" file-name))
      (error "Cannot get a file name"))))


;;バッファ管理------------------------------------
;; ido
; バッファ・ファイルを選択して開く
;; (global-set-key "\C-xf" 'helm-recentf)
(evil-leader/set-key "r" 'helm-recentf)
(setq helm-buffer-max-length 50)


;; bs
; 手軽にバッファ選択
(global-set-key (kbd "C-x C-b") 'bs-show)


;; メジャーモードごとの scratch バッファ
(global-set-key (kbd "s-b") 'omni-scratch-new-scratch-major-buffer)


;; 他のプログラムで変更があったときに自動で再読込
(global-auto-revert-mode 1)
(global-set-key (kbd "s-r") 'revert-buffer)

;; バッファ選択は ace-jump で
(require 'ace-jump-buffer)
(global-set-key (kbd "s-;") 'ace-jump-buffer)


;;ウィンドウ管理------------------------------------
;; ---------------------------------------------------------
;; popwin の設定
;; ---------------------------------------------------------
(require 'popwin)
(defvar display-buffer-function 'popwin:display-buffer)
(setq popwin:popup-window-position 'bottom)


;;保存系------------------------------------------
;; バッファの内容を自動保存(秒)
(require 'auto-save-buffers-enhanced)
;; 3 秒後に保存
(setq auto-save-buffers-enhanced-interval 3)
;; 特定のファイルのみ有効にする
(setq auto-save-buffers-enhanced-include-regexps '(".+")) ;全ファイル
;; not-save-file と.ignore は除外する
(setq auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$"))
;; Wrote のメッセージを抑制
(setq auto-save-buffers-enhanced-quiet-save-p t)

(auto-save-buffers-enhanced t)

;; C-x a s で auto-save-buffers-enhanced の有効・無効をトグル
(global-set-key "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)

;; フォーカスが外れたときに自動保存
(super-save-mode 1)


;;マクロ系----------------------------------------
;; 同じ FUNCTION を、複数モードの add-hook に、一括で登録するマクロ
(defmacro def-add-hooks (lst body)
  `(mapc '(lambda (name)
           (add-hook name '(lambda () ,body)))
         ,lst))
; 使い方
; (def-add-hooks `(text-mode-hook markdown-mode-hook)
;                (setq truncate-lines nil))

;; 垂直には分割しない
(setq split-width-threshold nil)


;; ---------------------------------------------------------
;; Emacs Lisp の設定
;; ---------------------------------------------------------
;; 式の評価結果を注釈するための設定
(require 'lispxmp)
;; emacs-lisp-mode で C-c C-d を押すと注釈される
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)


;; 括弧の対応を保持して編集する設定
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)


;; ---------------------------------------------------------
;; dired の設定
;; ---------------------------------------------------------
(require 'dired-x)

(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "")
(setq dired-details-hide-link-targets nil)


(defadvice find-dired-sentinel (after dired-details (proc state) activate)
  "find-dired でも dired-details を使えるようにする"
  (ignore-errors
    (with-current-buffer (process-buffer proc)
      (dired-details-activate))))


;;dired で削除したときにゴミ箱へ移動させる
(setq delete-by-moving-to-trash t)


;; サイズ表記を MB 単位で
(setq dired-listing-switches "-alh")


;; dired-mode で.zip で終わるファイルを Z キーで展開できるように
(eval-after-load "dired-aux"
   '(add-to-list 'dired-compress-file-suffixes
                 '("\\.zip\\'" ".zip" "unzip")))


;; O でシステムで関連付けされたプログラムで開く
(require 'crux)
(define-key dired-mode-map (kbd "O") 'crux-open-with)


;; dired を 2 つのウィンドウで開いている時に、デフォルトの移動 or コピー先をもう一方の dired で開いているディレクトリにする
(setq dired-dwim-target t)
;; ディレクトリを再帰的にコピーする
(setq dired-recursive-copies 'always)
;; dired バッファで C-s した時にファイル名だけにマッチするように
(defvar dired-isearch-filenames t)


;; 「仮想クリップボード」にファイルを格納して、
;; コピー・貼り付け感覚でファイルのコピー・移動
(define-key dired-mode-map (kbd "Y") 'dired-ranger-copy)
(define-key dired-mode-map (kbd "M") 'dired-ranger-move)
(define-key dired-mode-map (kbd "P") 'dired-ranger-paste)


;; wdired
(require 'wdired)
(setq wdired-allow-to-change-permissions t)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)


;; dired に色付け
(require 'dired)
(define-key dired-mode-map (kbd "g") 'dired-k)
(add-hook 'dired-initial-position-hook 'dired-k)


;; dired を絞り込む
; dired-filter.el が依存している
(require 'cl-lib)
(autoload 'dired-filter-mode "dired-filter" nil t)
; dired-mode で on にする
(defun dired-mode-hooks()
  (dired-filter-mode))
(add-hook 'dired-mode-hook 'dired-mode-hooks)


(eval-after-load "dired-aux" '(require 'dired-async))


;; dired-toggle
(global-set-key (kbd "<f5>") 'dired-toggle)


;; C-c C-e で ~/.emacs.d/init.el を別ウィンドウで開く
;; (global-set-key (kbd "C-c C-e") 'crux-find-user-init-file)
;; 下のならウィンドウを分割しない
(defun init.el ()
  (interactive)
  (find-file "~/dotfiles/.emacs.d/init.el"))
;; (global-set-key (kbd "C-c C-e") 'init.el)
(evil-leader/set-key "e" 'init.el)


;; 現在のファイルを規定のプログラムで開く
(defun open ()
  "Let's open file!!"
  (interactive)
  (cond ((eq system-type 'darwin)
         (shell-command (concat "open " (buffer-file-name))))
        ((eq system-type 'windows-nt)
         (shell-command (concat "cygstart " (buffer-file-name))))
        )
  )
(global-set-key "\C-co" 'open)


;; dired-find-alternate-file の有効化
(put 'dired-find-alternate-file 'disabled nil)
;; ファイルなら別バッファで、ディレクトリなら同じバッファで開く
(defun dired-open-in-accordance-with-situation ()
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (dired-find-alternate-file)
      (dired-find-file))))

;; RET 標準の dired-find-file では dired バッファが複数作られるので
;; dired-find-alternate-file を代わりに使う
(require 'evil)
(define-key dired-mode-map (kbd "RET") 'dired-open-in-accordance-with-situation)
(define-key dired-mode-map (kbd "<right>") 'dired-open-in-accordance-with-situation)
(evil-define-key 'normal dired-mode-map
  "l" 'dired-open-in-accordance-with-situation
  )
(define-key dired-mode-map (kbd "a") 'dired-find-file)

;; ディレクトリの移動キーを追加(wdired 中は無効)
(add-hook 'dired-mode-hook
 (lambda ()
  (define-key dired-mode-map (kbd "]")
    (lambda ()
      (interactive)
      (find-alternate-file "..")))
  ; was dired-up-directory
 ))
(add-hook 'dired-mode-hook
 (lambda ()
   (evil-define-key 'normal dired-mode-map
     "h"
     '(lambda ()
        (interactive)
        (find-alternate-file "..")))
  ; was dired-up-directory
 ))


(define-key dired-mode-map (kbd "L") 'my-tabbar-forward-tab)
(define-key dired-mode-map (kbd "H") 'my-tabbar-backward-tab)


;; dired にアイコン-------------------------------
(require 'all-the-icons)
(require 'all-the-icons-dired)
(add-to-list 'all-the-icons-icon-alist '("\\.[rR]$" all-the-icons-fileicon "R" :face all-the-icons-lblue))
(add-to-list 'all-the-icons-icon-alist '("\\.[rR][dD]ata$" all-the-icons-fileicon "R" :face all-the-icons-lred))
(add-to-list 'all-the-icons-icon-alist '("\\.[rR]md$" all-the-icons-octicon  "markdown" :face all-the-icons-lred))
(add-to-list 'all-the-icons-icon-alist '("\\.stan$" all-the-icons-fileicon "stan" :face all-the-icons-lred))
(add-to-list 'all-the-icons-icon-alist '("\\.sas$" all-the-icons-fileicon "sas" :face all-the-icons-lblue))
(add-to-list 'all-the-icons-icon-alist '("\\.sas7bdat$" all-the-icons-fileicon "sas" :face all-the-icons-lred))
(add-to-list 'all-the-icons-icon-alist '("\\.m$" all-the-icons-fileicon "matlab" :face all-the-icons-yellow))
(add-to-list 'all-the-icons-icon-alist '("\\.xls[x]$" all-the-icons-fileicon "excel" :face all-the-icons-green))

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)


;; dired-subtree----------------------------------
(require 'dired-subtree)
;; i を置き換え
(define-key dired-mode-map (kbd "i") 'dired-subtree-insert)
;; org-mode のように TAB で折り畳む
(define-key dired-mode-map (kbd "<tab>") 'dired-subtree-remove)
;; C-x n n で subtree にナローイング
(define-key dired-mode-map (kbd "C-x n n") 'dired-subtree-narrow)


;; dired-subtree を dired-details に対応させる
(defun dired-subtree-after-insert-hook--dired-details ()
  (dired-details-delete-overlays)
  (dired-details-activate))
(add-hook 'dired-subtree-after-insert-hook
          'dired-subtree-after-insert-hook--dired-details)

;; find-dired 対応
(defadvice find-dired-sentinel (after dired-details (proc state) activate)
  (ignore-errors
    (with-current-buffer (process-buffer proc)
      (dired-details-activate))))
;; (progn (ad-disable-advice 'find-dired-sentinel 'after 'dired-details) (ad-update 'find-dired-sentinel))

;; ^を dired-subtree に対応させる
(defun dired-subtree-up-dwim (&optional arg)
  "subtree の親ディレクトリに移動。そうでなければ親ディレクトリを開く(^の挙動)。"
  (interactive "p")
  (or (dired-subtree-up arg)
      (dired-up-directory)))
(define-key dired-mode-map (kbd "^") 'dired-subtree-up-dwim)


(defun dired-nolinum ()
  (nlinum-mode -1))
(add-hook 'dired-mode-hook 'dired-nolinum)


;; ---------------------------------------------------------
;; quick-preview の設定
;; ---------------------------------------------------------
(require 'quick-preview)
(setq quick-preview-method 'quick-look)

;;Setting for key bindings
(global-set-key (kbd "C-c q") 'quick-preview-at-point)
(define-key dired-mode-map (kbd "SPC") 'quick-preview-at-point)


;; ---------------------------------------------------------
;; SKK の設定
;; ---------------------------------------------------------
(when (require 'skk nil t)
  (global-set-key (kbd "C-x j") 'skk-mode)
  (setq default-input-method "japanese-skk")         ;;emacs 上での日本語入力に skk を使う
  (require 'skk-study))                              ;;変換学習機能の追加

(setq skk-server-prog "/usr/local/bin/google-ime-skk") ; google-ime-skk の場所
(setq skk-server-inhibit-startup-server nil) ; 辞書サーバが起動していなかったときに Emacs からプロセスを立ち上げる
(setq skk-server-host "localhost") ; サーバー機能を利用
(setq skk-server-portnum 55100)     ; ポートは google-ime-skk
(setq skk-share-private-jisyo t)   ; 複数 skk 辞書を共有


;; ノーマルステート時に状態遷移した時に skk が起動している場合、自動的にアスキーモードにする
(when (locate-library "skk")
  (require 'skk)
  (defun my-skk-control ()
    (when skk-mode
      (skk-latin-mode 1)))
  (add-hook 'evil-normal-state-entry-hook 'my-skk-control))

;; インサートモードでは自動で skk モードに
(defun skk-mode-on ()
  (interactive)
  (skk-latin-mode 1))
(add-hook 'evil-insert-state-entry-hook 'skk-mode-on)

;; アスキーモードのカーソルの色
(setq skk-cursor-latin-color "#5BFBD0")

;; ミニバッファでは C-j を改行にしない
(define-key minibuffer-local-map (kbd "C-j") 'skk-kakutei)

;; backspace は必ず後方削除
(define-key skk-j-mode-map [backspace] 'delete-backward-char)

;; ";"を sticky shift に用いることにする
(setq skk-sticky-key ";")


;; 候補表示
;; (setq skk-show-inline t)   ; 変換候補の表示位置
;; (setq skk-show-tooltip t) ; 変換候補の表示位置
(setq skk-show-candidates-always-pop-to-buffer t) ; 変換候補の表示位置
(setq skk-henkan-show-candidates-rows 2) ; 候補表示件数を 2 列に

;; 動的候補表示
(setq skk-dcomp-activate t) ; 動的補完
(setq skk-dcomp-multiple-activate t) ; 動的補完の複数候補表示
(setq skk-dcomp-multiple-rows 10) ; 動的補完の候補表示件数
;; 動的補完の複数表示群のフェイス
(set-face-foreground 'skk-dcomp-multiple-face "Black")
(set-face-background 'skk-dcomp-multiple-face "#BDBDBD")
(set-face-bold 'skk-dcomp-multiple-face nil)
;; 動的補完の複数表示郡の補完部分のフェイス
(set-face-foreground 'skk-dcomp-multiple-trailing-face "dim gray")
(set-face-bold 'skk-dcomp-multiple-trailing-face nil)
;; 動的補完の複数表示郡の選択対象のフェイス
(set-face-foreground 'skk-dcomp-multiple-selected-face "black")
(set-face-background 'skk-dcomp-multiple-selected-face "#666666")
(set-face-bold 'skk-dcomp-multiple-selected-face nil)
;; 動的補完時に C-n で次の補完へ
(define-key skk-j-mode-map (kbd "C-n") 'skk-comp-wrapper)

;; 動作
(setq skk-egg-like-newline t) ; Enter で改行しない
(setq skk-delete-implies-kakutei nil) ; ▼モードで一つ前の候補を表示
(setq skk-use-look t) ; 英語補完
(setq skk-auto-insert-paren t) ; 閉じカッコを自動的に
(setq skk-henkan-strict-okuri-precedence t) ; 送り仮名が厳密に正しい候補を優先して表示
(require 'skk-hint) ; ヒント

;; 句読点を動的に決定する
(add-hook 'skk-mode-hook
          (lambda ()
            (save-excursion
              (goto-char 0)
              (make-local-variable 'skk-kutouten-type)
              (if (re-search-forward "。" 10000 t)
                  (setq skk-kutouten-type 'en)
                (setq skk-kutouten-type 'jp)))))


;; 言語
(setq skk-japanese-message-and-error t) ; エラーを日本語に
(setq skk-show-japanese-menu t) ; メニューを日本語に

;; isearch
(add-hook 'isearch-mode-hook 'skk-isearch-mode-setup) ; isearch で skk のセットアップ
(add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup) ; isearch で skk のクリーンアップ
(setq skk-isearch-start-mode 'latin) ; isearch で skk の初期状態

;; カタカナを変換候補に入れる
(setq skk-search-katakana 'jisx0201-kana)


;;; C-/M-などを skk で入力するために
(defun skk-henkan-C- ()
  (concat "C-" (skk-henkan-ctrl-meta-conversion (read-string "C-"))))
(defun skk-henkan-M- ()
  (concat "M-" (skk-henkan-ctrl-meta-conversion (read-string "M-") 'meta)))
(defun skk-henkan-M-x ()
  (concat "M-x " (read-string "M-x ")))
(defun skk-henkan-C-c ()
  (concat "C-c " (skk-henkan-ctrl-meta-conversion (read-string "C-c "))))
(defun skk-henkan-C-u ()
  (concat "C-u " (skk-henkan-ctrl-meta-conversion (read-string "C-u "))))
(defun skk-henkan-C-x ()
  (concat "C-x " (skk-henkan-ctrl-meta-conversion (read-string "C-x "))))
(defun skk-henkan-ctrl-meta-conversion (input &optional metap)
  (if (and metap (string= "x" (substring input 0 1)))
      input
    (replace-regexp-in-string
     "c-" "C-"
     (replace-regexp-in-string
      "m-" "M-"
      (replace-regexp-in-string
       "h-" "H-"
       (replace-regexp-in-string
        "ret" "RET"
        (replace-regexp-in-string
         "spc" "SPC"
         (replace-regexp-in-string
          "tab" "TAB"
          (replace-regexp-in-string
           "esc" "ESC"
           (replace-regexp-in-string
            "del" "DEL"
            input))))))))))
;;; (skk-henkan-M-)
;;; (skk-henkan-C-)
;;; (skk-henkan-C-c)
;;; (skk-henkan-C-u)


(define-minor-mode skk-auto-replace-mode
  "同じ見出し語を query-replace する。議事録・セミナーメモ校正のためのモード。"
  nil " SKK 置換")
(defvar skk-my-kakutei-key nil "")
(defadvice skk-start-henkan (before auto-replace activate)
  (and (eq skk-henkan-mode 'on)
       (setq skk-my-kakutei-key (buffer-substring skk-henkan-start-point (point)))))
;; (progn (ad-disable-advice 'skk-start-henkan 'before 'auto-replace) (ad-update 'skk-start-henkan))
(defadvice skk-kakutei (after auto-replace activate)
  (skk-replace-after-kakutei))
;; (progn (ad-disable-advice 'skk-kakutei 'after 'auto-replace) (ad-update 'skk-kakutei))

(defun skk-replace-after-kakutei ()
  (interactive)
  (when (and skk-auto-replace-mode
             skk-my-kakutei-key)
    (unwind-protect
        (perform-replace
         skk-my-kakutei-key (buffer-substring skk-henkan-start-point (point))
         t nil nil)
     (setq skk-my-kakutei-key nil))))


;; find-file で skk-mode になる
;; (add-hook 'find-file-hooks 'skk-mode-on)
;; helm でも C-j で skk のかなモードに

;; ミニバッファ上でも skk-mode にする
(add-hook 'minibuffer-setup-hook 'skk-mode-on)


;; かなモードの入力で (モード変更を行なわずに) 長音(ー)を
;; ASCII 数字の直後では `-' に、全角数字の直後では `－' にしたい。
(setq skk-rom-kana-rule-list
      (cons '("-" nil skk-hyphen)
            skk-rom-kana-rule-list))

(defun skk-hyphen (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "ー")
          ((and (<= ?0 c) (>= ?9 c)) "-")
          ((and (<= ?０ c) (>= ?９ c)) "－")
          (t "ー"))))


;; かなモードの入力でモード変更を行わずに、数字入力中の
;; 小数点 (.) およびカンマ (,) 入力を実現する。
;; (例) かなモードのまま 1.23 や 1,234,567 などの記述を行える。
;; period
(setq skk-rom-kana-rule-list
      (cons '("." nil skk-period)
            skk-rom-kana-rule-list))

(defun skk-period (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "。")
          ((and (<= ?0 c) (>= ?9 c)) ".")
          ((and (<= ?０ c) (>= ?９ c)) "．")
          (t "。"))))


;; comma
(setq skk-rom-kana-rule-list
      (cons '("," nil skk-comma)
            skk-rom-kana-rule-list))

(defun skk-comma (arg)
  (let ((c (char-before (point))))
    (cond ((null c) "、")
          ((and (<= ?0 c) (>= ?9 c)) ",")
          ((and (<= ?０ c) (>= ?９ c)) "，")
          (t "、"))))


;; z1 とか x1 で丸数字入力を可能にする
(let ((s "⑩①②③④⑤⑥⑦⑧⑨"))
  (dotimes (n (length s))
    (add-to-list
    'skk-rom-kana-rule-list
    (list (concat "z" (number-to-string n))
          nil
          (cons (substring s n (1+ n)) (substring s n (1+ n)))))))

(let ((s "⑳⑪⑫⑬⑭⑮⑯⑰⑱⑲"))
  (dotimes (n (length s))
    (add-to-list
    'skk-rom-kana-rule-list
    (list (concat "x" (number-to-string n))
          nil
          (cons (substring s n (1+ n)) (substring s n (1+ n)))))))


;; ---------------------------------------------------------
;; Evil の設定
;; ---------------------------------------------------------
;; evil-leaders-----------------------------------
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

(evil-leader/set-key
  "f" #'helm-find-files)

;; Evil 有効
(evil-mode 1)

;; Evil のいろいろな設定
(setq evil-default-cursor 'hbar
      evil-normal-state-cursor '("#F3A836" (bar . 2)) ;; ノーマルステートではオレンジの垂直バー
      evil-insert-state-cursor '("red" (bar . 2)) ;; 挿入ステートでは赤い垂直バーに
      evil-move-cursor-back nil ;; ノーマルステートに戻るときにカーソルを後退しない
      evil-regexp-search nil
      )

;; インサート→ノーマルステートを jj でやる
(require 'key-chord)
(setq key-chord-two-keys-delay 0.3)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)


;; C で選択範囲をコメント/アンコメント
; ただし Emacs の標準機能で M-; でも可能
(require 'evil-operator-comment)
(global-evil-operator-comment-mode 1)


;; SKK との共存設定
(defadvice update-buffer-local-cursor-color
  (around evil-update-buffer-local-cursor-color-in-insert-state activate)
  ;; SKK によるカーソル色変更を, 挿入ステートかつ日本語モードの場合に限定
  "Allow ccc to update cursor color only when we are in insert
state and in `skk-j-mode'."
  (when (and (eq evil-state 'insert) (bound-and-true-p skk-j-mode))
    ad-do-it))
(defadvice evil-refresh-cursor
  (around evil-refresh-cursor-unless-skk-mode activate)
  ;; Evil によるカーソルの変更を, 挿入ステートかつ日本語モードではない場合に限定
  "Allow ccc to update cursor color only when we are in insert
state and in `skk-j-mode'."
  (unless (and (eq evil-state 'insert) (bound-and-true-p skk-j-mode))
    ad-do-it))

(defadvice evil-ex-search-update-pattern
  (around evil-inhibit-e/x-search-update-pattern-in-skk-henkan activate)
  ;; SKK の未確定状態(skk-henkan-mode)ではない場合だけ, 検索パターンをアップデート
  "Inhibit search pattern update during `skk-henkan-mode'.
This is reasonable since inserted text during `skk-henkan-mode'
is a kind of temporary one which is not confirmed yet."
  (unless (bound-and-true-p skk-henkan-mode)
    ad-do-it))

;; evil デフォルトの設定では"\C-j"は改行なのでこれをキャンセルする
; このことで改行せずにかな入力モードへ移行できる
(define-key evil-insert-state-map "\C-j" 'nil)

;; :q を C-x C-c ではなく kill this buffer にする
(evil-ex-define-cmd "q[uit]" 'kill-this-buffer)


;; Evil でのモードラインの色を変える
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-normal-state-p) '("#4169e1" . "#ffffff"))
                                 ((evil-insert-state-p) '("#2e8b57" . "#ffffff"))
                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))


;; C-p と C-n について-------------------------------
;; 通常は C-p で一つ前にヤンク(コピー)した内容を貼り付け直し、
;; C-n で一つ後のものを貼り付け直す
(defadvice evil-paste-pop (around evil-paste-or-move-line activate)
  ;; evil-paste-pop できなかったら previous-line する
  "If there is no just-yanked stretch of killed text, just move
to previous line."
  (condition-case err
      ad-do-it
    (error (if (eq this-command 'evil-paste-pop)
               (call-interactively 'previous-line)
             (signal (car err) (cdr err))))))
(defadvice evil-paste-pop-next (around evil-paste-or-move-line activate)
  ;; evil-paste-pop-next できなかったら next-line する
  "If there is no just-yanked stretch of killed text, just move
to next line."
  (condition-case err
      ad-do-it
    (error (if (eq this-command 'evil-paste-pop-next)
               (call-interactively 'next-line)
             (signal (car err) (cdr err))))))


;; インサートモードでの範囲選択とかをvimっぽくする---
(require 'vim-region)
(key-chord-define evil-insert-state-map "vv" 'vim-region-mode)


;; evil-surround----------------------------------
(require 'evil-surround)
(global-evil-surround-mode 1)


;; evil-matchit-----------------------------------
(require 'evil-matchit)
(global-evil-matchit-mode 1)

;; Ruby の正規表現で有効にする
(eval-after-load 'evil-matchit-ruby
  '(progn
     (add-to-list 'evilmi-ruby-extract-keyword-howtos '("^[ \t]*\\([a-z]+\\)\\( .*\\| *\\)$" 1))
     (add-to-list 'evilmi-ruby-match-tags '(("unless" "if") ("elsif" "else") "end"))
     ))


;; evil-numbers-----------------------------------
(require 'evil-numbers)
(global-set-key (kbd "C-c =") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)


;; Evil 上でマルチカーソル-------------------------
(require 'evil-multiedit)
;; キーバインド設定
;; Highlights all matches of the selection in the buffer.
(define-key evil-visual-state-map "R" 'evil-multiedit-match-all)

;; Match the word under cursor (i.e. make it an edit region). Consecutive presses will
;; incrementally add the next unmatched match.
(define-key evil-normal-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
;; Match selected region.
(define-key evil-visual-state-map (kbd "M-d") 'evil-multiedit-match-and-next)

; Same as M-d but in reverse.
(define-key evil-normal-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
(define-key evil-visual-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)

;; OPTIONAL: If you prefer to grab symbols rather than words, use
;; `evil-multiedit-match-symbol-and-next` (or prev).

;; Restore the last group of multiedit regions.
(define-key evil-visual-state-map (kbd "C-M-D") 'evil-multiedit-restore)

;; RET will toggle the region under the cursor
(define-key evil-multiedit-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)

;; ...and in visual mode, RET will disable all fields outside the selected region
(define-key evil-visual-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)

;; For moving between edit regions
(define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
(define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
(define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)

;; Ex command that allows you to invoke evil-multiedit with a regular expression, e.g.
(evil-ex-define-cmd "ie[dit]" 'evil-multiedit-ex-match)


;; キーバインド-----------------------------------
(define-key evil-insert-state-map "\C-a" 'move-beginning-of-line)
(define-key evil-insert-state-map "\C-e" 'move-end-of-line)
(define-key evil-insert-state-map "\C-n" 'evil-next-line)
(define-key evil-insert-state-map "\C-p" 'evil-previous-line)


;; 空行を挿入
(defun evil-insert-new-line-below ()
  "Inserts a new line below point and places point in that line
with regard to indentation."
  (interactive)
  (evil-narrow-to-field
    (evil-move-end-of-line)
    (insert "\n")
    (back-to-indentation)))
(define-key evil-normal-state-map (kbd "RET") 'evil-insert-new-line-below)


;; ---------------------------------------------------------
;; rainbow-mode の設定
;; ---------------------------------------------------------
(require 'rainbow-mode)

;; カラーコードに色付けしたいモードの設定
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'scss-mode-hook 'rainbow-mode)
(add-hook 'php-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)
(add-hook 'less-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'lisp-mode-hook 'rainbow-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-mode)


;; ---------------------------------------------------------
;; WhiteSpace の設定
;; ---------------------------------------------------------
;; 改行コードを表示する
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

(require 'whitespace)
(setq whitespace-style '(face           ; face で可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         space-mark     ; 表示のマッピング
                         tab-mark
                         newline        ; 改行
                         newline-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])
        (newline-mark 10 [8629 10]) ; 10 LINE FEED
        ))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; 保存前に自動でクリーンアップ
;; (setq whitespace-action '(auto-cleanup))


(global-whitespace-mode 1)


(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)
(set-face-attribute 'whitespace-newline nil
                    :background nil
                    :foreground "gray30"
                    :height 0.7
                    :weight 'ultra-light)


;; オンオフの切り替え
(defun whitespace-mode-toggle ()
  (interactive)
  (whitespace-mode 'toggle))

(global-set-key (kbd "A-w") 'whitespace-mode-toggle)


;; ---------------------------------------------------------
;; stripe-buffers の設定
;; ---------------------------------------------------------
(add-hook 'dired-mode-hook 'stripe-listify-buffer)
(add-hook 'org-mode-hook 'turn-on-stripe-table-mode)


;; ---------------------------------------------------------
;; hydra の設定
;; ---------------------------------------------------------
;; ズームイン / アウトの設定
(defhydra hydra-zoom (global-map "<f6>")
  "zoom"
  ("i" text-scale-increase "zoom in")
  ("o" text-scale-decrease "zoom out"))


;; ---------------------------------------------------------
;; yascroll の設定
;; ---------------------------------------------------------
;; スクロールバーを非表示
(scroll-bar-mode 0)

;; yascroll
(require 'yascroll)
(global-yascroll-bar-mode 1)


;; ---------------------------------------------------------
;; auto-complete の設定
;; ---------------------------------------------------------
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-auto-show-menu 0.2) ; 補完リストが表示されるまでの時間
(define-key ac-completing-map (kbd "C-n") 'ac-next)      ; C-n で次候補選択
(define-key ac-completing-map (kbd "C-p") 'ac-previous)  ; C-p で前候補選択
;; ファイルパスの補完
(global-set-key [(alt tab)] 'ac-complete-filename)
(setq ac-dwim t)  ; 空気読んでほしい
;; 情報源として
;; * ac-source-filename
;; * ac-source-words-in-same-mode-buffers
;; を利用
(setq-default ac-sources '(ac-source-filename
                           ac-source-words-in-same-mode-buffers
                           ac-source-yasnippet))
;; また、Emacs Lisp モードでは ac-source-symbols を追加で利用
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-symbols t)))
(setq ac-auto-start 3);; 補完を開始する文字数


;; 色
(set-face-background 'ac-completion-face "#333333")
(set-face-foreground 'ac-candidate-face "black")
(set-face-background 'ac-selection-face "#666666")
(set-face-foreground 'popup-summary-face "black")  ;; 候補のサマリー部分
(set-face-background 'popup-tip-face "#ffffd8")  ;; ドキュメント部分
(set-face-foreground 'popup-tip-face "black")


(global-set-key (kbd "A-;") 'ac-complete-with-helm)
(define-key ac-complete-mode-map (kbd "C-;") 'ac-complete-with-helm)


;; ---------------------------------------------------------
;; company-mode の設定
;; ---------------------------------------------------------
(require 'company)
(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "orange")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")

;; C-n, C-p で補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; C-s で絞り込む
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)


;; ---------------------------------------------------------
;; dunb-jump の設定
;; ---------------------------------------------------------
;; dumb-jump(C-M-g/p で変数定義に飛ぶ)
(add-hook 'python-mode-hook 'dumb-jump-mode)

(setq python-shell-completion-native-enable nil)


;; ---------------------------------------------------------
;; highlight-symbol の設定
;; ---------------------------------------------------------
(require 'highlight-symbol)
(setq highlight-symbol-colors '("HotPink" "SlateBlue1" "DarkOrange" "SpringGreen1" "tan" "DodgerBlue1"))
(global-set-key (kbd "<f9>") 'highlight-symbol-at-point)
(global-set-key (kbd "M-<f9>") 'highlight-symbol-remove-all)
(global-set-key (kbd "C-M-j") 'highlight-symbol-next)
(global-set-key (kbd "C-M-k") 'highlight-symbol-prev)
;; シンボル置換
(global-set-key (kbd "A-q") 'highlight-symbol-query-replace)


;; ---------------------------------------------------------
;; electric-operator の設定(演算子にスペースを自動入力)
;; ---------------------------------------------------------
(require 'electric-operator)
(add-hook 'enh-ruby-mode-hook 'electric-operator-mode)
(add-hook 'ess-mode-hook 'electric-operator-mode)
(add-hook 'org-mode-hook 'electric-operator-mode)
(add-hook 'python-mode-hook 'electric-operator-mode)
(add-hook 'yatex-mode-hook 'electric-operator-mode)

;; ESS では%を演算子から外す
(electric-operator-add-rules-for-mode 'ess-mode
  (cons "%" nil))


;; ---------------------------------------------------------
;; smartparens の設定(カッコを自動で閉じてくれる)
;; ---------------------------------------------------------
(require 'smartparens-config)
(smartparens-global-mode t)

;; LaTeX の数式補完用に
(def-add-hooks `(yatex-mode-hook markdown-mode-hook org-mode-hook poly-markdown+r-mode)
               '(lambda ()
                 (sp-pair "$" "$")))


;; ---------------------------------------------------------
;; rainbow-delimiters の設定(対応するカッコに色付け)
;; ---------------------------------------------------------
;; rainbow-delimiters を使うための設定
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'ESS-mode-hook 'rainbow-delimiters-mode)
(add-hook 'R-mode-hook 'rainbow-delimiters-mode)
(add-hook 'SAS-mode-hook 'rainbow-delimiters-mode)
(add-hook 'julia-mode-hook 'rainbow-delimiters-mode)
(add-hook 'stan-mode-hook 'rainbow-delimiters-mode)

(setq rainbow-delimiters-outermost-only-face-count 1)

;; (set-face-foreground 'rainbow-delimiters-depth-1-face "#f0f0f0")
;; (set-face-foreground 'rainbow-delimiters-depth-2-face "#ff5e5e")
;; (set-face-foreground 'rainbow-delimiters-depth-3-face "#ffaa77")
;; (set-face-foreground 'rainbow-delimiters-depth-4-face "#dddd77")
;; (set-face-foreground 'rainbow-delimiters-depth-5-face "#80ee80")
;; (set-face-foreground 'rainbow-delimiters-depth-6-face "#66bbff")
;; (set-face-foreground 'rainbow-delimiters-depth-7-face "#da6bda")
;; (set-face-foreground 'rainbow-delimiters-depth-8-face "#afafaf")
;; (set-face-foreground 'rainbow-delimiters-depth-9-face "#9a4040")

;; 括弧の色を強調する設定
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (interactive)
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
    (cl-callf color-saturate-name (face-foreground face) 30))))
(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)


;; ---------------------------------------------------------
;; 連番入力 の設定
;; ---------------------------------------------------------
;; srep でエクセルのオートフィルっぽくする
;; http://d.hatena.ne.jp/ken_m/20111219/1324318727
(require 'srep)

;; anotherline で M-o で一発インクリメント
(defun another-line (num-lines)
    "Copies line, preserving cursor column, and increments any numbers found.
  Copies a block of optional NUM-LINES lines.  If no optional argument is given,
  then only one line is copied."
    (interactive "p")
    (if (not num-lines) (setq num-lines 0) (setq num-lines (1- num-lines)))
    (let* ((col (current-column))
           (bol (save-excursion (forward-line (- num-lines)) (beginning-of-line) (point)))
           (eol (progn (end-of-line) (point)))
           (line (buffer-substring bol eol)))
      (goto-char bol)
      (while (re-search-forward "[0-9]+" eol 1)
        (let ((num (string-to-int (buffer-substring
                                    (match-beginning 0) (match-end 0)))))
          (replace-match (int-to-string (1+ num))))
        (setq eol (save-excursion (goto-char eol) (end-of-line) (point))))
      (goto-char bol)
      (insert line "\n")
      (move-to-column col)))
(define-key global-map (kbd "M-o") 'another-line)


;; ---------------------------------------------------------
;; モードラインの設定
;; ---------------------------------------------------------
(require 'powerline)
(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background "#4169e1"
                    :box nil)

(set-face-attribute 'powerline-active1 nil
                    :foreground "#fff"
                    :background "#6495ED"
                    :inherit 'mode-line)


(setq ns-use-srgb-colorspace nil) ;; 色の境目をきれいにする


;; mode の名前を自分で再定義
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (flycheck-mode . " Fc")
    (paredit-mode . " Pr")
    ;; (undo-tree-mode . " Ut")
    ;; (anzu-mode . " Az")
    (yas-minor-mode . " Ys")
    (auto-complete-mode . " Ac")
    (ruby-refactor-mode . " RbRef")
    (abbrev-mode . " Abr")
    (ruby-block-mode . " RbB")
    (orgtbl-mode . " Ot")
    (dired-filter-mode . " df")
    (dired-icon-mode . " ic")
    (projectile-mode . " Pj")
    (google-this-mode . "")
    (page-break-lines-mode . "")
    (helm-migemo-mode . "")
    (which-key-mode . "")
    (super-save-mode . "")
    (all-the-icons-dired-mode . "")
    (ace-pinyin-mode . "")
    (pangu-spacing-mode . "")
    (ace-isearch-mode . "")
    ;; For major-mode
    (lisp-interaction-mode . "Li")
    (python-mode . "Py")
    (inferior-python-mode . "IP")
    (ruby-mode   . "Rb")
    (enh-ruby-mode   . "EnhRb")
    (emacs-lisp-mode . "El")
    (markdown-mode . "Md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)


;; フォント
;; モードライン
(set-face-font 'mode-line "Symbola-14")
;; 非アクティブなウィンドウのモードライン
(set-face-font 'mode-line-inactive "Ricty Diminished for Powerline-14")
;; バッファ名
(set-face-font 'mode-line-buffer-id "Ricty Diminished for Powerline-14")

;; telephone-line
(require 'telephone-line)
(require 'vc)
(telephone-line-mode 1)
(setq telephone-line-lhs
        '((evil   . (telephone-line-evil-tag-segment))
          (accent . (telephone-line-vc-segment
                     telephone-line-erc-modified-channels-segment
                     telephone-line-process-segment))
          (nil    . (telephone-line-minor-mode-segment
                     telephone-line-buffer-segment))))
(setq telephone-line-rhs
      '((nil    . (telephone-line-misc-info-segment))
        (accent . (telephone-line-major-mode-segment))
        (evil   . (telephone-line-airline-position-segment))))

(setq telephone-line-primary-left-separator 'telephone-line-gradient
      telephone-line-secondary-left-separator 'telephone-line-nil
      telephone-line-primary-right-separator 'telephone-line-gradient
      telephone-line-secondary-right-separator 'telephone-line-nil)
(setq telephone-line-height 18)

;; sky-color-clock
(require 'sky-color-clock)      ;;
(sky-color-clock-initialize 35) ;; 東京の緯度で初期化
(sky-color-clock-initialize-openweathermap-client (my-lisp-load "openweathermap-api") 1850144) ; 東京の City ID
;; デフォルトの mode-line-format の先頭に sky-color-clock を追加
(push '(:eval (sky-color-clock)) (default-value 'mode-line-format))
(setq sky-color-clock-enable-emoji-icon t)
(setq sky-color-clock-enable-temperature-indicator t)
(setq sky-color-clock-format "%H:%M")


;; ---------------------------------------------------------
;; diminish の設定(指定したマイナーモードを表示しない)
;; ---------------------------------------------------------
(require 'diminish)

(defmacro safe-diminish (file mode &optional new-name)
  "https://github.com/larstvei/dot-emacs/blob/master/init.org"
  `(with-eval-after-load ,file
     (diminish ,mode ,new-name)))

(safe-diminish "helm-mode" 'helm-mode)
(safe-diminish "rainbow-mode" 'rainbow-mode)
(safe-diminish "smartparens" 'smartparens-mode)
(safe-diminish "whitespace" 'global-whitespace-mode)
(safe-diminish "smooth-scroll" 'smooth-scroll-mode)
(safe-diminish "anzu" 'anzu-mode)
(safe-diminish "undo-tree" 'undo-tree-mode)


;; ---------------------------------------------------------
;; smooth-scroll の設定
;; ---------------------------------------------------------
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

(setq scroll-step 1) ;; keyboard scroll one line at a time

(require 'smooth-scroll)
(smooth-scroll-mode t)

;; 横方向のスクロール行数を変更する。
(setq smooth-scroll/hscroll-step-size 4)


;; ---------------------------------------------------------
;; migemo の設定
;; http://qiita.com/kenbeese/items/ebbf0128d7c752a94a22
;; http://qiita.com/duloxetine/items/0adf103804b29090738a
;; ---------------------------------------------------------
(setq migemo-command "/usr/local/bin/cmigemo")
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-user-dictionary nil)
(setq migemo-coding-system 'utf-8)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(require 'migemo)
(migemo-init)


;; ---------------------------------------------------------
;; anzu の設定
;; ---------------------------------------------------------
(require 'anzu)
(global-anzu-mode 1)

;; migemo で有効にする
(setq anzu-use-migemo t)


;; ---------------------------------------------------------
;; helm の設定
;; ---------------------------------------------------------
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "C-;") 'helm-command-prefix)
;; (define-key global-map (kbd "M-x") 'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-; o") 'helm-occur)

;; migemo を有効にする
(helm-migemo-mode 1)

;; 候補の色
(set-face-background 'helm-selection "#44475a")

; helm-autoresize-mode(helm バッファの大きさを自動調整
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode t)


;; ace-jump を使う
(require 'ace-jump-helm-line)

(define-key helm-map (kbd "`") 'ace-jump-helm-line--with-error-fallback)
(define-key helm-map (kbd ";") 'ace-jump-helm-line-and-execute-action)

; anything-shortcut-keys-alist と同じように設定
(setq avy-keys (append "asdfghjklzxcvbnmqwertyuiop" nil))

; ちょっとアレンジ
(defun ajhl--insert-last-char ()
  (insert (substring (this-command-keys) -1)))
(defun ace-jump-helm-line--with-error-fallback ()
  "ヒント文字以外の文字が押されたらその文字を挿入するように修正"
  (interactive)
  (condition-case nil
      (ace-jump-helm-line)
    (error (ajhl--insert-last-char))))
(defun ace-jump-helm-line-and-execute-action ()
  "anything-select-with-prefix-shortcut 互換"
  (interactive)
  (condition-case nil
      (progn (ace-jump-helm-line)
             (helm-exit-minibuffer))
    (error (ajhl--insert-last-char))))


(require 'helm-smex)
(define-key global-map (kbd "M-x") 'helm-smex)


;; ---------------------------------------------------------
;; helm-swoop の設定
;; ---------------------------------------------------------
(require 'helm-swoop)
;; isearch からの連携を考えると C-r/C-s にも割り当て推奨
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

;; 検索結果を cycle しない
(setq helm-swoop-move-to-line-cycle nil)

(cl-defun helm-swoop-nomigemo (&key $query ($multiline current-prefix-arg))
  "シンボル検索用 Migemo 無効版 helm-swoop"
  (interactive)
  (let ((helm-swoop-pre-input-function
         (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol)))))
    (helm-swoop :$source (delete '(migemo) (copy-sequence (helm-c-source-swoop)))
                :$query $query :$multiline $multiline)))
;; C-M-:に割り当て
;; (global-set-key (kbd "C-M-;") 'helm-swoop-nomigemo)
(define-key evil-normal-state-map (kbd "A-?") 'helm-swoop-nomigemo)
(define-key evil-insert-state-map (kbd "A-?") 'helm-swoop-nomigemo)


;; ace-isearch
(global-ace-isearch-mode 1)

;; C-u C-s / C-u C-u C-s
(defun isearch-forward-or-helm-swoop (use-helm-swoop)
  (interactive "p")
  (let (current-prefix-arg
        (helm-swoop-pre-input-function 'ignore))
    (call-interactively
     (case use-helm-swoop
       (1 'isearch-forward)
       (4 'helm-swoop)
       (16 'helm-swoop-nomigemo)))))
(global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop)
(define-key evil-normal-state-map (kbd "A-/") 'helm-swoop)
(define-key evil-insert-state-map (kbd "A-/") 'helm-swoop)


;; ---------------------------------------------------------
;; ace-jump の設定
;; ---------------------------------------------------------
(require 'ace-jump-mode)

;; ヒント文字に使う文字を指定する
(setq ace-jump-mode-move-keys
      (append "asdfghjklzxcvbnmqwertyuiopASDFGHJKLZXCVBNMQWERTYUIOP" nil))


;; H-a 〜 z で word モードが発動するように
(defun add-keys-to-ace-jump-mode (prefix c &optional mode)
  (define-key global-map
    (read-kbd-macro (concat prefix (string c)))
    `(lambda ()
       (interactive)
       (funcall (if (eq ',mode 'word)
                    #'ace-jump-word-mode
                  #'ace-jump-char-mode) ,c))))

(loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-" c 'word))
(loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-" c 'word))


;; ace-jump-char-mode を日本語対応
(require 'ace-pinyin)
(defun ace-pinyin--build-regexp (query-char &optional prefix)
  (let ((diff (- query-char ?a)))
    (if (and (< diff 26) (>= diff 0))
        (let ((regexp (nth diff ace-pinyin--char-table)))
          (if prefix regexp (concat (format "[%c]\\|" query-char) regexp)))
      (regexp-quote (make-string 1 query-char)))))

(defun ace-pinyin--jump-impl (query-char &optional prefix)
  "Basically copy the implementation of `ace-jump-char-mode'"
  (if ace-jump-current-mode (ace-jump-done))

  (if (eq (ace-jump-char-category query-char) 'other)
    (error "[AceJump] Non-printable character"))

  ;; others : digit , alpha, punc
  (setq ace-jump-query-char query-char)
  (setq ace-jump-current-mode 'ace-jump-char-mode)
  (ace-jump-do (ace-pinyin--build-regexp query-char prefix)))
;;; echo a | cmigemo -q --emacs -d /usr/share/cmigemo/utf-8/migemo-dict
;;; を a 〜 z で繰り返し、最初の[]の文字を取得することで生成
(setq ace-pinyin--char-table
  '(
    "[母餅渉恤閔憐遽慌鰒蚫鮑袷淡∃主袵衽歩垤蟻麁凡蘭塔露著表霰非諍抗検更革改現爭競争洗殿鉱予豫粗嵐恠彪妖殺禮絢怪綺彩肖漢過謝謬誤礼操綾飴黯菴罨鱇鮟餡闇行按諳晏鞍暗鶩鬚鰓顎喘発肋豈嫂兄騰崇県購贖网罔咫與中鼎新邉邊辺恰頭價価値游遊畔畦堋杏梓与衵袙憬坑孔案侮窖強貴讎讐徒仇痣黶欺鮮字糾嘲薊姐姉曙炮焙炙蜚薹膏脂油危鐙虻泡踪蹟能痕跡東預纂蒐乢輯聚遏軋誂羹壓惇集陸敦暑淳篤熱扱暖温遖斡私圧焦汗桜奥央櫻媼奧塰蜑餘遍周普剰蔗余尼雨甘天押凹樗楝溢艶庵鰺網戯簣鯵味渥軛堊圷憧欠踵幄握芥齷厚漁鯏蜊蕣淺麻浅龝煥晢晰呆朖光啓旭滉昜晄輝亮顯陽璋鑑亨聡洸曠昿諦朗哲顕彬晶賈章商穐彰晃昭晧秋瞹欸阨穢埃噫姶文隘粟曖鮎藹饗靉挨間相哀葭趾朝晨愛蹇跛跫脚蘆葦芦桎鐐足赫淦燈赧紅旃朱茜藜銅赭曉閼暁垢皸皹證灯絳暴証赤扇呷黝榮碧葵蒼煽仰青穴倦厭遭当悪椏敢襾或彼宛安該褪揚娃飽會荒飫浴上嗚韲哇和痾亞開阿併唖吾在當婀惡明合逢擧挙充編遇有あａ藍金＠∧＆&論∩∠銀会∀域空↓↑⇔⇒←→⌒後Ц亜米¨´｀＾’≒〜ÅАαаアΑ A]"
    "[鯔鰡堀本凡盆煩梵骨凹歿鈕釦沒渤没樸穆睦濮目攵攴朴木僕墨卜牧星懋蠎黽网旁罔謗儚鉾甍袤胞貌牟瑁卯髦虻眸鋩榜抱茆蒡肪鵬旄氓蟒冐乏惘妨帽昴忙剖冒忘茅膀妄尨厖膨貿防紡滂茫望亡傍謀某拇謨坊姥牡菩簿慕褒掘母誉模乾募暮呆暈干姆彫保戊惚墓ぼ幎覓汨冖巾羃冪紅瞥韈鼈蔑塀汳遍抃瓣辯卞辧辨宀采湎辮眄冕勉娩弁可邉邊辺べ船房笛斑渕縁鞭淵渊椈樗太袋深葢盖蓋豚節勿佛物震勃蚋風鰤馼蚊聞文嘸武不歩舞撫伏廡蕪撃奉侮誣葡錻無分憮拭撲蒲吹打部葺振悔毋ぶ米謐人匹浸額鐚跛！広開繆別謬泯旻岷梹緡罎紊檳頻壜愍瓶鬢閔憫敏貧便帛闢辟百白票杪緲″猫憑鋲屏渺眇平錨苗秒描廟病嵋寐尾濔眉弭備火比枇美日琵毘未贔瀰引麋糜弾靡微糒媚縻び速早林針尿拂腹散払祓原旛鷭蠻幡塙旙鑁悗挽判棒絆版輓蕃板播礬阪坂磐番盤晩萬蛮万箱蠅芒挟伴蜂桴枹鉢撥働畑畠屎糞鼻花端離話 V 魅秤許拔魃罸筏閥橋箸走柱藐獏貘寞暴漠瀑麥縛博駁莫驀爆霾狽吠憊賣唄楳杯苺培煤黴貝焙賠買陪売倍梅媒跋伐末幕曝抜罰歯塲刄晴羽刃芭婆庭貼罵化張這馬場馳葉ばｂ“仏■□⊥下底×｜−‖＼∵麦ボバ］［｛｝ブБΒベβбビ b]"
    "[恐怖惟怺※米暦轉頃鯤坤鶤艮袞琿悃壼獻很狠建棍魂蒟菎滾梱溷献痕渾墾恨懇根杪王挙泥裔樸鞐熟枹醴蛩徑蹊径溢毀零錯苔拒亊箏判斷諺理断盡尽辞琴言異事今壽寿鯒冀希礫鯉拱齣狛細腓昆拳瘤鮗兄近谺応應答是爰凩惚兀榾忽輿甑腰拵拗鏝鐺浤惶伉犒哮鮫湟蛤狎慌槹礦扛扣搆椌閧絖哽淆闔閤鴿鏗肴仰匣覯餃杲遘呷窖肓湊藁敲幌桁皐倥猴紘訌缸昊詬凰靠遑頁袷羔洸徨岡峺寇冓困棡亙鵁壙鍠鱇晄誥洽啌效耗吭峇釦傚昿稾肱隍頏磽昴絋逅冦砿鬨糠矼黌爻塙烋盍崗汞胱恆畊蚣熕嫦皋紺鈩絳閘蒙氷冰郡蛟槁候楮媾溘后蝗酵嚆犢稿亢哄睾梗慷笄郊効岬肛項巷鑛洪佼狡叩昂勾喉晃滉剛糀晧曠宏控恍侯耿煌膏坑港皓皎向江膠虹巧鴻鉱興衡浩厚耕弘綱抗購講恒薨溝鋼更航孝校行肯荒皇光高好詰谷棘轂哭釛斛梏尅槲告刻酷穀呱痩壷拠去懲鴣詁⌒沽混觚箍兒餬虚雇錮漉蠱児蝴葫壺跨捏己滸皷黄女杞超瑚漕怙倒罟糊濾粉辜菰股琥乕瞽鈷濃越扈瓠胯誇估凅肥孤弧夸蛄踰転湖故込木恋古虍娘戸粐袴楜冴媚冱鼓放乎滬戀虎こ芹鬩鐫揃喘燹韆綫栫痊槫涎吮僣筌纖舛專簽刋倩舩旃槧苫亘沾饌湶濳仟阡斬箭薦茜荐筅錢擶纎磚孱翦濺甎僊癬蟾銛孅牋羶箋贍殲殱闡賎餞羨顫甅竰糎陝銓踐閃∨潺遷銑栴剪煽譫僉瞻践栓跣疝詮銭穿戰尠繊僭腺泉仙嬋淺擅鮮専扇浅船蘚線撰宣洗選煎戦尖先忙倅伜逼狹狭蝉旋緤啜§泄絏渫椄卩洩紲薛攝鱈刹褻浙竊窃截殺説拙摂節切籍瘠迹蹐蹠威螫績裼蓆跖晢勣晰跡夕鶺雪寂∬∫碩惜析隻席萋菁躋嘶撕犀擠婿睛韲牲甥貰齊晟情穽醒筬齏瀞淒歳栖棲掣腥逝斉惺臍旌悽整凄靖製晴畝迫攻勢丗塞畆急世脊堰糶瀬せ配栩椡櫪椪檪椚箜櫟含纐婚糞癖潛潜鵠凹窪縊跟頚軛珞頸諄鞋窟履狐轡覆沓碎砕条降件頽崩屑釘莖茎陸杙杭掘崛倔鶏鐃藥擽薬楠誓梳串釧與与挫籖鯀鯨鬮籤隈熊艸嚔藾叢鏈腐鎖ξΞ茸菌楔草圀國邦国嗽漱吻劫腔φ刧粂熏皸醺桾皹勳裙崑燻訓勲葷君委钁企咥銜桑某冥眛峅昏暝鮓比闇位鞍藏暗倉廚厨涅〃ゝヾゞ々仝ヽ公曇雲蜘佝栗狂包胡俥梍枢畔鐵★玄黒来吼桍苦徠區吁暮久怐紅眩孔駒宮組呉瞿奇供区來鳩惧口工垢衢朽繰九玖汲絎劬枸窶煦懼句貢狗９庫嶇く埀謐Σσ蘂蕋蕊痺茵褥鵐蔀鷸鴫入責霑蔵嶌了縞嶋島凋搾澀澁渋縛暫屡柴荵凌鎬忍簧舖慕↓襪認从從．舌扱罔Θθ虐粃秕椎椣貎尿臠肉猪衣榻黙蜆恵楙誠茂成繁惻鋪陣頻閾櫁樒鹽汐潮隰瑟蟋櫛嫉隲疾蛭悉漆躾膝失室沒鎭沈滴雫賤鎮靜静顰尓爾聢乍然併□■◆◇倖幸貭叱征質柵卯滋撓品鬼鍜錏錣凝痼而拉設垂萎栞襞吝咳什導汁験徴著記印☆〇銀城報調蝨虱白濕湿七標僕笞楚霜臀退斥後尻寫柘卸砂冩者舍炙♯＃暹諜喋煮這西娑沙謝紗鯱奢赦洒捨鮭瀉釋蜥決炸蹟刳鑠妁斫勺抉爍皙昔芍酌爵折癪笏赤綽灼杓石尺赭写鷓積遮舎車射斜釈社娵麈娶蛛諏洙殳鬚侏繻銖戚倏肅菽蓿蹙叔俶淑夙粛宿縮殊珠趣卆恤蟀出繍溲遒讐洲綉駲讎楢逎酬楸穐鷲緝蹤岫萩甃泅螽葺售收驟舅囚姑蓚皺鞦銹脩輯醜習羞酋聚舟秀祝袖拾啾蒐収執衆愁就臭蹴週終褶州宗集秋椶棕朱撞種修周手酒首須雋濬皴蕣悛儁惷墫順蠢舜旬浚竣峻駿逡筍瞬俊岑臻寢槙脣娠譖鷆晉忱齔嗔袗怎蔘哂蓁矧譛鷏疹畛甄縉瀋箴軫榛秦襯診鉐津駸讖紳斟針唇呻蜃賑芯瞋振殿侵晨薪辰震宸森眞愼伸慎寝晋進審深親臣鍼申心宍信真新薯嶼杵苴處苜墅砠藷狙胥岨黍蜍渚曙背緒雎蔗庶処署所暑聲稍艢鷦橸劭厰舂將腫政嶂蛸錆枩廂懾韶峭邵奬炒慯筱摺鬆顳樅星鯖樵訟梢敞橡霎廠秤篠咲燮愴愀甞湫獎井囁觴鍬剿妝庠浹簫陞殤淞誚升璋醤青慫従逍倡竦爿薔笙樟装肖菖＜≦湘誦聳檣稱声裳蒋蕉嘯慴盛精清霄鈔粧鏘悚悄蕭彰哨瀟焦憔匠鍾償鞘瘴漿頌詔妾沼請唱薑庄渉障奨床牀娼椒宵聖抄荘傷性相生召銷賞猩症昭燒猖尚昌少憧晶祥紹承證笑焼将照招詳章消硝証掌商昇小屬謖寔觸稙軾昃矚稷拭嗇穡禝属燭贖囑嘱織蝕式喰蜀殖諸初触埴植食職賜閇阯仕咫仔駟伺摯之鷙染肆凍至嗤翅衰錙祉釶巳笶浸肢脂貲尸篩諡司四士蚩緊祗姉糸粢氏侈厶厮思贄嗜嘴弑熾〆滲若髭敷啻此師梔耆絲痣次誌刺知歯恃茨及舐沁緇諮獅駛試俟嗣趾志示止如咨砥識笥幟岐揣呰詞自弛漬梓指始矢卮姿紫匙芝詩史瓷廝輜使絞齎偲施時締旨屎巵資孜址只覗齒恣徙誣豕泗耜死觜妛茲祠枝占竢視市痴領祀雌強私沚謚し癢糜粥痒麹輕骨業軽鰈鰔餉通瓶龜甕亀鴈獵鳫殯 K 猟雁鳧鳬釀髢氈鴨側巛躱厠廁磧瓦獺翡為裘皮→紮〜搦苧碓柄軆體躰躯身体鴉犂烏絡空唐榧茅揀鐶寰稈丱厂鑵歡坎篏捍卷扞撼豢皖淦歛戡驩瞰盥杆勸讙羹蒄陷瀚啣繝拑嫻罕奐羮憾骭澗潤鸛澣康樌懽嫺莟酣觀橄涵渙堪覡巫鉋随萱簪舘艱咸翰柬駻悍燗槓浣邯稽攷宦考棺潅閂煥鉗疳癇凾函鹹桓款緘箝諫諌轗旱坩侃鰥　館莞橇韓患灌勧菅奸刊柑肝桿看緩寒干嵌廣広竿貫巻敢漢環間歓閑喊陥喚甘監寛管慣完汗乾艦幹官観壁椛屍姓庇鞄芳蔓千鯑一勘蜻⊃影蔭陰景＊梯棧筧庚辛柧門廉乞癩κ川Κ合《｝‘”〈’）“｛》〉囓柁悴鮖舵鰍梶錺餝飾篭籠孵卻歸皈還省顧楓槭却帰反返守督髮帋祇韮主裃雷髪紙鉦矩曲予鐘樺沫偏騙語潟刀象模仇固硬傍難容忝辱頑形方旁型肩風滓微翳幽掠綛纃絣緕擦糟鎹粕春蠍猾瞎戞轄剋蝎喝擔劼∧黠濶恰聒蛞餓鞨羯筈曷刮鬘蘰桂闊括嘗捷豁渇担滑松堅鰹功割戛活疽暈鵲瘡傘嵩重襲葛笠堵硴牆墻蠣蛎柿掲罹關抱踵嬶嚊拘関係貌顏郁薫顔母感窰釡罐鴎框叺喧竃竈窯缶釜蒲鎌數数槝栢膳傅畏賢橿姦樫炊爨喞圍託囲鈎『鉤「』」限鍵（傾禿蕪鏑頭齧被兜敵適哉必要称鼎彜彝鬲叶片哀愛悲鋺蛇鉄蜩神奏金楫裹磆餅徒褐糧粮幗槨壑∠膕寉狢咯覈膈貉茖擴蠖覺掴愨椁骼癨埆穫嚇隱殼霍礁恪擱匿撹攪喀廓較郭〕［【〔】］殻挌劃閣格隠覚矍革核鶴馘攫獲拡客隔角確枴醢喙价懈褂揩峡獪觧椢茴丐誨櫂誡畍匯夬廨械徊蠏隗迴恠囘嵬壞榿蛙瑰乖浬鰄傀糴柏街鳰懷蛔蠶蚕邂蟹潰壊恢腕芥垣楷會拐悔詼諧皆疥界魁偕改繪貝胛絵甲快灰槐晦懐介解回廻階塊戒開会怪海縢篝炬赫耀輝冠鑒鑑各屈鏡痂買墟淅刈蝌茄珂稼譁彼崋駈個狩懸咬價哥醸畫下支代描翔迦糅禾藉科勝訛課換涸譌闕賀苟萪花上掛蝦个軻踝馨貨枷箇呵家画霞伽訶缺罅書何佳価柯賈戈噛借禍菓香駆袈枯繋ヶ跏貸顆耶河嫁替遐夏架日嗅舁葭華蚊斯火易變苅渦謌夥驅和過飼歌鹿暇黴笳嚼假窩咼搗兼寡苛渮果嘉卦厦廈靴嘩賭掻且仮啝克嗄欠蝸化舸ヵ荷可堝かｃ・…塩閉倶錫呼∩取籐加交цЮФЩЪАмСнПЫЛИЗеохсДвщрМЯфжйКЭбШуХиаёЬЖэТРВшдГЙлъУпОьгкБзтюНЕыяЁ♪╂┼┿╋×●◎○銅∪χΧ子Чч株Ц珈，、色ク競衝構簡制≡変接カ└┓┗┐┏┛┘┌正コ℃¢セシ c]"
    "[共吃巴鑼錚鳥鶏響嫩緞丼呑曇貪鈍肭遠蚌溝隣鄰塢床処所年時鰌鯲鰍得徳讀獨髑毒読陶耨嫐橈藤桐働鐃通僮閙儂ゞ萄撓々恫瞳憧鬧≡⇔撞慟導〃仝洞堂瞠艟獰胴銅童動同道堵何融退戸度駑取奴呶弩努録怒孥留土止解ど瓰竕凸竍籵瓧禰泥捏溺寺棯沺鈿佃甸淀畋黏澱臀傳殿電照でヅ鶴辛強妻綱勤伝筒包做造作尽机月冢塚遣疲使釣連付積漬突図詰津吊づヂ中近力地痔持ぢ種棚倒彩濃逹畳諾濁゛玉默球魂騙谷点館舘嶽竹岳高蛸凧怛妲獺奪脱臺梯餒岱戴廼迺弟平内醍橙］［題＞≧第台代大鱈頼便誰樽懶怠椴灘斷黙旦煖彈暖談段断檀団團壇弾男唾騨澑垂懦儺駄拿出抱墮駝荼兌立雫堕橢惰田鴕妥柁朶舵陏炊蛇娜沱拏建溜打佗陀楕だｄ直◎．、，丶\.・‥…＄“”↓‡†—┤達°℃独ド÷◆◇ダジдΔデδ∂Д D]"
    "[瘧腮偉鰓衿撰襟鹽掾覃薗渕湲爰黶圜捐悁¥櫞蜒篶艷讌魘渊轅檐媛垣閼簷鳶鴛焉嫣宛閻衍臙閹槐⌒援筵淹厭寃淵掩烟嚥圓沿宴奄蜿煙袁艶焔炎怨鉛園苑偃冤延婉遠堰燕演塩円縁刔刳抉猿狗描択鰕箙蛯蝦貊狄胡戎夷乢靨咽噎粤鉞戉桟悦閲謁掖伯亦蜴懌繹奕越役驛疫易益腋駅液衡潁咏翳塋娃瑩殪瓔贏曵纓頴珱裔蠑營洩楹瀛睿泳縊榮暎瑛曳盈郢影詠穎嬰鋭叡映営栄永画會惠繪猥杖畫榎絵回衞選柄獲衣得荏懷慧恵枝餌会重囘衛笑依江え─━┯┬┳┰┸┴┻┷фФ＝≡⇔∈∋рРмМｅН→英∃式！ΗηСсЛлэЭエΕε e]"
    "[麓梺冬賁枌汾′濆吩刎氛雰糞褌忿墳吻紛焚扮分粉顫舊揮旧故震篩奮隹古衾襖贅燻筆鰒総總惣絃房閼鬱塞鞴章郁史艦簡札耽吭鰾笛文罧節苳蕗淦舩艙舷舟船肥太懷懐≦≠≧＞＜≪≫渊淵渕縁盖葢再弍蓋双藤鯊蒸潭鱶殕楓瘋封諷怫黻拂髴彿祓憤恚慍二払沸拒防愎蝠箙茯輹蔔腓⊇⊃脹膨嚢梟袋含⊆⊂袱覆輻腹幅復馥服副複福深觝觸怖触冨仆膚狂麸附生蹈腐普婦伏噴付老傅歩柎罘孵賻桴匐踏郛敷巫不負鯆風夫坿殖吹鮒榑經俛府臥咐経葺阜振孚父践俯拊腑賦蜉斑埠芙赴拭履溥麩符布俘畉趺舗降誣譜増鋪苻訃扶斧更芬呎飜翻ふｆ鉄♀∀¶富⌒金佛仏偽誤♭弗浮フΦ F Ффφ f]"
    "[頃殺米魂權諢艮勤権鮴好蓙応駒事若琴亊毎如鏝込埖塵氷声肥聲腰拵心戀恋国石獄敖濠嗷熬壕軣刧噛哈盒遨拷囂轟毫傲鼇郷劫≡号豪剛互蜈子牾呉茣後兒唔午后 5 児吾瑚極５超護伍宕齬娯忤晤珸期庫寤梧五越悟檎炬誤碁沍醐篌冴ご〓鬩屐隙郤戟檄闃鷁撃激劇貎霓麑倪皃黥囈猊迎鯨芸藝蘖囓齧監痃广芫彦呟愿軒舷眩源儼衒弦絃験諺言現限幻玄減原毛実拐夏解蹴偈觧睨下げ靴腐草種口薬糞癖胡萸茱串遇藕嵎宮寓隅偶黒栗蔵倉鞍位昏羣麕郡群軍苦周包車狂愚狗食禺惧具麌暮壷組倶虞颶壺弘ぐ衣君嫌裂際牛憖岑垠斤崟吟銀禦圄圉馭閠嶷魚玉漁翹嶢繞堯尭澆御痙曉蟯驍僥仰業暁凝行瘧謔虐逆議祇義擬宜木城着伎誼萓魏嶬僞技犠気艤切犧礒巍欺決祁戯妓斬蟻沂儀戲偽疑羲曦ぎ巛皮川革乾側通絡殻辛柄烏鴉嚴阮鳫巖貫厳偐頷嵒岸厂⊃贋龕強岩翫鴈丸雁玩癌元願眼巌含頑神紙髮髪上鐘金係皈歸肯帰返固方潟語刀難型形鰹歹垳顏顔釜蟇窯鎌蒲蟹傘重笠號垣樫頭月合齶諤鄂學斈樂壑鍔萼愕嶽咢鰐額岳顎楽学劾既愾礙磑崖乂葢剴漑涯盖垓睚崕亥啀艾駭皚該咳階孩碍芥害鎧街凱慨概蓋骸外画伽峨駕ケ変書換餓牙勝訛掛賀雅鵞呀狩蛾代畫刈買衙娥ヵ鵝訝峩俄芽哦果我莪駆貸ヶ借替臥河が≫＞ｇ瓦≧ガゴηΝΗΠδπΞχΑλΔσζτοφΤΣξΒψΡΩβΖΟυΥιαΘθεΨκΙΦμΧωΛΕΜρΚνギグГгΓゲγ g]"
    "[洞袰亡滅幌濠壕畚笨略艢檣焔炎仄朖朗塊程施滸幾殆缶熱解屠榾螢蛍骨細本＊※糒擅恣縦星桙戟戈綻祠誇埃矛鉾堀頬棒豐抔蔀泙弸棚朴皰舫堋膀勹枋峰峯袍鞄磅垉鴇褓篷呆怦麭苞葬琺寳炮鵬寶繃魴鋒髣逢朋烹鳳彗箒俸焙蓬烽幇抱崩訪泡澎彷縫捧萠萌彭包胞邦倣飽庖疱奉豊砲硼報宝攴攵蹼瀑樮北賞抛穗脯舖穂畝捕恍餔襃褒哺埔逋欲掘輔堡誉耄黼葡哮彫吼咆葆保浦譽惚ほ謙遜篦廰廳篇駢褊貶諞胼蝙翩變∂遍返騙編扁変暼丿諛諂隔凹臍巳蛇蔕蒂瓸竡粨闢甓癖躄璧劈碧壁餅坪竝幤嬖閇聘娉箆蔽塀病并陛屏炳瓶斃幣弊敝併閉並戸邊歴辺圧折舳減屁邉へ麓梺冬♭賁枌汾′濆吩氛雰糞褌忿墳吻紛焚扮分粉顫舊揮旧故震篩奮隹古衾襖贅燻鰒陰総總惣絃房閼鬱塞章郁艦簡補札耽吭鰾笛芬呎文罧節苳蕗淦舩艙舷舟船蒲懷懐≦≧＞≪≫渊淵渕縁盖葢弍蓋双 B 藤蒸潭鱶殕楓瘋封諷佛怫黻髴彿憤恚慍仏 F 弗沸φΦ拒防愎蝠箙茯輹蔔⊇⊃嚢梟袋含⊆⊂袱覆輻復馥副複福深觝觸怖触冨仆狂麸附富蹈腐普婦伏噴付傅歩柎罘孵賻桴匐踏郛敷巫不負鯆風夫坿殖吹鮒榑經俛府臥咐経葺阜振孚父践俯拊賦蜉埠芙赴拭溥麩符俘畉趺舗降誣譜増鋪苻訃扶斧更ふ鶸禀蘋彬嬪斌繽殯賓擯牝貧頻瀕稟品葫怯晝飜蒜蛭昼綬胙紐鰭∝片衡鮃閃鵯辟百媛姫仭尋太宥絋擴展仞拡拓拾祐恕紘泰煕熙裕啓洋寛弘宏浩廣広驫彪冰凭雹飃馮殍飆俵髟冫飄豹漂驃剽慓嫖兵憑票評標平表燧老捫拈撚捻歪籖籤柊魃旱秀跪膝蜩羆佗攣−低隙閑暇雛髯鬚髭¬蹄濳潛潜顰密窃鬻提匏瓢蠡瓠壽恒央廂尚寿久率蟆痙蟇丙丁女史孤獨独稘斉斎準均倫等≠單偏単他仁瞳人 1 １柆蔆拉柄杓犇◆◇菱醢醤曾蘖彦酷漬浸鶲額聖肱肘熈芒光膕控皹皸響罅僻鰉逼疋篳匹畢蹕柩棺弼櫃謐坤未羊筆必襞養饑＜（「【←『左灯鄙臂庇朏退彼卑皮疲秕裨梭斐魅妃砒丕陳轢髀暃否樋霏惹匪俾祕痞費氷肥飛檜碑悲毘蓖泌秘鞴挽桧贔避痺引蜚火妣比鞁日貔乾牽扉匕碾杼脾菲罷冷紕曳昜譬批披緋干轡豼狒索被ひ布鱧釖鉤蝟梁鍼磔針禳肚腑腸孕原拂祓払玄遼温請腹陽遙悠東遥治春頓捷鮠鶻駿疾囃林隼胖潘釆絆泛鈑蟠磐樊笵畔膰拌氾坂范凡燔楾洪瘢翻板攀゜大伴煩槃袢斑判範藩繙蕃版搬叛班阪般販犯汎帆頒反侍鯊櫨祝？硲間劇勵激烈励速蝿蠅飯省勢彈外筈弭辱逸毓育齦浮阻難掵憚幅巾柞母翅旌幟側旛圃将旙傍働鰰機叩疥畠籏幡畑旗斜鴿再鳩開秦跣膚肌裸弾薑椒壱哉一甫創弌馨壹元始鋼芳夾剪鋏螯挾挟脛萩餞贐離塙萼英蕚衄衂縹譚咄放噺話洟甚鼻華花觜迸枦赱奔艀婢梯燥箸柱走橋□筐箪匣凾繁方運匚筥箱函亳蘗魄佰狛珀膊愽璞柏栢粕陌岶擘箔舶泊搏迫帛拍圖諮企測秤謀量計図儚捗袴伯博墓癶釟髮秡溌肇廿二初椀蓮８♪鉢蜂發髪服半法白醗薄八発琲孛埴拜睥吠旆湃牌擺裴坏盃霈珮碚入沛榛杯悖—廢腓誹徘稗癈肺俳憊輩背鷂胚廃排拝敗灰配蛤濱浜刃刷派爆脹恥生佩破榮坡穿着禿羽耻碆簸慙跳刄菷爬食矧陂腫晴菠端栄杷琶跛歯垪捌頗馳嵌葉愧剥刎叭羞巴匍帚怕笆把映播覇霽吐霸帶貼這張齒撥葩果填芭掃暎膨玻履早はｈ─━┘┛┻┷┴┸┐┓┬┯┰┳┨┥┤┫┿┼╂╋波‐フ★☆非ヒホヘハ h]"
    "[Ηη賤卑鄙苟嫌弥薯妹芋藷夢艷鑪鈩彩鱗色鯆忽綺貸甍応答愈圦杁蚓茵霪婬飮蔭贇酳韵寅尹胤隱氤湮堙廴音飲慇韻咽淫殞姻隕院允殷隠陰窟巌巖頌祝鰛鰮鰯岩磐¥円鼾歪弋弑抱懐贅肬疣狗戌乾犬諱坐在未汝誡警戒縛今Εε曰禾稻員因蝗嘶鰍電引躄誘動忿≦鵤錨碇怒雷霹霆凧桴筏魚 S 菴庵彌雖家尿荊棘茨祈祷命猯豕古聿鎰乙鴪伍軼樹慈悼慯愴労格到至傷鼬頂戴病徒致鈑痛板柞砂沙些聊潔諍烈功諫勳勇勲漁諌憇＝憩粹熱粋憤域閾勢勤忙急磯孰焉湶泉厳何弄苛≧范鎔啀毬訝燻息挑絲縷厭營営愛稚幼緒遑暇糸弌壹肆莓苺櫟著市碑鐓礎甃臀弩石犧犠牲池溢 Y 佚壱 1 １粥毓鬻燠礇的戦戰軍郁幾育一稲否飯揖詑居維将洟挿容良行緯活矮渭慰逸往爲唯斐饐炒生凍頤出威胃矣姨要肄謂僞委云為五萎煎蔚鑄井恚位懿醫貽好以ゐ噫怡依畏違易熬莞斎鋳如夷移亥帷胆圍彝已彜淹痍猗尉椅逝鰄異熨囗善去忌倚惟癒偉堰遺偽医射幃鮪率可韋意痿猪衣逶囲李言詒彙苡い氷йЙ→⇒⊂⊃▼▽伊ｉ印入∞吋∈∋∬∫∩ＩイиИ私ιΙ I]"
    "[塩縞嶋嶌島橲衄竺宍衂舳忸軸舌喰食直凝實昵実印尻贐潯糂盡仭進稔刄臣恁仞儘侭訊俥蕁迅刃靱荏甚靭燼櫁樒塵尽尋陣腎壬人洳杼莇蜍敍汝恕茹耡敘舒縟辱褥蓐溽所抒鋤徐絮叙序助嬲聶星絛茸孃瀞仍乘躡拯讓仗疉滌帖繩遶諚疊塲靜淨繞疂蕘壌釀驤穰禳襄壤生蟐如剩娘嬢錠静醸縄女尉饒丈成烝嫋穣擾丞盛杖場條条蒸貞状攘剰畳冗定浄乗情城上常譲愀鷲嬬得戍竪咒就讐懦讎濡聚詢凖隼盾筍徇笋楯篤蓴惇淳洵閏恂諄馴旬荀潤醇巡循遵順准殉純準襦誦需戌朮孰宿塾珠熟恤術述呪孺豎儒綬樹受授壽澁廿糅縱澀从鞣從狃揉戎拾中蹂神汁獸絨縦渋柔什充十従獣住銃重膩時侍孳兒二珥只冶餌邇茲怩死持子祀蒔嗣痔辞辭畤轜寺示亊弍自瓷史岻児以焦塒峙事敷路爾次慈寿滋粫耳知恃仕似至尓爺染字地磁除而柱仁士司璽迩醤鮭着鉐尺惹搦雀寂若弱麝闍蛇邪戯者じｊ┃│┝├┣┠┌┏．еЕ治яЯ日ЮюёЁЙйジ j]"
    "[怖旃之惟怺薦米暦轉殺鯤坤鶤艮袞琿悃壼很狠漿棍魂菎滾梱溷痕渾墾恨懇根梢杪王泥裔樸鞐熟枹醴聲声蛩凍溢零錯苔亊箏判斷諺理断盡尽悉辞詞殊事壽寿鯒礫鯉齣狛腓昆瘤鮗谺応應答茲是爰試志心凩笏惚兀榾輿甑腰拵拗鏝鐺浤惶伉犒哮鮫湟鎬蛤狎慌槹礦扛扣搆椌閧絖哽淆闔閤鴿鏗肴仰匣覯餃杲遘呷窖肓湊藁敲幌皐倥猴紘衝訌缸昊縞詬凰靠遑簧袷羔洸徨岡峺寇冓困亘棡亙鵁壙鍠鱇晄誥洽啌耗吭峇釦傚昿稾肱隍頏磽昴絋倖逅冦砿鬨糠矼黌爻塙盍崗汞胱恆畊蚣熕嫦皋紺鈩絳閘蒙氷冰郡蛟槁候楮媾溘蝗酵嚆犢稿亢哄睾慷郊岬肛項巷鑛洪佼狡叩昂勾喉晃滉剛糀晧曠宏控恍侯耿膏坑港皓皎江絞膠虹巧鴻鉱衡浩厚耕幸弘綱抗購攻講恒薨溝鋼航行肯荒皇光高好谷轂哭釛斛梏尅槲石告酷穀呱痩壷子懲鴣詁凝沽混觚箍兒餬雇錮漉蠱児蝴葫壺跨捏滸皷女超請瑚漕怙倒罟小糊濾粉辜菰股琥乕痼瞽鈷濃此越扈瓠胯誇估凅呼肥焦孤弧夸蛄踰転湖故込恋古虍娘戸粐袴楜冴媚冱仔鼓放乎滬戀虎こ峻欅獸娟愆瞼搴騫愃惓涓權俔蜷鵑黔甄椦縣儉檢妍綣圈獻幵劔險謇劒顯虔暄劵臉鉉諠剱慊釼歉験慳捲倦遣羂嶮蹇鹸狷譴腱軒驗憲繭謙圏険硯倹献犬絢顕券劍剣見権研眷拳牽県建烟鑷言獣蓋涜吝削畩閲検貶健桁嗾抉歇獗尻厥碣偈蕨杰頡刔訐譎竭亅襭訣孑頁纈蹶桀穴傑結血挈挂夐醯匸盻煢瓊詣鮭冂絅憬綮畦冏剄檠勍奚迥枅笄蹊徑憇兮攜黥彑逕繼惠慧謦鷄系┥┳┯┤┣┨┓┿─┸┫╋├┼┷━│┏┰┃┛┻┝┬╂┠┴罫痙奎脛谿溪螢蛍渓閨憩圭携硅恵刑継勁珪計啓褻蹴毛異け姑配栩椡橡櫪椪檪椚湫箜櫟含纐柵婚屎糞癖潛潜鵠凹窪縊跟頚軛珞頸首諄鞋窟履轡覆沓碎砕条降件頽崩屑釘莖茎陸杙杭掘崛倔鶏鐃藥擽薬樟楠梳櫛串釧與与挫籖鯀鯨籤隈熊艸嚔藾叢鏈腐鎖種ξΞ臭楔草圀國邦国髭嗽漱吻嘴脣唇梔腔φ粂熏皸醺桾皹勳裙崑燻訓勲葷詳精委钁鍬咥銜桑某冥眛峅昏罔暝鮓比闇位鞍藏暗倉廚厨涅曇蜘佝栗包俥車梍枢畔鐵玄蔵黒吼桍苦區吁暮喰刳焼怐紅眩孔駒組呉瞿倶区惧口工垢衢繰酌絎劬枸窶煦懼句貢狗庫食嶇く段痍疵絆紲傷築鱚嚴稷黍帛後碪砧絹兆萌刻鞫椈掬辟君牙蘗檗訖迄狐屹詰佶拮吃鞠橘菊喫＜＞°∽▲◎≪≫≡↑∴＋≠｜△♯／−〓♂＿″∨¶▽〆：〒＠ゞ％≒∫○‖‡¢∞！‾ヽ§↓；—≧＝＼℃£゜□†・◇＆．ゝ±●。∝☆゛ー≦Å←〇＄′〃◆＃｀，÷Ц‥♭…´ヾ■仝々♀、★‐‰▼¬♪¥⌒∵¨？＾煙蚶更衣細后妃楸蕈茸乙雉轢杵軋岸桔穢汚北樵際裂燦煌雲嫌胆竏粁瓩浄潔澄淳清雰錐蛬吉霧檮桐忻饉箘噤襟鈞釿瑾磬听箟釁懃衾芹覲衿掀檎斤蒟径窘擒巾菌公禽筋錦僅欣琴均禁謹緊欽近勤踞嘘舉據筥渠苣擧秬鉅慶倨距歔遽鋸醵拠拒去洫亟蕀勗跼旭局挙許居巨虚洶竅羌頃炯竸梗繦轎蕎刧况峽竟鍄卿誑狹恟筴廾荊抂棘經烱陜徼姜襁恊況亰僵劫筺篋孝亨跫敬筐梟饗矯矜挾挟校拱嬌鞏響杏向興匈嚮享警競喬怯兄彊僑兢供莢狂橋驕兇凶郷叫侠匡狭夾恐経疆協境胸強驚脅共恭今教玖笈疚赳鬮摎扱歙蚯恷樛皀９貅舊逑邱烋岌厳胡翕朽泣穹糾糺及躬汲臼窮灸弓宮久柩究給丘求鳩級球休救旧急吸九著癸尋窺羇祺綺虧嬉机耆聴聞祈剞切麒喜規欷冀效譏訊馗麾曁効幾器跂圻期鬼匱唏气瞶憙木寄飢城櫃揆愾稘着既竒伎旡記肌氣禧危希諱驥軌熈屓剪跪噐生覬截暉喟畸碁碕倚燬利忌稀其季幃毅起鑽消嵜淇僖槻逵棋來姫酒基棊覊熹箕鰭奇棄欹企毀崎餽熙晞祁决羈聽樹饋徽徠騏朞伐黄揮妓煕来汽几斬己弃杞卉猗詭岐紀貴饑騎決極愧掎畿悸き癢糜粥痒麹輕骨業軽鰈鰔餉通瓶龜甕亀鴈獵鳫殯猟雁鳧鳬釀髢鴨側巛躱厠廁磧瓦獺翡裘皮→紮搦苧碓柄枳軆體躰躯体鴉犂烏機絡空唐榧茅揀鐶寰稈丱厂鑵歡坎篏捍卷扞撼豢皖淦歛戡驩瞰盥杆勸讙羹蒄陷瀚啣繝拑嫻罕奐羮憾骭澗潤鸛澣康樌懽嫺莟酣觀橄涵渙凵堪覡巫鉋萱簪舘艱咸翰柬駻悍燗槓浣邯稽攷宦考棺潅閂煥鉗疳癇凾函鹹顴桓款緘箝諫諌轗旱坩侃鰥　館莞橇韓患灌勧菅奸簡刊柑肝桿看緩寒干嵌廣広竿貫巻敢漢環間歓閑喊陥喚甘監寛管慣完乾艦幹官観壁椛屍姓庇鞄芳蔓鯑一勘⊃影蔭陰景＊梯棧筧庚辛柧┐┌┘門廉脚乞癩∪川合《｝‘”〈’）“｛》〉囓柁旗悴鮖舵鰍鍛梶錺餝飾篭籠孵卻歸皈還省顧楓却帰反返守督髮帋祇韮裃雷髪紙鉦矩曲予鐘樺沫偏騙語潟刀象模仇固硬傍難容忝辱頑形方旁型肩風滓微翳幽掠綛纃絣緕擦糟鎹粕蠍猾∩瞎戞轄剋蝎喝擔劼∧黠濶恰聒蛞餓鞨羯筈曷刮鬘蘰桂闊括嘗捷豁渇担滑堅鰹割戛活疽暈鵲瘡傘嵩重襲葛笠堵硴牆墻蠣蛎柿掲罹關抱踵嬶嚊拘関係貌顏郁薫顔母感窰釡罐鴎框叺構喧竃竈缶釜蒲鎌數数槝栢膳傅瑕畏賢橿姦樫炊爨喞圍託囲鈎『鉤「』」限鍵傾禿蕪鏑頭齧気被兜敵適哉必要鼎彜彝鬲叶片哀愛悲鋺蛇鉄蜩神奏楫裹磆餅徒褐糧粮幗槨壑∠膕寉狢咯覈膈貉茖擴蠖覺掴愨椁骼癨埆穫嚇隱殼霍礁恪擱匿撹攪喀廓較郭〕［【〔】］殻挌劃閣格隠覚矍革核鶴馘攫獲拡客隔角確枴醢喙价懈褂揩峡獪觧椢茴丐誨櫂誡畍匯夬廨械徊蠏隗迴恠囘嵬壞榿蛙瑰乖浬鰄傀糴柏街鳰懷蛔蠶蚕邂蟹潰壊恢腕芥垣楷會拐悔詼諧契皆疥界魁偕改繪貝胛絵甲快灰槐晦懐介解回廻階塊戒開会怪海縢篝炬赫耀輝冠鑒鑑各屈鏡痂買墟淅刈蝌茄珂稼譁彼崋駈個狩懸咬價哥醸畫下支代描翔迦糅禾藉科勝訛課換涸譌闕賀苟萪花上掛蝦个軻踝馨貨枷箇呵家画霞伽訶缺罅書何佳変価柯賈戈噛借禍菓香駆袈枯繋ヶ跏貸顆耶河嫁替遐夏架日嗅舁葭華蚊斯交火易變苅渦謌夥驅和過飼歌鹿暇黴笳嚼假窩咼搗兼寡苛渮果嘉卦厦廈靴嘩珈賭掻且仮啝克嗄欠蝸化加舸ヵ荷可堝かｋ京節└┗※хХ忽コ汗〜功（株 K ク×金窯キκкΚΧケカχК K]"
    "[ォぉェぇゥぅィぃァぁ＜≪ｌ‾＿≦李左←⊃∨∃¬∀ル∧レラΛЛ£лλ l]"
    "[脆醪師諸催靄舫腿銛杜森聞捫匁紋問玩翫擡齎靠凭鴃鵙縺悶樅籾椛楓蛻潛濳艾潜殯黐餠用糯餅桃者懶專専物尤勿畚旧悖戻下故許乖求礎素基本元綟捩文默沐杢黙网罔耗莽芒檬耄朦魍艨濛矇曚亡蒙毛孟猛網模持喪望洩糢楙姆揉以漏保藻貰若燃摸裳母茂も麪眄緜緬麺門棉綿面蓍珎珍♀娶貭粧妾牝瞽盲娚暈繞萌慈惠恵萠暝謎滅溟姪瞑盟酩銘鳴奴睨賞碼瑪女芽雌減召め羣榁室簇屯邨連邑叢村紫梅葎宜憤葮槿毳椋酬報尨躯骸旨難睦酷麥麦邀対百迎昔空虚鞅宗棟胸掬娘結笞鞭徒蠧蝕蠹蟲莚寧筵蓆席虫毟貉狢豸貪壻聟婿六毋鵡夢務咽剥无謀無噎群霧梦矛蒸武向牟む渠霙溝妊澪薨岑嶺峯峰亂紊淫婬妄濫猥乱■◇※＊簔穣簑蓑儖醜慘短惨幹研耳壥廛店操陵鶚岬崎巫尊詔敕勅＞」砌頻汀→】』右翠碧緑認幣蹊径倫導途通路道瞠髻鬟湖自蹼蛟瑞癸禊晦漲源鏖港湊南瞶謐櫁水調貢密甕帝蜜覩幸脉脈韭韮竓粍瓱榠螟茗名妙命冥都宮閔罠皆眠明民味箕看充観觀視美御身彌己靡盈實稔三魅診深巳壬弥み毬鞠紕蝮麿転稀賓客檀繭黛眉巡囘周防衞衛護守荳菽豆槫°゜◯圓。・．（）丸鬘謾幡縵鰻懣幔蹣蔓瞞卍饅漫滿慢迄笆貧幻瞼蔟疎眩廻回申設儲招繚統纒的蟶孫弯彎籬擬免猿亮純信実委罷侭圸壗飯儘継随髷任芻蒭耙紛鮪猯見塗學斈眦眥眼俎愛学斑斗枡鱒升舛桝萬蠱呪薪槙槇牧惑悗窗円窓甼襠区街町前複亦俣叉跨全瞬木胯股又鍖枕膜幕詣妹瑁參参眛哩迷枚米賄賂埋昧邁毎秣奉枩抹沫靺祀纏祭睫末秀大太勝柾弄優成盛將松匡鉞賢誠征希将昌政雅正仁間茉在増馬墹枉先混蒔痲俟散万雑交嘛満待摩播魔捲巻未坐負舞益目媽撒敗磨放麼真曲眞卷まｍ光月♭♪♯ム∇∽⇔≪≫∧√∂≡∴≠∈∨⊂Δ≒⊃∫∞×≧∋±∝⊆≦∪∩⊇∠÷⊥∬∃∀¬∵⌒⇒♂曼麻●〇◎○モ〒′−マ最ミメΜμМ M]"
    "[ンん麕咒燧烽詛呪孔弼雅朔伯悳教糊宜典範矩哲紀規憲修亘允惟攵展順暢信則法後罵咽吭喉鑿蚤々湾宣曰覘臨稀望覗殘遺残鋸芒禾騰幟昇登上簷檐軒遁逸衲皇碯曩瑙王腦嚢膿能脳農嚥飲伸乗乘飮熨廼野陳除之退−呑埜延載述濃の塒姉檸侫聹嚀濘寧佞鼡鼠拗猫嫉妬希願捏熱労犒葱狙閨睡棔眠棯然稔懇拈撚燃念年袮禰煉捩捻音錬嶺涅値練根粘寝祢子寢ね絖饅垈帛幣鵺主蛻拭温布沼偸盜窃盗抽擢緯糠額抜怒貫縫奴塗脱濡拔ぬ楡蒻潦鷄鶏瀑庭繞獰女尿眈韭薤睨韮姙儿刄蒜葫刃忍∀妊認任人乳擔蜷担濁賑握俄鳰臭匂錵沸贄偐僞贋偽柔靤如苦膠霓滲虹躙廿《》◎∬『』悪憎兄螺鰊鯡錦西入新肉‖貮仁煮貳迩丹似弐 2 邇尼荷二２弍児岻逃迯に靡抔嫐嬲鯆屶釶鉈泥薺詰若慨歎嘆抛擲撲毆殴慰治癒等猶直泪波辺邊邉鍋浪某棘棗懷懐夏擦梨情譌懶艶訛鉛鯰癜鮠鱠膾韲憖怠鈍腥捺准擬凖準謎涙洋宥傾灘詠霖眺痼存乍流轅永和椥梛渚長勿莫毋半・媒仲中７斜七蔑乃尚内繩畷縄苗滑鞣惱悩哉就也斉形業徳娚垂喃∵楠尓爾汝男軟難何双柞枹列均倣肄⊃→⇒楢習納啾做娜熟那慣鳴南奈狎綯痿無茄嘗失並馴啼撫生泣嚶爲菜薙舐拿凪亡哭萎涕投為魚儺竝な┘┛┃│┨┥┤┫┝┠├┣╋┿┼╂成＃∋∇名└┗ｎ日≒ニネ〜¬≠ナヌノнΝνН N]"
    "[俺游泳指妖畢在澱檻氈拇親愚疎颪卸念錘惟慮赴徐趣俤羈主想表重面園隱瘟Å怨♀妾温恩鈍悍臣覺溺朦朧思覚榲現朮桶威嚇踴戯縅棘愕駭驚躍踊傲奢驕嚴厳遣痴瘧怒行怠蒹補荻懼獺惧怐虞畏恐襲甥笈及綬葹〃ゝ仝ヽヾゞ々同唖繦襁鴛鴦教几忍筬收兎抑稚長幼理治収修檍遲納後遅賻饋諡贈送憶袵臆拜拝奇峻阜冒犯岳陵崗侵女陸丘岡欄斧自己各戦鬼衰劣囮頤訪貶乙漢♂音弟阿脅怯首夥誘屋膃億穩穏煽熈煕燠熾諚掟興隠沖墺蓊悒殃泱姶毆瓮嚶翁罌枉徃閘浤惶襖鴬凰泓奧秧澳鸚懊嫗媼鴎怏鏖謳旺凹櫻鴨欒楝樗殴朷甌汪横往鞅歐嘔陥陷遠蔽夛奄應果掩蓋応概欧公邑麋薤被仰扇皇狼弁鴻鳳鵬黄奥多衽覆粱凡鰲頁王降於置押尾帶汚起追捺塢朗惜御小麻織措夫緒苧折男勇帯負央老桜嗚推圧穂墮牡淤悪生郎壓墜下終乎落擱雄堕怖唹逐居将おｏ大◎∞和∝♪∨∪開Οオω○ОοоΩ O]"
    "[本磅椪砲烹方法報歩舖舗ぽ蔽併閉閇×邊辺篇片邉編遍屁ぺ服幅風分腐布符泌匹俵憑票品筒平日犯搬版板幇払腹発發走箱朴愽拍博駮泊包放敗配牌杯盃八破羽波張播ぱｐ鉛ψΨぴ±＋ぷφΦ┣├∝北┴‰．％£〒・点プポ頁）（∂¶‖ペパПпπΠ燐ピ p]"
    "[配栩椡椢橡櫪椪檪椚湫櫟含纐柵婚屎糞癖潛潜鵠裹凹窪馘括縊跟踵頚軛珞頸首諄鞋窟履寛狐轡覆靴沓碎砕管条降件頽崩屑葛釘莖茎陸杙株杭掘崛倔鶏鐃藥擽薬樟楠酒髪梳櫛串釧與与挫籖鯀鯨鬮籤隈熊艸嚔藾叢鏈腐鎖種ξΞ臭日茸菌楔草圀國邦国髭嗽漱吻嘴喙脣唇蛇梔劫腔φ刧　空粂熏皸醺桾皹勳裙下薫燻訓勲葷君詳精委钁企鍬加咥銜桑塊某晦冥眛競峅昏罔暝鮓比較闇位鞍藏暗倉廚厨涅〃ゝヾゞ々仝ヽ曇雲蜘栗狂包俥車廓曲郭梍枢踝畔鉄鐵★●■玄蔵黒悔来吼駆桍苦徠功驅區吁暮喰刳久焼怐紅眩孔駒宮組呉瞿奇供倶区來鳩惧駈口工垢衢朽拘矩繰九玖酌汲絎劬枸窶煦懼句貢狗柧９躯鉤庫屈食嶇くｑ‘”’“♪ケ？ク¶ q]"
    "[堽侖崙崘栄論漉祿轆碌肋勒麓禄鹿６録瑯蘢榔薐鑞瓏僂實螻潦焜樓勞臈滝簍朖螂琅弄柆槞哢咾隴朧壟撈臘郎瘻廊牢浪蝋癆聾篭楼籠狼漏朗枦髏輅櫓艪蘆顱櫚艫櫨臚廬炉轤驢瀘爐鷺蕗滷賂鹵ろ洌糲〇蛎苓綟澪囹犁儷砺齡蛉鴒齢蠡唳聆勵黎羚戻禮祈隸茘隷麗玲伶癘励零冷例冽劣烈裂列靂轣鬲癧櫪檪瀝礫轢歴縺鏈濂鎌瀲奩斂嗹匳漣戀輦簾櫺∧聨憐恋蓮煉錬攣練聯廉連れ♪路盧泪縲壘瘰誄涙羸塁累類婁縷陋鏤璢褸屡る犂篥葎率慄栗淕勠六戮陸律擽畧暦掠略畄瘤瀏鏐旒霤瑠餾窿鉚苙嶐澑嚠笠榴溜硫琉留立柳粒劉隆流棆藺廩醂麟鄰痳菻鈴懍 P 躪躙淪厘凜霖琳悋綸淋禀稟凛鱗倫吝隣林燐臨梠絽侶踉膂虜呂慮仂力緑鐐暸繆楞魎嶺崚輌怜粱凉椋鷯靈獵鬣裲倆粮兩廖蓼輛燎瞭聊陵令梁糧諒霊遼龍凌漁亮寮涼⇔繚撩綾療竜量菱僚領喨了寥稜両料閭旅李理莅履痢利釐哩裏詈驪漓浬梨俐籬里罹璃吏離俚裡莉悧りΛλ婪襴覧亂臠覽儖欖攬瀾嬾籃繿纜巒檻欒襤懶爛藍鸞卵濫闌嵐欄乱蘭労溂剌老埓埒猟辣薤喇樂珞絡犖駱酪烙楽落洛徠罍擂蕾賚醴耒籟儡櫑莱磊癩來礼雷頼来拉裸良等們騾蘿鑼邏螺らｒ右→УпгОьЙлГъВдшЦэЖЬТЁяЕыютзчНкБЗИхоеСнмЛПЫЪЩЧ露АцФЮХуШёаифЯЭбКжй魯МсщвД輪√根羅ロ々ラルレリрΡРρ r]"
    "[似杣灌傍峙毓育具供備害底苑薗園酘貮儲妬埆埣譏讒詆誹謗濡外猝率喞熄仄息足促束測側薮歃掫甑髞湊嫂窗弉鯵帚槽赱叟笊滝嗾裝葱壯搶譟蚤嗽懆筝燥剏崢贈瀧澡竃愡爭樔勦瘡屮雙蔟艚奘菷諍箒竈抓梍艘偬輳箱孀窓踪匝噪遭艙爪糟莊倉匆怱曹淙繰宋漕簇槍躁鎗箏綜痩喪藻艸葬壮操掻掃奏蹌滄争草層創蒼叢僧走惣送叛乖抑諳某轌橇艝巽拵邨鱒噂忖蹲樽孫遜存尊損反詛疏踈徂逸噌鼡麁祖副咀阻胙愬粗俎齟爼沿甦鼠訴礎措租祚想塑蔬其蘓姐囎組疽沮疎酥そ芹鬩鐫揃喘燹韆綫栫痊巛槫涎吮僣潛筌纖舛專簽刋倩舩旃槧苫亘沾饌湶濳仟阡箭籤茜荐筅錢擶纎磚孱翦濺氈甎僊癬蟾籖銛孅牋羶箋贍殲殱闡釧賎餞羨顫甅竰糎¢陝銓踐閃潺遷銑栴川剪煽譫僉瞻践栓跣疝詮銭穿戰繊僭腺泉嬋淺擅鮮専潜扇浅船蘚線撰宣洗煎戦千忙倅伜逼蝉旋緤泄絏屑椄卩洩紲薛攝鱈褻浙竊℃窃拙摂接節楔淅籍瘠迹蹐蹠藉威績裼蓆跖磧晢關勣晰跡夕鶺潟碩惜析関隻席萋菁躋嘶撕擠婿睛韲牲甥貰晟情穽筬齏瀞淒掣腥逝惺旌蜻整靖誓制晴畝攻勢丗畆急世競脊堰糶瀬せ鯣鋭坐座李已既昴術辷全滑皇脛臑裾双英村選優営寸啌雪勸濯漱薦啜勧芒薄煤賺鼈捩筋頗輔甫丞佑亮祐介助蘇裔陶曽曾乃即則淳漁凉鑾篶漫硯雀涼鱸鮓鮨遊椙犂耒犁篦隙尽末眇縋管菅廢頽廃窘救掬寡尠粭糘菫速純鈴炭角墨隅【】陬鄒菘雛數芻嵩崇趨樞±≫∫∧×∝∃∞∂∬∇÷≒⇔≪Δ∨≧∠⌒∩∵∋⇒∴¬∀∈≠枢錘隹捶悴榱萃粹騅陲瘁翆邃忰帥誰醉遂膵燧彗綏錐穂炊翠⊥ H 吹粋推水酔睡過掏剥籔醋喫好壽澂直漉棄空拗擂簾住巣栖饐耡鋤梳棲吸総透總剃寿統据磨澄埀謐蘂蕋蕊痺茵褥鵐蔀鷸鴫入霑蔵嶌縞嶋島凋澀沫澁渋縛暫屡荵凌鎬忍簧舖慕↓襪健認从啝從随．舌扱罔Θθ虐粃秕椎椣卓貎尿臠肉猪榻黙蜆楙誠茂成繁重惻鋪陣頻閾櫁樒鹽汐潮隰瑟蟋櫛嫉隲疾蛭漆躾膝失室沒鎭沈滴雫賤鎮靜顰尓爾確聢併◆◇鹿貭叱征質卯滋撓科品鬼鍜錏錣凝痼而拉設萎栞襞吝咳爲什導怪汁験徴著記印〇○』銀城代『報調蝨濕湿七僕笞楚霜臀退斥尻寫柘卸冩者舍炙暹諜喋煮這謝鯱奢赦捨瀉釋蜥決蹟刳嚼鑠妁斫勺抉爍皙昔芍酌爵折癪笏赤綽灼石尺借赭写鷓積舎車斜釈社娵麈娶株蛛諏洙殳鬚侏繻銖卒粥戚槭倏肅菽蓿蹙叔俶淑夙粛縮取殊珠趣卆恤蟀出繍溲遒讐洲綉駲讎楢逎酬楸穐鷲緝蹤岫萩甃嗅泅楫螽葺售鰍收驟舅囚姑蓚鞦脩輯醜習羞酋聚舟秀祝袖拾啾蒐収執衆愁襲就臭蹴週終褶州宗椶棕守朱撞種修周手首狩須雋皴蕣悛儁惷墫順蠢舜旬竣峻駿逡春筍瞬俊岑臻寢槙脣娠譖鷆晉忱齔嗔袗怎簪蔘哂蓁矧譛鷏疹畛甄縉瀋箴軫榛秦襯診鉐津駸讖紳斟針唇呻蜃賑芯瞋振殿侵辛晨薪辰震宸森眞愼伸慎寝晋身進審深親臣鍼心宍信神薯嶼杵苴處苜墅且砠藷狙胥岨黍蜍渚曙背塩緒枌雎蔗庶処所書暑聲稍艢鷦橸劭礁厰舂將腫政嶂蛸枩廂懾嘗韶峭邵奬炒慯筱摺鬆顳樅星樵訟梢敞橡霎廠秤燮愴愀姓甞湫獎井觴鍬剿妝餉庠浹簫陞殤淞誚升璋醤慫従逍倡竦爿墻牆薔笙樟装肖菖＜≦湘誦聳檣稱声裳（）蒋蕉嘯慴精霄鈔粧鏘悚悄蕭彰哨瀟焦憔匠鍾償瘴漿頌詔妾沼請衝唱薑庄渉奨床牀娼椒鉦宵抄荘翔傷踵召銷賞猩症昭燒猖尚昌少憧松晶紹捷象承正證笑勝称焼将照招詳章消鐘硝証掌省商昇屬謖寔餝稙軾昃矚稷拭嗇穡禝属燭贖色飾囑嘱織蝕式喰蜀殖諸初埴植食職賜閇柿阯咫仔駟伺摯之鷙染肆祇凍至嗤翅錙祉釶巳笶浸紙肢脂貲尸篩諡司四蚩緊祗姉糸粢氏侈厶厮思贄閉嘴帋弑屍為熾滲若髭敷啻此師梔耆絲痣次誌歯恃茨及舐沁緇諮獅駛飼試俟嗣趾志示如咨砥識笥斯滓幟岐揣呰詞自弛漬梓始矢卮姿紫芝詩史瓷廝輜使絞齎施時締旨屎巵資孜址只覗齒恣徙誣豕泗耜死觜妛茲祠枝占竢視市痴領子祀雌強沚謚し杓雨寤鮫清鞘莢騷觸触鰆椹爽騒澤沢濬掠新攫渫浚杷更士桾申素白嶄纉餐粲汕蠶跚衫讚慘驂攅鑚芟爨斬蒜潸戔彡杉秋桑…≡簒纂鯢燦珊繖棧刪卅參鑽蚕算傘３▽贊▼ 3 参賛 O 散惨産酸嘸摩遉樣彷碍妨様山漣貶蔑垂鮭叫仙寞寥皺鏥淋生鯆虱鯖捌偖扨偵宿禎貞定哘誘蝎蠍授皿祥桟匙簓障囁私篠支捧笹逧迫讃鐸蛹宛真碕尖嵜前崎魁峺遮哢囀候侍核実俚説暁了逹達聰敏諭慧叡訓哲知郷悟智聡恵理杆里小棹竿扎紮箚刹皐撮搜寒捜相主盛柧觚盞盃杯榮栄倒肴魚阪界堺境酒泝逆賢坂榊猿麾挟鷺拶撒擦颯先数察薩刷札摧崔釵腮悽凄切責淬縡纔衰綵晒霽砦樶寨洒靫顋濟殺灑碎偲犲哉倖豺呵苛幸猜塞蔡栽儕采財齊臍截孥載宰済齋犀際災柴賽菜砕採債妻斉祭斎催才細鰓裁歳最埼槊筰筴柞齪縒捉册咋辟簀窄酢嘖朔柵遡溯鑿索搾昨炸冊策錯櫻桜削詐曝插査寂避嵯瑣止狹做渣再沙蓑嵳注娑去柤早射捺醒瑳扠冷槎嗄佐挫咲砂些左紗搓作褪莎簑銹錆覚挿割茶冱覺差磋梭冴提下裟点狭唆嗟刺叉裂鎖然螫蹉荒乍さ√錫す／仕指製西　┐┓〆□■Шш上♯＃щЩ添∪日ｓ⊂⊆⊃⊇文静＊★☆標嗜青三聖土彩▲△悉署〜∽‘’┌┏集＼探§″性セサシソスс秒ΣσС S]"
    "[乕囚寅虎瀞舮靹侶供纜燭艫朋倶鞆讐讎輩伴共友巴飩沌惇丼団暾團遯燉遁豚禽鷄酉砦塞俘擒虜豐恍惚枢乏塒迚科咎篷笘攴苫鶏伽唱稱鄰隣朿棘刺整鎖處処所床享鵄鴟扉鳶嫁訥晨刻穐秋鴇鬨斎頓幄幃帷柮杤栃閼軣轟屆届咄吶凸駿暁祀世壽繁稔寿豊歳俊利敏年悳慝黷牘犢匿督徳涜∃得特萄盪夲沓鬥儻檮陦帑滕蘯酘吋稻兜叨櫂亠棹嶝縢竇篤淌樋涛礑擣鞳桶朸荅閙讀罩磴纛棠剳納鐙溏搨迯宕抖諮籘榻梼嶋潼鬧嶌道釖塘盜橦档黨綯鞜逗螳蟷稲■幢滔鼕掏當峠読饕疼淘濤籐董悼棟搭痘套＝燈豆桃韜統遠騰橈冬討骰祷藤灯島橙凍刀陶糖謄唐答投等桐泊解秉留砥止畄蠹録図礪鎔肚蚪獲賭十渡妬菟人外莵翔閇疾問富荼執屠砿研採途取冨梳鍍覩觧戸砺熔兎睹溶蠧登杜穫塗融説飛跿脱圖摂堵盗汢磨兔と瑛晃輝衒寺鷆諂腆壥碾殄、槙，躔鷏廛囀巓忝靦沾霑轉：‥．輾填甜奠顛纒癲恬殿纏覘展篆添梃輦輟姪垤銕咥耋屮餮鐡跌迭荻鏑狄廸笛俶糴逖覿擲迪滴轍的哲敵撤剔徹鐵鉄嚏楴酲騁鵜酊叮碵嚔柢睇眤詆棣羝掟遉觝汀釘幀渟弟碇剃蹄邸締梯悌訂程底偵廷遞逓牴抵呈艇鄭涕啼庭定低弖照て模幹劈聾辛列貫面液汁露冷舶錘紡系艷艶鉉寉絃橡劔劍剱釼劒剣弦蔓敦鶴幣兵鉗噤鶫償恆桓典恒常夙勉務努勤拙拐抓倹嬬撮詳審爪褄妻募角晦瞑螺円呟礫具粒辻辟罪把捉捕閊寮丘阜首曹元司官柄仕掴遣攫搏疲使窄蕾莟局壷壺坪綱繋壌蝪培霾戊己伝傳鐔翼翅鍔燕唾續約皷鼓続葛綴番栂槌縋弊費序潰終墜遂鎚椎追殲捏殱做繕傍旁創造作熟机佃蹲坏拒欟鴾槻月障砲裹躑榴謹慎筒恙愼包堤痛接憑附継繼盡支連浸尽就告付通攣次積嗣點突漬衝椄詰尾撞搗津つ吃釁衢岐巷粡粽因杠契鵆児交腟帙膣些蟄 N 窒斉秩父捷矗筑築逐盟税力親邇誓迩近苣尖縮鏤塵趁珎抻亭狆朕鎭碪跛闖鴆砧椿枕鎮陳珍沈賃杖找摘茶嫡着儲瀦潴箸竚杼躇紵豬墸苧緒樗楮⊥陟敕飭捗躅稙猪勅著窕萇微鵈迢挺趙佻蔦輒髫誂塚昶廳脹廰糶楪膓吊鼎悵疔樢澂輙聽齠晁甼雕鬯漲凋帖掉停諜跳眺貼鐇澄提喋頭銚ー蝶暢帳丁牒重逃鳥弔張懲肇兆嘲徴釣聴彫潮頂町調貂腸庁超挑朝丶黜紬綢惆肘籌蟲冢丑晝儔冑※胄鍮寵廚稠酎紐鑄冲沖偸宙虫］｝［｛厨誅鋳紂仲註駐注柱衷籀昼抽中痴池黐血置黹褫岻稚輊癡致穉夂遅散馳千知笞蜘乳踟家治値躓魑耻禿茅恥地智夊緻薙遲ち便党屯榱椽架樽弛鰔膤蕩鱈盥戯俵袂保躊為様樣爲疸餤緞摶毯椴湍亶褝殫檀膽彖覃站啗鄲袒綻攤慱潭憺襌猯壇憚擔槫賺靼酖湯澹‡†蛋耽 W 痰旦啖坦眈反 C 嘆歎誕胆箪譚担淡鍛單短探貪単覊栲妙戲訊攜携尋訪比畴疇類民髱樂娯恃頼愉楽喩例譬滾激嵶仆斃垰殕倒嫋旅貍狸称讃賛敲蹈踏祟湛戰鬪斗戦闘彳佇叩疉疂疊畳箍鏨違互耕畉畊掌店棚到炭辿斬撻韃闥燵巽辰佐扶援＋佑相弼輔助襷髻椨誑胤種塔龍竜糜糺爛漂維伊禎貞理直惟是忠匡徒唯只窘嗜慥確胝鮹鱆凧蛸誥嶽哮茸豪英威毅猛笋筍酣雄丈健斌武彈靈珪承賚珠魂霊卵偶適環弾球玉丹謀莨束縱｜盾鬣奉楯蓼縦竪質城達館忽橘舘瀑薪滝瀧峪溪渓谿谷宇亨集任臣尭昂楼小剛洪恭岳喬嵩孚尚孝尊敬崇隆貴鷹竹篁簟寶財高寳宝但濯柝擇拆鈬擢澤綰魄柘啅倬戳鐸畜企啄磔巧匠択沢逞琢蓄度託宅卓謫托拓躰紿碓隶抬黛體滯殆靆帶替軆平駘擡逮腿当怠玳諦岱鯛對颱袋戴堆頽態苔滞待代帝貸隊褪胎帯体泰大退対夛経佗經溜揉建侘他蛇炊手發矯朶強起耐発勃薫它絶咤埀田堪詑闌給詫躱裁截賜撓断点立貯長多太岔逹斷汰焚垂足食誰閉澑たｔцЦ〜天時×型火土→吐都東上瓲噸│┃台表第木スジ∴Θθザ正ツ¨転透▼▽△▲トチ…・試端タΤ┴┨┤┥┸т┝┰〒Т┳τ┷┠┻テ┫├┬┯┣ t]"
    "[孳蛤礼敬恭洞鱗愛潤騒煩粳漆閏患慯悄恙騷愁呻楳梅嫐釉噂吽曇褞黄紜耘云繧慍薀蘊暈運錙怏麗羨卦憾怨恨占卜末嬉心裏浦糶瓜汝己畴畦畆疇畝疎踈宜諾奪姥腕莵兔驢鑿穿嗽魘唸促令項頷訴獺鷽嘯嘘蠕蠢動覘窺伺海萼台詠謌唱唄宴讌転詩謠謡謳疑歌葎鯏鴬鶯ヱゑゐヰ鶉疼堆蹲踞渦舂臼碓羅薄食筌槽朮肯凵魚巧茨廐廏厩鰻午甘秣孫餞馬旨冩暎遷蔚寫噐器移慈俯映写現虚美靱笂靭靫空鰾萍初蛆雲氏上後喪艮丑潮牛裡鬱中欝袿梁家内雨菟有射胡得埋挧傴産受烏憂饂右打禹績搏泛鵜紆迂撲夘請芋熟承膿享攵浮卯賣齲宇飢兎攴羽失于売撃植生討茹嫗盂倦うｕ¨↑∪υΥУуウ Uu]"
    "[ｖ：├値⊥版В∨вヴ↓ v]"
    "[ヲ女翁汚尾緒男惜小牡雄を孳蛤礼敬恭洞鱗愛潤騒粳漆閏慯悄恙騷愁呻楳梅嫐釉噂吽曇褞紜耘云繧慍薀蘊暈運錙怏麗羨 U 卦憾怨恨占卜末嬉心裏浦糶瓜汝己Υυ畴畦畆疇畝疎踈宜諾奪姥莵兔驢鑿穿嗽魘唸促令項頷訴獺鷽嘯嘘蠕蠢動覘窺伺萼台詠謌唱唄宴讌転詩謠謡謳疑歌葎鯏鴬鶯ヱゑ鶉疼堆蹲踞渦舂臼碓羅薄食筌槽朮肯凵魚巧茨廐廏厩鰻午甘秣孫餞馬旨冩暎遷蔚寫噐器移慈俯映写現虚美靱笂靭靫空鰾萍初蛆氏↑上後喪艮丑潮牛裡鬱中欝袿梁家内雨菟有射胡得埋挧傴産受烏憂饂右打禹績搏泛鵜紆迂撲夘請芋熟承膿享攵浮卯賣齲宇飢兎攴失于売撃植生討茹嫗盂倦うヰ居ゐ叫喚÷惡悪稿原嗤妾蕨童藁鞋笑萬豌綰灣万弯彎椀雲腕碗湾黄往横皇羂罠纔微毫僅煩患術伎厄災禍態業技佗王鰐忘掖弁腋譯腸緜道渉亙弥航亘棉渡綿私隈薈賄淮脇矮猥歪轍海蟠儂∪頒觧解判訣別稚若或枠惑鷲萵破話羽割詫訳杷琶倭我和侘吾環把輪涌啝湧分沸わｗ幅水∧波ウワ w]"
    "[ォぉェぇゥぅィぃァぁｘХхξ×Ξ X]"
    "[蒿艾蓬娵嫁齡齢據頼弱憙歓鎧万萬過便婚汚涎捩杙翊緘峪慾欲翌翼抑米比粧裝装澱淀縦誼祥葭悦克純宜圭禎葦慶淑美禧芳喜吉義窰廱癰樣榕瑶癢蓉雍泱瘍謠穃恙暘漾痒孕甬慵遙曄燿瀁踴怏慂姚珱昜陶踊幺鷹瓔煬邀遥拗擁瑤窯徭窈膺殀耀曜庸夭揚葉蛹腰羊熔杳沃壅様妖溶用佯謡陽洋嘉宵蘓蘇甦奸辟横選醉訓輿四能丗予与歟代譱預憑除詠呼読讀飫４餘避撚畭與縒蕷舁譽豫誉喚攀酔世余よ潤赦弛緩聴岼閖梦努纈∴故濯檠穰豐豊倖志裄之幸雪趾梼讓譲牀紫縁浴床犹莠邑俑酉熊猷尢蚰悒黝囿蝣蕕攸佳尤佑〒右郵涌侑祐游猶湧融宥夕幽悠釉友雄憂有兪覦腴楡徃輸愉喩蝓揄結弓臾諭由瑜逾瘉柚汰搖遊諛淘油渝征茹揺踰揃ゆΗη賤卑鄙苟嫌妹湯芋藷夢艷鑪鈩彩鱗色鯆忽綺貸甍応答愈圦杁蚓茵霪婬飮蔭贇酳韵寅尹胤隱氤湮堙吋廴 I 音慇韻咽淫殞姻隕院允殷隠陰窟巌巖頌祝鰛鰮鰯岩磐鼾歪弋弑抱懐贅肬疣狗戌乾犬諱坐在未汝誡警戒縛今Εε曰禾稻員因蝗印嘶鰍電引躄誘動忿≦鵤錨碇怒雷霹霆凧桴筏Ιι魚菴庵雖尿荊棘茨祈祷命猯豕古聿鎰乙鴪伍軼樹慈悼慯愴労格到至傷鼬頂戴徒致鈑痛板柞砂沙些聊潔諍烈功諫勳勇勲漁諌憇＝憩粹熱粋憤域閾勢勤忙急磯孰焉湶泉厳何弄苛≧范鎔啀毬訝燻息指挑拠絲縷厭營営愛幼緒遑暇糸Ｉ弌壹肆莓苺櫟著市碑鐓礎甃臀弩石犧犠牲池溢佚壱 1 １粥毓鬻燠礇的戦戰軍郁幾一稲許否飯揖詑居入維将洟挿容良行緯活矮渭慰逸往爲唯斐饐炒生凍頤出威胃矣姨要肄謂僞委云為五萎煎蔚鑄井恚位懿醫貽好以ゐ噫怡依畏違熬莞斎鋳如夷移亥帷胆圍彝彜淹痍猗椅逝鰄異熨囗善去忌倚惟癒偉堰遺偽医射幃鮪率可韋意痿猪衣逶囲李言詒彙伊苡い稚稍飲鎗槍鑓孀鰥寡Я碼傭雇闇敗吝薮藪殕脂寄宿櫓軈軅簗梁 S 漸鋏刃灸軟和柔窶鱧奴僕萢優柳喧宅舘館族輩鏃鑰譯籥龠葯蜴≒藥繹檪扼益厄疫躍約役訳薬岾疚疾楊谺邪薯豺犲〈《〉》山邸廛壥豢養社鑢育尉廉寧裕泰恭易休康保安靖哉彌矢耶病殺辭辞屋輻夜止已焼罷妬⇒也痩谷八灼燒熄冶笶弥瘠椰野破爺⇔揶演埜遣家やｙЕе¥円←↑↓→Ёё━─ユヤヨйイυыΥ Y ЫЙ Y]"
    "[空損存揃薗園底束續屬足∋∈賊続粟族俗属梍賍臧臟噌僧慥贓憎像臓贈象増造添沿曽反初曾ぞ苒繕然譱禪薇千蠕∀髯禅善漸冉前全關関蝉膳錢銭絶噬説勢筮贅脆税攻責是ぜ狡詰桷寸喘鮨附◆惴蕊蘂蕋髓膸隧隋隨瑞髄随豆好図酢頭津厨刷廚逗鶴付圖ず塩縞嶋嶌島橲衄竺宍衂舳忸軸舌祖喰食直凝日實昵印闍者鮭邪蛇麝着鉐尺惹搦雀寂若弱尻贐潯糂盡仭進稔刄臣恁仞儘侭訊俥蕁迅刃靱荏甚靭燼櫁樒塵尽尋陣腎壬人洳杼莇蜍敍汝恕茹耡敘舒縟辱褥蓐溽所抒鋤徐絮叙序助嬲聶星絛茸孃瀞仍乘躡拯讓仗疉滌帖繩遶諚疊塲靜淨繞疂蕘壌釀驤穰禳襄壤生蟐如醤剩娘嬢錠静醸縄女尉饒丈成烝嫋穣擾丞杖場條条蒸貞状攘剰畳冗定浄乗情城上常譲愀鷲嬬得戍竪咒就讐懦讎濡聚詢凖隼盾筍徇笋楯篤蓴惇淳洵閏恂諄馴旬荀潤醇巡循遵順准殉純準襦誦需戌朮孰宿塾珠熟恤術述呪孺豎儒綬樹受授壽澁廿糅縱澀从鞣從狃揉戎拾中蹂神汁獸絨縦渋柔什充十従獣住銃重膩時侍孳兒二珥只冶餌邇茲怩死持子祀蒔嗣痔辞辭畤轜寺示亊弍自瓷史岻児以焦塒峙事敷治路爾次慈寿滋粫耳知恃仕似至尓爺染字地磁除而柱仁士司璽迩じ騒沢澤猿笊皿晒曝鮫鏨竄慘懴参山算殘塹巉懺嶄讒惨暫慚慙斬残実笹酒坂盛三嵜崎桜榴襍雜棹竿雑西斉済濟才戝劑剤材財罪在蔵坐戯座左咲挫冷醒差冴覚藏裂ざｚ→↑ЪъьЬ↓←Жжズゾ零〇〒ザジΖзζゼЗ Z]"

  ))
(global-set-key (kbd "H-;") 'ace-pinyin-jump-char)
(ace-pinyin-global-mode 1)


;; ---------------------------------------------------------
;; ripgrep の設定
;; 要 rust & ripgrep
;; ---------------------------------------------------------
;;; rg バイナリの位置
(setq ripgrep-executable "~/.cargo/bin/rg")
;;; rg に渡すオプション
(setq ripgrep-arguments '("-S"))


;; ---------------------------------------------------------
;; helm-ag の設定
;; ---------------------------------------------------------
;; ag 以外の検索コマンドも使える
;; (setq helm-ag-base-command "grep -rin")
;; (setq helm-ag-base-command "csearch -n")
;; (setq helm-ag-base-command "pt --nocolor --nogroup")
(setq helm-ag-base-command "rg --vimgrep --no-heading") ;; ripgrip を使用
;; 現在のシンボルをデフォルトのクエリにする
(setq helm-ag-insert-at-point 'symbol)
;; C-cg はちょうどあいてる
(global-set-key (kbd "C-c g") 'helm-ag)
(global-set-key (kbd "C-c k") 'backward-kill-sexp)

(defun helm-ag-dot-emacs ()
  ".emacs.d 以下を検索"
  (interactive)
  (helm-ag "~/.emacs.d/"))
(require 'projectile nil t)
(defun helm-projectile-ag ()
  "Projectile と連携"
  (interactive)
  (helm-ag (projectile-project-root)))
;; (helm-ag "~/.emacs.d/")


;; ---------------------------------------------------------
;; helm-gtagsの設定
;; ---------------------------------------------------------
(custom-set-variables
 '(helm-gtags-suggested-key-mapping t)
 '(helm-gtags-auto-update t)
 )

;; ---------------------------------------------------------
;; multi-term の設定
;; 参考：http://sakito.jp/emacs/emacsshell.html
;; http://passingloop.tumblr.com/post/11324890598/emacs-terminfo-configuration
;; ---------------------------------------------------------
;; path 追加
; より下に記述した物が PATH の先頭に追加される
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/opt/local/bin"
              "/sw/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
 ;; PATH と exec-path に同じ物を追加
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))

;;multi-term
(setq load-path(cons "~/dotfiles/.emacs.d/elpa" load-path))
(require 'multi-term)
(setenv "TERMINFO" "~/.terminfo")

;; shell の存在を確認
; 上から順に探して最初に見つかったものを適用
(defun skt:shell ()
  (or
      ;; (executable-find "xonsh")
      (executable-find "fish")
      (executable-find "zsh")
      (executable-find "bash")
      (error "can't find 'shell' command in PATH!!")))

;; Shell 名の設定
(setq shell-file-name (skt:shell))
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)

;; Emacs が保持する terminfo を利用する
(setq system-uses-terminfo nil)

;; multi-term を呼び出すたのキーバインド
(global-set-key (kbd "C-c t") '(lambda ()
                                (interactive)
                                (multi-term)))

;; C-z で evil モードを切ったときはこっち
(defun term-mode-hooks ()
  ;; C-h を term 内文字削除にする
  (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
  ;; C-y を term 内ペーストにする
  (define-key term-raw-map (kbd "C-y") 'term-paste)
  ;; 行番号非表示
  (nlinum-mode -1)
  (setenv "LANG" "ja_JP.UTF-8")
  (set-language-environment 'utf-8)
  )
(add-hook 'term-mode-hook 'term-mode-hooks)

;; evil のときはこっち
(evil-define-key 'normal term-raw-map
  "p" 'term-paste)


;; shell の設定ファイルを別ウィンドウで開く
(global-set-key (kbd "C-c C-s") 'crux-find-shell-init-file)


;; shell-pop の設定
(require 'shell-pop)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(shell-pop-shell-type (quote ("multi-term" "*terminal<1>*" '(lambda () (multi-term)))))
 '(shell-pop-term-shell "/Users/ymattu/.pyenv/shims/xonsh")
 '(shell-pop-universal-key "C-t")
 '(shell-pop-window-height 30)
 '(shell-pop-window-position "bottom"))
(global-set-key (kbd "C-c s") 'shell-pop)


;; ---------------------------------------------------------
;; yasnippet の設定
;; ---------------------------------------------------------
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/mysnippets"
        yas-installed-snippets-dir
        ))


;; yas 起動
(yas-global-mode 1)

;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)

;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)

;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)


;; ---------------------------------------------------------
;; マルチカーソルの設定
;; (参考: http://qiita.com/ongaeshi/items/3521b814aa4bf162181d)
;; ---------------------------------------------------------
(require 'multiple-cursors)
(require 'smartrep)

(declare-function smartrep-define-key "smartrep")

(global-set-key (kbd "C-M-c") 'mc/edit-lines)
(global-set-key (kbd "C-M-r") 'mc/mark-all-in-region)


(smartrep-define-key global-map "C-="
  '(("C-t"      . 'mc/-next-like-this)
    ("n"        . 'mc/mark-next-like-this)
    ("p"        . 'mc/mark-previous-like-this)
    ("m"        . 'mc/mark-more-like-this-extended)
    ("u"        . 'mc/unmark-next-like-this)
    ("U"        . 'mc/unmark-previous-like-this)
    ("s"        . 'mc/skip-to-next-like-this)
    ("S"        . 'mc/skip-to-previous-like-this)
    ("*"        . 'mc/mark-all-like-this)
    ("d"        . 'mc/mark-all-like-this-dwim)
    ("i"        . 'mc/insert-numbers)
    ("o"        . 'mc/sort-regions)
    ("O"        . 'mc/reverse-regions)))

(defun mc/edit-lines-or-string-rectangle (s e)
  "C-x r t で同じ桁の場合に mc/edit-lines (C-u M-x mc/mark-all-dwim)"
  (interactive "r")
  (if (eq (save-excursion (goto-char s) (current-column))
          (save-excursion (goto-char e) (current-column)))
      (call-interactively 'mc/edit-lines)
    (call-interactively 'string-rectangle)))
(global-set-key (kbd "C-x r t") 'mc/edit-lines-or-string-rectangle)

(defun mc/mark-all-dwim-or-mark-sexp (arg)
  "C-u C-M-SPC で mc/mark-all-dwim, C-u C-u C-M-SPC で C-u M-x mc/mark-all-dwim"
  (interactive "p")
  (cl-case arg
    (16 (mc/mark-all-dwim t))
    (4 (mc/mark-all-dwim nil))
    (1 (mark-sexp 1))))
(global-set-key (kbd "C-M-SPC") 'mc/mark-all-dwim-or-mark-sexp)


;; ---------------------------------------------------------
;; tabbar の設定
;; ---------------------------------------------------------
(require 'tabbar)
(tabbar-mode 1)

;; タブ上でマウスホイール操作無効
(tabbar-mwheel-mode -1)

;; グループ化しない
(setq tabbar-buffer-groups-function nil)

;; 画像を使わないことで軽量化する
(setq tabbar-use-images nil)

;; 左に表示されるボタンを無効化
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

;; タブ間の長さ
(setq tabbar-separator '(1.5))

;; 外観変更
(set-face-attribute
 'tabbar-default nil
 :family "MeiryoKe_Gothic"
 :background "#34495E"
 :foreground "#EEEEEE"
 :family "Ricty Diminished"
 :height 0.95
 )
(set-face-attribute
 'tabbar-unselected nil
 :background "#34495E"
 :foreground "#EEEEEE"
 :box nil
)
(set-face-attribute
 'tabbar-modified nil
 :background "#E67E22"
 :foreground "#EEEEEE"
 :box nil
)
(set-face-attribute
 'tabbar-selected nil
 :background "#E74C3C"
 :foreground "#EEEEEE"
 :box nil)
(set-face-attribute
 'tabbar-button nil
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :height 1.0)

;; タブに表示させるバッファの設定
(defvar my-tabbar-displayed-buffers
  '("*scratch*" "*Backtrace*" "*Colors*" "*Faces*" "*R*"
    "*eww*" "*terminal<1>*" "*terminal<2>*" "*terminal<3>*")
  "*Regexps matches buffer names always included tabs.")

(defun my-tabbar-buffer-list ()
  "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
  (let* ((hides (list ?\  ?\*))
         (re (regexp-opt my-tabbar-displayed-buffers))
         (cur-buf (current-buffer))
         (tabs (delq nil
                     (mapcar (lambda (buf)
                               (let ((name (buffer-name buf)))
                                 (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
                                   buf)))
                             (buffer-list)))))
    ;; Always include the current buffer.
    (if (memq cur-buf tabs)
        tabs
      (cons cur-buf tabs))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)


;; L, H でタブを切り替える
(defun my-tabbar-forward-tab ( number )
  (interactive "p")
  (setq num 0)
  (while (< num number)
    (tabbar-forward-tab)
    (setq num (1+ num))
    ))

(defun my-tabbar-backward-tab ( number )
  (interactive "p")
  (setq num 0)
  (while (< num number)
    (tabbar-backward-tab)
    (setq num (1+ num))))

(define-key evil-normal-state-map (kbd "L") 'my-tabbar-forward-tab)
(define-key evil-normal-state-map (kbd "H") 'my-tabbar-backward-tab)


;; ---------------------------------------------------------
;; win-switch の設定 (ウィンドウを分割してるときの移動を楽に)
;; ---------------------------------------------------------
(require 'win-switch)
;; 0.75 秒間受け付けるタイマー
(setq win-switch-idle-time 0.75)
;; 好きなキーを複数割り当てられる
;; ウィンドウ切り替え
(win-switch-set-keys '("k") 'up)
(win-switch-set-keys '("j") 'down)
(win-switch-set-keys '("h") 'left)
(win-switch-set-keys '("l") 'right)
(win-switch-set-keys '("o") 'next-window)
(win-switch-set-keys '("p") 'previous-window)
;; リサイズ
(win-switch-set-keys '("K") 'enlarge-vertically)
(win-switch-set-keys '("J") 'shrink-vertically)
(win-switch-set-keys '("H") 'shrink-horizontally)
(win-switch-set-keys '("L") 'enlarge-horizontally)
;; 分割
(win-switch-set-keys '("3") 'split-horizontally)
(win-switch-set-keys '("2") 'split-vertically)
(win-switch-set-keys '("0") 'delete-window)
;; その他
(win-switch-set-keys '(" ") 'other-frame)
(win-switch-set-keys '("u" [return]) 'exit)
(win-switch-set-keys '("\M-\C-g") 'emergency-exit)
;; C-x o を置き換える
(global-set-key (kbd "C-x o") 'win-switch-dispatch)


;; ---------------------------------------------------------
;; swap-buffers の設定 (ウィンドウを入れ替える)
;; ---------------------------------------------------------
(defun swap-buffers-keep-focus ()
  (interactive)
  (swap-buffers t))
;;; 無設定で使えるが、swap-screen に倣って f2/S-f2 に割り当てる
(global-set-key [f2] 'swap-buffers-keep-focus)
(global-set-key [S-f2] 'swap-buffers)


;; ---------------------------------------------------------
;; window-numbering の設定 (ウィンドウを分割してるときの移動を楽に)
;; ---------------------------------------------------------
(window-numbering-mode 1)


;; ---------------------------------------------------------
;; zoom-window の設定
;; ---------------------------------------------------------
(require 'zoom-window)
(global-set-key (kbd "C-x 1") 'zoom-window-zoom)
(setq zoom-window-mode-line-color "DarkGreen")


;; ---------------------------------------------------------
;; org-mode の設定
;; ---------------------------------------------------------
;; org-mode の初期化
(require 'org-install)
(require 'org)

;; 拡張子が org のファイルを開いた時，自動的に org-mode にする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; org-mode での強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)

;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)

;; TODO 状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
;; DONE の時刻を記録
(setq org-log-done 'time)

;; 画像表示
(setq org-startup-with-inline-images t)

;; 見出しの移動を vi 風に
;; (add-hook 'org-mode-hook 'worf-mode)

;; 見出し移動を楽にする
;; http://emacs.rubikitch.com/sd1511-key-chord-smartrep/ を参照
(smartrep-define-key org-mode-map "C-c"
  '(("C-n" . org-next-visible-heading)
    ("C-p" . org-previous-visible-heading)
    ("C-u" . outline-up-heading)
    ("C-f" . org-forward-heading-same-level)
    ("C-b" . org-backward-heading-same-level)))


;; reveal-js が使えるようにする
(require 'ox-reveal)


;; org-link に変換した上でファイルパスをクリップボードに保存.
(defun my/copy-current-org-link-path ()
  (interactive)
  (let* ((fPath (my/get-curernt-path))
         (fName (file-relative-name fPath)))
    (my/copy-org-link fPath fName)))

(defun my/copy-org-link (my/current-path my/current-title)
  (let ((orgPath
  (format "[[%s][%s]]" my/current-path my/current-title)))
    (message "stored org-link: %s" orgPath)
    (kill-new orgPath)))

(global-set-key (kbd "C-c [") 'my/copy-current-org-link-path)


;; ---------------------------------------------------------
;; org-babel の設定
;; ---------------------------------------------------------
;; org-babel
(org-babel-do-load-languages
'org-babel-load-languages
'((R . t)
  (python . t)
  (ipython . t)
  (matlab . t)
)
 )
(setq org-confirm-babel-evaluate nil)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

;; ob-ipythton
(require 'ob-ipython)
;; コードを評価するとき尋ねない
(setq org-confirm-babel-evaluate nil)
;; ソースコードを書き出すコマンド
(defun org-babel-tangle-and-execute ()
  (interactive)
  (org-babel-tangle)
  (org-babel-execute-buffer)
  (org-display-inline-images))
(define-key org-mode-map (kbd "C-c C-v C-m") 'org-babel-tangle-and-execute)


;; ---------------------------------------------------------
;; ESS の設定
;; ---------------------------------------------------------
(require 'ess-site)

;R 関連--------------------------------------------
;; パスの追加
(add-to-list 'load-path "~/dotfiles/.emacs.d/elpa")

;; 拡張子が r, R の場合に R-mode を起動
(add-to-list 'auto-mode-alist '("\\.[rR]$" . R-mode))

;; R-mode を起動する時に ess-site をロード
(autoload 'R-mode "ess-site" "Emacs Speaks Statistics mode" t)

;; R を起動する時に ess-site をロード
(autoload 'R "ess-site" "start R" t)


;; R-mode, iESS を起動する際に呼び出す初期化関数
(setq ess-loaded-p nil)
(defun ess-load-hook (&optional from-iess-p)
  ;; インデントの幅を 2 にする（デフォルト 2）
  (setq ess-indent-level 2)
  ;; インデントを調整
  (setq ess-arg-function-offset-new-line (list ess-indent-level))
  ;; comment-region のコメントアウトに # を使う（デフォルト##）
  (make-variable-buffer-local 'comment-add)
  (setq comment-add 0)

  ;; 最初に ESS を呼び出した時の処理
  (when (not ess-loaded-p)
    ;; C-c C-g で オブジェクトの内容を確認できるようにする
    (require 'ess-R-object-popup)
    (define-key ess-mode-map "\C-c\C-g" 'ess-R-object-popup)
    ;; 補完機能を有効にする
    (setq ess-use-auto-complete t)
    ;; helm を使いたいので IDO は邪魔
    (setq ess-use-ido nil)
    ;; キャレットがシンボル上にある場合にもエコーエリアにヘルプを表示する
    (setq ess-eldoc-show-on-symbol t)
    ;; 起動時にワーキングディレクトリを尋ねられないようにする
    (setq ess-ask-for-ess-directory nil)
    ;; # の数によってコメントのインデントの挙動が変わるのを無効にする
    (setq ess-fancy-comments nil)
    (setq ess-loaded-p t)
    ;; flycheck はうざいので切る
    (flycheck-mode -1)
    (unless from-iess-p
      ;; ウィンドウが 1 つの状態で *.R を開いた場合はウィンドウを縦に分割して R を表示する
      (when (one-window-p
        (split-window-sensibly)
        (let ((buf (current-buffer)))
          (ess-switch-to-ESS nil)
          (switch-to-buffer-other-window buf)))
      ;; R を起動する前だと auto-complete-mode が off になるので自前で on にする
      ;; cf. ess.el の ess-load-extras
      (when (and ess-use-auto-complete (require 'auto-complete nil t))
        (add-to-list 'ac-modes 'ess-mode)
        (mapcar (lambda (el) (add-to-list 'ac-trigger-commands el))
                '(ess-smart-comma smart-operator-comma skeleton-pair-insert-maybe))
        (setq ac-sources '(ac-source-R
                           ac-source-R-args
                           ac-source-R-objects
                           ac-source-filename
                           ac-source-yasnippet)))
      ))

  (if from-iess-p
      ;; R のプロセスが他になければウィンドウを分割する
      (if (> (length ess-process-name-list) 0)
          (when (one-window-p)
            (split-window-vertically)
            (other-window 1)
            ))
    ;; *.R と R のプロセスを結びつける
    ;; これをしておかないと補完などの便利な機能が使えない
    (ess-force-buffer-current "Process to load into: "))))

;; R-mode 起動直後の処理
(add-hook 'R-mode-hook 'ess-load-hook)

;; R 起動直前の処理
(defun ess-pre-run-hooks ()
  (ess-load-hook t))
(add-hook 'ess-pre-run-hook 'ess-pre-run-hooks)


;;ESS R Data View
(require 'ess-R-data-view)
(define-key ess-mode-map (kbd "C-c v") 'ess-R-dv-ctable)
(define-key ess-mode-map (kbd "C-c V") 'ess-R-dv-pprint)


;; オブジェクトにも色付け
(defvar ess-R-fl-keyword:assign-vars
  (cons "\\(\\(?2:\\s\"\\).+\\2\\|\\sw+\\)\\s-*\\(<-\\)"
        '(1 font-lock-variable-name-face)))

(add-to-list 'ess-R-font-lock-keywords '(ess-R-fl-keyword:assign-vars . t) t)


;; パイプ演算子
(defun then_R_operator ()
  "R - %>% operator or 'then' pipe operator"
  (interactive)
  (just-one-space 1)
  (insert "%>%")
  (reindent-then-newline-and-indent))
(define-key ess-mode-map (kbd "M-M") 'then_R_operator)
(define-key inferior-ess-mode-map (kbd "M-M") 'then_R_operator)



;; ess mode では自動で行末スペースを削除しない
(defun ess-mode-trailing-whitespace ()
  (set (make-local-variable 'whitespace-action) nill))
;; (add-hook 'ess-mode-hook 'ess-mode-trailing-whitespace)


;; dumb-jump(C-M-g/p で変数定義に飛ぶ)
(add-hook 'ess-mode-hook 'dumb-jump-mode)


;; R コンソール内では行数を表示しない
(defun iESS-hooks ()
  (nlinum-mode -1))
(add-hook 'inferior-ess-mode-hook 'iESS-hooks)


;; helm インタフェースで 関数のヘルプをひく
(require 'helm-myR)
(define-key ess-mode-map (kbd "C-c h") 'helm-for-R)
(define-key inferior-ess-mode-map (kbd "C-c h") 'helm-for-R)

(define-key ess-mode-map (kbd "A-h") 'helm-myR-install-packages)
(define-key inferior-ess-mode-map (kbd "A-h") 'helm-myR-install-packages)


;; ソースコードにインライン画像を埋め込む
(require 'inlineR)
(define-key ess-mode-map "\C-ci" 'inlineR-insert-tag)
(setq inlineR-re-funcname ".*plot.*\\|.*gg.*") ;; 作図関数追加

;; e2wm-R
(require 'e2wm-R)

;; e2wm:dp-R-view, e2wm:stop-management を toggleis する
(defun e2wm:toggle-management ()
  (interactive)
  (if (e2wm:pst-get-instance)
      (e2wm:stop-management) (e2wm:dp-R-view)))
(define-key ess-mode-map (kbd "C-,") 'e2wm:toggle-management)


;; R Markdown-------------------------------------
;; MARKDOWN
(require 'poly-markdown)
;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

;; R modes
(require 'poly-R)
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; html へ変換
(defun rmarkdown-to-html ()
  (interactive)
  "Run rmarkdown::rnder on the current file"
  "https://gist.github.com/kohske/9128031"
  (shell-command
   (format "Rscript -e \"library(revealjs); library(xaringan); rmarkdown::render ('%s')\""
           (shell-quote-argument (buffer-file-name)))))

(define-key poly-markdown+r-mode-map "\C-c\C-h" 'rmarkdown-to-html)


;; pdf へ変換
(defun rmarkdown-to-pdf ()
  (interactive)
  "make a pdf document on the current file"
  (shell-command
   (format "Rscript -e \"rmarkdown::render('%s', 'pdf_document')\""
           (shell-quote-argument (buffer-file-name)))))

(define-key poly-markdown+r-mode-map "\C-c\C-d" 'rmarkdown-to-pdf)


;; html スライドに変換
(defun rmarkdown-to-slide ()
  (interactive)
  "Run slidify::slidify on the current file"
  (shell-command
   (format "Rscript -e \"slidify::slidify ('%s')\""
           (shell-quote-argument (buffer-file-name)))))

(define-key poly-markdown+r-mode-map "\C-c\C-l" 'rmarkdown-to-slide)


;; チャンク挿入
(defun tws-insert-r-chunk (header)
  "Insert an r-chunk in markdown mode.
Necessary due to interactions between polymode and yas snippet"
  (interactive "sHeader: ")
  (insert (concat "```{r " header "}\n\n```"))
  (forward-line -1))

(define-key poly-markdown+r-mode-map (kbd "M-n M-r") 'tws-insert-r-chunk)

(defun tws-insert-py-chunk (header)
  "Insert a python-chunk in markdown mode.
Necessary due to interactions between polymode and yas snippet"
  (interactive "sHeader: ")
  (insert (concat "```{python " header "}\n\n```"))
  (forward-line -1))

(define-key poly-markdown+r-mode-map (kbd "M-n M-p") 'tws-insert-py-chunk)

(defun tws-insert-norm-chunk (header)
  "Insert a chunk in markdown mode.
Necessary due to interactions between polymode and yas snippet"
  (interactive "sHeader: ")
  (insert (concat "```{" header "}\n\n```"))
  (forward-line -1))

(define-key poly-markdown+r-mode-map (kbd "M-n M-c") 'tws-insert-norm-chunk)



;; do this in R process
;; library (rmarkdown); render ("file_name.Rmd")

(defun ess-rmarkdown ()
  (interactive)
  "Compile R markdown (.Rmd). Should work for any output type."
  "http://roughtheory.com/posts/ess-rmarkdown.html"
  ; Check if attached R-session
  (condition-case nil
      (ess-get-process)
    (error
     (ess-switch-process)))
  (let* ((rmd-buf (current-buffer)))
    (save-excursion
      (let* ((sprocess (ess-get-process ess-current-process-name))
             (sbuffer (process-buffer sprocess))
             (buf-coding (symbol-name buffer-file-coding-system))
             (R-cmd
              (format "library (rmarkdown); rmarkdown::render (\"%s\")"
                      buffer-file-name)))
        (message "Running rmarkdown on %s" buffer-file-name)
        (ess-execute R-cmd ‘ buffer nil nil)
        (switch-to-buffer rmd-buf)
        (ess-show-buffer (buffer-name sbuffer) nil)))))

(define-key polymode-mode-map "\M-ns" 'ess-rmarkdown)


;;; SAS 関連---------------------------------------
;; 拡張子が SAS の場合に SAS-mode を起動
(add-to-list 'auto-mode-alist '("\\.sas$" . SAS-mode))

;; SAS-mode を起動する時に ess-site をロード
(autoload 'SAS-mode "ess-site" "Emacs Speaks Statistics mode" t)

;; SAS を起動する時に ess-site をロード
(autoload 'SAS "ess-site" "start SAS" t)


(defun sas-mode-setup ()
"SAS モードの初期設定"
  ;; インデント幅は 2
  (setq sas-indent-width 2))
(add-hook 'SAS-mode-hook 'sas-mode-setup)


;; シンタックスハイライトを追加(for SAS 9.4)------
(add-to-list 'SAS-mode-font-lock-defaults
             (cons (concat "\\<proc[ ]+"
                           (regexp-opt '("bchoice"
                                         "fedsql"
                                         "iclifetest"
                                         "irt"
                                         "irphreg"
                                         "spp"
                                         "datekeys"
                                         ) 'words)) font-lock-constant-face)
             )

(add-to-list 'SAS-mode-font-lock-defaults
             (cons (concat
                    (regexp-opt
                     '("as"
                       "create"
                       "group"
                       "order"
                       "from"
                       "on"
                       "inner join"
                       "left outer join"
                       "right outer join"
                       "cross join"
                       "full join"
                       "union"
                       "having"
                       "case"
                       "when"
                       ) 'words)) font-lock-keyword-face)
             )


;; auto-complete 関連-----------------------------
;; ユーザ辞書の場所
(defvar ac-user-dict-dir (expand-file-name "~/.emacs.d/ac-dict/"))

;; コンプリート時の動作 - 候補の末尾に()があればその内にカーソルを置く
(defun ac-go-into-braces-action ()
  (save-restriction
    (narrow-to-region (point) (- (point) 2))
    (if (re-search-backward "()" nil t)
        (forward-char))))


;; 直前の文字を区別して辞書を使用する - proc+スペースの後の場合に補完する
(defun ac-sas-proc-prefix ()
  "`x.' prefix."
  (if (re-search-backward "proc \\(.*\\)" nil t)
      (match-beginning 1)))


;; 辞書 (ac-sas-proc)
;; 色設定
(defface ac-sas-proc-candidate-face
  '((t (:background "#a6fe2d" :foreground "#000000")))
  "Face for underscore.js candidates."
  :group 'auto-complete)


; 情報源に辞書ファイルを指定
(defvar ac-sas-proc-cache
  (ac-file-dictionary (concat ac-user-dict-dir "ac-sas-proc")))

; 辞書の設定
(defvar ac-source-sas-proc-dict
  '((candidates . ac-sas-proc-cache) ;; 候補の情報源 これ以下はオプション
    (candidate-face . ac-sas-proc-candidate-face) ;; 候補の色設定
    (prefix . ac-sas-proc-prefix) ;; 直前の文字の条件
    (action . ac-go-into-braces-action) ;; 補完後の動作
    (symbol . "proc") ;; ライブラリ名 (無理矢理。本来の意図とは違うはず)
    (requires . 2) ;; 補完が開始される最低入力文字数を上書き
    ;; (limit . 30) ;; 候補を一度に表示する上限数を上書き
    ))


;; 使用する辞書・情報源を選択
(add-hook 'SAS-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-sas-proc-dict t
                         )))


;;; julia 関連---------------------------------------
(setq inferior-julia-program-name "/Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia")
;; (add-to-list 'load-path "/usr/local/bin/julia")
;; (require 'julia-mode)
(add-to-list 'auto-mode-alist '("\\.jl$" . ess-julia-mode))
;; (autoload 'julia-mode "ess-site" "Emacs Speaks Statistics mode" t)
;; (autoload 'julia "ess-site" "start Julia" t)
;; (defun my-julia-mode-hooks ()
;;   (require 'ess-site))
;; (add-hook 'julia-mode-hook 'my-julia-mode-hooks)
;; (define-key ess-julia-mode-map (kbd "C-c C-c") 'quickrun)
;; (define-key ess-julia-mode-map (kbd "C-c c") 'quickrun-with-arg)
;; (define-key ess-julia-mode-map (kbd "C-c C-s") 'julia-shell-save-and-go)

;; (defun julia-env-lang ()
;;   (setenv "LANG" "ja_JP.UTF-8")
;;   (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))

;; (add-hook 'julia-mode-hook 'julia-env-lang)

(defun julia-window ()
  ;; *.jl ファイルを開いたときにウィンドウを上下に分割して下に julia シェルを表示
  (setq w (selected-window))
  (swap-buffers-keep-focus)
  (setq w2 (split-window w (- (window-height w) 20)))
  (select-window w2)
  (inferior-julia)
  (select-window w)
  )

(add-hook 'ess-julia-mode-hook 'julia-window)



;; ---------------------------------------------------------
;; stan-mode の設定
;; ---------------------------------------------------------
(require 'stan-mode)

(require 'stan-snippets)

;; 拡張子が Stan の場合に Stan-mode を起動
(add-to-list 'auto-mode-alist '("\\.stan$" . stan-mode))

(defun stan-mode-hooks ()
  (yas-minor-mode 1))

(add-hook 'stan-mode-hook 'stan-mode-hooks)


;; C 関連のエラーを防止する設定
(c-lang-defconst c-:$-multichar-token-regexp stan nil)
(c-lang-defconst c->-op-without->-cont-regexp stan nil)
(c-lang-defconst c-multichar->-op-not->>-regexp stan nil)


;; ---------------------------------------------------------
;; matlab の設定
;; ---------------------------------------------------------
(add-to-list 'load-path (expand-file-name "~/dotfiles/.emacs.d/elpa/")) ;; パス設定
(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)

(setq auto-mode-alist (cons '("\\.m$" . matlab-mode) auto-mode-alist))
;; (add-hook 'matlab-mode-hook
;;          '(lambda ()
;;             (set-buffer-file-coding-system 'sjis-dos))) ;; M-ファイルはシフト JIS で開く

(setq matlab-shell-command "/Applications/MATLAB_R2017b.app/bin/matlab"
  matlab-indent-level 2
  matlab-indent-function-body nil
  matlab-highlight-cross-function-variables t
  matlab-return-add-semicolon t
  matlab-show-mlint-warnings t
  mlint-programs '("/Applications/MATLAB_R2017a.app/bin/maci64/mlint")
  matlab-mode-install-path (list (expand-file-name "~/dotfiles/.emacs.d/elisp/matlab/"))
  )

(autoload 'mlint-minor-mode "mlint" nil t)
(add-hook 'matlab-shell-mode-hook 'ansi-color-for-comint-mode-on)


(defun matlab-mode-hooks ()
  (setenv "LANG" "C")
  (nlinum-mode -1)
  )

(add-hook 'matlab-shell-mode-hook 'matlab-mode-hooks)


(defun matlab-window ()
  (mlint-minor-mode 1)
  ;; *.m ファイルを開いたときにウィンドウを上下に分割して下に matlab シェルを表示
  (setq w (selected-window))
  (setq w2 (split-window w (- (window-height w) 20)))
  (select-window w2)
  (matlab-shell)
  (select-window w)
  )

(add-hook 'matlab-mode-hook 'matlab-window)


(eval-after-load "shell"
    '(define-key shell-mode-map [down] 'comint-next-matching-input-from-input))
(eval-after-load "shell"
    '(define-key shell-mode-map [up] 'comint-previous-matching-input-from-input))


;; キーバインド
(defvar matlab-mode-map
  (let ((km (make-sparse-keymap)))
    (define-key km [return] 'matlab-return)
    (define-key km "%" 'matlab-electric-comment)
    (define-key km "\C-c;" 'matlab-comment-region)
    (define-key km "\C-c:" 'matlab-uncomment-region)
    (define-key km [(control c) return] 'matlab-comment-return)
    (define-key km [(control c) (control c)] 'matlab-insert-map)
    (define-key km [(control c) (control f)] 'matlab-fill-comment-line)
    (define-key km [(control c) (control j)] 'matlab-justify-line)
    (define-key km [(control c) (control q)] 'matlab-fill-region)
    (define-key km [(control c) (control s)] 'matlab-shell-save-and-go)
    (define-key km [(control c) (control r)] 'matlab-shell-run-region)
    (define-key km [(meta control return)] 'matlab-shell-run-cell)
    (define-key km [(control c) (control t)] 'matlab-show-line-info)
    (define-key km [(control c) ?. ] 'matlab-find-file-on-path)
    (define-key km [(control h) (control m)] 'matlab-help-map)
    (define-key km [(control j)] 'matlab-linefeed)
    (define-key km "\M-\r" 'newline)
    (define-key km [(meta \;)] 'matlab-comment)
    (define-key km [(meta q)] 'matlab-fill-paragraph)
    (define-key km [(meta a)] 'matlab-beginning-of-command)
    (define-key km [(meta e)] 'matlab-end-of-command)
    (define-key km [(meta j)] 'matlab-comment-line-break-function)
    (define-key km [(meta s)] 'matlab-show-matlab-shell-buffer)
    (define-key km "\M-\t" 'matlab-complete-symbol)
    (define-key km [(meta control f)] 'matlab-forward-sexp)
    (define-key km [(meta control b)] 'matlab-backward-sexp)
    (define-key km [(meta control q)] 'matlab-indent-sexp)
    (define-key km [(meta control a)] 'matlab-beginning-of-defun)
    (define-key km [(meta control e)] 'matlab-end-of-defun)
    ;; add
    (define-key km [(control return)] 'matlab-shell-run-region-or-line)
    (if (string-match "XEmacs" emacs-version)
	(define-key km [(control meta button1)] 'matlab-find-file-click)
      (define-key km [(control meta mouse-2)] 'matlab-find-file-click))
    (substitute-key-definition 'comment-region 'matlab-comment-region
			       km) ; global-map ;torkel
    km)
  "The keymap used in `matlab-mode'.")
;; (define-key matlab-shell-mode-map (kbd "C-q") 'matlab-shell-exit)


;; 自動行末削除を行わない
;; (add-hook 'matlab-mode-hook
;;           '(lambda ()
;;              (set (make-local-variable 'whitespace-action) nil)))


;; ---------------------------------------------------------
;; python の設定
;; http://org-technology.com/posts/emacs-elpy.html
;; ---------------------------------------------------------

;; Elpy を有効化
(elpy-enable)

;; 使用する Anaconda の仮想環境を設定
(defvar venv-default "~/.pyenv/shims/ipython")

(exec-path-from-shell-copy-env "PATH")
;; (elpy-use-ipython "ipython3")
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "ipython3" python-shell-interpreter-args "--simple-prompt --pprint")


(require 'jedi)
(require 'epc)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(setq jedi:complete-on-dot t)
(require 'virtualenvwrapper)
(require 'auto-virtualenvwrapper)
(add-hook 'python-mode-hook #'auto-virtualenvwrapper-activate)

(defun elpy-setting ()
 ;; (define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tab はウィンドウの移動に用いる
 (company-mode -1)
 (auto-complete-mode -1)
 ;; (add-to-list 'ac-sources 'ac-source-jedi-direct)
 )

(add-hook 'python-mode-hook 'elpy-setting)


;; ---------------------------------------------------------
;; Ein(Jupyter Notebook) の設定
;; ---------------------------------------------------------
(require 'ein)


(eval-after-load 'ein-notebook
  '(progn
     (define-key ein:notebook-mode-map (kbd "M-n")
       'ein:worksheet-goto-next-input)
     (define-key ein:notebook-mode-map (kbd "M-p")
       'ein:worksheet-goto-prev-input)
     (define-key ein:notebook-mode-map (kbd "C-c C-n")
       'ein:worksheet-next-input-history)
     (define-key ein:notebook-mode-map (kbd "C-c C-p")
       'ein:worksheet-prev-input-history)
     (define-key ein:notebook-mode-map "\C-c\C-d"
            'ein:worksheet-delete-cell)))

(defun ein-mode-hooks ()
  ;; 行番号非表示
  (nlinum-mode -1))
(add-hook 'ein:notebook-mode-hook 'ein-mode-hooks)

;; jedi を起動
(add-hook 'ein:notebook-mode-hook 'jedi:setup)


;; ---------------------------------------------------------
;; Ruby の設定
;; http://futurismo.biz/archives/2213
;; ---------------------------------------------------------
;; 拡張子関連
(autoload 'enh-ruby-mode "enh-ruby-mode"
  "Enhanced Major mode for editing Ruby code" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))


;; ruby-electric(do, end 対応)
(require 'ruby-electric)
(defun ruby-electric-hooks ()
  (ruby-electric-mode t)
  (setq ruby-electric-expand-delimiters-list nil))
(add-hook 'enh-ruby-mode-hook 'ruby-electric-hooks)


;; ruby-block.el --- highlight matching block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)


(with-eval-after-load 'enh-ruby-mode
  ;; rcodetools
  (require 'rcodetools)
  (setq rct-find-tag-if-available nil)
  (define-key enh-ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key enh-ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key enh-ruby-mode-map "\C-c\C-f" 'rct-ri)
  )


;; rdefs
;; ソースコードの class や module, def といった宣言のラインを引っ張り出してくれるツール.
(require 'anything-rdefs)
(defun enh-ruby-anything-rdefs ()
  (define-key enh-ruby-mode (kbd "C-@") 'anything-rdefs))
(add-hook 'enh-ruby-mode-hook 'enh-ruby-anything-rdefs)


;; ruby-refactor
(require 'ruby-refactor)
(add-hook 'enh-ruby-mode-hook 'ruby-refactor-mode-launch)


;; inf-tuby
(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)


;; quickrun
(require 'quickrun)
(define-key enh-ruby-mode-map (kbd "C-c C-c") 'quickrun)
(define-key enh-ruby-mode-map (kbd "C-c c") 'quickrun-with-arg)
(setq quickrun-timeout-seconds 30)
(push '("*quickrun*" :stick t) popwin:special-display-config)


;; flycheck
(add-hook 'enh-ruby-mode-hook 'flycheck-mode)


;; dumb-jump(C-M-g/p で変数定義に飛ぶ)
(add-hook 'enh-ruby-mode-hook 'dumb-jump-mode)


;; ---------------------------------------------------------
;; scala の設定
;; http://blog.shibayu36.org/entry/2015/07/07/103000
;; ---------------------------------------------------------
(autoload 'scala-mode "scala-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))

(autoload 'ensime-scala-mode-hook "ensime"
  "Conveniance hook function that just starts ensime-mode." t)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; ensime の補完には autoo-complete を使う
(setq ensime-completion-style 'auto-complete)

(defun scala/enable-eldoc ()
  "Show error message or type name at point by Eldoc."
  (setq-local eldoc-documentation-function
              #'(lambda ()
                  (when (ensime-connected-p)
                    (let ((err (ensime-print-errors-at-point)))
                      (or (and err (not (string= err "")) err)
                          (ensime-print-type-at-point))))))
  (eldoc-mode +1))

(defun scala/completing-dot-company ()
  (cond (company-backend
         (company-complete-selection)
         (scala/completing-dot))
        (t
         (insert ".")
         (company-complete))))

(defun scala/completing-dot-ac ()
  (insert ".")
  (ac-trigger-key-command t))

;; Interactive commands
(defun scala/completing-dot ()
  "Insert a period and show company completions."
  (interactive "*")
  (eval-and-compile (require 'ensime))
  (eval-and-compile (require 's))
  (when (s-matches? (rx (+ (not space)))
                    (buffer-substring (line-beginning-position) (point)))
    (delete-horizontal-space t))
  (cond ((not (and (ensime-connected-p) ensime-completion-style))
         (insert "."))
        ((eq ensime-completion-style 'company)
         (scala/completing-dot-company))
        ((eq ensime-completion-style 'auto-complete)
         (scala/completing-dot-ac))))

;; 初期化の処理
(add-hook 'ensime-mode-hook #'scala/enable-eldoc)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(add-hook 'scala-mode-hook 'flycheck-mode)


;; ---------------------------------------------------------
;; Flycheck の設定
;; ---------------------------------------------------------
;; エラーをツールチップ表示
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

(when (require 'flycheck nil t)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(define-key elpy-mode-map (kbd "C-c C-v") 'helm-flycheck)
(smartrep-define-key elpy-mode-map "C-c"
  '(("C-n" . flycheck-next-error)
    ("C-p" . flycheck-previous-error)))

(add-hook 'after-init-hook 'global-flycheck-mode)

(defun disable-fylcheck-in-org-src-block ()
  (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(add-hook 'emacs-lisp-mode-hook 'disable-fylcheck-in-org-src-block)


;; ---------------------------------------------------------
;; YaTeX の設定
;; ---------------------------------------------------------
;; YaTeX mode
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "platex")
(setq dviprint-command-format "dvipdfmx %s")


;; 文字コードまわり
;; set YaTeX coding system
(setq YaTeX-kanji-code 4)
(setq YaTeX-inhibit-prefix-letter t)
(setq YaTeX-latex-message-code 'utf-8)


;; Mac では skim でプレビュー
(when (equal system-type 'darwin)     ;; for Mac only
  (setq dvi2-command "/usr/bin/open -a Skim")
  (setq tex-pdfview-command "/usr/bin/open -a Skim"))
(setq bibtex-command "pbibtex")
(setq dviprint-command-format "dvipdfmx")


; 自動改行を無効化
(defun yatex-delete-linum ()
  (auto-fill-mode -1))
(add-hook 'yatex-mode-hook 'yatex-delete-linum)


;; tex ファイルを開くと自動で RefTex モード
(add-hook 'yatex-mode-hook 'turn-on-reftex)

;; RefTex モードでのコマンドを選択
(setq reftex-cite-format 'natbib)

;; YaTeX モードで flycheck
(add-hook 'yatex-mode-hook 'flycheck-mode)

;; YaTeX モードで orgtbl mode
(add-hook 'yatex-mode-hook 'orgtbl-mode)


(require 'ac-math)
(defun ac-LaTeX-mode-setup () ; add ac-sources to default ac-sources
  (setq ac-sources
        (append '(ac-source-math-latex ac-source-math-unicode)
                ac-sources))
;; auto-complete-yatex
  (add-to-list 'ac-modes 'yatex-mode)
  (require 'auto-complete-latex)
  ;; キーワードの追加は以下のようにやる
  ;; (setq ac-l-source-user-keywords*
  ;;       '("aaa" "bbb" "ccc"))
      )
(add-hook 'yatex-mode-hook 'ac-LaTeX-mode-setup)
;; (setq ac-math-unicode-in-math-p t)


;; latex-math-preview
(add-hook 'yatex-mode-hook
         '(lambda ()
         (YaTeX-define-key "\C-p" 'latex-math-preview-expression)
         (YaTeX-define-key "\C-f" 'latex-math-preview-save-image-file)
         (YaTeX-define-key "\C-j" 'latex-math-preview-insert-symbol)
         ;; (YaTeX-define-key "\C-a" 'latex-math-preview-last-symbol-again)
         (YaTeX-define-key "\C-b" 'latex-math-preview-beamer-frame)))
(setq latex-math-preview-in-math-mode-p-func 'YaTeX-in-math-mode-p)
(setq latex-math-preview-latex-command "/Library/TeX/texbin/platex")
(setq latex-math-preview-command-dvipng "/Library/TeX/texbin/dvipng")
(setq latex-math-preview-command-dvips "/Library/TeX/texbin/dvips")


;; ウィンドウ設定
(require 'popwin-yatex)
(push '("*YaTeX-typesetting*" :stick t) popwin:special-display-config)
(push '("*dvi-preview*" :dedicated t) popwin:special-display-config)
(push '("*latex-math-preview-expression*") popwin:special-display-config)


(setq yatex-mode-load-hook
      '(lambda()
  (setq section-table
        (append section-table '(("mathscr") ("mathbb") ("mathfrak"))))
  ))


;; ---------------------------------------------------------
;; web-mode の設定
;; ---------------------------------------------------------
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(setq web-mode-engines-alist
'(("php"    . "\\.phtml\\'")
  ("blade"  . "\\.blade\\.")))

;; M-x impatient-mode でプレビューする
;; http://localhost:8080/imp/
(require 'impatient-mode)


;; web-mode の色
(custom-set-faces
 '(web-mode-doctype-face
   ((t (:foreground "#D78181"))))
 '(web-mode-html-tag-face
   ((t (:foreground "#4A8ACA"))))
 '(web-mode-html-attr-name-face
   ((t (:foreground "#87CEEB"))))
 '(web-mode-html-attr-equal-face
   ((t (:foreground "#FFFFFF"))))
 ;; '(web-mode-html-attr-value-face
 ;;   ((t (:foreground "#D78181"))))
 '(web-mode-comment-face
   ((t (:foreground "#969896"))))
 '(web-mode-server-comment-face
   ((t (:foreground "#969896"))))

 ;;; web-mode. css colors.
 '(web-mode-css-at-rule-face
   ((t (:foreground "#DFCF44"))))
 '(web-mode-comment-face
   ((t (:foreground "#969896"))))
 '(web-mode-css-selector-face
   ((t (:foreground "#DFCF44"))))
 '(web-mode-css-pseudo-class
   ((t (:foreground "#DFCF44"))))
 '(web-mode-css-property-name-face
   ((t (:foreground "#87CEEB"))))
 ;; '(web-mode-css-string-face
 ;;   ((t (:foreground "#D78181"))))
 )


;; インデント
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook)


; auto tag closing
;0=no auto-closing
;1=auto-close with </
;2=auto-close with > and </
(setq web-mode-tag-auto-close-style 2)


;; ---------------------------------------------------------
;; emmet-mode の設定
;; ---------------------------------------------------------
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップ言語全部で使う
(add-hook 'web-mode-hook 'emmet-mode) ;; web-mode で使う
(add-hook 'css-mode-hook  'emmet-mode) ;; CSS にも使う
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent はスペース 2 個
(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tab の被りを回避
(define-key emmet-mode-keymap (kbd "H-i") 'emmet-expand-line) ;; C-i で展開

(require 'ac-emmet)
(add-hook 'sgml-mode-hook 'ac-emmet-html-setup)
;; (add-hook 'css-mode-hook 'ac-emmet-css-setup)
(add-hook 'web-mode-hook 'ac-emmet-html-setup)
;; (add-hook 'web-mode-hook 'ac-emmet-css-setup)
(add-hook 'web-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-emmet-html-snippets t)))
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (add-to-list 'ac-sources 'ac-source-emmet-css-snippets t)))


;; ---------------------------------------------------------
;; javascript の設定
;; ---------------------------------------------------------
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


(add-hook 'js2-mode-hook
    (lambda ()
        (tern-mode t)))


(eval-after-load 'tern
    '(progn
        (require 'tern-auto-complete)
        (tern-ac-setup)))


;; ---------------------------------------------------------
;; Markdown-mode の設定
;; 参考：https://github.com/niku/markdown-preview-eww
;; ---------------------------------------------------------
(require 'markdown-mode)

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; eww でプレビューする
(require 'markdown-preview-eww)
(define-key markdown-mode-map (kbd "C-c e") 'markdown-preview-eww)

;; ブラウザで github ライクにプレビュー
;; pip install grip をしておく
(setq github-user "ymattu")
(setq github-pass (my-lisp-load "githubpass"))
(defun my-markdown-preview ()
  (interactive)
  (when (get-process "grip")
    (kill-process "grip"))
  (sleep-for 0.5)  ;; Wait for process exit
  (start-process "grip" "*grip*" "grip" (format "--user=%s" github-user) (format "--pass=%s" github-pass) "--browser" buffer-file-name)
  (when (get-process "grip")
    (set-process-query-on-exit-flag (get-process "grip") nil))
  )
(define-key markdown-mode-map (kbd "C-c r") 'my-markdown-preview)


(defun my--markdown-entery-key-ad (this-func &rest args)
  "markdown-mode で skk-henkan-mode 中にエンターすると行頭にカーソルが飛んでしまう問題の対応"
  (if skk-henkan-mode (skk-kakutei)
    (apply this-func args)))
(advice-add #'markdown-enter-key :around #'my--markdown-entery-key-ad)


(defun md-mode-hooks ()
  (auto-complete-mode 1))
(add-hook 'markdown-mode-hook 'md-mode-hooks)


;; 見出しの色
(custom-set-faces
 '(markdown-header-face-1 ((t (:inherit org-level-1))))
 '(markdown-header-face-2 ((t (:inherit org-level-2))))
 '(markdown-header-face-3 ((t (:inherit org-level-3))))
 '(markdown-header-face-4 ((t (:inherit org-level-4))))
 '(markdown-header-face-5 ((t (:inherit org-level-5))))
 '(markdown-header-face-6 ((t (:inherit org-level-6))))
)

;; 折りたたみ
(add-hook 'markdown-mode-hook
  (lambda()
    (define-key markdown-mode-map (kbd "M-f") 'markdown-cycle)
    (hide-sublevels 4)))

(make-variable-buffer-local 'my-outline-level)
    (setq-default my-outline-level 1)

    (defun my-global-cycle-md ()
      (interactive)
      (cond
       ((eq my-outline-level 1)
        (hide-sublevels 2)
        (setq my-outline-level 2))
       ((eq my-outline-level 2)
        (hide-sublevels 3)
        (setq my-outline-level 3))
       ((eq my-outline-level 3)
        (hide-sublevels 1)
        (setq my-outline-level 1))))

(add-hook 'markdown-mode-hook
  (lambda()
    (define-key markdown-mode-map (kbd "M-i") 'my-global-cycle-md)))


;; ---------------------------------------------------------
;; hatena-blog-mode の設定
;; 参考：http://fnwiya.hatenablog.com/entry/2015/11/28/212302
;; ---------------------------------------------------------
(require 'hatena-blog-mode)
(setq hatena-id "songcunyouzai")
(setq hatena-blog-api-key  (my-lisp-load "hatena-blog-api-key"))
(setq hatena-blog-id "y-mattu.hatenablog.com")
(setq hatena-blog-editing-mode "md") ;; markdown
(setq hatena-blog-backup-dir "/Users/matsumurayuuya/Desktop/blog")

;; キーバインド
(evil-leader/set-key "bw" 'hatena-blog-write)
(evil-leader/set-key-for-mode 'markdown-mode "bp" 'hatena-blog-post)


;; ---------------------------------------------------------
;; twittering-mode の設定
;; 参考: https://www.emacswiki.org/emacs/TwitteringMode-ja
;; ---------------------------------------------------------
(when (require 'twittering-mode nil t)
  ;; アイコンを表示する
  (setq twittering-icon-mode t)
  ;; タイムラインを 90 秒ごとに更新する
  (setq twittering-timer-interval 60))

(setq twittering-account-authorization 'authorized)
(setq twittering-oauth-access-token-alist
      '(("oauth_token" . (my-lisp-load "tw-oauth-token"))
        ("oauth_token_secret" . (my-lisp-load "tw-oauth-token-secret"))
        ("user_id" . "1251607231")
        ("screen_name" . "y__mattu")))
(defun twittering-mode-hook-func ()
  (define-key twittering-mode-map (kbd "F") 'twittering-favorite))
(add-hook 'twittering-mode-hook 'twittering-mode-hook-func)

(defun twit-delete-linum ()
  (nlinum-mode -1))
(add-hook 'twittering-mode-hook 'twit-delete-linum)


;; ---------------------------------------------------------
;; csv-mode の設定
;; ---------------------------------------------------------
(require 'cl)
(require 'csv-mode)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


;; ---------------------------------------------------------
;; magit の設定
;; ---------------------------------------------------------
(require 'magit)

(setq magit-git-executable "/usr/bin/git")

(setq-default magit-auto-revert-mode nil)
(eval-after-load "vc" '(remove-hook 'find-file-hooks 'vc-find-file-hook))
;; (global-set-key (kbd "C-c m") 'magit-status)
(evil-leader/set-key "ms" 'magit-status)
;; (global-set-key (kbd "C-c l") 'magit-blame)
(evil-leader/set-key "mb" 'magit-blame)


;; magit のログで、コミット日時を時刻で表示させる
(defun magit-format-duration--format-date (duration spec width)
  (format-time-string "%y-%m-%dT%H:%M:%S"
                      (seconds-to-time (- (float-time) duration))))
(advice-add 'magit-format-duration :override
            'magit-format-duration--format-date)
(defun magit-log-margin-set-timeunit-width--fixed ()
  (setq magit-log-margin-timeunit-width 9))
(advice-add 'magit-log-margin-set-timeunit-width :override
            'magit-log-margin-set-timeunit-width--fixed)
(setq magit-log-margin-spec '(24 9 magit-duration-spec))


;; 行番号は非表示
(defun magit-nlinum-delete ()
  (nlinum-mode -1))
(add-hook 'magit-popup-mode-hook 'magit-nlinum-delete)


;; 文字化け対策
(add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))
(add-hook 'git-commit-mode-hook
          '(lambda ()
             (set-buffer-file-coding-system 'utf-8)))

;; magit を全画面で
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows)
  )

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))


(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

;; evil key bindings
(evil-set-initial-state 'magit-log-edit-mode 'insert)
(evil-set-initial-state 'git-commit-mode 'insert)
(evil-set-initial-state 'magit-commit-mode 'motion)
(evil-set-initial-state 'magit-status-mode 'motion)
(evil-set-initial-state 'magit-log-mode 'motion)
(evil-set-initial-state 'magit-wassup-mode 'motion)
(evil-set-initial-state 'magit-mode 'motion)
(evil-set-initial-state 'git-rebase-mode 'motion)

(evil-define-key 'motion git-rebase-mode-map
  "c" 'git-rebase-pick
  "r" 'git-rebase-reword
  "s" 'git-rebase-squash
  "e" 'git-rebase-edit
  "f" 'git-rebase-fixup
  "y" 'git-rebase-insert
  "d" 'git-rebase-kill-line
  "u" 'git-rebase-undo
  "x" 'git-rebase-exec
  (kbd "<return>") 'git-rebase-show-commit
  "\M-n" 'git-rebase-move-line-down
  "\M-p" 'git-rebase-move-line-up)

(evil-define-key 'motion magit-commit-mode-map
  "\C-c\C-b" 'magit-show-commit-backward
  "\C-c\C-f" 'magit-show-commit-forward)

(evil-define-key 'motion magit-status-mode-map
  "\C-f" 'evil-scroll-page-down
  "\C-b" 'evil-scroll-page-up
  "." 'magit-mark-item
  "=" 'magit-diff-with-mark
  "C" 'magit-add-log
  "I" 'magit-ignore-item-locally
  "S" 'magit-stage-all
  "U" 'magit-unstage-all
  "W" 'magit-toggle-whitespace
  "X" 'magit-reset-working-tree
  "d" 'magit-discard-item
  "i" 'magit-ignore-item
  "s" 'magit-stage-item
  "u" 'magit-unstage-item
  "z" 'magit-key-mode-popup-stashing)

(evil-define-key 'motion magit-log-mode-map
  "." 'magit-mark-item
  "=" 'magit-diff-with-mark
  "e" 'magit-log-show-more-entries)

(evil-define-key 'motion magit-wazzup-mode-map
  "." 'magit-mark-item
  "=" 'magit-diff-with-mark
  "i" 'magit-ignore-item)

(evil-set-initial-state 'magit-branch-manager-mode 'motion)
(evil-define-key 'motion magit-branch-manager-mode-map
  "a" 'magit-add-remote
  "c" 'magit-rename-item
  "d" 'magit-discard-item
  "o" 'magit-create-branch
  "v" 'magit-show-branches
  "T" 'magit-change-what-branch-tracks)

(evil-define-key 'motion magit-mode-map
  "\M-1" 'magit-show-level-1-all
  "\M-2" 'magit-show-level-2-all
  "\M-3" 'magit-show-level-3-all
  "\M-4" 'magit-show-level-4-all
  "\M-H" 'magit-show-only-files-all
  "\M-S" 'magit-show-level-4-all
  "\M-h" 'magit-show-only-files
  "\M-s" 'magit-show-level-4
  "!" 'magit-run-popup
  "$" 'magit-process
  "+" 'magit-diff-larger-hunks
  "-" 'magit-diff-smaller-hunks
  "=" 'magit-diff-default-hunks
  "/" 'evil-search-forward
  ":" 'evil-ex
  ";" 'magit-git-command
  "?" 'evil-search-backward
  "<" 'magit-stash-pop
  "A" 'magit-cherry-pick-item
  "B" 'magit-bisect-popup
  "D" 'magit-revert-item
  "E" 'magit-ediff
  "F" 'magit-pull-popup
  "G" 'evil-goto-line
  "H" 'magit-rebase-step
  "J" 'magit-key-mode-popup-apply-mailbox
  "K" 'magit-dispatch-popup
  "L" 'magit-add-change-log-entry
  "M" 'magit-remote-popup
  "N" 'evil-search-previous
  "P" 'magit-push-popup
  "Q" 'magit-quit-session
  "R" 'magit-refresh-all
  "S" 'magit-stage-all
  "U" 'magit-unstage-all
  "W" 'magit-diff-working-tree
  "X" 'magit-reset-working-tree
  "Y" 'magit-interactive-rebase
  "Z" 'magit-stash-pop
  "a" 'magit-apply-item
  "b" 'magit-branch-popup
  "c" 'magit-commit-popup
  "e" 'magit-diff
  "f" 'magit-key-mode-popup-fetching
  "g?" 'magit-describe-item
  "g$" 'evil-end-of-visual-line
  "g0" 'evil-beginning-of-visual-line
  "gE" 'evil-backward-WORD-end
  "g^" 'evil-first-non-blank-of-visual-line
  "g_" 'evil-last-non-blank
  "gd" 'evil-goto-definition
  "ge" 'evil-backward-word-end
  "gg" 'evil-goto-first-line
  "gj" 'evil-next-visual-line
  "gk" 'evil-previous-visual-line
  "gm" 'evil-middle-of-visual-line
  "h" 'magit-key-mode-popup-rewriting
  "j" 'magit-section-forward
  "k" 'magit-section-backward
  "l" 'magit-log-popup
  "m" 'magit-merge-popup
  "n" 'evil-search-next
  "o" 'magit-submodule-popup
  "p" 'magit-cherry
  "q" 'magit-mode-quit-window
  "r" 'magit-refresh
  "t" 'magit-tag-popup
  "v" 'magit-revert-item
  "w" 'magit-wazzup
  "x" 'magit-reset-head
  "y" 'magit-copy-item-as-kill
  ;z  position current line
  " " 'magit-show-item-or-scroll-up
  "\d" 'magit-show-item-or-scroll-down
  "\t" 'magit-visit-item
  (kbd "<return>")   'magit-toggle-section
  (kbd "C-<return>") 'magit-dired-jump
  (kbd "<backtab>")  'magit-expand-collapse-section
  (kbd "C-x 4 a")    'magit-add-change-log-entry-other-window
  (kbd "\M-d") 'magit-copy-item-as-kill)


;; ---------------------------------------------------------
;; diff-hl の設定
;; ---------------------------------------------------------
(require 'diff-hl)
; バージョン管理下のコードをハイライト
(global-diff-hl-mode)


;; ---------------------------------------------------------
;; gist の設定
;; ---------------------------------------------------------
;; (require 'gist)
;; (require 'anything-gist)


;; ---------------------------------------------------------
;; projectile の設定
;; ---------------------------------------------------------
(require 'projectile)
(require 'helm-projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)


;; ---------------------------------------------------------
;; google-this の設定
;; ---------------------------------------------------------
(setq google-this-keybind (kbd "C-x g"))
(google-this-mode 1)
(require 'google-this)
(setq google-this-location-suffix "co.jp")
(defun google-this-url () "URL for google searches."
  ;; 100 件/日本語ページ/5 年以内ならこのように設定する
  (concat google-this-base-url google-this-location-suffix
          "/search?q=%s&hl=ja&num=100&as_qdr=y5"))


;; ---------------------------------------------------------
;; google-translate の設定
;; ---------------------------------------------------------
(require 'google-translate)
(require 'google-translate-default-ui)

(defvar google-translate-english-chars "[:ascii:]"
  "これらの文字が含まれているときは英語とみなす")
(defun google-translate-enja-or-jaen (&optional string)
  "region か現在位置の単語を翻訳する。C-u 付きで query 指定も可能"
  (interactive)
  (setq string
        (cond ((stringp string) string)
              (current-prefix-arg
               (read-string "Google Translate: "))
              ((use-region-p)
               (buffer-substring (region-beginning) (region-end)))
              (t
               (thing-at-point 'word))))
  (let* ((asciip (string-match
                  (format "\\`[%s]+\\'" google-translate-english-chars)
                  string)))
    (run-at-time 0.1 nil 'deactivate-mark)
    (google-translate-translate
     (if asciip "en" "ja")
     (if asciip "ja" "en")
     string)))

(push '("\*Google Translate\*" :height 0.3 :stick t) popwin:special-display-config)

(global-set-key (kbd "C-x t") 'google-translate-enja-or-jaen)


;; ---------------------------------------------------------
;; Auto-insert の設定
;; ---------------------------------------------------------
(require 'autoinsert)
(auto-insert-mode 1)
(add-hook 'find-file-hooks 'auto-insert)
;; (setq auto-insert-query nil) ;; 自動補完しますか?って最初に聞かれる機能のオンオフ


;; ---------------------------------------------------------
;; yatemplate の設定
;; ---------------------------------------------------------
(yatemplate-fill-alist)
(auto-insert-mode 1)
(defun find-file-hook--yatemplate ()
  "yatemplate の snippet のテストができるようにするために snippet-mode にする"
  (when (string-match "emacs.*/templates/" buffer-file-name)
    (let ((mode major-mode))
      (snippet-mode)
      (setq-local yas--guessed-modes (list mode)))))
(add-hook 'find-file-hook 'find-file-hook--yatemplate)
(defun after-save-hook--yatemplate ()
  "yatemplate ファイル保存後、auto-insert-alist に反映させる"
  (when (string-match "emacs.*/templates/" buffer-file-name)
    (yatemplate-fill-alist)))
(add-hook 'after-save-hook 'after-save-hook--yatemplate)


;; ---------------------------------------------------------
;; sql-mode の設定
;; ---------------------------------------------------------
;; SQL 文の整形をする設定
;; http://qiita.com/sambatriste/items/b44b3e5d4d76a8e0a344
; 実行する外部コマンド
(setq sql-format-external-command
  (concat "java -jar " (expand-file-name "~/.emacs.d/lib/sql-formatter-1.0.0-jar-with-dependencies.jar")))

; SQL 文をフォーマットする関数
(defun my-format-sql (begin end)
  "バッファまたはリージョン内の SQL 文を整形する。"
  (interactive "r")
  (unless mark-active
    (setq begin (point-min))
    (setq end (point-max)))
  (save-excursion
    (shell-command-on-region
     begin
     end
     sql-format-external-command
     nil
     t ;; replace buffer
     )))

;; キーバインド設定
(with-eval-after-load "sql"
  (define-key sql-mode-map (kbd "C-s-f") 'my-format-sql))


;; ---------------------------------------------------------
;; eww の設定
;; ---------------------------------------------------------
(require 'eww)
;; キーバインド
(define-key eww-mode-map "r" 'eww-reload)
(define-key eww-mode-map "c 0" 'eww-copy-page-url)
(define-key eww-mode-map "n" 'scroll-down)
(define-key eww-mode-map "p" 'scroll-up)


;; 背景色の設定
(defvar eww-disable-colorize t)
(defun shr-colorize-region-disable (orig start end fg &optional bg &rest _)
       (unless eww-disable-colorize
         (funcall orig start end fg)))

(advice-add ' shr-colorize-region :around ' shr-colorize-region-disable)
(advice-add ' eww-colorize-region :around ' shr-colorize-region-disable)
(defun eww-disable-color ()
  "eww で文字色を反映させない"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))

(defun eww-enable-color ()
  "eww で文字色を反映させる"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))

;; デフォルトの検索エンジンを google に変更
(setq eww-search-prefix "http://www.google.co.jp/search?q=")

;; duckduckgo の設定
;; (setq eww-search-prefix "https://duckduckgo.com/html/?kl=jp-jp&k1=-1&kc=1&kf=-1&q=")

;; eww を複数起動する
(defun eww-mode-hook-rename-buffer ()
       "Rename eww browser ’ s buffer so sites open in new page."
       (rename-buffer "eww" t))
(add-hook 'eww-mode-hook 'eww-mode-hook-rename-buffer)

;; 検索結果にハイライトをつける
;; (defun eww-search (term)
;;   (interactive "sSearch terms: ")
;;   (setq eww-hl-search-word term)
;;   (eww-browse-url (concat eww-search-prefix term)))

;; (add-hook 'eww-after-render-hook (lambda ()
;;                   (highlight-regexp eww-hl-search-word)
;;                   (setq eww-hl-search-word nil)))


;; 現在の url を 外部ブラウザ で開く
(defun eww-browse-open ()
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "google-chrome"))
(add-hook 'eww-mode-hook 'eww-browse-open)


;; 現在の url を eww で開く
(defun browse-url-with-eww ()
  (interactive)
  (let ((url-region (bounds-of-thing-at-point 'url)))
    ;; url
    (if url-region
        (eww-browse-url (buffer-substring-no-properties (car url-region)
                                                        (cdr url-region))))
    ;; org-link
    (setq browse-url-browser-function 'eww-browse-url)
    (org-open-at-point)))

(global-set-key (kbd "s-p") 'browse-url-with-eww)


(defun eww-disable-images ()
  "eww で画像表示させない"
  (interactive)
  (setq-local shr-put-image-function 'shr-put-image-alt)
  (eww-reload))

(defun eww-enable-images ()
  "eww で画像表示させる"
  (interactive)
  (setq-local shr-put-image-function 'shr-put-image)
  (eww-reload))

(defun shr-put-image-alt (spec alt &optional flags)
  (insert alt))

;; はじめから非表示
(defun eww-mode-hook-disable-image ()
       (setq-local shr-put-image-function 'shr-put-image-alt))

(add-hook 'eww-mode-hook 'eww-mode-hook-disable-image)


;; ace-link
(require 'ace-link)
;; (eval-after-load 'eww '(define-key eww-mode-map "f" 'ace-link-eww))
(ace-link-setup-default)


;; 行番号を切る
(defun eww-delete-linum ()
  (interactive)
  (nlinum-mode -1))
(add-hook 'eww-mode-hook 'eww-delete-linum)


;; eww-copy-page-url (y) で現在の URL をクリップボードにコピー.
(defun eww-copy-page-org-link ()
  (interactive)
  (my/copy-org-link (eww-current-url) (eww-current-title)))
(define-key eww-mode-map (kbd "y") 'eww-copy-page-org-link)


;; eww モードでは evil モードを切る
(evil-make-overriding-map eww-mode-map 'emacs)


;; epub とかを eww で見る
(pandoc-turn-on-advice-eww)


;; ---------------------------------------------------------
;; regex-tools の設定
;; ---------------------------------------------------------
(require 'regex-tool)

(defun regex-render-ruby (regex sample)
  (with-temp-buffer
    (insert (format "
line = DATA.read
re = /%s/
print '('
pos = 0
while md=re.match(line,pos)
  printf '(%%d %%d', md.begin(0), md.end(0)-md.begin(0)
  puts
  md.captures.each_with_index{|c,i| printf '(%%d . %%s)', i+1,c.inspect }
  pos = md.end(0)
  puts ')'
end
print ')'
__END__
%s" regex sample))
    (insert (format ""))
   (call-process-region (point-min) (point-max) "ruby" t t)
   (goto-char (point-min))
   (read (current-buffer))))

(defun regex-tool-emacs ()
  (interactive)
  (setq regex-tool-backend 'emacs)
  (regex-tool))

(defun regex-tool-perl ()
  (interactive)
  (setq regex-tool-backend 'perl)
  (advice-remove 'regex-render-perl 'regex-render-ruby)
  (regex-tool))

(defun regex-tool-ruby ()
  (interactive)
  (setq regex-tool-backend 'perl)
  (advice-add 'regex-render-perl :override 'regex-render-ruby)
  (regex-tool))


;; ---------------------------------------------------------
;; col-highlight の設定
;; ---------------------------------------------------------
;; カーソル位置を十字形にハイライトできる
(require 'col-highlight)

(global-set-key (kbd "A-c") 'flash-column-highlight)

(custom-set-faces
 '(col-highlight ((t (:inherit hl-line)))))


;; ---------------------------------------------------------
;; lilypond-mode の設定
;; ---------------------------------------------------------
(add-to-list 'load-path "~//dotfiles.emacs.d/elpa/lilypond")
(require 'lilypond-mode)
(add-to-list 'auto-mode-alist '("\\.ly" . LilyPond-mode))
(add-hook 'LilyPond-mode-hook 'turn-on-font-lock)
(require 'ac-lilypond)

(add-hook 'LilyPond-mode-hook (function (lambda ()
                                          (add-to-list 'LilyPond-command-alist
                                                       '("OpenPDF" "open -a Skim '%f'"))
                                          )))

(push '("*compilarion*" :stick t) popwin:special-display-config)


;; ---------------------------------------------------------
;; 0blayout の設定
;; ---------------------------------------------------------
(setq 0blayout-mode-map (make-sparse-keymap))
;; キーバインドを正す
(evil-leader/set-key "lc" '0blayout-new)
(evil-leader/set-key "lk" '0blayout-kill)
(evil-leader/set-key "lb" '0blayout-switch)
;; 念のため
(define-key 0blayout-mode-map (kbd "C-c w c") '0blayout-new)
(define-key 0blayout-mode-map (kbd "C-c w k") '0blayout-kill)
(define-key 0blayout-mode-map (kbd "C-c w b") '0blayout-switch)
(0blayout-mode 1)


;; ---------------------------------------------------------
;; dockerfile-mode の設定
;; ---------------------------------------------------------
(autoload 'dockerfile-mode "dockerfile-mode" nil t)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))


;; ---------------------------------------------------------
;; xonshrcの設定
;; ---------------------------------------------------------
(add-to-list 'auto-mode-alist '(".xonshrc\\'" . python-mode))

