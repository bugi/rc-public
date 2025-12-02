#!bash
# vim:set ft=sh tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent copyindent :

# usage:
#   declare grr_d=()
#   source_files_in_dir grr_d grr.d/
#   for fn in "${grr_d[@]}"
#   do
#     if [ -r "$fn" ] ; then . "$fn" ; fi
#   done
#   unset grr_d fn

gather_files_in_dir ()
{ # reads files from find into array, sorted and without concerns of special characters
  # provides sane defaults for which files to find
  local files_list_var="$1" ; shift
  local dir="$1" ; shift
  local fn
  local find_args=( -maxdepth 1 -type f )
  find_args+=( ! -name '*.sw?' ! -name '*.README' ! -name '*.md' ! -name README ! -name '.*' )

  if [[ $# -gt 0 ]]
  then
    if [[ $1 == +++ ]]
    then
      shift
    elif [[ $1 == === ]]
    then
      shift
      find_args=()
    fi
    find_args+=( "$@" )
  fi

  # read list of files in $dir
  # skipping files that shouldn't apply
  # and put the names in array variable files_list
  mapfile -d $'\0' "$files_list_var" < <( find "$dir" "${find_args[@]}" -print0 | LC_ALL=C sort -z )
}
