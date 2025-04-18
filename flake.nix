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
          autoconf
          # make
          gmp
          mpfr
          libmpc
          isl
          zlib
          expat
          texinfo
          flock
          flex
          libslirp
          bison
          gnum4
          # dtc
          # boost
          # gcc10
          # clang
        ];
      in {
        legacyPackages = pkgs;
        devShell = pkgs.mkShell.override {stdenv = pkgs.clang16Stdenv;} {
          name = "rvgnutc";
          buildInputs = deps;
          hardeningDisable = ["all"];
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
