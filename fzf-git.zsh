is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf_git_branch() {
  # Parse command line arguments
  while getopts hr flag
  do
    case "${flag}" in
      h) echo "Fuzzy search and select git branches."
         echo
         echo "usage: fzf_git_branch [options]"
         echo "  options:"
         echo "    -h         Print this help."
         echo "    -r         Show remote branches."
         return;;
      r) local filter="HEAD";;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  if ! (( ${+filter} )); then
    local filter="HEAD|remote"
  fi

  # Pipe commands to fuzzy-search and select single branch
  git branch --all --sort=-committerdate |
    grep -Ev $filter |
    fzf --ansi --no-multi --preview-window right:65% --header "Select a branch" \
        --preview 'git log -n 50 --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
    sed "s/.* //"
}

fzf_git_branch_multi() {
  # Return if function not called from git repo
  is_in_git_repo || return

  # Pipe commands to fuzzy-search and select multiple branches
  git branch --all --sort=-committerdate |
    grep -Ev "HEAD|remote" |
    fzf --ansi --multi --preview-window right:65% --header "Select a branch" \
        --preview 'git log -n 50 --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
    sed "s/.* //"
}

fzf_git_commit_hash() {
  # Return if function not called from git repo
  is_in_git_repo || return

  # Pipe commands to fuzzy-search and select git commit
  git log --decorate --pretty=oneline |
    fzf |
    awk '{print $1}'
}

fzf_git_diff_name_only() {
  # Return if function not called from git repo
  is_in_git_repo || return

  git diff --name-only |
    # Show filepath(s) in fzf relative to base of git repo
    fzf --ansi --multi --preview-window right:65% --header "Select a file" \
        --preview 'realpath --relative-to=. $(git rev-parse --show-toplevel)/{} |
                   xargs git diff --color=always --date=short --' |
    # Return filepath(s) relative to current location
    xargs -I {} realpath --relative-to=. $(git rev-parse --show-toplevel)/{}
}

fzf_git_unmerged_files() {
  # Return if function not called from git repo
  is_in_git_repo || return

  git diff --name-only --diff-filter=U |
    # Show filepath(s) in fzf relative to base of git repo
    fzf --ansi --multi --preview-window right:65% --header "Select a file" \
        --preview 'realpath --relative-to=. $(git rev-parse --show-toplevel)/{} |
                   xargs git diff --date=short --' |
    # Return filepath(s) relative to current location
    xargs -I {} realpath --relative-to=. $(git rev-parse --show-toplevel)/{}
}

fzf_git_unstaged_files() {
  is_in_git_repo || return

  git status -s |
    cut -c4- |
    fzf --ansi --multi --preview-window right:65% --header "Select file(s)" \
        --preview 'git diff --color=always --date=short -- {}'
}

fzf_git_add() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Fuzzy search for modified files to stage for commit."
         echo
         echo "usage: fzf_git_add [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local files=$(fzf_git_unstaged_files)

  if [[ "$files" = "" ]]; then
    echo "No file(s) selected."
    return
  fi

  echo $files | xargs git add
}

fzf_git_conflicts() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Fuzzy search for files with conflicts and open in default editor."
         echo
         echo "usage: fzf_git_conflicts [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local file=$(fzf_git_unmerged_files)

  if [[ "$file" = "" ]]; then
    echo "No file selected."
    return
  fi

  if [[ "$VISUAL" = "vim" ]]; then
    # Populate location list with selected file's merge conflicts
    $VISUAL -c "lgrep '<<<<<<' %" -c "lopen" $file
  else
    $VISUAL $file
  fi

  # Prompt user to mark selected file as resolved
  printf "%s " "Do you wish to mark ${file} as resolved? (y/n)"
  read is_resolved

  if [[ $is_resolved == "y" ]]; then
    git add $file
  fi
}

