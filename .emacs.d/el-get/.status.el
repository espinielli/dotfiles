<<<<<<< HEAD
((el-get status "required" recipe nil)
 (psvn status "installed" recipe
       (:name psvn :description "Subversion interface for emacs" :type http :url "http://www.xsteve.at/prg/emacs/psvn.el"))
=======
((auctex status "installed" recipe
	 (:name auctex :website "http://www.gnu.org/software/auctex/" :description "AUCTeX is an extensible package for writing and formatting TeX files in GNU Emacs and XEmacs. It supports many different TeX macro packages, including AMS-TeX, LaTeX, Texinfo, ConTeXt, and docTeX (dtx files)." :type cvs :module "auctex" :url ":pserver:anonymous@cvs.sv.gnu.org:/sources/auctex" :build
		`(("./autogen.sh")
		  ("./configure" "--without-texmf-dir" "--with-lispdir=`pwd`" ,(concat "--with-emacs=" el-get-emacs))
		  "make")
		:load-path
		("." "preview")
		:load
		("tex-site.el" "preview/preview-latex.el")
		:info "doc"))
 (auto-complete status "installed" recipe
		(:name auto-complete :website "http://cx4a.org/software/auto-complete/" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
		       (popup fuzzy)))
 (auto-complete-yasnippet status "installed" recipe
			  (:name auto-complete-yasnippet :description "Auto-complete sources for YASnippet" :type http :url "http://www.cx4a.org/pub/auto-complete-yasnippet.el" :depends
				 (auto-complete yasnippet)))
 (buffer-move status "installed" recipe
	      (:name buffer-move :description "Swap buffers without typing C-x b on each window" :type emacswiki :features buffer-move :after
		     (progn
		       (global-set-key
			(kbd "<C-S-up>")
			'buf-move-up)
		       (global-set-key
			(kbd "<C-S-down>")
			'buf-move-down)
		       (global-set-key
			(kbd "<C-S-left>")
			'buf-move-left)
		       (global-set-key
			(kbd "<C-S-right>")
			'buf-move-right))))
 (color-theme status "installed" recipe
	      (:name color-theme :description "An Emacs-Lisp package with more than 50 color themes for your use. For questions about color-theme" :website "http://www.nongnu.org/color-theme/" :type http-tar :options
		     ("xzf")
		     :url "http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz" :load "color-theme.el" :features "color-theme" :post-init
		     (progn
		       (color-theme-initialize)
		       (setq color-theme-is-global t))))
 (color-theme-sanityinc status "removed" recipe nil)
 (color-theme-solarized status "installed" recipe
			(:name color-theme-solarized :description "Emacs highlighting using Ethan Schoonover's Solarized color scheme" :type github :pkgname "sellout/emacs-color-theme-solarized" :depends color-theme :prepare
			       (progn
				 (add-to-list 'custom-theme-load-path default-directory)
				 (autoload 'color-theme-solarized-light "color-theme-solarized" "color-theme: solarized-light" t)
				 (autoload 'color-theme-solarized-dark "color-theme-solarized" "color-theme: solarized-dark" t))))
 (color-theme-tango status "installed" recipe
		    (:name color-theme-tango :description "Color theme based on Tango Palette. Created by danranx@gmail.com" :type emacswiki :depends color-theme :prepare
			   (autoload 'color-theme-tango "color-theme-tango" "color-theme: tango" t)))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :features el-get :info "." :load "el-get.el"))
 (emacs-goodies-el status "installed" recipe
		   (:name emacs-goodies-el :website "http://packages.debian.org/sid/emacs-goodies-el" :description "Miscellaneous add-ons for Emacs" :type http-tar :url "http://alioth.debian.org/snapshots.php?group_id=30060" :options
			  ("xzf")
			  :build
			  (let*
			      ((pdir
				(el-get-package-directory 'emacs-goodies-el))
			       (pkg-goodies-dir
				(or
				 (car
				  (directory-files pdir 'full "^pkg-goodies-el-"))
				 pdir))
			       (default-directory
				 (file-name-as-directory
				  (expand-file-name "emacs-goodies-el" pkg-goodies-dir))))
			    (el-get-verbose-message "Building commands from %s" default-directory)
			    (el-get-verbose-message "Expecting commands to run in %s" pdir)
			    (append
			     (mapcar
			      (lambda
				(patch-file)
				(list "patch" "-p1" "-f" "--no-backup-if-mismatch" "-i"
				      (expand-file-name patch-file
							(expand-file-name "emacs-goodies-el/debian/patches" pdir))
				      "-d"
				      (expand-file-name "emacs-goodies-el" pdir)))
			      (with-temp-buffer
				(insert-file-contents "debian/patches/series")
				(split-string
				 (buffer-string)
				 "\n" t)))
			     (let
				 ((makerfiles
				   (split-string
				    (shell-command-to-string "find . -name '*.make'"))))
			       (el-get-verbose-message "Makerfiles: %S" makerfiles)
			       (mapcar
				(lambda
				  (makerfile)
				  (let*
				      ((maker-dir
					(expand-file-name
					 (file-name-directory makerfile)
					 (expand-file-name "emacs-goodies-el" pdir)))
				       (maker-command
					(replace-regexp-in-string "\n" ""
								  (replace-regexp-in-string "emacs -batch"
											    (concat el-get-emacs " -batch")
											    (with-temp-buffer
											      (insert-file-contents makerfile)
											      (buffer-string))))))
				    (format "cd %s && %s" maker-dir maker-command)))
				makerfiles))))
			  :load-path
			  ("emacs-goodies-el/elisp/debian-el" "emacs-goodies-el/elisp/devscripts-el" "emacs-goodies-el/elisp/dpkg-dev-el" "emacs-goodies-el/elisp/emacs-goodies-el" "emacs-goodies-el/elisp/vm-bonus-el")
			  :features
			  (emacs-goodies-el debian-el dpkg-dev-el)
			  :post-init
			  (progn
			    (autoload 'debuild "devscripts" "Run debuild in the current directory." t)
			    (autoload 'debc "devscripts" "Run debc in the current directory." t)
			    (autoload 'debi "devscripts" "Run debi in the current directory." t)
			    (autoload 'debit "devscripts" "Run debit in the current directory." t)
			    (autoload 'debdiff "devscripts" "Compare contents of CHANGES-FILE-1 and CHANGES-FILE-2." t)
			    (autoload 'debdiff-current "devscripts" "Compare the contents of .changes file of current version with previous version;\nrequires access to debian/changelog, and being in debian/ dir." t)
			    (autoload 'debclean "devscripts" "Run debclean in the current directory." t)
			    (autoload 'pdebuild "pbuilder-mode" "Run pdebuild in the current directory." t)
			    (autoload 'pdebuild-user-mode-linux "pbuilder-mode" "Run pdebuild-user-mode-linux in the current directory." t)
			    (autoload 'pbuilder-log-view-elserv "pbuilder-log-view-mode" "Run a elserv session with log view.\n\nRunning this requires elserv.  Use elserv, and do `elserv-start' before invoking this command." t)
			    (autoload 'debuild-pbuilder "pbuilder-mode" "Run debuild-pbuilder in the current directory." t)
			    (autoload 'pbuilder-build "pbuilder-mode" "Run pbuilder-build for the given filename." t)
			    (autoload 'pbuilder-user-mode-linux-build "pbuilder-mode" "Run pbuilder-user-mode-linux for the given filename." t)
			    (defgroup vm-bonus-el nil "Customize vm-bonus-el Debian packages." :group 'vm)
			    (defgroup vm-bogofilter nil "VM Spam Filter Options" :group 'vm :group 'vm-bonus-el :load 'vm-bogofilter)
			    (autoload 'vm-bogofilter-setup "vm-bogofilter" "Initialize vm-bogofilter." t)
			    (defcustom vm-bogofilter-setup nil "Whether to initialize vm-bogofilter on startup.\nvm-bogofilter interfaces VM with the bogofilter spam filter." :type 'boolean :set
			      (lambda
				(symbol value)
				(set-default symbol value)
				(when value
				  (vm-bogofilter-setup)))
			      :load 'vm-bogofilter :group 'vm :group 'vm-bogofilter :group 'vm-bonus-el))))
 (escreen status "installed" recipe
	  (:name escreen :description "Emacs window session manager" :type http :url "http://www.splode.com/~friedman/software/emacs-lisp/src/escreen.el" :prepare
		 (autoload 'escreen-install "escreen" nil t)))
 (ess status "installed" recipe
      (:name ess :description "Emacs Speaks Statistics: statistical programming within Emacs" :type svn :url "https://svn.r-project.org/ESS/trunk/" :info "doc/info/" :build `,(mapcar
																						(lambda
																						  (target)
																						  (concat "make " target " EMACS=" el-get-emacs))
																						'("clean" "all"))
	     :load-path
	     ("lisp")
	     :features ess-site))
 (ess-smart-underscore status "installed" recipe
		       (:name ess-smart-underscore :website "https://github.com/mlf176f2/ess-smart-underscore.el" :description "Smarter underscore behavior in emacs" :type github :pkgname "mlf176f2/ess-smart-underscore.el"))
 (fuzzy status "installed" recipe
	(:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (goto-last-change status "installed" recipe
		   (:name goto-last-change :description "Move point through buffer-undo-list positions" :type emacswiki :load "goto-last-change.el" :after
			  (progn
			    (global-set-key
			     (kbd "C-x C-/")
			     'goto-last-change))))
 (ipython status "installed" recipe
	  (:name ipython :description "Adds support for IPython to python-mode.el" :type http :url "https://raw.github.com/ipython/ipython/master/docs/emacs/ipython.el" :depends python-mode :features ipython :post-init
		 (setq py-shell-name "ipython")))
 (js-comint status "installed" recipe
	    (:name js-comint :description "Run javascript in an inferior process window." :type http :url "http://downloads.sourceforge.net/js-comint-el/js-comint.el"))
 (js2-mode status "installed" recipe
	   (:name js2-mode :website "https://github.com/mooz/js2-mode#readme" :description "An improved JavaScript editing mode" :type github :pkgname "mooz/js2-mode" :prepare
		  (autoload 'js2-mode "js2-mode" nil t)))
 (json status "installed" recipe
       (:name json :description "JavaScript Object Notation parser / generator" :type http :url "http://edward.oconnor.cx/elisp/json.el" :features json))
 (magit status "installed" recipe
	(:name magit :website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :info "." :autoloads
	       ("50magit")
	       :build
	       (("make" "all"))
	       :build/darwin
	       `(("make" ,(format "EMACS=%s" el-get-emacs)
		  "all"))
	       :after
	       (progn
		 (global-set-key
		  (kbd "C-x C-z")
		  'magit-status))))
 (magithub status "installed" recipe
	   (:name magithub :description "Magit extensions for using GitHub" :type github :username "nex3" :depends magit))
 (markdown-mode status "installed" recipe
		(:name markdown-mode :description "Major mode to edit Markdown files in Emacs" :type git :url "git://jblevins.org/git/markdown-mode.git" :before
		       (add-to-list 'auto-mode-alist
				    '("\\.\\(md\\|mdown\\|markdown\\)\\'" . markdown-mode))))
 (markup-faces status "installed" recipe
	       (:name markup-faces :description "Collection of faces for markup language modes." :type github :pkgname "sensorflo/markup-faces"))
 (muse status "installed" recipe
       (:name muse :description "An authoring and publishing tool for Emacs" :type github :pkgname "alexott/muse" :load-path
	      ("./lisp")
	      :build
	      `(,(concat "make EMACS=" el-get-emacs))
	      :indo "texi" :autoloads "muse-autoloads"))
 (nxhtml status "installed" recipe
	 (:type github :username "emacsmirror" :name nxhtml :type emacsmirror :description "An addon for Emacs mainly for web development." :build
		(list
		 (concat el-get-emacs " -batch -q -no-site-file -L . -l nxhtmlmaint.el -f nxhtmlmaint-start-byte-compilation"))
		:load "autostart.el"))
 (popup status "installed" recipe
	(:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :pkgname "auto-complete/popup-el"))
 (psvn status "installed" recipe
       (:name psvn :description "Subversion interface for emacs" :type http :url "http://www.xsteve.at/prg/emacs/psvn.el"))
 (python-mode status "installed" recipe
	      (:type github :username "emacsmirror" :name python-mode :type emacsmirror :description "Major mode for editing Python programs" :features
		     (python-mode doctest-mode)
		     :compile nil :load "test/doctest-mode.el" :prepare
		     (progn
		       (autoload 'python-mode "python-mode" "Python editing mode." t)
		       (add-to-list 'auto-mode-alist
				    '("\\.py$" . python-mode))
		       (add-to-list 'interpreter-mode-alist
				    '("python" . python-mode)))))
 (smex status "installed" recipe
       (:name smex :description "M-x interface with Ido-style fuzzy matching." :type github :pkgname "nonsequitur/smex" :features smex :post-init
	      (smex-initialize)
	      :after
	      (progn
		(setq smex-save-file "~/.emacs.d/.smex-items")
		(global-set-key
		 (kbd "M-x")
		 'smex)
		(global-set-key
		 (kbd "M-X")
		 'smex-major-mode-commands))))
 (switch-window status "installed" recipe
		(:name switch-window :description "A *visual* way to choose a window to switch to" :type github :pkgname "dimitri/switch-window" :features switch-window))
>>>>>>> origin/master
 (yasnippet status "installed" recipe
	    (:name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :features "yasnippet" :pre-init
		   (unless
		       (or
			(boundp 'yas/snippet-dirs)
			(get 'yas/snippet-dirs 'customized-value))
		     (setq yas/snippet-dirs
			   (list
			    (concat el-get-dir
				    (file-name-as-directory "yasnippet")
				    "snippets"))))
		   :post-init
		   (put 'yas/snippet-dirs 'standard-value
			(list
			 (list 'quote
			       (list
				(concat el-get-dir
					(file-name-as-directory "yasnippet")
					"snippets")))))
		   :compile nil :submodule nil)))
