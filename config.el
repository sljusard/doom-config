;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq shell-file-name (executable-find "bash"))

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font"
                            :size 14
                            :weight 'regular)

      doom-big-font (font-spec :family "JetBrainsMono Nerd Font"
                                :size 20)

      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font"
                                           :size 14)

      doom-symbol-font (font-spec :family "JetBrainsMono Nerd Font"
                                   :size 14))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-agenda-files
      '("~/org/log/"
        "~/org/log/journals/"
        "~/org/log/tasks/"
        "~/org/log/projects/"))

(setq org-hide-emphasis-markers t)

(add-hook 'org-mode-hook
          (lambda ()
            (progn
              (setq left-margin-width 2)
              (setq right-margin-width 2)
              (set-window-buffer nil (current-buffer)))))

(setq calendar-week-start-day 1)

;; 'org-roam' settings
(setq org-roam-directory "~/org/")
(setq org-roam-db-location "~/org/org-roam.db")
(setq org-roam-dailies-directory "log/")
(org-roam-db-autosync-mode)


;; 'org-attach' settings
(setq org-attach-use-inheritance t)
(setq org-startup-with-inline-images t)
(setq org-attach-auto-tag nil)
(setq org-image-max-width 300)

;; time settings
;; (setenv "TZ" "UTC0")
(setq system-time-locale "C")
(setq org-timestamp-formats '("%Y-%m-%d %a" . "%Y-%m-%d %a %H:%M %z"))
(setq org-property-format "%s %s")

;; org-log
(setq org-log-into-drawer t)
(setq org-habit-show-habits-only-for-today nil)

;; 'org-roam' node RU -> EN transliteration
(after! org-roam
    (defun my/translit-russian (str)
        "ICAO Cyrillic to Latin transliteration (RU -> EN)"
        (let ((translit-table
            '(("а" . "a") ("б" . "b") ("в" . "v") ("г" . "g")
                ("д" . "d") ("е" . "e") ("ё" . "e") ("ж" . "zh")
                ("з" . "z") ("и" . "i") ("й" . "i") ("к" . "k")
                ("л" . "l") ("м" . "m") ("н" . "n") ("о" . "o")
                ("п" . "p") ("р" . "r") ("с" . "s") ("т" . "t")
                ("у" . "u") ("ф" . "f") ("х" . "kh") ("ц" . "ts")
                ("ч" . "ch") ("ш" . "sh") ("щ" . "shch") ("ъ" . "ie")
                ("ы" . "y") ("ь" . "") ("э" . "e") ("ю" . "iu")
                ("я" . "ia")
                ("А" . "a") ("Б" . "b") ("В" . "v") ("Г" . "g")
                ("Д" . "d") ("Е" . "e") ("Ё" . "e") ("Ж" . "zh")
                ("З" . "z") ("И" . "i") ("Й" . "i") ("К" . "k")
                ("Л" . "l") ("М" . "m") ("Н" . "n") ("О" . "o")
                ("П" . "p") ("Р" . "r") ("С" . "s") ("Т" . "t")
                ("У" . "u") ("Ф" . "f") ("Х" . "kh") ("Ц" . "ts")
                ("Ч" . "ch") ("Ш" . "sh") ("Щ" . "shch") ("Ъ" . "ie")
                ("Ы" . "y") ("Ь" . "") ("Э" . "e") ("Ю" . "iu")
                ("Я" . "ia"))))
        (dolist (pair translit-table str)
            (setq str (replace-regexp-in-string
                    (car pair) (cdr pair) str)))))

    (defun my/org-roam-slug (node)
        "Generate ${slug} with transliteration from Cyrillic using my/translit-russian"
        (let* ((title (org-roam-node-title node))
            (translitted (my/translit-russian title))
            (slug (replace-regexp-in-string
                    "[^a-z0-9]+" "-"
                    (downcase translitted))))
        (string-trim slug "-")))
    (advice-add 'org-roam-node-slug :override #'my/org-roam-slug)
)

(defun my/month-russian-genitive (&optional time)
  "%m override in Russian (genitive case)"
  (let ((month (string-to-number (format-time-string "%m" time))))
    (nth (1- month)
        '("января" "февраля" "марта" "апреля" "мая" "июня"
        "июля" "августа" "сентября" "октября" "ноября" "декабря"))))

