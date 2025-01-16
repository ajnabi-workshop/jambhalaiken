{
  description = "Jambhalaiken Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          bashInteractive
          deno
          gnugrep
          just
          httpie
          neovim
          nixpkgs-fmt
          nix-prefetch-git
          nodejs_20
          nodePackages.pnpm
          python311
          python311Packages.autopep8
          (vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-extensions; [
              asvetliakov.vscode-neovim
              denoland.vscode-deno
              dracula-theme.theme-dracula
              jnoortheen.nix-ide
              mkhl.direnv
              ms-python.python
              ms-python.vscode-pylance
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "aiken";
                publisher = "TxPipe";
                version = "1.0.8";
                sha256 = "99b000d27a710d7313dd2639a4ff56ec9d38dcbbbf126c36f259683217a3a6f9";
              }
            ];
          })
        ];
      };
    }
  );
}