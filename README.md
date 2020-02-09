# :MessagesQF

English is only supported.

Define by yourself.

```vim
command! MessagesQF call g:messages_qf#messages() | copen
```

# Screenshots

![image](https://user-images.githubusercontent.com/29811106/74102721-86a84980-4b89-11ea-996e-1d84a79c47b8.png)

Rightside is the result transformed by this plugin. Line numbers are chaned to absolute line of one file.


# Recipe for Dumping

This is useful to debug your vim plugin. This keeps absolute.

```vim
command! SaveMes call writefile([json_encode(g:messages_qf#parse_messages(split(execute('messages','silent!'),"\n")))],expand('~/.cache/vim.messages.json'))
command! LoadMes call setqflist(json_decode(readfile(expand('~/.cache/vim.messages.json')))) | copen
```

# License

[The Unlicense](https://unlicense.org)


