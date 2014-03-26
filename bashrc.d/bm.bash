#
# implements simple bookmark-style friend for pushd/popd
#

# bm - set bookmark for current directory
# arg is boomark name
function bm {
	eval _bm_$1="`pwd`"
	}

# go - go to the directory referenced by the given bookmark
# arg is boomark name
function go {
	eval cd \$_bm_$1
	}

# go - go to the directory referenced by the given bookmark
# arg is boomark name
# second and further args are optional
function go {
	# The simpler, but safer version:
	#	eval cd \$_bm_$1
	#
	# the nested evals allows a second level of substitution, so you could have a bm like
	#	_bm_foo=/foo/\${2}/bar
	# and if you said
	#	go foo baz
	# you would wind up at
	#	/foo/baz/bar
	#
	# Be careful though.  That "\${2}" could've been "\$(hostname)" or "\$(rm -rf /)".
	#
	eval cd $(eval "echo \$_bm_$1")
	}

# lsbm - list the bookmarks
# optional arg restricts the beginning of the list
# so, 'lsbm h' would list home, but not foo
function lsbm {
	set | grep ^_bm_$1 | sed 's/^_bm_//;s/=/	/'
	}
alias ldirs=lsbm
alias lbm=lsbm

# rmbm - remove the referenced bookmark
# arg is boomark name
function rmbm {
	unset _bm_$1
	}

# savebm - save a bookmark set
# first arg is name of bookmark set
# second (optional) arg is like the optional arg of lsbm
function savebm {
	local bum="$1" ; shift
	local nm="$1" ; shift
	if [ -n "$bash_RC_private" ]
	then
		set | grep "^_bm_$nm" > "$bash_RC_private/bm.bash.list.$bum"
	else
		set | grep "^_bm_$nm" > "$HOME/.bm.bash.list.$bum"
	fi
	}

# loadbm - load a bookmark set, as saved by savebm
# arg is the name of the bookmark set
function loadbm {
	local bum="$1" ; shift
	if [ -r "$bash_RC_private/bm.bash.list.$bum" ]
	then
		. "$bash_RC_private/bm.bash.list.$bum"
	elif [ -r "$HOME/.bm.bash.list.$bum" ]
	then
		. "$HOME/.bm.bash.list.$bum"
	fi
	}

loadbm default
