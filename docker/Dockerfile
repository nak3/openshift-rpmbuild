FROM centos:centos6

ADD openshift-origin-nightly-deps.repo /etc/yum.repos.d/openshift-origin-nightly-deps.repo

RUN yum update -y && yum clean all
RUN yum -y install tar git createrepo rpm-build scl-utils-build ruby193-build jpackage-utils ruby193-rubygem-rails ruby193-rubygem-compass-rails ruby193-rubygem-sprockets ruby193-rubygem-rdiscount ruby193-rubygem-formtastic ruby193-rubygem-net-http-persistent ruby193-rubygem-haml ruby193-rubygem-therubyracer ruby193-rubygem-minitest ruby193-rubygems-devel ruby193-rubygem-coffee-rails ruby193-rubygem-jquery-rails ruby193-rubygem-uglifier ruby193-rubygems rubygem-openshift-origin-console ruby193-ruby ruby193-ruby-devel ruby193-rubygem-json v8314 pam-devel libselinux-devel libattr-devel ruby193-rubygem-sass-twitter-bootstrap ruby193-rubygem-sass-rails ruby193-rubygem-syslog-logger nodejs010-build selinux-policy httpd gcc vim-enhanced wget epel-release && \
    yum -y install golang
RUN cd /tmp && git clone https://github.com/openshift/origin-server.git && wget https://raw.githubusercontent.com/nak3/openshift-rpmbuild/master/openshift-rpmbuild.sh
RUN cd /tmp && /bin/bash openshift-rpmbuild.sh buildall

ENTRYPOINT /bin/bash
