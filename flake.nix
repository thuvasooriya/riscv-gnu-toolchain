{
  description = "rvgnu flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Function to generate attributes for all systems
    forAllSystems = fn:
      nixpkgs.lib.genAttrs supportedSystems (
        system:
          fn {
            inherit system;
            pkgs = import nixpkgs {inherit system;};
          }
      );

    # Determine if a system is Linux-based
    isLinux = system: nixpkgs.lib.hasPrefix "linux" (nixpkgs.lib.last (nixpkgs.lib.splitString "-" system));

    # Determine if a system is Darwin-based
    isDarwin = system: nixpkgs.lib.hasPrefix "darwin" (nixpkgs.lib.last (nixpkgs.lib.splitString "-" system));
  in {
    # Define development shells for each system
    devShells = forAllSystems (
      {
        system,
        pkgs,
      }: let
        # Common dependencies for all platforms
        commonDeps = with pkgs; [
          python313
          gawk
          gnused
          autoconf
          gmp
          mpfr
          libmpc
          isl
          zlib
          expat
          texinfo
          flex
          bison
          gnum4
          flock
          libslirp
        ];

        # linux-specific dependencies
        linuxDeps = with pkgs; [
        ];

        # system-specific dependencies
        systemDeps =
          commonDeps
          ++ (
            if isLinux system
            then linuxDeps
            else [
              # darwin specific dependencies
            ]
          );

        # system-specific stdenv
        systemStdenv =
          if isLinux system
          then pkgs.clang16Stdenv
          # else pkgs.stdenv;
          else pkgs.clang16Stdenv;
      in {
        default =
          pkgs.mkShell.override {
            stdenv = systemStdenv;
          } {
            name = "rvgnutc";
            buildInputs = systemDeps;
            # turn off warning to compile tc successfully cause it's a c project
            hardeningDisable = ["all"];
            shellHook = ''
              echo "activating rvgnu development environment for ${system}"
            '';
          };
      }
    );
  };
}
