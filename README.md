openshift-rpmbuild
==================

The script to build openshift RPM/SRPM packages

Quick start for centos
----------

##### 1. Set up repository
```
cat > /etc/yum.repos.d/openshift-origin-nightly-deps.repo <<EOF
[openshift-origin-nightly-deps]
name=openshift-origin-nightly-deps
baseurl=https://mirror.openshift.com/pub/origin-server/nightly/rhel-6/dependencies/x86_64/
enabled=1
gpgcheck=0
skip_if_unavailable=1
EOF
```

##### 2. Install necessary packages
```
yum -y install tar git createrepo rpm-build scl-utils-build ruby193-build jpackage-utils ruby193-rubygem-rails ruby193-rubygem-compass-rails ruby193-rubygem-sprockets ruby193-rubygem-rdiscount ruby193-rubygem-formtastic ruby193-rubygem-net-http-persistent ruby193-rubygem-haml ruby193-rubygem-therubyracer ruby193-rubygem-minitest ruby193-rubygems-devel ruby193-rubygem-coffee-rails ruby193-rubygem-jquery-rails ruby193-rubygem-uglifier ruby193-rubygems rubygem-openshift-origin-console ruby193-ruby ruby193-ruby-devel ruby193-rubygem-json v8314 pam-devel libselinux-devel libattr-devel ruby193-rubygem-sass-twitter-bootstrap ruby193-rubygem-sass-rails ruby193-rubygem-syslog-logger nodejs010-build selinux-policy golang httpd gcc epel-release
yum -y install golang
```

##### 3. Clone this repository and copy scpript to OpenShift source diretory
```
git clone https://github.com/nak3/openshift-rpmbuild.git
```

```
cp openshift-rpmbuild/openshift-rpmbuild.sh $OPENSHIFT_SRCDIR
```

#### 4. Run and build all RPM packages
```
./openshift-rpmbuild.sh buildall
```

#### 5. Find rpm packages ./tmp.repos/RPMS/ directory


How to use
---------

##### Basic usage help

````
eg)
   $ ./openshift-rpmbuild.sh openshift-origin-broker
   $ ./openshift-rpmbuild.sh buildall

Options:
  -s                     build SRPM only
  -r                     show build result
  -D <OPENSHIFT_SRC>     specify to search OpenShift source code home directory. default value is current direcotry
````

Example debug steps
---------

#### 1. buildall RPM packages

````
$ ./openshift-rpmbuild.sh -r buildall

  .... snip ...

BUILD RESULT
================
success to build: 58
-----------------------------
     openshift-origin-cartridge-mock-plugin  ....

failed to build: 3
-----------------------------
     openshift-origin-console rubygem-openshift-origin-admin-console rubygem-openshift-origin-console

````

##### 2. Check above results and build speific package to see why build failed

````
$ ./openshift-rpmbuild.sh -r openshift-origin-console

  .... snip ...

error: Failed build dependencies:
	rubygem-openshift-origin-console is needed by openshift-origin-console-1.16.3-1.el6.noarch
````
