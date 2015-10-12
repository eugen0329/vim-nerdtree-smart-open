if exists('g:loaded_nerdtree_smart_open')
  finish
endif
let g:loaded_nerdtree_smart_open = 1

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

let s:openers =  ['xdg-open', 'gnome-open', 'open', 'kde-open']

if exists('g:nerdtree_smart_open_commands')
  let cmds = copy(g:nerdtree_smart_open_commands)
  if type(cmds) == type([])
    for c in cmds | call filter(s:openers, 'v:val !=# "'.c.'"') | endfor
    let s:openers = cmds + s:openers
  elseif type(cmds) == type('')
    call insert(filter(s:openers, 'v:val !=# "'.cmds.'"'), cmds, 0)
  else
    echoerr 'Wrong g:nerdtree_smart_open_commands type'
  end
endif

if get(g:, 'nerdtree_smart_open_default_mappings', 1)
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
endif

fu! NERDTreeSmartOpenHandler(filenode)
  let file_name = a:filenode.path.pathSegments[-1]

  if file_name =~ '\('.join(g:nerdtree_smart_open_extensions, '\|').'\)$'
    if !s:open(a:filenode)
      return 1
    endif
  endif

  return a:filenode.activate({'reuse': 'all', 'where': 'p'})
endfu

fu! NERDTreeSmartOpenForcedHandler(node)
  return s:open(a:node)
endfu

fu! s:open(filenode)
  let full_path = a:filenode.path.str()
  if has('unix')
    for opener in s:openers
      if executable(opener)
        exe 'silent !'.opener.' '.shellescape(full_path, 1).(has('gui_running') ? ' &' : ' > /dev/null 2>&1')
        redraw!
        if !get(v:, 'shell_error', 0) | return 0 | endif
      endif
    endfor
    call nerdtree#echoError("Can't find any opener")
  else
    call nerdtree#echoError("Only supported on *nix OS's")
  endif

  return 1
endfu
