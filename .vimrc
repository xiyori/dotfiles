set tabstop=4
set shiftwidth=4
set smarttab
set number
set et
set wrap
set ai
set cin
set hlsearch
set incsearch
set ignorecase
set listchars=tab:⋅⋅
set list
set completeopt=menu,menuone
set iskeyword-=_
setlocal spell spelllang=en_us
command! Vb normal! <C-v>
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
nnoremap <BS> a<C-W>
nnoremap <C-z> :u<CR>
inoremap <C-z> <C-o>:u<CR>
"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
colorscheme catppuccin-mocha
