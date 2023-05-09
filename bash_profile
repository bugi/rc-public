#!bash
# vim:set ft=sh tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent copyindent :

# This is a sample bash_profile.
#
# I don't symlink it to ~/.bash_profile because
# other utilities append to it.  Those stanzas
# are usually host specific, like for instance
# google cloud sdk insists on hard coding the
# full path without allowing for the $HOME variable.

#
# COPY this file as ~/.bash_profile
#

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# Below here is stuff that automated tools added.
# We handle them in a different way in bashrc.
return

