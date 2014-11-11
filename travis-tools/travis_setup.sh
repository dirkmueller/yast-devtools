#!/bin/sh
#
# Prepare a Travis node for running Yast build (SLE-12-GA branch):
#
# - import YaST:SLE-12:GA:Travis OBS repository GPG key
# - add YaST:SLE-12:GA:Travis OBS repository
# - download/refresh repository metadata
# - optionally install specified packages
# - optionally install specified Ruby gems (from rubygems.org)
#   (Very likely you will need to switch to system Ruby using
#    "rvm reset" *before* installing gems with this script.)
#

set -x

# prepare the system for installing additional packages from OBS
curl http://download.opensuse.org/repositories/YaST:/SLE-12:/GA:/Travis/xUbuntu_12.04/Release.key | sudo apt-key add -
echo "deb http://download.opensuse.org/repositories/YaST:/SLE-12:/GA:/Travis/xUbuntu_12.04/ ./" | sudo tee -a /etc/apt/sources.list
sudo apt-get update -q

while getopts ":p:g:" opt; do
  case $opt in
    # install packages
    p)
      sudo apt-get install --no-install-recommends $OPTARG
      ;;
    # install Ruby gems
    g)
      sudo gem install $OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

