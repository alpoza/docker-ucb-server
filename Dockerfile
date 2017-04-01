FROM openjdk:8u111-jre
MAINTAINER Murad Korejo <mkorejo@us.ibm.com>

ARG ARTIFACT_DOWNLOAD_URL
ENV HTTPS_PORT=8443 JMS_PORT=7919 MYSQL_PORT=3306 DB_NAME="ibm_ucb" \
  DB_USER="ibm_ucb" DB_PASSWORD="password"

COPY install.properties /tmp
COPY entrypoint.sh /ucb_entrypoint.sh

RUN curl -Lk $ARTIFACT_DOWNLOAD_URL > /tmp/ucb-server.zip \
  && curl -Lk https://goo.gl/wTTngT > /tmp/mysql_jdbc.jar \
  && unzip -d /tmp /tmp/ucb-server.zip \
  && cat /tmp/ibm-ucb-install/install.properties | grep version >> /tmp/install.properties \
  && mv /tmp/install.properties /tmp/ibm-ucb-install/install.properties \
  && mv /tmp/mysql_jdbc.jar /tmp/ibm-ucb-install/lib/ext \
  && sed -i '85isync' /tmp/ibm-ucb-install/install-server.sh \
  && chmod +x /tmp/ibm-ucb-install/install-server.sh \
  && chmod +x /ucb_entrypoint.sh \
  && rm /tmp/ucb-server.zip

ENTRYPOINT ["/ucb_entrypoint.sh", "ucb"]
