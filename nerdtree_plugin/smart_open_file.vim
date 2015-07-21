if exists('g:loaded_nerdtree_smart_open_file')
  finish
endif
let g:loaded_nerdtree_smart_open_file = 1

let s:unix_openers =  ['xdg-open', 'gnome-open', 'open', 'kde-open']
if exists('g:nerdtree_smart_open_command')
  call insert(s:unix_openers, g:nerdtree_smart_open_command, 0)
endif

if !exists('g:nerdtree_smart_open_extensions')
  let g:nerdtree_smart_open_extensions = []
endif
call extend(g:nerdtree_smart_open_extensions, [
      \ '.jpg', '.gif', '.jpeg', '.png',
      \ '.pdf', '.djvu', '.odf', '.doc', '.docx', '.swf',
      \ '.otf', '.eot', '.ttf', '.woff',
      \ '.mpg', '.mpeg', '.mov', '.flv', '.avi', '.3gp', '.wmv',
      \ ])
call map(g:nerdtree_smart_open_extensions, 'escape(v:val, ".")')

call NERDTreeAddKeyMap({
       \ 'key': 'o',
       \ 'override': 1,
       \ 'callback': 'NERDTreeSmartOpenHandler',
       \ 'quickhelpText': 'open handler',
       \ 'scope': 'FileNode' })

call NERDTreeAddKeyMap({
       \ 'key': '<C-o>',
       \ 'override': 1,
       \ 'callback': 'NERDTreeSmartOpenForcedHandler',
       \ 'quickhelpText': 'open handler',
       \ 'scope': 'Node' })

function! NERDTreeSmartOpenHandler(filenode)
  let file_name = a:filenode.path.pathSegments[-1]

  if file_name =~ '\('.join(g:nerdtree_smart_open_extensions, '\|').'\)$'
    if !s:open(a:filenode)
      return 1
    endif
  endif

  call a:filenode.activate({'reuse': 'all', 'where': 'p'})
endfunction

function! NERDTreeSmartOpenForcedHandler(node)
  call s:open(a:node)
endfunction

fu! s:open(filenode)
  let full_path = a:filenode.path.str()
  if has('unix')
    for opener in s:unix_openers
      if executable(opener)
        exe 'silent !'.opener.' '.shellescape(full_path, 1).(has('gui_running') ? ' &' : ' > /dev/null 2>&1')
        redraw!
        return 0
      endif
    endfor
    call nerdtree#echoError("Can't find any opener")
  else
    call nerdtree#echoError("Only supported on *nix OS's")
  endif

  return 1
endfu
