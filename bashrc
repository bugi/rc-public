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
PATH="${HOME}/.local/bin:${PATH}"
# PATH=".:${PATH}"

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


f="$( readlink "${BASH_SOURCE[0]}" )"
this_bashdir="$(dirname "$f" )"
f="$f".interactive
if [ $? -ne 0 ]
then
  echo "readlink/greadlink -f doesn't work properly." 1>&2
  return
fi
if ! [ -r "$f" ]
then
  echo "The file '$f' does not exist." 1>&2
  return
fi

# https://github.com/junegunn/fzf
# Read fzf config here instead of in a separate file because
# fzf's install really wants it in this file.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$f"
