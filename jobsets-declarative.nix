{ nixpkgs, declInput }:
let
  pkgs = import nixpkgs {};
  desc = {
    trunk = {
      description = "Build master of nixpkgs-cloudwatt";
      checkinterval = "60";
      enabled = "1";
      nixexprinput = "cloudwatt";
      nixexprpath = "jobset.nix";
      schedulingshares = 100;
      enableemail = false;
      emailoverride = "";
      keepnr = 3;
      hidden = false;
      inputs = {
        cloudwatt = {
          value = "https://github.com/nlewo/nixpkgs-cloudwatt declarative keepDotGit";
          type = "git";
          emailresponsible = false;
        };
        bootstrap_pkgs = {
          value = "https://github.com/NixOS/nixpkgs a0e6a891ee21a6dcf3da35169794cc20b110ce05";
          type = "git";
          emailresponsible = false;
        };
        pushToDockerRegistry = {
          value = "true";
          type = "boolean";
          emailresponsible = false;
        };
        publishToAptly = {
          value = "true";
          type = "boolean";
          emailresponsible = false;
        };
      };
    };
  };

in {
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toXML declInput}
    EOF
    cat >$out <<EOF
    ${builtins.toJSON desc} 
    EOF
  '';
}
