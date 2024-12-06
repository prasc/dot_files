# Environment Variables
export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short  # Sets the default layout for the Brazil workspace
export AUTO_TITLE_SCREENS="NO"  # Disables automatic terminal title updates
export RPROMPT=  # Clears the right-hand side of the prompt
export NODE_PATH='/home/pcheliy/.nvm/versions/node/v14.19.3/bin/node'  # Sets the Node.js path
export PATH="$HOME/.npm-packages/bin:$PATH"  # Adds the npm global packages directory to PATH
export PATH=$HOME/.toolbox/bin:$PATH  # Adds the .toolbox/bin directory to PATH
export AWS_EC2_METADATA_DISABLED=true  # Disables AWS EC2 instance metadata service
export LANG=en_US.UTF-8  # Sets the system locale to English (United States) with UTF-8 encoding
export HISTFILE=~/.zsh_history  # Sets the location of the zsh history file
export HISTFILESIZE=1000000000  # Sets the maximum size of the zsh history file
export HISTSIZE=1000000000  # Sets the maximum number of commands to keep in memory
export AUTO_NOTIFY_EXPIRE_TIME=8000  # Sets the expiration time for auto-notify plugin notifications
export AUTO_NOTIFY_THRESHOLD=10  # Sets the threshold for auto-notify plugin notifications
export AUTO_NOTIFY_IGNORE=("vim" "nvim" "more" "man" "watch" "git commit" "ssh")  # Sets the list of commands to ignore for auto-notify plugin

export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=/opt/homebrew/bin:$PATH

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Aliases
alias getStackTrace='node /Users/pcheliy/workplace/sn-7443/src/SpaceNeedleJSCli/src/getStackTrace.js'
alias showStackTrace='cat /Users/pcheliy/workplace/sn-7443/src/SpaceNeedleJSCli/output/sourceMapStaceTrace.md'
alias auth='mwinit --aea'
alias sshhost='ssh dev-dsk-pcheliy-1a-dd0ee066.us-east-1.amazon.com'
alias sshcr='ssh dev-dsk-pcheliy-1a-4498d3bf.us-east-1.amazon.com'
alias bb='brazil-build'
alias odintunnel='ssh -fNL 2009:127.0.0.1:2009 dev-dsk-pcheliy-1a-dd0ee066.us-east-1.amazon.com'
alias bws='brazil ws'
alias python=/usr/bin/python3

# Functions
set-title() {
    echo -e "\e]0;$*\007"
}  # Function to set the terminal window title

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}  # Overrides the default ssh command to update the terminal title

parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\[\033[0;32m\1\033[0m\]/p'
}  # Function to parse the current Git branch

sync-dot-files() {
    rsync -avu --progress /home/pcheliy/zsh-plugins /home/pcheliy/play/Pcheliy_dotfiles/src/Pcheliy_dotfiles/DevDesktop/zsh-plugin
    rsync -avu --progress /home/pcheliy/.zshrc /home/pcheliy/play/Pcheliy_dotfiles/src/Pcheliy_dotfiles/DevDesktop/
}  # Function to synchronize zsh plugin files and .zshrc

pull-packages() {
    brazil ws --create --name ~/home/pcheliy/rebase-packages -vs spaceneedle/live
    cd ~/home/pcheliy/rebase-packages
    bws use -p SpaceNeedleExplorationExperienceWeb --latestVersion
    bws use -p SpaceNeedleJSExplorationConstants --latestVersion
    bws use -p SpaceNeedleJSExplorationExperienceComponents --latestVersion
    bws use -p SpaceNeedleJSExplorationFederatedModules --latestVersion
    bws use -p SpaceNeedleJSExplorationTypes --latestVersion
    bws use -p SpaceNeedleWebsiteStaticContent --latestVersion

    bws use -vs spaceneedle/live-sirius-orch

    brazil-recursive-cmd 'git checkout sirius-orch' --allPackages
    brazil-recursive-cmd 'git rebase mainline' --allPackages
    brazil-recursive-cmd 'git push' --allPackages
}  # Function related to the Brazil tool for managing packages

createSpectrumTestWorkspace() {
    brazil ws create --name spectrum-tests --root ~/workplace/spectrum-tests --versionset spaceneedle/live
    cd ~/workplace/spectrum-tests
    brazil ws --use --package SpectrumTestUtilities --latest
    brazil ws --use --package SpectrumPageObjects --latest
    brazil ws --use --package SpaceNeedleUIVisualsTests --latest
    cd src/SpectrumPageObjects
    brazil-build
    cd ../SpectrumTestUtilities
    brazil-build
    cd ../SpaceNeedleUIVisualsTests
    brazil-build
    cd ../SpectrumPageObjects
    sed -i '' '/main/s/[^:]*$/'"\"src\/index\.js\",/" package.json
    npm link
    cd ../SpaceNeedleUIVisualsTests
    npm link SpectrumPageObjects
    cp .env_examples/.env.json.example .env.json
    cp .env_examples/.account.json.example .account.json
    cp .env_examples/.endpoint.json.example .endpoint.json
}

# Prompt Configuration
autoload -Uz vcs_info  # Loads the vcs_info module for displaying version control information
precmd() { vcs_info }  # Updates the vcs_info before each prompt
zstyle ':vcs_info:git:*' formats '%b '  # Configures the format of the Git information in the prompt
setopt PROMPT_SUBST  # Enables prompt string expansion
PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '  # Defines the format of the zsh prompt
PS1="🏠%F{33}p%f%F{39}c%f%F{38}h%f%F{44}e%f%F{50}l%f%F{43}i%f%F{44}y-%f%F{45}home🏠 :%f%F{50}%1~/%f $"  # Defines the primary zsh prompt string
RPROMPT='$(parse_git_branch)'

# Plugins and Tools
source /Users/pcheliy/zsh-plugins/aliases  # Sources the aliases plugin
source /Users/pcheliy/zsh-plugins/setupfunctions  # Sources the setup functions plugin
source /Users/pcheliy/zsh-plugins/cursorchange  # Sources the cursor change plugin
source /Users/pcheliy/zsh-plugins/zsh-z/zsh-z.plugin.zsh  # Sources the zsh-z plugin for directory jumping
source /Users/pcheliy/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh  # Sources the zsh-autosuggestions plugin
source /Users/pcheliy/zsh-plugins/auto-notify/auto-notify.plugin.zsh  # Sources the auto-notify plugin
source /Users/pcheliy/zsh-plugins/you-should-use/you-should-use.plugin.zsh  # Sources the you-should-use plugin
source /Users/pcheliy/zsh-plugins/diff-so-fancy/diff-so-fancy.plugin.zsh  # Sources the diff-so-fancy plugin
source /Users/pcheliy/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # Sources the zsh-syntax-highlighting plugin
[ -s "/home/pcheliy/.scm_breeze/scm_breeze.sh" ] && source "/home/pcheliy/.scm_breeze/scm_breeze.sh"  # Sources the scm_breeze tool

for f in AmazonAwsCli envImprovement OdinTools BarkCLI ApolloCommandLine; do
    if [[ -d /apollo/env/$f ]]; then
        export PATH=$PATH:/apollo/env/$f/bin  # Adds various tool directories to PATH
    fi
done

# Completion and History
autoload -U compinit && compinit  # Initializes the zsh completion system
zstyle ':completion:*' menu select  # Configures the completion menu style
setopt HIST_FIND_NO_DUPS  # Avoids duplicates in the history
setopt INC_APPEND_HISTORY  # Appends to the history file incrementally

# Working Directory
cd /Users/pcheliy/workplace

# iTerm2 Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"  # Sources the iTerm2 shell integration script

# Additional Setup
eval "$(pyenv init --path)"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh)"  # Set up mise for runtime management

