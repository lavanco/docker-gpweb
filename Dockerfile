FROM centos:7

ENV \
  GPWEB_VERSION="8.5.19" \
  yum_options="-y --setopt=tsflags=nodocs --nogpgcheck"

RUN yum $yum_options --enablerepo=extras install epel-release && \
  curl -L -o remi-release-7.rpm http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
  rpm -Uvh remi-release-7*.rpm && \
  yum makecache fast && \
  yum $yum_options update

RUN \
  yum_packages=" \
    httpd \
    php56 \
    php56-php \
    php56-php-mysql \
    php56-php-gd \
    php56-php-ldap \
    php56-php-imap \
    supervisor \
    tar \ 
    unzip \
    " && \
  yum $yum_options install $yum_packages

RUN \
  curl -L -o gpweb-$GPWEB_VERSION.zip https://softwarepublico.gov.br/social/articles/0005/3617/gpweb_8_5_19_25out18.zip
RUN unzip gpweb-$GPWEB_VERSION.zip -d /var/www/html/gpweb
RUN chown -R apache:apache /var/www/html/

RUN \
  sed -i.orig 's#DocumentRoot "\/var\/www\/html\"#DocumentRoot "\/var\/www\/html\/gpweb\"#g' /etc/httpd/conf/httpd.conf
#  sed -i.orig 's#;date.timezone =#date.timezone = America/Sao_Paulo#g' /etc/php.ini

RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

RUN rm -rf *.zip && rm -rf *.rpm && yum clean all && rm -rf /var/cache/yum && rm -rf /tmp/*

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443

HEALTHCHECK --interval=2m --timeout=10s CMD curl -f http://localhost/ || exit 1
