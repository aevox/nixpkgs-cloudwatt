# DO NOT EDIT
# This file has been generated by
# $ ./tools/sources-from-github.sh

{pkgs}:
{
  # Head of branch R3.2-cloudwatt of repository github.com/cloudwatt/contrail-controller at 2018-10-01 13:56:37
  controller = pkgs.fetchFromGitHub {
    name = "controller";
    owner = "cloudwatt";
    repo = "contrail-controller";
    rev = "a9547fcee938ee8d72257fe949520d2a3acbee25";
    sha256 = "1viv1lqw4q2i3b08bc26kvg0xfp4vvk00whv05c0sbix3czc5fyz";
  };
  # Head of branch R3.2-cloudwatt of repository github.com/cloudwatt/contrail-neutron-plugin at 2018-10-01 13:56:53
  neutronPlugin = pkgs.fetchFromGitHub {
    name = "neutronPlugin";
    owner = "cloudwatt";
    repo = "contrail-neutron-plugin";
    rev = "4a3ff56631ae0df9fd2acfdc541fe2fa36e8c861";
    sha256 = "1c8vk65czkxp7ag05yafafzx8y5bzyss6247145f9w91yzsfkf62";
  };
  # Head of branch R3.2-cloudwatt of repository github.com/nlewo/contrail-vrouter at 2018-10-01 13:56:55
  vrouter = pkgs.fetchFromGitHub {
    name = "vrouter";
    owner = "nlewo";
    repo = "contrail-vrouter";
    rev = "005b2af10aa8ad5819e123f9ef596041dba8db5d";
    sha256 = "0pk8vhgskjnr9914n49ilzvpxiwxabmsf3cd8zqn80s4pkhbd78w";
  };
}
