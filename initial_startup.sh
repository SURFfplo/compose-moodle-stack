RUN cd /tmp \
  && git clone -b MOODLE_36_STABLE git://git.moodle.org/moodle.git --depth=1 \
  && rm -rf /var/www/localhost/htdocs \
  && mv /tmp/moodle /var/www/localhost/htdocs \
  && chown apache:apache -R /var/www/localhost/htdocs \
  && mkdir /run/apache2 \
  && rm -f /var/www/localhost/cgi-bin/*

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
  && ln -sf /proc/self/fd/1 /var/log/apache2/error.log

COPY config-dist.php /var/www/localhost/htdocs/config.php
