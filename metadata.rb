name "app_config"
maintainer "Zozi"
maintainer_email "dev@zozi.com"
license "Apache 2.0"
description "Library for managing application config"
version "0.0.4"

%w(ubuntu debian suse fedora centos redhat amazon scientific).each do |os|
  supports os
end
