" markdown filetype
if exists("did\_load\_filetypes")
    finish
endif

augroup markdown
    au! BufRead,BufNewFile *.md     setfiletype mkd
augroup END

augroup yaml
    au! BufRead,BufNewFile *.yaml,*.yml     setfiletype yaml
augroup END

augroup filetypedetect
    " Mail
    autocmd BufRead,BufNewFile *mutt-*      setfiletype mail
augroup END
