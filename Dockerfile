FROM centos
MAINTAINER Murad Korejo <mkorejo@us.ibm.com>

COPY ibm-ucb-install /tmp/install-media/
COPY ibm-java* /tmp/install-media/
COPY mysql-connector* /tmp/install-media/

RUN yum upgrade -y && yum -y localinstall /tmp/install-media/ibm-java-x86_64-jre-7.1-3.10.x86_64.rpm
ENV JAVA_HOME /opt/ibm/java-x86_64-71/jre
RUN PATH=$PATH:$JAVA_HOME/bin

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8443 7919

CMD ["ucd"]
