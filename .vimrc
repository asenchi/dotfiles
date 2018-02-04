" File: dot.vimrc
" Author: Curt Micol
" Email: asenchi@asenchi.com

" -----------------------------------------------------------------------------
" LICENSE
" -----------------------------------------------------------------------------
" Copyright (c) 2011, Curt Micol <asenchi@asenchi.com>
"
" Permission to use, copy, modify, and/or distribute this software for any
" purpose with or without fee is hereby granted, provided that the above
" copyright notice and this permission notice appear in all copies.
"
" THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
" WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
" MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
" ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
" WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
" ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
" OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

" -----------------------------------------------------------------------------
" Plug
" -----------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

" -----------------------------------------------------------------------------
" General
" -----------------------------------------------------------------------------
set nocompatible                " a must
set ffs=unix,dos,mac
set hidden
set history=1000                " remember 1000 commands
"set visualbell
set ruler
set title
set showcmd
set laststatus=2                " statusline tweaks
set ch=1
"set textwidth=78                " 78 columns
set scrolloff=8
set sidescrolloff=20
set sidescroll=1
set showmatch                   " show matches
set linebreak
set backspace=indent,eol,start  " backspace across lines and indents
set whichwrap+=<,>,[,],h,l      " allow us to move across lines
"set pastetoggle=<C-f>            " Turn off formatting when pasting
set pastetoggle=<F6>            " Turn off formatting when pasting
set matchpairs+=<:>
set switchbuf=useopen
set autoread
set nostartofline

" -----------------------------------------------------------------------------
" PATH
" -----------------------------------------------------------------------------
if system('uname') =~ 'Darwin'
    let $PATH = '/usr/local/bin:/usr/local/sbin:' .
        \ $PATH
endif

" -----------------------------------------------------------------------------
" Map leader key (',')
" -----------------------------------------------------------------------------
let mapleader = ","             " leader key map
let g:mapleader = ","
let maplocalleader = "\\"

" -----------------------------------------------------------------------------
" Indentation
" -----------------------------------------------------------------------------
set autoindent                  " indentation
set smartindent                 " smart indentation on new line
set tabstop=8                   " number of spaces a <tab> counts for
set shiftwidth=4                " We default to 4 spaces
set softtabstop=4               " "feels" like tabs are being inserted
set showtabline=2               " display tab page
set expandtab                   " use appropriate number of spaces insert-mode
set shellcmdflag=-c
set shell=/bin/bash

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------
set hlsearch                    " highlight search
set incsearch                   " show pattern as search is typed
set ignorecase                  " ignore case on searches

" -----------------------------------------------------------------------------
" Backups and swap
" -----------------------------------------------------------------------------
silent !mkdir -p ~/.vim/sessions > /dev/null 2>&1
set backupdir=~/.vim/sessions    " backups

set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set noswapfile

" -----------------------------------------------------------------------------
" Wildmenu items
" -----------------------------------------------------------------------------
set wildmenu                    " enhanced command-line completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,.DS_Store,*.jpg,*.png,*.gif,*.gitkeep
set wildignore+=*.gem

" -----------------------------------------------------------------------------
" misc
" -----------------------------------------------------------------------------
set grepprg=git\ grep\ -n
let $MANPAGER = '/usr/bin/less -is'

colorscheme delek

" -----------------------------------------------------------------------------
" gist
" -----------------------------------------------------------------------------
let g:gist_default_private = 1
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" -----------------------------------------------------------------------------
" ctrlp
" -----------------------------------------------------------------------------
"let g:ctrlp_map = '<C-p>'
"let g:ctrlp_working_path_mode = 'rc'

" -----------------------------------------------------------------------------
" Color Column (only on insert)
" -----------------------------------------------------------------------------
if exists("&colorcolumn")
    autocmd InsertEnter * set colorcolumn=80
    autocmd InsertLeave * set colorcolumn=""
endif

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the statusline to green when entering Vim
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" -----------------------------------------------------------------------------
" vimrc hax
" -----------------------------------------------------------------------------
map <leader>v :call EditVimrc()<CR>

function! EditVimrc()
    execute ':tabedit ~/.vimrc'
endfunction

if has("autocmd")
    augroup vimrchooks
        au!
        autocmd bufwritepost .vimrc source ~/.vimrc
        autocmd bufwritepost dot.vimrc source ~/.vimrc
    augroup END
endif

" -----------------------------------------------------------------------------
" Plugin Options
" -----------------------------------------------------------------------------
" go
let g:go_fmt_command = "goimports"
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_addtags_transform = "snakecase"
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" -----------------------------------------------------------------------------
" mappings!
" -----------------------------------------------------------------------------
" Edit a new file using current file's path
map <leader>e  :e <C-R>=expand("%:p:h") . "/"<CR>
map <leader>te :tabe <C-R>=expand("%:p:h") . "/"<CR>

