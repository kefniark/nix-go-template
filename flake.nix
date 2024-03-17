{
  description = "Nix-Go-Template environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake Output
  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, gomod2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        version = "0.0.2";
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        gm2n = gomod2nix.legacyPackages.${system};

        go-build = gm2n.buildGoApplication {
          inherit version;

          pname = "nix-go-${system}";
          src = ./.;
          pwd = ./.;
          doCheck = false;
          go = pkgs-unstable.go_1_22;
          modules = ./gomod2nix.toml;
          ldflags = [ "-s" "-w" "-X main.BuildVersion=${version}" ];
          meta = {
            description = "Nix-Go-Template CLI";
            homepage = "https://github.com/kefniark/nix-go-template";
          };
        };
      in {
        # The main output of the build `nix build .`
        packages.default = go-build;

        # Apps can be used with `nix run .#app1`
        apps.app1 = {
          type = "app";
          program = "${go-build}/bin/app1";
        };
        apps.app2 = {
          type = "app";
          program = "${go-build}/bin/app2";
        };

        # Development shell can be used with `nix develop .`
        devShells.default = pkgs.mkShell {
          name = "nix-go-devshell-${system}";
          # Build deps
          nativeBuildInputs = with pkgs; [
            pkgs-unstable.go_1_22
            pkgs-unstable.gocover-cobertura
            gm2n.gomod2nix
            gotools
            golangci-lint
            just
          ];
          # Build + Runtime deps
          buildInputs = [ ];

          # Create some alias for easy development
          shellHook = ''
            alias dev-app1="go run cmd/app1/app1.go"
            alias dev-app2="go run cmd/app2/app2.go"
            echo "💻 Welcome in Nix Dev Shell ($system) 🚀"
          '';
        };

        # Can be used with `nix fmt`
        formatter = pkgs.nixfmt;
      });
}
