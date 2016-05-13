set nocompatible               " be iMproved
filetype off                   " required!
 
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
 
" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
 
" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
" ...
Bundle 'https://github.com/Lokaltog/vim-powerline.git' 
Bundle 'The-NERD-tree'
Bundle 'winmanager'
Bundle 'taglist.vim'
Bundle 'minibufexpl.vim'
Bundle 'bufexplorer.zip'
Bundle 'OmniCppComplete'
filetype plugin indent on     " required!
"
" Brief help  -- 此处后面都是vundle的使用命令
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set csverb
    set cspc=3
    "add any database in current dir
    "if filereadable("cscope.out")
        "cs add cscope.out
    "else search cscope.out elsewhere
    "else
       let cscope_file=findfile("cscope.out", ".;")
       "let cscope_pre="/home/hyan/data/job/sabre44/kernel_imx"
       let cscope_pre=expand('%:p:h')
       let ctags_route=cscope_pre."/tags"
       "set tags=ctags_route
       if !empty(cscope_file) && filereadable(cscope_file)
           exe "cs add" cscope_file cscope_pre
       endif
       "set cscopequickfix=s-,c-,d-,i-,t-,e-      
     "endif
endif
func! GetUserName()
    let str = system('whoami')
    let len = strlen(str)
    return strpart(str, 0, len - 1)
endfunc

let g:prj_root_path = getcwd()
let g:user_name = GetUserName()
let g:tag_root_path = '/local/' . g:user_name . '/my_tags/'
let g:tag_dir=""
let g:easytags_file=g:tag_root_path . 'tags'
let g:easytags_events=['BufWritePost']
let g:easytags_async=1
let g:easytags_auto_update=0
let g:easytags_auto_highlight=0
let g:easytags_autorecurse=1
let g:easytags_include_members=1

function! AutoLoadCTagsAndCScope()
	let max = 5
    let dir=g:tag_root_path . g:tag_dir . "/"
	let i = 0
	let break = 0
	while isdirectory(dir) && i < max
		if filereadable(dir . 'cscope.out') 
			execute 'cscope add ' . dir . 'cscope.out'
			let break = 1
		endif
		if filereadable(dir . 'tags')
			execute 'set tags =' . dir . 'tags'
			let break = 1
		endif
		if break == 1
			execute 'lcd ' . dir
			break
		endif
		let dir = dir . '../'
		let i = i + 1
	endwhile
    " set for easytags plugin
    let g:easytags_file=dir . 'tags'
endf

nmap <F7> :call AutoLoadCTagsAndCScope()<CR>
nmap <F6> :TlistOpen<CR>
call AutoLoadCTagsAndCScope()
""""""""""""automatically update cscope database"""""""""""""""""""""
map <F8> :call UpdateCscopeData()<CR>  
func! UpdateCscopeData()
    if (!isdirectory(g:tag_root_path . g:tag_dir))
        exec "!mkdir -p " . g:tag_root_path . g:tag_dir
    endif

    exec "cd " . g:tag_root_path . g:tag_dir

    exec "!find -L " . g:prj_root_path . " -iname '*.[chxsS]' -o -iname '*.cpp'  > cscope.files"
    exec "!cscope -Rbk"
    exec "!ctags -R -L cscope.files -f tags"

    exec "cd -"

    "exec "!find -L " . g:prj_root_path . " -iname '*.[chxsS]' -o -iname '*.cpp'  > " . path . "/cscope.files"
    "exec "!cscope -Rbk -i " . path . "/cscope.files -f " . path . "/cscope.out"
    "exec "!ctags -R -L " . path . "/cscope.files -f ". path . "/tags"
endfunc 
