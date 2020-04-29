:set number         	" show line numbers
syntax on           	" syntax highlighting

" auto indent
if has("autocmd")
  filetype plugin indent on
endif

" configure exanding of tabs for various filetypes
au BufRead,BufNewFile *.py set expandtab
au BufRead,BufNewFile *.c set expandtab
au BufRead,BufNewFile *.h set expandtab
au BufRead,BufNewFile Makefile* set expandtab

" configure editor with tabs
set expandtab		" enter spaces when tab is pressed
set tabstop=4		" use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4	" number of spaces to use for auto indent
set autoindent		" copy indent from current line when starting new line
set showcmd         	" show partial statusline
set ruler           	" show line and column number
