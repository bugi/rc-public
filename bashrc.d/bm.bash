#!bash
# vim:set ft=sh tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent copyindent :

#
# implements simple bookmark-style friend for pushd/popd
#

declare -A _BM_=()

# bm - set bookmark for current directory
# arg is boomark name
function bm {
  local space=' '
  if [[ $1 =~ $space ]]
  then
    echo "spaces are not allowed in bookmark names" 1>&2
  else
    _BM_["$1"]="$(pwd)"
  fi
  }

# go - go to the directory referenced by the given bookmark
# arg is boomark name
function wend {
  cd "${_BM_["$1"]}"
  }

# wend - go to the directory referenced by the given bookmark
# "wend" used to be "go", but then golang colonized the name.
# arg is boomark name
# second and further args are optional
# "wend" because that is (or was) the present tense of "went"
# "gan" because the old english "gān"
function gan {
  # For the simpler, but safer version see "wend".
  #
  # For gan, the nested evals allows a second level of substitution,
  # so you could have a bm like
  #  _BM_[foo]=/foo/\${1}/bar
  # and if you said
  #  gan foo baz
  # you would wind up at
  #  /foo/baz/bar
  #
  # Be careful though.  There's bound to be a way to
  # exploit that the "\${1}" could've been
  # "\$(hostname)" or "\$(rm -rf /)".
  #
  local k="$1" ; shift
  local v="$( eval echo "${_BM_["$k"]}" )"
  cd "$v"
  dirs -v |head -1 |sed 's/^ *[0-9][0-9]*  *//'  # show the newly current directory
  }

function _bm_complete ()
{
  COMPREPLY=( $( compgen -W "${!_BM_[*]}" -- "${COMP_WORDS[COMP_CWORD]}" ) )
  true
}
shopt -s progcomp
complete -F _bm_complete gan
complete -F _bm_complete wend

# lsbm - list the bookmarks
# optional arg restricts the beginning of the list
# so, 'lsbm h' would list home, but not foo
function lsbm_keys {
  local k
  for k in "${!_BM_[@]}"
  do
    echo "$k"
  done |grep -v ' '
  }
function lsbm_keys_filter {
  if [ -z "$1" ]
  then
    lsbm_keys
  else
    lsbm_keys | grep "^$1"
  fi
  }
function lsbm {
  for k in $( lsbm_keys_filter "$1" )
  do
    if [ -n "$k" ]
    then
      v="${_BM_["$k"]}"
      echo "$k  $v"
    fi
  done | column -t -s ' '
  }

# rmbm - remove the referenced bookmark
# arg is boomark name
function rmbm {
  unset _BM_["$1"]
  }

# __savebm - save a bookmark set
#
# The first arg is where to find the bookmark sets.
#
# The second arg is name of bookmark set, defaulting to "default".
# That first arg can be "-" which means STDOUT.
#
# The third (optional) arg is like the optional arg of lsbm
#
# However, I suggest maintaining most of your bookmark files manually.
# That way you can make use of comments, loops and whatnot.
function __savebm {
  local basefile="$1" ; shift
  local bum="$1" ; shift
  if [ -z "$bum" ]
  then
    bum=default
  fi
  local nm="$1" ; shift
  local fn="${basefile}.list.$bum"
  if [ "$bum" = - ]
  then
    fn=/dev/stdout
  elif [ -r "$fn" ]
  then
    :
  else
    true
    return
  fi
  local k
  for k in $( lsbm_keys_filter "$nm" )
  do
    v="${_BM_["$k"]}"
    echo "_BM_['$k']='$v'"
  done > "$fn"
  }

# __loadbm - load a bookmark set, as saved by savebm
#
# The first arg is where to find the bookmark sets.
# The second arg is the name of the bookmark set
function __loadbm {
  local basefile="$1" ; shift
  local bum="$1" ; shift
  if [ -z "$bum" ]
  then
    bum=default
  fi
  if [ -r "${basefile}.list.$bum" ]
  then
    .  "${basefile}.list.$bum"
  fi
  if [ -r "$HOME/.bm.bash.list.$bum" ]
  then
    . "$HOME/.bm.bash.list.$bum"
  fi
  }

bmbasefile="${BASH_SOURCE[0]}"
public_bmbasefile="${BASH_SOURCE[0]}"

function savebm_public { __savebm "$public_bmbasefile" "$@" ; }
function loadbm_public { __loadbm "$public_bmbasefile" "$@" ; }
function savebm { __savebm "$bmbasefile" "$@" ; }
function loadbm { __loadbm "$bmbasefile" "$@" ; }



loadbm_public default