fzf_git_diff() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "View git diff for multiple files selected in fuzzy search."
         echo
         echo "usage: fzf_git_diff [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local mod_files=$(fzf_git_diff_name_only)

  if [[ "$mod_files" = "" ]]; then
    echo "No file(s) selected."
    return
  fi

  # git diff of selected modified file(s)
  echo $mod_files | xargs git diff
}

fzf_git_overwrite_local() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Overwrite local changes for multiple files selected in fuzzy search."
         echo
         echo "usage: fzf_git_overwrite_local [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local mod_files=$(fzf_git_diff_name_only)

  if [[ "$mod_files" = "" ]]; then
    echo "No file(s) selected."
    return
  fi

  # Overwrite local changes to selected modified file(s)
  echo $mod_files | xargs git checkout --
}

fzf_git_checkout() {
  # Parse command line arguments
  while getopts rh flag
  do
    case "${flag}" in
      h) echo "Fuzzy search for and select branch to checkout."
         echo
         echo "usage: fzf_git_checkout [options]"
         echo "  options:"
         echo "    -h         Print this help."
         echo "    -r         Include remote branches in search."
         return;;
      r) local remote=true;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local branch
  if [[ $remote ]]; then
    branch=$(fzf_git_branch -r)
  else
    branch=$(fzf_git_branch)
  fi

  if [[ "$branch" = "" ]]; then
      echo "No branch selected."
      return
  fi

  if [[ "$branch" = "remotes/"* ]]; then
    # Checkout branch and set to tracking remote
    git checkout --track $branch
  else
    # Checkout local branch
    git checkout $branch
  fi
}

fzf_git_delete_branch() {
  # Parse command line arguments
  while getopts fh flag
  do
    case "${flag}" in
      h) echo "Fuzzy search and select multiple local branches to delete."
         echo
         echo "usage: fzf_git_delete_branch [options]"
         echo "  options:"
         echo "    -h         Print this help."
         echo "    -f         Force delete."
         return;;
      f) local force=true;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local branches=$(fzf_git_branch_multi)

  if [[ "$branches" = "" ]]; then
    echo "No branch(es) selected."
      return
  fi

  # Delete selected branch(es)
  if [[ $force ]]; then
    echo $branches | xargs git branch -D
  else
    # TODO: Check status code of delete and prompt user if they want to force delete
    echo $branches | xargs git branch -d
  fi
}

fzf_git_merge() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Fuzzy search and select branch to merge."
         echo
         echo "usage: fzf_git_merge [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local branch=$(fzf_git_branch)

  if [[ "$branch" = "" ]]; then
    echo "No branch selected."
    return
  fi

  # Merge selected branch
  git merge $branch
}

fzf_git_rebase() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Fuzzy search and select branch to rebase."
         echo
         echo "usage: fzf_git_rebase [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local branch=$(fzf_git_branch)

  if [[ "$branch" = "" ]]; then
    echo "No branch selected."
    return
  fi

  # Rebase selected branch
  git rebase $branch
}

fzf_git_rebase_interactive() {
  # Parse command line arguments
  while getopts h flag
  do
    case "${flag}" in
      h) echo "Fuzzy search and select commit to use as fork point in interactive rebase."
         echo
         echo "usage: fzf_git_rebase_interactive [options]"
         echo "  options:"
         echo "    -h         Print this help."
         return;;
      \?) echo "Invalid option"
          return;;
    esac
  done

  # Return if function not called from git repo
  is_in_git_repo || return

  local commit_hash=$(fzf_git_commit_hash)

  if [[ "$commit_hash" = "" ]]; then
    echo "No commit selected."
    return
  fi

  # Interactive rebase using selected commit as fork point
  git rebase -i $commit_hash
}

# aliases
alias ga="fzf_git_add"
alias gb="fzf_git_branch"
alias gco="fzf_git_checkout"
alias gdb="fzf_git_delete_branch"
alias gdf="fzf_git_diff"
alias gol="fzf_git_overwrite_local"
alias gm="fzf_git_merge"
alias gc="fzf_git_conflicts"
alias gr="fzf_git_rebase"
alias gri="fzf_git_rebase_interactive"
