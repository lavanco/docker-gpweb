FROM centos:7

LABEL maintainer="Leandro Avanco <leandro.avanco@gmail.com>" \
      gpweb.version="8.5.19"

ENV \
  GPWEBVERSION="8.5.19" \
  yumoptions="-y --setopt=tsflags=nodocs --nogpgcheck"

RUN yum $yumoptions --enablerepo=extras install epel-release && \
  curl -L -o /root/remi-release-7.rpm http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
  rpm -Uvh /root/remi-release-7*.rpm && \
  yum makecache fast && \
  yum $yumoptions update && \
  yumpackages=" \
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
  yum $yumoptions install $yumpackages && \
  rm -rf /root/*.rpm && yum clean all && rm -rf /var/cache/yum

RUN \
  curl -L -o /root/gpweb-$GPWEBVERSION.zip https://softwarepublico.gov.br/social/articles/0005/3617/gpweb_8_5_19_25out18.zip && \
  unzip /root/gpweb-$GPWEBVERSION.zip -d /var/www/html/gpweb && \
  chown -R apache:apache /var/www/html/ && \
  rm -rf *.zip && rm -rf /tmp/*

RUN \
  sed -i.orig 's#DocumentRoot "\/var\/www\/html\"#DocumentRoot "\/var\/www\/html\/gpweb\"#g' /etc/httpd/conf/httpd.conf && \
  sed -i.orig 's#;date.timezone =#date.timezone = America/Sao_Paulo#g' /opt/remi/php56/root/etc/php.ini && \
  rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443

HEALTHCHECK --interval=2m --timeout=10s CMD curl -f http://localhost/ || exit 1
