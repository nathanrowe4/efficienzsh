## efficienzsh

The following modules are available in efficienzsh:

- [fzf-git](#fzf-git)
- [fzf-kubectl](#fzf-kubectl)

### fzf-git {#fzf-git}
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
- [fzf\_git\_merge\_conflicts](#fzf-git-merge-conflicts)
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

#### fzf\_git\_merge\_conflicts {#fzf-git-merge-conflicts}

fzf\_git\_merge\_conflicts allows you to fuzzy find files in your repository
with merge conflicts. When you select a file, it opens in your default visual
editor. Once you finish editing the selected file, you will be prompted to mark
your changes as resolved.

##### Conflicts in Location List

If your visual editor of choice is "vim", fzf\_git\_merge\_conflicts will
populate the location list with the conflicts for the file you selected. This
will allow you to navigate quickly to the merge conflicts you wish to resolve.
More information on location lists and how to use them can be found in the
[documentation](http://vimdoc.sourceforge.net/htmldoc/quickfix.html)

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

### fzf-kubectl {#fzf-kubectl}

kubectl is a tool built to control the Kubernetes cluster manager. As such, it
provides functionality to run operations on different resource types in a
cluster.

The following functions are available:
- [fzf\_kubectl\_describe\_pod](#fzf-kubectl-describe-pod)
- [fzf\_kubectl\_logs\_pod](#fzf-kubectl-logs-pod)
- [fzf\_kubectl\_port\_forward\_pod](#fzf-kubectl-port-forward-pod)
- [fzf\_kubectl\_exec\_pod](#fzf-kubectl-exec-pod)

#### fzf\_kubectl\_describe\_pod {#fzf-kubectl-describe-pod}

fzf\_kubectl\_describe\_pod allows you to fuzzy search for a namespace and
select a pod from the selected namespace. This allows you to very quickly
describe a pod.

This is essentially ```kubectl -n <namespace> describe pod <pod>``` with a
simpler way to select ```<namespace``` and ```<pod>```. Further documentation
for the "describe" command can be found
[here](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe).

#### fzf\_kubectl\_logs\_pod {#fzf-kubectl-logs-pod}

fzf\_kubectl\_logs\_pod allows you to fuzzy search for a namespace and select a
pod from the selected namespace. Then, we can get the logs for the selected
pod.

This is essentially ```kubectl -n <namespace> logs <pod>``` with a simpler way
to select ```<namespace>``` and ```<pod>```. Further documentation for the
"logs" command can be found
[here](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#logs).

#### fzf\_kubectl\_port\_forward\_pod {#fzf-kubectl-port-forward-pod}

fzf\_kubectl\_port\_forward\_pod allows you to fuzzy search for a namespace and
select a pod from the selected namespace. Then, we can port-forward a local
port to the selected pod. The default port to forward can be specified on a
per-deployment basis.

This is essentially ```kubectl -n <namespace> port-forward pod/<pod> <port>```
with a simpler way to select ```<namespace>``` and ```<pod>```. Further
documentation for the "port-forward" command can be found
[here](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#port-forward).

#### fzf\_kubectl\_exec\_pod {#fzf-kubectl-exec-pod}

fzf\_kubectl\_exec\_pod allows you to fuzzy search for a namespace and select a
pod from the selected namespace. Then, we can exec into the pod.

This is essentially ```kubectl -n <namespace> exec <pod> -it -- /bin/bash```
with a simpler way to select ```<namespace>``` and ```<pod>```. Further
documentation for the "exec" command can be found
[here](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#exec).
