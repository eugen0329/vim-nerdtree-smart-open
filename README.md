# Usage

Use default open mappings ('o' or '\<CR\>') to open files under the cursor
inside of the NERDTree window.  The effect will be only in the case that the 
file extension will match with on of the extensions, specified in
g:nerdtree_smart_open_extensions.

Press \<C-o\> to open current file/directory under the cursor forcefully.

# Customization

Use g:nerdtree_smart_open_extensions to add a new extensions to the list of
standart extensions. Example:

        let g:nerdtree_smart_open_extensions = ['.foo', '.bar']


Set g:nerdtree_smart_open_commands variable to add a custom command for handling
nodes opening. Example:

        let g:nerdtree_smart_open_commands = 'another_opener'
        " or
        let g:nerdtree_smart_open_commands = ['foo', 'bar']