" Change path for all buffers or just locally
nmap <leader>cd :cd%:p:h<CR>
nmap <leader>.  :lcd%:p:h<CR>

" Quick write
nmap <leader>w :w<CR>
nmap <leader>W :w!<CR>

" New line
nmap <CR> o<Esc>

" Some <space> hacks
nnoremap <SPACE><SPACE> :!

" Some sane shortcuts
nmap F %
nmap Y y$
map <C-k> <C-W>k
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-l> <C-W>l

" Remove search hilight
nnoremap <leader><space> :nohlsearch<CR>

" Split line
nnoremap S i<cr><esc>

" Replace <ESC> functionality with easier to reach key cmds.
inoremap jj <ESC>

" Fill window with buffer
map <leader>F <C-W>_

" mimic some common emacs keys
map  <C-e> $
map  <C-a> 0
imap <C-a> <C-o>0
imap <C-e> <C-o>$

" For when I need to sudo a sandwich
cmap w!! %!sudo tee > /dev/null %

" auto-indent according to surrounding code
nnoremap <leader>p p
nnoremap <leader>P P
nnoremap p p'[v']=
nnoremap P P'[v']=

" -----------------------------------------------------------------------------
" fzf
" -----------------------------------------------------------------------------
" files
map <leader>f :Files<cr>
" commits
map <leader>c :Commits<cr>
" buffers
map <leader>b :Buffers<cr>

" -----------------------------------------------------------------------------
" buffers!
" -----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" -----------------------------------------------------------------------------
" tabs!
" -----------------------------------------------------------------------------
map <leader>t :tabnew %<CR>
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>
map <leader>td <ESC>:tabclose<CR>
map <leader>tm <ESC>:tabmove<CR>

" -----------------------------------------------------------------------------
" Strip whitespace
" -----------------------------------------------------------------------------
map <leader>S :call StripWhitespace ()<CR>
function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction

" -----------------------------------------------------------------------------
" toggle listchars
" -----------------------------------------------------------------------------
function! ToggleListChars()
    if &list
        set invlist
    else
        set list
        set listchars=tab:▸·,eol:¬,trail:·
    endif
endfunction
nmap <leader>' :call ToggleListChars()<CR>

" -----------------------------------------------------------------------------
" Open browser on the URL
" -----------------------------------------------------------------------------
map <leader>B :call Browser()<CR>
function! Browser()
    let line0 = getline (".")
    let line = matchstr (line0, "http[^ )]*")
    let line = escape (line, "#?&;|%")
    exec ':silent !open ' . "\"" . line . "\""
endfunction

" -----------------------------------------------------------------------------
" Hax
" -----------------------------------------------------------------------------
if has('autocmd')
    " Group these to make it easy to delete
    augroup vimrcEx
    au!
    autocmd FileType text setlocal textwidth=78

    " Jump to last known cursor position.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ end
    augroup END
else
    set autoindent
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" -----------------------------------------------------------------------------
" Functions
" -----------------------------------------------------------------------------
function! GetMode()
    let mode = mode()

    if mode ==# 'v'
        let mode = "VISUAL"
    elseif mode ==# 'V'
        let mode = "V-LINE"
    elseif mode ==# ''
        let mode = "V-BLOCK"
    elseif mode ==# 's'
        let mode = "SELECT"
    elseif mode ==# 'S'
        let mode = "S-LINE"
    elseif mode ==# ''
        let mode = "S-BLOCK"
    elseif mode =~# '\vi'
        let mode = "INSERT"
    elseif mode =~# '\v(R|Rv)'
        let mode = "REPLACE"
    else
        let mode = "NORMAL"
    endif
    return mode
endfunction

function! CurDir()
    let curdir = getcwd()
    let curdir_a = split(curdir, '/')
    let reldir = join([curdir_a[-2], curdir_a[-1]], '/')
    return reldir
endfunction

function! GuiTabLabel()
    " add the tab number
    let label = '[ '.tabpagenr()
    " modified since the last save?
    let buflist = tabpagebuflist(v:lnum)
    for bufnr in buflist
        if getbufvar(bufnr, '&modified')
            let label .= '*'
            break
        endif
    endfor
    " count number of open windows in the tab
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
        let label .= ', '.wincount
    endif
    let label .= ' ] '
    " add the file name without path information
    let n = bufname(buflist[tabpagewinnr(v:lnum) - 1])
    let label .= fnamemodify(n, ':t')
    return label
endfunction

