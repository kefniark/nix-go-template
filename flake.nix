{
  description = "Nix-Go-Template environment";

  # Flake Inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    # Use unstable channel for go 1.22
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    gomod2nix = {
      url = github:nix-community/gomod2nix;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  # Flake Output
  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        gm2n = gomod2nix.legacyPackages.${system};

        # Configuration
        version = "0.0.2";
        meta = {
          description = "Nix-Go-Template CLI";
          homepage = "https://github.com/kefniark/nix-go-template";
        };
      in {
        # We build our application
        packages.default = gm2n.buildGoApplication {
          inherit version meta;

          pname = "nix-go-template-${system}";
          src = ./.;
          pwd = ./.;
          ldflags = [ "-s" "-w" "-X main.BuildVersion=${version}" ];
          modules = ./gomod2nix.toml;
          doCheck = false;
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          name = "nix-go-devshell-${system}";
          buildInputs = [
            # Go (from unstable channel)
            pkgs-unstable.go_1_22
            pkgs-unstable.gocover-cobertura
            gm2n.gomod2nix

            # Dev Tools: just, goimports, godoc, ...
            # pkgs.go
            pkgs.gotools
            pkgs.golangci-lint
            pkgs.just
          ];
          shellHook = "	echo \"💻 Welcome in Nix Dev Shell ($system) 🚀\"\n";
        };

        formatter = pkgs.nixfmt;
      });
}
