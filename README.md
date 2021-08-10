# efficienzsh

A collection of Zsh functions to simplify and streamline common command-line
workflows.

## Table of Contents

- [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Clone Repository](#clone-repository)
  - [Sourcing in .zshrc](#source-in-zshrc)
- [Usage](#usage)

## Installation

### Dependencies

Each .zsh file in efficienzsh requires different dependencies. As such, you may
not require all dependencies depending on which .zsh files you're sourcing.

An exhaustive list of dependencies:
- [Oh My Zsh](https://ohmyz.sh/)
- [fzf](https://github.com/junegunn/fzf)
- [git](https://git-scm.com/)

### Clone Repository

You can "git clone" this repository to any directory.

```sh
git clone https://github.com/nathanrowe4/efficienzsh.git ~/.efficienzsh
```

### Source in .zshrc

efficienzsh is a collection of .zsh files that can be individually sourced into
your .zshrc file.

Therefore, to use any of the commands, add the following in your .zshrc file:
```zsh
export efficienzsh="~/.efficienzsh"

# Source the efficienzsh files you wish to use
[ -f $efficienzsh/fzf-git.zsh ] && source $efficienzsh/fzf-git.zsh
```

## Usage

Complete usage documentation for efficienzsh can be found
[here](https://nathanrowe4.github.io/efficienzsh).
