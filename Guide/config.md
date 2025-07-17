⌨️ Keymaps
LazyVim uses which-key.nvim to help you remember your keymaps. Just press any key like <space> and you'll see a popup with all possible keymaps starting with <space>.

image

default <leader> is <space>
default <localleader> is \
General
Key	Description	Mode
j	Down	n, x
<Down>	Down	n, x
k	Up	n, x
<Up>	Up	n, x
<C-h>	Go to Left Window	n
<C-j>	Go to Lower Window	n
<C-k>	Go to Upper Window	n
<C-l>	Go to Right Window	n
<C-Up>	Increase Window Height	n
<C-Down>	Decrease Window Height	n
<C-Left>	Decrease Window Width	n
<C-Right>	Increase Window Width	n
<A-j>	Move Down	n, i, v
<A-k>	Move Up	n, i, v
<S-h>	Prev Buffer	n
<S-l>	Next Buffer	n
[b	Prev Buffer	n
]b	Next Buffer	n
<leader>bb	Switch to Other Buffer	n
<leader>`	Switch to Other Buffer	n
<leader>bd	Delete Buffer	n
<leader>bo	Delete Other Buffers	n
<leader>bD	Delete Buffer and Window	n
<esc>	Escape and Clear hlsearch	i, n, s
<leader>ur	Redraw / Clear hlsearch / Diff Update	n
n	Next Search Result	n, x, o
N	Prev Search Result	n, x, o
<C-s>	Save File	i, x, n, s
<leader>K	Keywordprg	n
gco	Add Comment Below	n
gcO	Add Comment Above	n
<leader>l	Lazy	n
<leader>fn	New File	n
<leader>xl	Location List	n
<leader>xq	Quickfix List	n
[q	Previous Quickfix	n
]q	Next Quickfix	n
<leader>cf	Format	n, v
<leader>cd	Line Diagnostics	n
]d	Next Diagnostic	n
[d	Prev Diagnostic	n
]e	Next Error	n
[e	Prev Error	n
]w	Next Warning	n
[w	Prev Warning	n
<leader>uf	Toggle Auto Format (Global)	n
<leader>uF	Toggle Auto Format (Buffer)	n
<leader>us	Toggle Spelling	n
<leader>uw	Toggle Wrap	n
<leader>uL	Toggle Relative Number	n
<leader>ud	Toggle Diagnostics	n
<leader>ul	Toggle Line Numbers	n
<leader>uc	Toggle Conceal Level	n
<leader>uA	Toggle Tabline	n
<leader>uT	Toggle Treesitter Highlight	n
<leader>ub	Toggle Dark Background	n
<leader>uD	Toggle Dimming	n
<leader>ua	Toggle Animations	n
<leader>ug	Toggle Indent Guides	n
<leader>uS	Toggle Smooth Scroll	n
<leader>dpp	Toggle Profiler	n
<leader>dph	Toggle Profiler Highlights	n
<leader>uh	Toggle Inlay Hints	n
<leader>gb	Git Blame Line	n
<leader>gB	Git Browse (open)	n, x
<leader>gY	Git Browse (copy)	n, x
<leader>qq	Quit All	n
<leader>ui	Inspect Pos	n
<leader>uI	Inspect Tree	n
<leader>L	LazyVim Changelog	n
<leader>fT	Terminal (cwd)	n
<leader>ft	Terminal (Root Dir)	n
<c-/>	Terminal (Root Dir)	n
<c-_>	which_key_ignore	n, t
<C-/>	Hide Terminal	t
<leader>-	Split Window Below	n
<leader>|	Split Window Right	n
<leader>wd	Delete Window	n
<leader>wm	Toggle Zoom Mode	n
<leader>uZ	Toggle Zoom Mode	n
<leader>uz	Toggle Zen Mode	n
<leader><tab>l	Last Tab	n
<leader><tab>o	Close Other Tabs	n
<leader><tab>f	First Tab	n
<leader><tab><tab>	New Tab	n
<leader><tab>]	Next Tab	n
<leader><tab>d	Close Tab	n
<leader><tab>[	Previous Tab	n
