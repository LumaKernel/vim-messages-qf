
mes clear

:w

one

function! Fn_A()
  two
endfunction
call Hoge()

function! s:fn_b()
  three
endfunction
call s:fuga()

function! s:fn_c()
  five
  call s:fuga()
endfunction
call s:piyo()


let s:dict = {}
function! s:dict.fn_d()
  four
endfunction
call s:dict.fn_d()

function! s:dict.fn_e()
  call self.fn_d()
endfunction
call s:dict.fn_e()

function! s:fn_f() dict abort
  echoerr "[Important !] Error happened."
endfunction

let s:dict.fn_f = function('s:fn_f')

call s:dict.fn_f()

call messages_qf#messages()
copen

