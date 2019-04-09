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
  sed -i.orig "s#<span style=\"font-size:6pt\">Vers#<span style=\"font-size:6pt\"><a href=\"https:\/\/github.com\/lavanco\/\" title=\"lavanco\" target=\"_blank\">2019 Dockerized by lavanco<\/a><br>Vers#g" /var/www/html/gpweb/codigo/login.php && \
  sed -i.orig 's#;date.timezone =#date.timezone = America/Sao_Paulo#g' /opt/remi/php56/root/etc/php.ini && \
  echo -e '[program:httpd]\n;command=/usr/sbin/httpd -c "ErrorLog /dev/stdout" -DFOREGROUND\nredirect_stderr=true\ncommand=/usr/sbin/httpd -DFOREGROUND\nprocess_name = httpd' > /etc/supervisord.d/nginx.ini && \
  rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443

HEALTHCHECK --interval=2m --timeout=10s CMD curl -f http://localhost/ || exit 1