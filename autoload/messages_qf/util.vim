function! messages_qf#util#dump(filename) abort
  let mes = g:messages_qf#parse_messages(split(execute('messages', 'silent!'), "\n"))
  call writefile([json_encode(mes)], expand(a:filename))
endfunction

function! messages_qf#util#load(filename) abort
  return json_decode(readfile(expand(a:filename)))
endfunction
