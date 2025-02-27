
function! messages_qf#messages() abort
  redir => messages
    silent! messages
  redir END
  call messages_qf#setqfmes(messages)
endfunction

function! messages_qf#setqfmes(messages) abort
  let list = split(a:messages, "\n")
  let qflist = g:messages_qf#parse_messages(list)
  call setqflist(qflist, 'r')
endfunction

function! s:apply_rel_lnum(last, rel_lnum, next_line) abort
  let qfline = copy(a:last)
  if has_key(qfline, 'lnum')
    let qfline.lnum += a:rel_lnum
  endif
  if a:next_line isnot 0
    let qfline.text = a:next_line
  endif
  return qfline
endfunction


function! messages_qf#parse_messages(list) abort
  let res = []
  let last = 0
  let len = len(a:list)
  let idx = -1
  while idx + 1 < len | let idx += 1
    let line = a:list[idx]

    if last isnot 0
      let pat_lnum = '\C^line \+\(\d\+\):$'

      if line =~# pat_lnum && idx + 1 < len
        let group_lnum = matchlist(line, pat_lnum)

        let rel_lnum = str2nr(group_lnum[1])

        call add(res, s:apply_rel_lnum(last, rel_lnum, get(a:list, idx + 1)))
        let idx += 1
        continue
      endif
      call add(res, { 'text': '' })
      let last = 0
    endif

    let pat_func_line = '\C^\(.*\), line \(\d\+\)$'
    let pat_func = '\C^\(Error detected while processing function\) \(.*\):$'
    let pat_file = '\C^\(Error detected while processing\) \(.*\):$'
    let pat_op = '\C^"\(.*\)" \(\d\+\)L, \(\d\+\)C \(.*\)$'

    if line =~# pat_func_line
      let groups = matchlist(line, pat_func_line)
      let funcs_str = groups[1]
      let rel_lnum = str2nr(groups[2])
      let func_strs = split(funcs_str, '\.\.')
      call add(res, { 'text' : 'Error detected while processing function' } )
      for func_str in func_strs[: -2]
        call add(res, s:funcstr_to_qfline(func_str, '..'))
      endfor
      let last = s:funcstr_to_qfline(func_strs[-1], ':')
      call add(res, last)
      call add(res, s:apply_rel_lnum(last, rel_lnum, get(a:list, idx + 1)))
      let idx += 1
    elseif line =~# pat_func
      let groups = matchlist(line, pat_func)
      let start = groups[1]
      let funcs_str = groups[2]
      let func_strs = split(funcs_str, '\.\.')
      call add(res, { 'text' : start } )
      for func_str in func_strs[: -2]
        call add(res, s:funcstr_to_qfline(func_str, '..'))
      endfor
      let last = s:funcstr_to_qfline(func_strs[-1], ':')
      call add(res, last)
    elseif line =~# pat_file
      let groups = matchlist(line, pat_file)
      let start = groups[1]
      let filename = expand(groups[2])
      let last = { 'filename': filename, 'text': start }
      call add(res, copy(last))
      let last.lnum = 0
    elseif line =~# pat_op
      let groups = matchlist(line, pat_op)
      let filename = expand(groups[1])
      let lnum = groups[2]
      let col = groups[3]
      let mes = groups[4]
      call add(res, { 'filename': filename, 'text': mes, 'lnum': lnum, 'col': col })
    else
      call add(res, { 'text' : line })
    endif
  endwhile
  return res
endfunction

function! s:funcstr_to_qfline(funcstr, suffix) abort
  let funcstr = a:funcstr
  let funcline = 0
  let pat_lnum = '^\(.*\)\[\(\d\+\)\]$'
  if funcstr =~# pat_lnum
    let groups = matchlist(funcstr, pat_lnum)
    let funcstr = groups[1]
    let funcline = str2nr(groups[2])
  endif

  let func = funcstr
  if func =~# '^\d\+$' | let func = printf('{%s}', func) | endif

  let verb = execute(printf('verbose function %s', func), 'silent!')
  let def = get(split(verb, "\n"), 1, '')
  let pat_def = '\C^\tLast set from \(.*\) line \(\d\+\)$'
  if def =~# pat_def
    let groups = matchlist(def, pat_def)
    let filename = expand(groups[1])
    let lnum = str2nr(groups[2])
    return {
          \   'filename': filename,
          \   'lnum': lnum + funcline,
          \   'text': funcstr . a:suffix,
          \ }
  endif
  return {
        \   'text': '<Declaration not found> ' . funcstr . a:suffix,
        \ }
endfunction

