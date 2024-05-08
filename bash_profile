#!bash
# vim:set ft=sh tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent copyindent :

# This is a stub bash_profile.
# Your .bashrc must handle any complexities.
# If you're not running bash or don't have a .bashrc,
# the fallback position is minimal.
#
# I don't symlink it to ~/.bash_profile because
# other utilities append to it.  Those stanzas
# are usually host specific, like for instance
# google cloud sdk insists on hard coding the
# full path without allowing for the $HOME variable.

#
# COPY this file as ~/.bash_profile  or  ~/.profile
#

if [ -n "$BASH_ENV" ] ; then export BASH_ENV= ; fi   # runs away screaming
if [ -n "$BASH_VERSION" ]
then
  if [ -f "$HOME/.bashrc" ]
  then
    . "$HOME/.bashrc"
    return
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]
then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]
then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -n "$BASH_VERSION" ]
then
  export PATH
fi

# Below here is stuff that automated tools added.
# We handle them in a different way in bashrc.
return


