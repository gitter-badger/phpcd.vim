let s:save_cpo = &cpo
set cpo&vim

let g:phpcd_root = '/'

function! GetComposerRoot() " {{{
	let root = expand("%:p:h")

	if g:phpcd_root != '/' && stridx(root, g:phpcd_root) == 0
		return g:phpcd_root
	endif

	while root != "/"
		if (filereadable(root . "/vendor/autoload.php"))
			break
		endif
		let root = fnamemodify(root, ":h")
	endwhile
	let g:phpcd_root = root
	return root
endfunction " }}}

let root = GetComposerRoot()

if root == '/'
	let &cpo = s:save_cpo
	unlet s:save_cpo
	finish
endif

silent! nnoremap <silent> <unique> <buffer> <C-]>
			\ :<C-u>call phpcd#JumpToDefinition('normal')<CR>
silent! nnoremap <silent> <unique> <buffer> <C-W><C-]>
			\ :<C-u>call phpcd#JumpToDefinition('split')<CR>
silent! nnoremap <silent> <unique> <buffer> <C-W><C-\>
			\ :<C-u>call phpcd#JumpToDefinition('vsplit')<CR>

let phpcd_path = expand('<sfile>:p:h:h') . '/php/phpcd_main.php'
if g:phpcd_channel_id != -1
	call rpcstop(g:phpcd_channel_id)
endif
let g:phpcd_channel_id = rpcstart('php', [phpcd_path, root])

let phpid_path = expand('<sfile>:p:h:h') . '/php/phpid_main.php'
if g:phpid_channel_id != -1
	call rpcstop(g:phpid_channel_id)
endif
let g:phpid_channel_id = rpcstart('php', [phpid_path, root])


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker:noexpandtab:ts=2:sts=2:sw=2
