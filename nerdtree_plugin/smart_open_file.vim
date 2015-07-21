if exists('g:loaded_nerdtree_smart_open_file')
  finish
endif
let g:loaded_nerdtree_smart_open_file = 1

if !exists('g:nerdtree_smart_open_extensions')
  let g:nerdtree_smart_open_extensions = []
endif
let s:unix_openers = ['gnome-open', 'open', 'xdg-open', 'kde-open']
let s:default_extensions = [
      \ '.jpg', '.gif', '.jpeg', '.png',
      \ '.pdf', '.djvu', '.odf', '.doc', '.docx', '.swf',
      \ '.otf', '.eot', '.ttf', '.woff',
      \ '.mpg', '.mpeg', '.mov', '.flv', '.avi', '.3gp', '.wmv',
      \ ]

call extend(g:nerdtree_smart_open_extensions, s:default_extensions)
call map(g:nerdtree_smart_open_extensions, 'escape(v:val, ".")')

au VimEnter * call NERDTreeAddKeyMap({
       \ 'key': 'o',
       \ 'override': 1,
       \ 'callback': 'NERDTreeSmartOpenHandler',
       \ 'quickhelpText': 'open handler',
       \ 'scope': 'FileNode' })

function! NERDTreeSmartOpenHandler(filenode)
  let full_path = a:filenode.path.str()
  let name = a:filenode.path.pathSegments[-1]

  if name =~ '\('.join(g:nerdtree_smart_open_extensions, '\|').'\)$'
    if has('unix')
      for opener in s:unix_openers
        if executable(opener)
          exe 'silent !'.opener.' '.shellescape(full_path, 1).(has('gui_running') ? ' &' : ' > /dev/null 2>&1')
          redraw!
          return ''
        endif
      endfor
      call nerdtree#echoError("Can't find any opener")
    else
      call nerdtree#echoError("Only supported on *nix OS's")
    endif
  endif

  call a:filenode.activate({'reuse': 'all', 'where': 'p'})
endfunction
