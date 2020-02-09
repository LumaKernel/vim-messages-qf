
mes clear

:w

_one

function! Fn_A()
  _two
endfunction
call Fn_A()

function! s:fn_b()
  _three
endfunction
call s:fn_b()

function! s:fn_c()
  _five
  call s:fn_b()
endfunction
call s:fn_c()


let s:dict = {}
function! s:dict.fn_d()
  _four
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

