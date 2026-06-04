# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
alias vim="nvim"
alias cmp="g++ -Wall -Wextra -std=c++2a -O2 -Wshadow -Wformat=2 -Wduplicated-cond -Wcast-qual -Wcast-align -fsanitize=address -fsanitize=undefined -fno-sanitize-recover -fstack-protector -g -DLOCAL"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

help-tmux() {
  cat <<'EOF'
tmux shortcuts

Prefix: Ctrl-b

General
Ctrl-b Ctrl-b    send literal Ctrl-b to the terminal
Ctrl-b r         reload tmux config

Panes
Ctrl-b |         split pane horizontally
Ctrl-b -         split pane vertically
Ctrl-b h         focus pane left
Ctrl-b j         focus pane down
Ctrl-b k         focus pane up
Ctrl-b l         focus pane right
Ctrl-b H         resize pane left by 5
Ctrl-b J         resize pane down by 5
Ctrl-b K         resize pane up by 5
Ctrl-b L         resize pane right by 5
Ctrl-b m         zoom/unzoom pane
Ctrl-b x         kill pane

Windows
Ctrl-b c         new window in current path
Ctrl-b n         next window
Ctrl-b p         previous window
Ctrl-b w         choose window
Ctrl-b ,         rename window

Sessions
Ctrl-b s         choose session
Ctrl-b S         create and switch to a new named session

Copy mode
Ctrl-b [         enter copy mode
Ctrl-b ]         paste buffer
v                begin selection in copy mode
y                copy selection and leave copy mode
r                toggle rectangle selection in copy mode
EOF
}

help-i3() {
  cat <<'EOF'
i3 shortcuts

Mod key: Alt

Alt+Enter           open kitty
Alt+Shift+Enter     horizontal split + open kitty
Alt+Shift+v         vertical split + open kitty
Alt+d               app launcher
Alt+b               browser
Alt+e               file manager
Alt+Shift+q         close focused window

Alt+Shift+c         reload i3 config
Alt+Shift+r         restart i3
Alt+Shift+e         exit i3 prompt

Alt+h/j/k/l         focus left/down/up/right
Alt+Arrow           focus left/down/up/right
Alt+Shift+h/j/k/l   move window left/down/up/right
Alt+Shift+Arrow     move window left/down/up/right

Alt+\               horizontal split
Alt+-               vertical split
Alt+f               fullscreen
Alt+z               tabbed layout
Alt+t               toggle split layout
Alt+Shift+Space     toggle floating
Alt+Space           toggle focus floating/tiling

Alt+r               resize mode
  h/j/k/l or arrows resize
  Enter/Escape      leave resize mode

Alt+1..0            switch workspace 1..10
Alt+Shift+1..0      move window to workspace 1..10

Print               screenshot area
Alt+Print           full screenshot to ~/Pictures
Media keys          volume, mic, playback, brightness
EOF
}

help-kitty() {
  cat <<'EOF'
kitty shortcuts

Ctrl+Shift+c        copy
Ctrl+Shift+v        paste

Super+Enter         new kitty window
Super+v             vertical split
Super+s             horizontal split
Super+h/j/k/l       move between kitty windows
Super+Arrow         move between kitty windows
Super+w             close kitty window
Super+r             resize kitty window
EOF
}

help-vim() {
  cat <<'EOF'
Neovim shortcuts

Leader key: Space

Files and search
Space+pv            open netrw file explorer
Space+pf            find files with Telescope
Ctrl+p              find git files with Telescope
Space+ps            grep text with Telescope
Space+pws           grep word under cursor
Space+pWs           grep WORD under cursor
Space+vh            search help tags

Editing
J / K in visual     move selected lines down/up
J in normal         join line and keep cursor position
Ctrl+d / Ctrl+u     half-page down/up and center cursor
n / N               next/previous search result and center cursor
Space+p in visual   paste over selection without yanking it
Space+y             yank to system clipboard
Space+Y             yank line to system clipboard
Space+d             delete without yanking
Ctrl+c in insert    leave insert mode
Space+s             replace word under cursor across file
Space+x             make current file executable
Space+ee            insert Go-style if err block
Space+Space         source current file

LSP
gd                  go to definition
K                   hover documentation
Space+vws           workspace symbol
Space+vd            open diagnostic float
Space+vca           code action
Space+vrr           references
Space+vrn           rename symbol
Ctrl+h in insert    signature help
[d / ]d             next/previous diagnostic
Space+f             format buffer

Quickfix and location list
Ctrl+k / Ctrl+j     next/previous quickfix item
Space+k / Space+j   next/previous location-list item

Plugins
Space+gs            Git status with fugitive
Space+u             toggle undotree
Space+tt            toggle trouble diagnostics
[t / ]t             next/previous trouble item
Space+zz            toggle zen mode with numbers
Space+zZ            toggle zen mode without numbers

Commands
:Lazy               plugin manager
:Mason              LSP/tool installer
:TSInstall <lang>   install Treesitter parser
EOF
}
export PATH="$HOME/.cargo/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
