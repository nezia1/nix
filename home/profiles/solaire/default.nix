{self, ...}: {
  imports = [
    "${self}/home/services/udiskie.nix"

    "${self}/home/programs"

    "${self}/home/terminal/emulators/foot.nix"
    "${self}/home/programs/editors/neovim.nix"
    "${self}/home/programs/editors/helix.nix"
  ];
}
