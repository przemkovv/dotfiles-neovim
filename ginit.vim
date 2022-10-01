
let s:running_windows = has("win16") || has("win32") || has("win64")

if exists('g:GuiLoaded')
  if s:running_windows
    Guifont! FuraCode Nerd Font Mono:h14
  else
    Guifont FuraCode Nerd Font Mono:h14
  endif
endif

