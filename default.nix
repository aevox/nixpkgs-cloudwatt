{ fetched ? import ./nixpkgs-fetch.nix { }
, nixpkgs ? fetched.pkgs
, contrail ? fetched.contrail
}:

let pkgs = import nixpkgs { };
    lib =  import ./pkgs/lib { inherit pkgs cwPkgs; };

    callPackage = pkgs.lib.callPackageWith (
      pkgs // cwPkgs // { inherit pkgs lib callPackage; });
    callPackages = pkgs.lib.callPackagesWith (
      pkgs // cwPkgs // { inherit pkgs lib callPackage; });

    cwPkgs = rec {

      ci = callPackage ./ci { };

      perp = callPackage ./pkgs/perp { };

      fluentd = callPackage ./pkgs/fluentd { };

      fluentdCw = callPackage ./pkgs/fluentdCw { };

      consulTemplateMock = callPackage ./pkgs/consul-template-mock { };

      contrail32Cw = callPackages ./pkgs/contrail32Cw {
        inherit pkgs;
        contrailPath = contrail;
        nixpkgsPath = nixpkgs;
      };

      debianPackages = callPackages ./pkgs/debian-packages {
        contrailPkgs = contrail32Cw;
        skydive = skydive.override (_: { enableStatic = true;});
      };
      dockerImages = callPackages ./pkgs/docker-images { contrailPath = contrail; nixpkgs = nixpkgs; };

      tools = callPackages ./pkgs/tools { };

      locksmith = callPackage ./pkgs/vault-fernet-locksmith { };

      skydive = callPackage ./pkgs/skydive { };

      waitFor = callPackage ./pkgs/wait-for { };

      openstackClient = callPackage ./pkgs/openstackclient { };

      test.hydra = callPackage ./test/hydra.nix { hydraImage = ci.hydraImage; };
      test.fluentd = callPackage ./test/fluentd.nix { };
      test.perp = callPackage ./test/perp.nix { };
      test.contrail = callPackage ./test/contrail.nix {
        cwPkgs = cwPkgs; contrailPath = contrail; contrailPkgs = contrail32Cw;
      };
      test.contrailLoadDatabase = callPackage ./test/contrail-load-database.nix {
        contrailPath = contrail; contrailPkgs = contrail32Cw;
      };
      test.gremlinDump = callPackage ./test/gremlin-dump.nix {
        contrailPath = contrail; contrailPkgs = contrail32Cw;
      };

      # to run these tests:
      # nix-instantiate --eval --strict -A test.lib
      test.lib = callPackage ./pkgs/lib/tests.nix { };

      ubuntuKernelHeaders = callPackages ./pkgs/ubuntu-kernel-headers { };

    };

in cwPkgs
