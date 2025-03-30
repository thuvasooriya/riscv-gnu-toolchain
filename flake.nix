{
  description = "rvgnu flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        deps = with pkgs; [
          python313
          gawk
          gnused
          make
          gmp
          mpfr
          libmpc
          isl
          zlib
          expat
          texinfo
          flock
          libslirp
          # dtc
          # boost
        ];
      in {
        legacyPackages = pkgs;
        devShell = pkgs.mkShell {
          name = "rvgnutc";
          buildInputs = deps;
          # RISCV_TESTS_ROOT = "${pkgs.riscvTests}";
          shellHook = ''
          '';
        };
      }
    )
    // {
      inherit inputs;
    };
}
