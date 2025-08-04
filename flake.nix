{
  description = "A Nix flake for the consul-cni binary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      packages.${system}.consul-cni = pkgs.stdenv.mkDerivation rec {
        pname = "consul-cni";
        version = "1.8.0";

        src = pkgs.fetchurl {
          url = "https://releases.hashicorp.com/consul-cni/${version}/consul-cni_${version}_linux_amd64.zip";
          sha256 = "ddcaa91f652f7b6476f296378635244b64e189f7bb0291ab313d0ba7e837e573";
        };
        sourceRoot = ".";

	nativeBuildInputs = [ pkgs.unzip ];

        installPhase = ''
          mkdir -p $out/bin
          unzip $src -d $out/bin -x README
          chmod +x $out/bin/consul-cni
	'';

        meta = with pkgs.lib; {
          description = "Consul CNI plugin for HashiCorp Nomad (pre-built binary)";
          license = licenses.mpl20;
        };
      };

      defaultPackage.${system} = self.packages.${system}.consul-cni;
    };
}

