if exists("g:loaded_marcos") || &cp
	finish
endif
let g:loaded_marcos = 1

silent! nnoremap <unique> m<Tab> :Marcos<CR>
silent! nnoremap <unique> '<Tab> :Marcos <C-D>
silent! nnoremap <unique> dm :Marks<CR>:delmarks<Space>

command -nargs=? -complete=customlist,s:complete Marcos call s:marcos(<q-args>)
command Marks call s:marks()

function s:marcos(str)
	if empty(a:str)
		call s:set_mark()
	else
		let mark = matchstr(a:str, '^[A-Za-z]')[0]
		if empty(mark)
			echo "'"..a:str.."' doesn't start with a letter"
		else
			execute "'"..toupper(mark)
		endif
	endif
endfunction

function s:marks()
	echo s:file_marks()
		\->map({k,v -> v.mark[1]..' '..fnamemodify(v.file, ':~:.')})
		\->join("\n")
endfunction

function s:set_mark()
	let f = expand('%:p')

	if empty(f)
		echo 'No file'
		return
	endif

	let mark = s:get_existing_mark_for(f) ?? s:get_unused_mark_for(f)

	if empty(mark)
		echo 'No unused file marks left; time to :delmarks (dm)'
		return
	endif

	execute 'mark' mark
	echo 'm'..mark
endfunction

function s:jump_to_file(file)
	let mark = s:get_existing_mark_for(a:file)

	if empty(mark)
		echo 'No mark for '..a:file
		return
	endif

	execute "'"..mark
endfunction

function s:get_unused_mark_for(file)
	let used_marks = s:file_marks()->map('v:val.mark[1]')

	" use the file's first letter if available
	let first_letter = matchstr(fnamemodify(a:file, ':t'), '[a-zA-Z]')
	if !empty(first_letter) && index(used_marks, first_letter, 0, 1) == -1
		return toupper(first_letter)
	endif

	" start at the end so latest marked files will be listed first
	for i in range(char2nr('Z'), char2nr('A'), -1)
		let c = nr2char(i)
		if index(used_marks, c) < 0
			return c
		endif
	endfor
endfunction

function s:get_existing_mark_for(file)
	return s:file_marks()
		\->filter({k,v -> expand(v.file) ==# a:file})
		\->map('v:val.mark[1]')
		\->get(0)
endfunction

" same as getmarklist() but filters out non-uppercase marks
function s:file_marks()
	return getmarklist()->filter('v:val.mark =~# "[A-Z]$"')
endfunction

" :help :command-completion-customlist
function s:complete(a,l,p)
	return s:file_marks()
		\->sort(function('s:sort_by_lastused'))
		\->map({k,v -> v.mark[1]..' '..fnamemodify(v.file, ':~:.')})
		\->filter({i,v -> stridx(v, a:a) >= 0})
endfunction

" a == b: 0
" a after b: 1
" b after a: -1
function s:sort_by_lastused(a, b)
	" put the current file last (you don't normally want to jump there)
	if fnamemodify(a:a.file, ':p') == expand('%:p')
		return 1
	elseif fnamemodify(a:b.file, ':p') == expand('%:p')
		return -1
	endif
	
	let a_lastused = s:get_lastused(a:a.pos[0])
	let b_lastused = s:get_lastused(a:b.pos[0])

	if a_lastused < b_lastused
		return 1
	elseif a_lastused > b_lastused
		return -1
	else
		return 0
	endif
endfunction

function s:get_lastused(buf)
	return empty(a:buf) ? 0 : getbufinfo(a:buf)->get(0,{})->get('lastused')
endfunction
