" Vim plugin for send MDX queries to the OLAP server
" Maintainer: Pavel Byzov <pavel@byzov.com>
" License:

if exists("g:loaded_mdxquery")
    finish
endif
let g:loaded_mdxquery = 1

if !hasmapto('<Plug>MDXquerySend')
    map <unique> <Leader>a  <Plug>MDXquerySend
endif

if !exists(":MDXsend")
    command -range=% -nargs=0 MDXsend :<line1>,<line2>call s:Send()
endif

"function! GoogleSearch()
"     let searchterm = getreg("g")
"     silent! exec "silent! !firefox \"http://google.com/search?q=" . searchterm . "\" &"
"endfunction
"vnoremap <F6> "gy<Esc>:call GoogleSearch()<CR>

function! Send()
     let searchterm = shellescape(getreg("g"))
     exec "!/home/byzov_pa/mdxquery.py \"" . searchterm . "\""
endfunction
vnoremap <F6> "gy<Esc>:call Send()<CR>