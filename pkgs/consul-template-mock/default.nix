{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-template-mock-${version}";
  version = "2018-08-04";

  goPackagePath = "github.com/nlewo/consul-template-mock";

  src = fetchFromGitHub {
    owner = "nlewo";
    repo = "consul-template-mock";
    rev = "9e8e923bd387a9caf5ff277ab4b498366d45bbde";
    sha256 = "13w06vmi0mv3vwl6ar8171w78jjrpa4a31d4g76hp5kvz5yf38c6";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nlewo/consul-template-mock;
    description = "Render consul-template templates without Consul";
    licenses = [ licenses.gpl3 ];
    maintainers = [ maintainers.lewo ];
  };
}