;; 'org-roam' project file numeration
(defun my/org-roam-project-next-index ()
  "Return next index number for current year project"
  (let* ((year (format-time-string "%Y"))
        (dir (expand-file-name "log/projects/" org-roam-directory))
        (pattern (concat "^project-" year "-\\([0-9]\\{3\\}\\)"))
        (files (directory-files dir nil pattern))
        (numbers (mapcar
                (lambda (f)
                    (when (string-match pattern f)
                    (string-to-number (match-string 1 f))))
                files))
        (numbers (delq nil numbers)))
    (format "%03d" (1+ (if numbers (apply #'max numbers) 0)))))

;; 'org-attach' file renamer
(after! org-attach
  (defun my/org-attach-rename-on-attach (file)
    "Rename attachment on copying it to org-attach folder."
    (let* ((ext (file-name-extension file t))
           (new-name (concat (format-time-string "image-%Y%m%d%H%M%S" nil t) ext))
           (temp-path (expand-file-name new-name temporary-file-directory)))
      (copy-file file temp-path t)
      temp-path))
  (advice-add 'org-attach-attach :filter-args
              (lambda (args)
                (cons (my/org-attach-rename-on-attach (car args))
                      (cdr args)))))

;; Templates
(after! org-roam
    (setq org-roam-capture-templates
        '(
            ("d" "Default" plain "%?"
            :target (file+head "roam/%<%Y%m%d%H%M%S>-${slug}.org"
                                ":PROPERTIES:\n:CREATED: %U\n:END:\n#+TITLE: ${title}\n#+AUTHOR: Denis Sliusar\n")
            :unnarrowed t)
            ("p" "Project" plain "%?"
            :target (file+head "log/projects/project-%<%Y>-%(my/org-roam-project-next-index)-${slug}.org"
                                "#+TITLE: ${title}\n#+AUTHOR: Denis Sliusar\n#+CATEGORY: Project\n#+STARTUP: show2levels\n* PROJ ${title}")
            :unnarrowed t)
            ("j" "Journal" entry "* %<%d> %? %<%Y>"
            :target (file+head "log/journals/journal-%<%Y>-%<%m>.org"
                            "#+TITLE: ${title}\n#+AUTHOR: Denis Sliusar\n#+STARTUP: fold\n")
            :unnarrowed t)
            ))

    (setq org-roam-dailies-capture-templates
        '(("j" "Journal" entry "* %<%d> %(my/month-russian-genitive) %<%Y>\n%?"
            :target (file+head "journals/journal-%<%Y>-%<%m>.org"
                            "#+TITLE: ${title}\n#+AUTHOR: Denis Sliusar\n#+STARTUP: fold\n")
            :unnarrowed t
            :prepare-finalize org-id-get-create)))
)

(setq org-capture-templates
    '(("g" "Videogame" entry
       (file+headline "videogames.org" "Библиотека")
       "** %?\n:PROPERTIES:\n:RELEASE_DATE:\n:DEVELOPER:\n:PUBLISHER:\n:FIRST_LAUNCH:\n:LAST_LAUNCH:\n:PLAYTIME:\n:END:\n"
       :prepare-finalize org-id-get-create)
      ("i" "Idea" entry
       (file+headline "log/ideas.org" "Обдумать")
       "** IDEA %?")
      ))

;; using RU layout for commands
(use-package reverse-im
  :config
  (require 'quail)
  (quail-define-package
   "russian-colemak" "Russian" "RU-CMK" nil
   "russian-computer Colemak override."
   nil t t t t nil nil nil nil nil t)

  (quail-define-rules
   ("q" ?й) ("w" ?ц) ("f" ?у) ("p" ?к) ("g" ?е)
   ("j" ?н) ("l" ?г) ("u" ?ш) ("y" ?щ) (";" ?з)
   ("[" ?х) ("]" ?ъ)
   ("a" ?ф) ("r" ?ы) ("s" ?в) ("t" ?а) ("d" ?п)
   ("h" ?р) ("n" ?о) ("e" ?л) ("i" ?д) ("o" ?ж)
   ("'" ?э)
   ("z" ?я) ("x" ?ч) ("c" ?с) ("v" ?м) ("b" ?и)
   ("k" ?т) ("m" ?ь) ("," ?б) ("." ?ю)
   ("Q" ?Й) ("W" ?Ц) ("F" ?У) ("P" ?К) ("G" ?Е)
   ("J" ?Н) ("L" ?Г) ("U" ?Ш) ("Y" ?Щ) (":" ?З)
   ("{" ?Х) ("}" ?Ъ)
   ("A" ?Ф) ("R" ?Ы) ("S" ?В) ("T" ?А) ("D" ?П)
   ("H" ?Р) ("N" ?О) ("E" ?Л) ("I" ?Д) ("O" ?Ж)
   ("\"" ?Э)
   ("Z" ?Я) ("X" ?Ч) ("C" ?С) ("V" ?М) ("B" ?И)
   ("K" ?Т) ("M" ?Ь) ("<" ?Б) (">" ?Ю))

  (setq reverse-im-input-methods '("russian-colemak"))
  (reverse-im-mode 1))

;; 'elfeed' settings
(setq elfeed-feeds
      '(("https://www.factorio.com/blog/rss" videogame)
        ("https://planet.emacslife.com/atom.xml" software)
        ("https://ru.themoscowtimes.com/rss/news" news politics)
        ("https://www.nasa.gov/feeds/iotd-feed" space)))

;; (map! :leader
;;      "e o" #'elfeed)
;; (map! :leader
;;      "e t" #'elfeed-tree)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
