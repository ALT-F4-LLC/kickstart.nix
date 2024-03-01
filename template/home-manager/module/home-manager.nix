{
  homeDirectory,
  username,
}: {pkgs, ...}: {
  # add home-manager user settings here
  home.homeDirectory = homeDirectory;
  home.username = username;
  home.packages = with pkgs; [git neovim];
  home.stateVersion = "23.11";
}
