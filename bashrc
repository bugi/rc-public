#!bash
# vim:set ft=sh tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent copyindent :

#
# symlink this file as ~/.bashrc
#





# some systems default to 002 or 000, or even stranger
umask 022



# make sure hostname is set and is the hostname, not the fqdn.
if [ -z "$HOSTNAME" -o "${HOSTNAME%.*}" != "$HOSTNAME" ]
then
  [ "${-/i/}" = "$-" ] || echo "Your local hostname shouldn't be a fully qualified domain name." 1>&2
  HOSTNAME="$(hostname -s)"
  export HOSTNAME
fi



# ancient java :(
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
for f in \
  "${HOME}/usr/bin-public" \
  "${HOME}/usr/bin" \
  "${HOME}/bin" \
  "${HOME}/.local/bin" \
; do
  if [ -d "$f"/ ]
  then
    PATH="${f}:${PATH}"
  fi
done
# PATH=".:${PATH}"

export PATH


# for wlroots/sway manual install
case "$(uname -s)" in
(Linux)
  LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu/
  export LD_LIBRARY_PATH
  ;;
esac

if [ "${-/i/}" = "$-" ] # i is not present in shell options, so is non-interactive
                        # (handled via bashrc.d if interactive)
then
# nvm is used to manage which version of node/npm to use
# https://github.com/nvm-sh/nvm
# Reading nvm's config here instead
# Reading nvm config here instead of in a separate file because
# nvm's install searches this file for magic strings and puts them
# there if it doesn't find them.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ "${-/i/}" != "$-" ] && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion if in an interactive shell
fi


if [ "${-/i/}" = "$-" ] # i is not present in shell options, so is non-interactive
                        # (handled via bashrc.d if interactive)
then
# Google Cloud cli tools
# https://cloud.google.com/sdk/docs/install
# Here instead of in a separate file because gcp's install searches this file for magic strings.
# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.bash.inc" ]; then . "${HOME}/google-cloud-sdk/path.bash.inc"; fi
#
# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.bash.inc" ]; then . "${HOME}/google-cloud-sdk/completion.bash.inc"; fi
fi


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
