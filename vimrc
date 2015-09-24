" author: Valentin Bremond

"""""""""""""""""""""""""""""
" Set general configuration "
"""""""""""""""""""""""""""""

set nocompatible
set encoding=utf-8 fileencoding=utf-8 termencoding=utf-8
set statusline=%F\ %m\ %r\ %y%=%c,\ %l/%L\ %P   " Always display absolute path to files
set scrolloff=5
set incsearch

set ls=2                         " Always show status line + command-line
set mouse=a
set term=xterm
set ttymouse=xterm2              " Add mouse with screen
set number                       " Display line numbers
set background=light
set showmode                     " Display mode (insert or other)
set backspace=indent,eol,start   " Make backspace work the same way normal apps work
set smartindent                  " Make autoindentation smart
set sm                           " Syntax match: underline brackets, parenthesis, …
syntax on                        " Enable colorization
set ruler                        " Display exact cursor position on the bottom right corner
set hlsearch                     " Highlight search

" Do not create backup files…
set nobackup
" … but save undo file so we can undo changes to a file even if we close it
set undodir=/tmp/vimundo/ undofile

set shiftwidth=4      " Make a tabulation 4 spaces wide when displayed
set textwidth=0       " Disable line wrapping
set noexpandtab       " Do not replace tabs with spaces
set directory=/tmp/   " Set the swap directory to /tmp

" Change the default text on folded pieces of code (display the line under the opening bracket instead of the bracket)
function! ValFoldText()
	let n1 = v:foldend - v:foldstart + 1
	let comment = substitute(getline(v:foldstart+1),"^ *", "", 1)
	let texte = "+++ " . n1 . " lines: " . comment
	return texte
endfunction
set foldtext=ValFoldText()

" Design configuration

" Set 256 colors
set t_Co=256

" Set foreground to white and background to grey (instead of a harsh white) for the folds
hi Folded ctermfg=7
hi Folded ctermbg=0

" Change the color of the diffs
highlight DiffChange ctermbg=16
highlight DiffText ctermbg=3
highlight DiffDelete ctermbg=8
highlight DiffAdd ctermbg=17

" Highlight starting spaces (instead of tabs), trailing spaces and non-breaking spaces, git style (red background)
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\|^ \+/

" Change the autocomplete box colors
highlight Pmenu ctermbg=0 ctermfg=7
highlight PmenuSel ctermbg=7 ctermfg=0

" Change the visual selection color
highlight Visual ctermbg=0

" Background white and foreground black on searches
highlight Search ctermbg=15 ctermfg=16



"""""""""""""""""
" Set shortcuts "
"""""""""""""""""

" Use ,, to comment a selection and ,; to uncomment
map ,, :s/^/#/<CR>
map ,; :s/^.//<CR>

" Ctrl+Up for a new tab (you then only need to type the file you want to open and press Enter)
map <C-Up> :tabnew
" Ctrl+Right/Left to go to the tab on the right/left
map <C-Right> :tabnext <CR>
map <C-Left> :tabprevious <CR>

" Ctrl+n to remove highlights
map <C-n> :noh <CR>

" Ctrl+Space to autocomplete
inoremap <Nul> <C-n>

" Maj-Up and Maj-Down does not scroll the page but act as in a GUI (select lines)
imap <S-Up> <Esc> V <Up>
imap <S-Down> <Esc> V <Down>
nmap <S-Up> V <Up>
nmap <S-Down> V <Down>
vmap <S-Up> <Up>
vmap <S-Down> <Down>

" Ctrl-l to toggle lines numbers
map <C-l> <Esc> :set nonumber! <CR>

" Ctrl-p to set /unset paste mode
map <C-p> <Esc> :set paste! <CR>

" Enable panes switching/creation with Alt+Arrow
" These functions are used within the maps below
function! IsTopLeftPane()
	let oldw = winnr()
	silent! exe "normal! \<C-w>\<Left>"
	let neww = winnr()
	silent! exe oldw.'wincmd w'
	return oldw == neww
endfunction

function! IsTopUpPane()
	let oldw = winnr()
	silent! exe "normal! \<C-w>\<Up>"
	let neww = winnr()
	silent! exe oldw.'wincmd w'
	return oldw == neww
endfunction

function! IsTopRightPane()
	let oldw = winnr()
	silent! exe "normal! \<C-w>\<Right>"
	let neww = winnr()
	silent! exe oldw.'wincmd w'
	return oldw == neww
endfunction

function! IsTopDownPane()
	let oldw = winnr()
	silent! exe "normal! \<C-w>\<Down>"
	let neww = winnr()
	silent! exe oldw.'wincmd w'
	return oldw == neww
endfunction

function! GoToPane(pane)
	let pane=a:pane
	if( pane == 'left' )
		if( IsTopLeftPane() )
			execute "normal \<C-w>v \<C-w>\<Left>"
			return
		else
			execute "normal \<C-w>\<Left>"
			return
		endif
	elseif( pane == 'up' )
		if( IsTopUpPane() )
			execute "normal \<C-w>s \<C-w>\<Up>"
			return
		else
			execute "normal \<C-w>\<Up>"
			return
		endif
	elseif( pane == 'right' )
		if( IsTopRightPane() )
			execute "normal \<C-w>v \<C-w>\<Right>"
			return
		else
			execute "normal \<C-w>\<Right>"
			return
		endif
	elseif( pane == 'down' )
		if( IsTopDownPane() )
			execute "normal \<C-w>s \<C-w>\<Down>"
			return
		else
			execute "normal \<C-w>\<Down>"
			return
		endif
	endif
endfunction

" Alt-Arrow to go to the up / right / down / left pane
" If the screen is not splitted, this will split it
noremap <A-Left> :call GoToPane('left')<CR>
noremap <A-Up> :call GoToPane('up')<CR>
noremap <A-Right> :call GoToPane('right')<CR>
noremap <A-Down> :call GoToPane('down')<CR>
inoremap <A-Left> <Esc> :call GoToPane('left')<CR> <Ins>
inoremap <A-Up> <Esc> :call GoToPane('up')<CR> <Ins>
inoremap <A-Right> <Esc> :call GoToPane('right')<CR> <Ins>
inoremap <A-Down> <Esc> :call GoToPane('down')<CR> <Ins>

" Run Pathogen
execute pathogen#infect()



"""""""""""""""""""""""""""
" Syntastic configuration "
"""""""""""""""""""""""""""

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_java_javac_classpath = "/code/src/main/java/"

