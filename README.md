# :MessagesQF

English is only supported.

Define by yourself.

```vim
command! -bar MessagesQF call g:messages_qf#messages() | copen
```

# Screenshots

![image](https://user-images.githubusercontent.com/29811106/74102721-86a84980-4b89-11ea-996e-1d84a79c47b8.png)

Rightside is the result transformed by this plugin. Line numbers are chaned to absolute line of one file.


# Recipe for Dumping

This is useful to debug your vim plugin. This keeps absolute path in messages.

```vim
command! SaveMes call message_qf#util#dump('~/.cache/vim.messages.json')
command! LoadMes call setqflist(message_qf#util#load('~/.cache/vim.messages.json')) | copen
```

# License

[The Unlicense](https://unlicense.org)


