{pkgs, ...}: {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------
  home.packages = with pkgs; [
    git
    neovim
    awscli2
    fd
    gh
    # git-remote-codecommit
    jq
    k9s
    kubectl
    ripgrep
    # z-lua
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER="nvim +Man!"
  };

  home.stateVersion = "23.11";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------
  programs.bat = {
    enable = true;
    config = {theme = "catppuccin";};
    themes = {
      catppuccin = {
        src =
          pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          };
        file = "Catppuccin-macchiato.tmTheme";
      };
    };
  };

  programs.bottom.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      bind r source-file ~/.tmux.conf
      # start window numbers at 1 to match keyboard order with tmux window order
      set -g base-index 1

      # start pane indexing at 1 for tmuxinator
      set-window-option -g pane-base-index 1

      # renumber windows sequentially after closing any of them
      set -g renumber-windows on

      # Faster escape sequences (default is 500ms).
      # This helps when exiting insert mode in Vim: http://superuser.com/a/252717/65504
      set -s escape-time 50

      # Set mouse on
      set -g mouse on

      # Neovim says it needs this
      set-option -g focus-events on

      # Use vim keybindings in copy mode
      setw -g mode-keys vi
      # Setup 'v' to begin selection
      bind-key -T copy-mode-vi v send -X begin-selection
      # Setup 'y' to copy selection
      bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
      # Setup 'P' to paste selection
      bind P paste-buffer


      # Rebind spit and new-window commands to use current path
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      set-window-option -g mode-keys vi
      #bind -T copy-mode-vi v send-keys -X begin-selection

      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      # Mousemode
      # Toggle mouse on
      bind m set -g mouse on \; display 'Mouse Mode: ON'

      # Toggle mouse off
      bind M set -g mouse off \; display 'Mouse Mode: OFF'

      # Open a "test" split-window at the bottom
      bind t split-window -f -l 15 -c "#{pane_current_path}"
      # Open a "test" split-window at the right
      bind T split-window -h -f -p 35 -c "#{pane_current_path}"

      # Style status bar
      set -g status-style fg=white,bg=black
      set -g window-status-current-style fg=green,bg=black
      set -g pane-active-border-style fg=green,bg=black
      set -g window-status-format " #I:#W#F "
      set -g window-status-current-format " #I:#W#F "
      set -g window-status-current-style bg=green,fg=black
      set -g window-status-activity-style bg=black,fg=yellow
      set -g window-status-separator ""

      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
    '';
    # shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      cat = "bat";
      dr = "docker container run --interactive --rm --tty";
      lg = "lazygit";
      # nb = "nix build --json --no-link --print-build-logs";
      wt = "git worktree";
    };

    syntaxHighlighting = {
      enable = true;
    };
  }
}
