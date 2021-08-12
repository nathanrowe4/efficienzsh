is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf_git_branch() {
  # Return if function not called from git repo
  is_in_git_repo || return

  # Pipe commands to fuzzy-search and select single branch
  git branch --color=always --all --sort=-committerdate |
    grep -Ev "HEAD|remote" |
    fzf --ansi --no-multi --preview-window right:65% --header "Select a branch" \
        --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
    sed "s/.* //"
}

fzf_git_branch_multi() {
  # Return if function not called from git repo
  is_in_git_repo || return

  # Pipe commands to fuzzy-search and select multiple branches
  git branch --color=always --all --sort=-committerdate |
    grep -Ev "HEAD|remote" |
    fzf --ansi --multi --preview-window right:65% --header "Select a branch" \
        --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
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
                   xargs git diff --color=always --date=short --' |
    # Return filepath(s) relative to current location
    xargs -I {} realpath --relative-to=. $(git rev-parse --show-toplevel)/{}
}

fzf_git_merge_conflicts() {
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
  echo "Do you wish to mark ${file} as resolved?"
  select yn in "yes" "no"; do
      case $yn in
          yes ) git add $file; return;;
          no ) return;;
      esac
  done
}

fzf_git_diff() {
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

# TODO: Add flag to include remote branches
fzf_git_checkout() {
  # Return if function not called from git repo
  is_in_git_repo || return

  local branch=$(fzf_git_branch)

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
  # Return if function not called from git repo
  is_in_git_repo || return

  local branches=$(fzf_git_branch_multi)

  if [[ "$branches" = "" ]]; then
    echo "No branch(es) selected."
      return
  fi

  # Delete selected branch(es)
  echo $branches | xargs git branch -d
}

fzf_git_force_delete_branch() {
  # Return if function not called from git repo
  is_in_git_repo || return

  local branches=$(fzf_git_branch_multi)

  if [[ "$branches" = "" ]]; then
    echo "No branch(es) selected."
    return
  fi

  # Force delete selected branch(es)
  echo $branches | xargs git branch -D
}

fzf_git_merge() {
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
alias gb="fzf_git_branch"
alias gco="fzf_git_checkout"
alias gdb="fzf_git_delete_branch"
alias gDb="fzf_git_force_delete_branch"
alias gdf="fzf_git_diff"
alias gol="fzf_git_overwrite_local"
alias gm="fzf_git_merge"
alias gmc="fzf_git_merge_conflicts"
alias gr="fzf_git_rebase"
alias gri="fzf_git_rebase_interactive"
