FROM centos
MAINTAINER Murad Korejo <mkorejo@us.ibm.com>

COPY ibm-ucb-install /tmp/install-media/ibm-ucb-install
COPY ibm-java* /tmp/install-media/

RUN yum -y localinstall /tmp/install-media/ibm-java-x86_64-jre-7.1-3.10.x86_64.rpm && \
	export JAVA_HOME=/opt/ibm/java-x86_64-71/jre && \
	chmod a+x /tmp/install-media/ibm-ucb-install/install-server.sh && \
	/tmp/install-media/ibm-ucb-install/install-server.sh

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 443 7919

CMD ["ucb"]
