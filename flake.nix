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
                version = "1.0.11";
                sha256 = "18ea6f3c59f1649156a1709c282d8e05939fed7f915aab656a3192b91b4d5efa";
              }
            ];
          })
        ];
      };
    }
  );
}