" Code from:
" http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
" then https://coderwall.com/p/if9mda
" and then https://github.com/aaronjensen/vimfiles/blob/59a7019b1f2d08c70c28a41ef4e2612470ea0549/plugin/terminaltweaks.vim
" to fix the escape time problem with insert mode.
"
" Docs on bracketed paste mode:
" http://www.xfree86.org/current/ctlseqs.html
" Docs on mapping fast escape codes in vim
" http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
if &term =~ "xterm.*" || &term =~ "screen*"
  function! WrapForTmux(s)
    if !exists('$TMUX')
      return a:s
    endif

    let tmux_start = "\<Esc>Ptmux;"
    let tmux_end = "\<Esc>\\"

    return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
  endfunction

  let &t_SI .= WrapForTmux("\<Esc>[?2004h")
  let &t_EI .= WrapForTmux("\<Esc>[?2004l")

  function! XTermPasteBegin(ret)
    set pastetoggle=<f29>
    set paste
    return a:ret
  endfunction

  execute "set <f28>=\<Esc>[200~"
  execute "set <f29>=\<Esc>[201~"
  map <expr> <f28> XTermPasteBegin("i")
  imap <expr> <f28> XTermPasteBegin("")
  vmap <expr> <f28> XTermPasteBegin("c")
  cmap <f28> <nop>
  cmap <f29> <nop>
endif

" nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

if has("autocmd")
" -----------------------------------------------------------------------------
" python
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.py       setlocal ft=python tw=78 ts=4 sw=4 et
    au FileType python setlocal complete+=k~/.vim/syntax/python.vim "isk+=.,(
" -----------------------------------------------------------------------------
" sql
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.sql      setlocal ft=pgsql
" -----------------------------------------------------------------------------
" markdown
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.md       setlocal ft=mkd ts=2 sw=2 expandtab
    au BufRead,BufNewFile *.markdown setlocal ft=mkd ts=2 sw=2 expandtab
" -----------------------------------------------------------------------------
" ReST
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.rst      setlocal ft=rst tw=78 ts=4 sw=4 expandtab
" -----------------------------------------------------------------------------
" CSV
" -----------------------------------------------------------------------------
    au BufNewFile,BufRead *.csv      setlocal ft=csv
" -----------------------------------------------------------------------------
" ruby
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile Gemfile    setlocal ft=ruby
    au BufRead,BufNewFile Rakefile   setlocal ft=ruby
    au BufRead,BufNewFile Thorfile   setlocal ft=ruby
    au BufRead,BufNewFile *.ru       setlocal ft=ruby
    au FileType ruby                 setlocal tw=78 ts=2 sts=2 sw=2 expandtab
    au FileType yaml                 setlocal tw=78 ts=2 sts=2 sw=2 expandtab
" -----------------------------------------------------------------------------
" redo
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.do       setlocal ft=sh tw=78 ts=4 sw=4 expandtab
" -----------------------------------------------------------------------------
" golang
" -----------------------------------------------------------------------------
    au FileType go set noexpandtab
    au FileType go set shiftwidth=4
    au FileType go set softtabstop=4
    au FileType go set tabstop=4
" -----------------------------------------------------------------------------
" shell
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.sh       setlocal ft=sh tw=78 ts=4 sw=4 expandtab
    au BufRead,BufNewFile *.zsh      setlocal ft=sh tw=78 ts=4 sw=4 expandtab
    au BufRead,BufNewFile *.bash     setlocal ft=sh tw=78 ts=4 sw=4 expandtab
" -----------------------------------------------------------------------------
" html/css
" -----------------------------------------------------------------------------
    au FileType html,css setlocal ts=2 sts=2 sw=2 expandtab
    let html_no_rendering=1
" -----------------------------------------------------------------------------
" javascript
" -----------------------------------------------------------------------------
    au FileType javascript setlocal ts=4 sts=4 sw=4 expandtab
    au FileType coffee     setlocal ts=2 sts=2 sw=2 expandtab
" -----------------------------------------------------------------------------
" git
" -----------------------------------------------------------------------------
    au FileType gitcommit setlocal tw=60
" -----------------------------------------------------------------------------
" make
" -----------------------------------------------------------------------------
    au FileType make setlocal noexpandtab
" -----------------------------------------------------------------------------
" perl
" -----------------------------------------------------------------------------
    au FileType perl setlocal mp=perl\ -c\ %\ $* errorformat=%f:%l:%m aw
" -----------------------------------------------------------------------------
" puppet
" -----------------------------------------------------------------------------
    au BufRead,BufNewFile *.pp setlocal ft=puppet ts=2 sw=2 expandtab
" -----------------------------------------------------------------------------
endif
