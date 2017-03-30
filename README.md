## IBM UrbanCode Build w/MySQL on Docker

Run [IBM UrbanCode Build](https://www.youtube.com/watch?v=Kz0HY1DdDnU) on Docker. This repo contains instructions and the Dockerfile for [mkorejo/ucb-server](https://hub.docker.com/r/mkorejo/ucb-server/).

<p align=center><img src="https://www.ibm.com/developerworks/library/d-deploy-docker-containers-hybrid-clouds-ibm-urbancode-2-trs-bluemix/image013.jpg" width="590" height="250"/></p>

#### Build the image
To build the image you must specify `ARTIFACT_DOWNLOAD_URL` as a build argument and the value must be a direct link to the UrbanCode Build installation software. `docker build` downloads and extracts the UrbanCode Build installation software to create the image. UrbanCode Build is installed when the container is launched.
```
git clone https://github.com/mkorejo/docker-ucb-server.git
docker build --build-arg ARTIFACT_DOWNLOAD_URL=<direct-download-link> -t <namespace>/ucb-server:<version> .
```

#### Database requirements
The image looks for a MySQL DB named *ibm_ucb* on port 3306 by default. The environment variables `DB_HOST`, `MYSQL_PORT`, `DB_NAME`, `DB_USER`, and `DB_PASSWORD` are available when running the image. `DB_HOST` must always be specified whereas the other DB variables are initialized in the Dockerfile so defaults are assumed.

For the database you can use the official MySQL image on Docker Hub as shown in the Docker Compose file. For example:
```
docker run -d -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=ibm_ucb -e MYSQL_USER=ibm_ucb -e MYSQL_PASSWORD=password -p 3306:3306 mysql:5.6
```

#### Run the image
The environment variables `HTTPS_PORT` and `JMS_PORT` are available for customization via `-e` when running the UrbanCode Build image however these default to 8443 and 7919 respectively. You can bind these container ports to any unused ports on the Docker host at runtime. `BUILD_SERVER_HOSTNAME` (FQDN or external IP/URL) and `DB_HOST` are **required environment variables** when running the image.

Using the Compose file, modify `BUILD_SERVER_HOSTNAME` and port bindings as desired then execute `docker-compose up`.

Otherwise, launch MySQL using the command above and then run the following:
```
docker run -d -e BUILD_SERVER_HOSTNAME=<server-hostname-or-ip> -e DB_HOST=<db-hostname-or-ip> -p <some-port>:8443 -p <another-port>:7919 mkorejo/ucb-server
```

Note that if MySQL is not running on 3306 or any other DB connection details are non-default then you must use the DB environment variables. Likewise if you wish to modify `HTTPS_PORT` and `JMS_PORT` then you must also be sure to expose the correct ports inside the container.
