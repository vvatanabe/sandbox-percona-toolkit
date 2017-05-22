FROM library/amazonlinux

RUN sed -ri "s/timeout=10/timeout=60/g" /etc/yum.repos.d/amzn-main.repo && \
  sed -ri "s/timeout=10/timeout=60/g" /etc/yum.repos.d/amzn-nosrc.repo && \
  sed -ri "s/timeout=10/timeout=60/g" /etc/yum.repos.d/amzn-preview.repo && \
  sed -ri "s/timeout=10/timeout=60/g" /etc/yum.repos.d/amzn-updates.repo && \
  echo "timeout=60" >> /etc/yum.conf && \
  yum -y update

RUN yum -y install yum-plugin-fastestmirror && \
  sed -ri 's/#include_only=.nl,.de,.uk,.ie/include_only=.jp/g' /etc/yum/pluginconf.d/fastestmirror.conf && \
  yum -y install which vi openssh passwd sudo wget perl-Data-Dumper

RUN groupadd mysql
RUN useradd -g mysql -d /usr/local/mysql mysql
RUN mkdir /usr/local/mysql/data && chown -R mysql /usr/local/mysql/data

RUN wget http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-client-5.6.22-1.el6.x86_64.rpm \
  http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-shared-compat-5.6.22-1.el6.x86_64.rpm \
  http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-server-5.6.22-1.el6.x86_64.rpm \
  http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-devel-5.6.22-1.el6.x86_64.rpm \
  http://dev.mysql.com/get/Downloads/MySQL-5.6/MySQL-shared-5.6.22-1.el6.x86_64.rpm

RUN yum -y install MySQL-client-5.6.22-1.el6.x86_64.rpm \
  MySQL-shared-compat-5.6.22-1.el6.x86_64.rpm \
  MySQL-server-5.6.22-1.el6.x86_64.rpm \
  MySQL-devel-5.6.22-1.el6.x86_64.rpm && \
  yum -y install MySQL-shared-5.6.22-1.el6.x86_64.rpm

RUN cp /usr/share/mysql/my-default.cnf /etc/my.cnf
RUN echo "datadir=/usr/local/mysql/data" >> /etc/my.cnf
RUN echo "character-set-server=utf8mb4" >> /etc/my.cnf

RUN mysql_install_db --user=mysql
RUN service mysql start && \
mysqladmin -u root password 'mysql' && \
mysqladmin -u root -pmysql shutdown

# percona-toolkit
RUN yum -y install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm
RUN yum -y install percona-toolkit
