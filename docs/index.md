## efficienzsh

### fzf-git
There's no denying it, git provides a pretty awesome CLI. But I was finding
myself in situations where my keystrokes couldn't keep up to my brain.  fzf-git
is a tool with the purpose of simplifying commonly-used git workflows so that
less brain-power is required. This is simply an augmentation to the existing
git functionality, so there are certainly situations where the complexity
requires the more feature-rich CLI.

Without further ado:
- [fzf\_git\_diff](#fzf-git-diff)
- [fzf\_git\_overwrite\_local](#fzf-git-overwrite-local)
- [fzf\_git\_checkout](#fzf-git-checkout)
- [fzf\_git\_delete\_branch](#fzf-git-delete-branch)
- [fzf\_git\_force\_delete\_branch](#fzf-git-force-delete-branch)
- [fzf\_git\_merge](#fzf-git-merge)
- [fzf\_git\_rebase](#fzf-git-rebase)
- [fzf\_git\_rebase\_interactive](#fzf-git-rebase-interactive)

#### fzf\_git\_diff {#fzf-git-diff}

fzf\_git\_diff allows you to select which files you wish to see the diff for,
without manually typing each of their relative paths into the command line.
This command should be used when you wish to see the diff for only select files
in your list of modified files.

This is essentially ```git diff <file-1> <file-2> ... <file-n>``` with a
simpler way to select ```<file-1>``` through ```<file-n>```.

#### fzf\_git\_overwrite\_local {#fzf-git-overwrite-local}

fzf\_git\_overwrite\_local allows you to select which files you wish to
overwrite the local changes made. This command should be used when you wish to
overwrite the local changes for only select files in your list of modified
files.

This is essentially ```git checkout -- <file-1> <file-2> ... <file-n>``` with a
simpler way to select ```<file-1>``` through ```<file-n>```.

#### fzf\_git\_checkout {#fzf-git-checkout}

fzf\_git\_checkout allows you to fuzzy find and select the branch you wish to
checkout. This command is useful when you forget the name of the branch you
wish to checkout.

This is essentially ```git checkout <branch>``` with a simpler way to select
```<branch>```.

#### fzf\_git\_delete\_branch {#fzf-git-delete-branch}

fzf\_git\_delete\_branch allows you to fuzzy find and select multiple branches
you wish to delete. This is useful to quickly clean up your local branches that
accumulate over time.

This is essentially ```git branch -d <branch-1> <branch-2> ... <branch-n>```
with a simpler way to select ```<branch-1>``` through ```<branch-n>```.

#### fzf\_git\_force\_delete\_branch {#fzf-git-force-delete-branch}

fzf\_git\_delete\_branch allows you to fuzzy find and select multiple branches
you wish to force delete. This is useful to quickly clean up your local
branches that accumulate over time.

This is essentially ```git branch -D <branch-1> <branch-2> ... <branch-n>```
with a simpler way to select ```<branch-1>``` through ```<branch-n>```.

#### fzf\_git\_merge {#fzf-git-merge}

fzf\_git\_merge allows you to fuzzy find and select the branch you wish to
merge.

This is essentially ```git merge <branch>``` with a simpler way to select
```<branch>```.

#### fzf\_git\_rebase {#fzf-git-rebase}

fzf\_git\_rebase allows you to fuzzy find and select the branch you wish to
rebase.

This is essentially ```git rebase <branch>``` with a simpler way to select
```<branch>```.

#### fzf\_git\_rebase\_interactive {#fzf-git-rebase-interactive}

fzf\_git\_rebase allows you to fuzzy find and select the commit you wish to use
as the fork point in the interactive rebase. This is useful when you want to
modify the commit history but aren't sure exactly how many commits ago to set
your fork point.

This is essentially ```git rebase -i <commit>``` with a simpler way to select
```<commit>```.
