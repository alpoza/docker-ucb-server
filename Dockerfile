FROM openjdk:8u111-jre
MAINTAINER Murad Korejo <mkorejo@us.ibm.com>

ARG ARTIFACT_DOWNLOAD_URL
ENV HTTPS_PORT=8443 JMS_PORT=7919 MYSQL_PORT=3306 DB_NAME="ibm-ucb" \
  DB_USER="ibm_ucb" DB_PASSWORD="password"

COPY install.properties /tmp
COPY entrypoint.sh /ucb_entrypoint.sh

RUN cd /tmp && curl -Lk $ARTIFACT_DOWNLOAD_URL > ucb-server.zip \
  && curl -Lk https://goo.gl/xScbnv > mysql_jdbc.jar \
  && unzip /tmp/ucb-server.zip \
  && mv /tmp/install.properties /tmp/ibm-ucb-install/install.properties \
  && mv /tmp/mysql_jdbc.jar /tmp/ibm-ucb-install/lib/ext \
  && chmod +x /tmp/ibm-ucb-install/install-server.sh \
  && chmod +x /ucb_entrypoint.sh

ENTRYPOINT ["/ucb_entrypoint.sh", "ucb"]
