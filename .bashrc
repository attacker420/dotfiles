HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

alias grep='grep --color=auto'
alias gg='git grep -ni'
alias phpunit='phpunit --colors'
alias vimpress="VIMENV=talk vim"
alias c="composer"
alias v="vagrant"
alias node="nodejs"

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Stolen from Arch wiki
txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
badgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

export TERM=xterm-256color
export EDITOR=/usr/bin/vim


# Open all modified files in vim tabs
alias vimod="vim -p \`git status -suall | awk '{print \$2}'\`"

# Switch to git root dir
alias gr="cd \$(git rev-parse --show-toplevel)"

# Open files modified in a git commit in vim tabs; defaults to HEAD. Pop it in your .bashrc
# Examples: 
#     virev 49808d5
#     virev HEAD~3
function virev {
    commit=$1
    if [ -z "${commit}" ]; then
      commit="HEAD"
    fi
    rootdir=$(git rev-parse --show-toplevel)
    sourceFiles=$(git show --name-only --pretty="format:" ${commit} | grep -v '^$')
    toOpen=""
    for file in ${sourceFiles}; do
      file="${rootdir}/${file}"
      if [ -e "${file}" ]; then
        toOpen="${toOpen} ${file}"
      fi
    done
    if [ -z "${toOpen}" ]; then
      echo "No files were modified in ${commit}"
      return 1
    fi
    vim -p ${toOpen}
}

function gitRepoFlags {
  branch=$(__git_ps1)
  if [ -z "${branch}" ]; then
    return 1
  fi

  rootDir=$(git rev-parse --show-toplevel)

  untracked=$(git ls-files --other --exclude-standard ${rootDir} | wc | awk '{print $1}' 2> /dev/null)
  modified=$(git ls-files --modified ${rootDir} | wc | awk '{print $1}' 2> /dev/null)
  staged=$(git diff --name-only --staged | wc | awk '{print $1}' 2> /dev/null)

  str=""

  if [ "${staged}" != "0" ]; then 
    str="${str}ˢ"
  fi

  if [ "${untracked}" != "0" ]; then 
    str="${str}ᵘ"
  fi

  if [ "${modified}" != "0" ]; then 
    str="${str}ᵐ"
  fi

  echo -n "${str}"
}

function gitPrompt {
  command -v __git_ps1 > /dev/null && __git_ps1 " (%s)"
}

atC="${txtpur}"
nameC="${txtpur}"
hostC="${txtpur}"
pathC="${txtgrn}"
gitC="${txtpur}"
pointerC="${txtgrn}"
normalC="${txtwht}"

# Red name for root
if [ "${UID}" -eq "0" ]; then 
  nameC="${txtred}" 
fi

# Blue for gue hosts
if [ `hostname | cut -b1-3` == "gue" ]; then
  nameC="${txtblu}"
  atC="${txtblu}"
  hostC="${txtblu}"
fi

export PS1="${nameC}\u${atC}@${hostC}\h:${pathC}\w${gitC}\$(gitPrompt)${pointerC}▶${normalC} "

# Marks. See: http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function j { 
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function m { 
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function um { 
    rm -i $MARKPATH/$1 
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

# Local settings
if [ -f ~/.localrc ]; then 
  source ~/.localrc
fi

export PATH=${PATH}:/home/tom/bin
