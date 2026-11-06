" VIM Configuration Profile

" Use the PowerLine plugin (installed system-wide via the `powerline` apt package).
" Loading it through python3 avoids hard-coding a Python version in the path.
if has('python3')
  silent! python3 from powerline.vim import setup as powerline_setup; powerline_setup(); del powerline_setup
endif

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

" Always show the command as it is being typed.
set showcmd
