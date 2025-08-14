{
  description = "Minimal build VM configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          git
          nh
          docker
          fzf
          lazygit
        ];

        shellHook = ''
          if [ -f "/home/josef/gpu_test/gpu_test.sh" ]; then
            source "/home/josef/gpu_test/gpu_test.sh"
          fi
          alias lg='lazygit'
        '';
      };
    };
}
