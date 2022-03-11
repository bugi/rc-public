#!bash
# vim:set ft=sh tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent copyindent :

#
# symlink this file as ~/.bashrc
#





# some systems default to 002 or 000, or even stranger
umask 022



# make sure hostname is set and is the hostname, not the fqdn.
# it's a stupid-common rookie mistake.
if [ -z "$HOSTNAME" -o "${HOSTNAME%.*}" != "$HOSTNAME" ]
then
  HOSTNAME="${HOSTNAME:-$(hostname)}"
  # HOSTNAME="$(hostname)"
  HOSTNAME="${HOSTNAME%%.*}"
  export HOSTNAME
fi



# yeah, java :(
if [ -d /usr/lib/jvm/java-6-sun ]
then
  JAVA_HOME=/usr/lib/jvm/java-6-sun
  export JAVA_HOME
  JDK_HOME="${JAVA_HOME}"
  export JDK_HOME
  PATH="${JAVA_HOME}/bin:${PATH}"
  export PATH
fi


# App setup needed even for non-interactive shells.
# (Claws is run from a non-interactive shell.)

PARINIT='rTbgqR B=.?_A_a Q=_s>|'
export PARINIT


#
# belabor the path
#

# path for snap apps
if [ -d /snap/bin ]
then
  PATH="/snap/bin:${PATH}"
fi

# setup for golang: GOPATH and PATH
if [ -z "$GOPATH" ]
then
  if [ -d "$HOME/golang" ]
  then
    GOPATH="$HOME/golang"
  elif [ -d "$HOME/go" ]
  then
    GOPATH="$HOME/go"
  fi
  export GOPATH
fi
if [ -n "$GOPATH" ]
then
  PATH="${GOPATH}/bin:${PATH}"
fi

# my own stuff comes first
PATH="${HOME}/usr/bin:${PATH}"
PATH="${HOME}/bin:${PATH}"
PATH=".:${PATH}"

export PATH


# for wlroots/sway manual install
LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/
export LD_LIBRARY_PATH


#
#
#

if [ -z "$PS1" ] # non-interactive, so we're done here
then
  return
fi


#
# From here on, assumes bash.  not sh.  not ksh.  not ash.  not zsh.
#


#
# From here on is for making interactive sessions bearable.
#

if [ "${-/i/}" = "$-" ] # i is not present in shell options, so is non-interactive
then
  return # non-interactive, so we're done here
fi

function abspath ()
{ # like `readlink -f` but should work on BSD, more or less
  # $1     : relative filename
  # return : absolute path
  #   See description of -f in GNU's readlink(1).
  #   Returns false if it can't resolve the path, true otherwise.
  #   It can return an empty string along with false.
  #   Doesn't fully resolve symlinks if the path is a symlink to a file.

  # Best is to simply call GNU's `readlink -f` if it's available.
  if [ "$(uname -s)" = Linux ]
  then
    readlink -f "$1"
    return
  elif type greadlink >/dev/null 2>&1
  then
    # This is for if you're running OSX and have installed coreutils utilities via homebrew.
    greadlink -f "$1"
    return
  elif readlink -f / >/dev/null 2>&1
  then
    readlink -f "$1"
    return
  fi

  # The implementation below will not always fully resolve symlinks.
  # To do so, it would have to safely follow a symlink at the end of the path.

  if [ -d "$1" ]
  then
    (cd "$1" && pwd -P )
    true
    return
  elif [[ $1 == /*/* ]]
  then
    # This will fail in some cases:
    #   • "/tmp/foo" symlinked to "/bin/ls" will return "/tmp/foo" (not /usr/bin/ls)
    echo "$(cd "${1%/*}" && pwd -P)/${1##*/}"
    true
    return
  elif [[ $1 == /* ]]
  then
    # This will fail in some cases:
    #   • "/foo" symlinked to "bin/ls" will return "/foo" (not /usr/bin/ls)
    echo "$1"
    true
    return
  elif [[ $1 == */* ]]
  then
    # This will fail in some cases:
    #   • "foo/bar" symlinked to "/bin/ls" will return ".../foo" (not /usr/bin/ls)
    echo "$(cd "${1%/*}" && pwd -P)/${1##*/}"
    true
    return
  else
    # This will fail in some cases:
    #   • "foo" symlinked to "/bin/ls" will return "$(pwd)/foo" (not /usr/bin/ls)
    echo "$(pwd -P)/$1"
    true
    return
  fi
  false
}

. "$( abspath "${BASH_SOURCE[0]}" )".interactive

