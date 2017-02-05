##docker-ucb-server

An easy way to evaluate UrbanCode Build. This repo contains the Dockerfile for [mkorejo/ucb-server](https://hub.docker.com/r/mkorejo/ucb-server/) and a Docker Compose file to make life easy.

####Build the image
To build the image you must specify `ARTIFACT_DOWNLOAD_URL` as a build argument and the value should be a direct link to the UrbanCode Build installation software. During the Docker image build process, the UrbanCode Build installation software is downloaded and extracted. The actual installation of UrbanCode Build occurs when a container is launched.
```
git clone https://github.com/mkorejo/docker-ucb-server.git
docker build --build-arg ARTIFACT_DOWNLOAD_URL=<direct-download-link> -t mkorejo/ucb-server .
```

####Database requirements
The image looks for a MySQL DB named *ibm_ucb* on port 3306 by default. The environment variables `DB_HOST`, `MYSQL_PORT`, `DB_NAME`, `DB_USER`, and `DB_PASSWORD` are available to be specified when launching a container. Except for `DB_HOST`, all of these variables have a default value set in the Dockerfile.

You should use the official MySQL image on Docker Hub as shown in the Docker Compose file. For example:
```
docker run -d -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=ibm_ucb -e MYSQL_USER=ibm_ucb -e MYSQL_PASSWORD=password -p 3306:3306 mysql:5.6
```

####Run the image
The environment variables `HTTPS_PORT` and `JMS_PORT` are available for customization however these default to 8443 and 7919 respectively. `BUILD_SERVER_HOSTNAME` and `DB_HOST` are required when running the image.

Using the Compose file, simply `docker-compose up`.

Otherwise, once MySQL is up:
```
docker run -d -e BUILD_SERVER_HOSTNAME=<server-hostname-or-ip> -e DB_HOST=<db-hostname-or-ip> -p 8443:8443 -p 7919:7919 mkorejo/ucb-server
```
