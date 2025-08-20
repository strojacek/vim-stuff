" kerf.vim - Vim plugin for working with kerf (k language)
" Author: Adapted from kerf-mode.el by Scott Vokes and Scott Locklin
" License: ISC

if exists("g:loaded_kerf")
  finish
endif
let g:loaded_kerf = 1

command! KerfRun call s:run_kerf()
command! KerfSendLine call s:kerf_send_line()
command! KerfSendRegion call s:kerf_send_region()
command! KerfSendBuffer call s:kerf_send_buffer()

nnoremap <silent> <leader>kk :KerfRun<CR>
nnoremap <silent> <leader>kn :KerfSendLine<CR>
vnoremap <silent> <leader>kr :KerfSendRegion<CR>
nnoremap <silent> <leader>kb :KerfSendBuffer<CR>

let s:kerf_term_buf = -1

function! s:run_kerf() abort
  if s:kerf_term_buf != -1 && bufexists(s:kerf_term_buf)
    exec 'buffer' s:kerf_term_buf
  else
    let s:kerf_term_buf = term_start('kerf', {'term_name': 'kerf', 'hidden': v:false})
  endif
endfunction

function! s:kerf_send(str) abort
  if s:kerf_term_buf == -1 || !bufexists(s:kerf_term_buf)
    call s:run_kerf()
  endif
  call chansend(bufwinid(s:kerf_term_buf), a:str . "\n")
endfunction

function! s:kerf_send_line() abort
  call s:kerf_send(getline('.'))
endfunction

function! s:kerf_send_region() abort
  let l:lines = getline("'<", "'>")
  call s:kerf_send(join(l:lines, "\n"))
endfunction

function! s:kerf_send_buffer() abort
  call s:kerf_send(join(getbufline('%', 1, '$'), "\n"))
endfunction

" syntax/kerf.vim
" Basic kerf highlighting

syntax match kerfComment "//.*$"
syntax match kerfString /"[^"]*"/
syntax match kerfString /'[^']*'/
syntax match kerfNumber /\v-?\d+(\.\d*)?([eE][+-]?\d+)?/
syntax match kerfDate /\v\d{4}\.\d{2}\.\d{2}/
syntax match kerfTime /\v\d{2}:\d{2}(:\d{2}(\.\d{1,3})?)?/
syntax match kerfBuiltin /\<\(add\|mmul\|inv\|abs\|exp\|sqrt\|join\|map\|sum\|rand\|count\|mod\)\>/
syntax match kerfAdverb /\\[><=~\/\\]?/

highlight link kerfComment Comment
highlight link kerfString String
highlight link kerfNumber Number
highlight link kerfDate Constant
highlight link kerfTime Constant
highlight link kerfBuiltin Function
highlight link kerfAdverb Keyword


    
augroup kerf
  autocmd!
  autocmd BufRead,BufNewFile *.kerf set filetype=kerf
augroup END

    
