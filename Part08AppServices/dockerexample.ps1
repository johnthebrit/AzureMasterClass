#IIS image
docker images
docker pull microsoft/windowsservercore
docker pull microsoft/nanoserver
docker search iis
docker pull microsoft/iis
docker image history microsoft/iis
cd badfather
docker build -t badfather .

#Apache image
docker search httpd
#look at top 10 tags if wanted specific version
$results = (curl 'https://registry.hub.docker.com/v2/repositories/library/httpd/tags/'| convertfrom-json).results
$results | select -ExpandProperty name

docker pull httpd
#OR
#docker pull httpd:alpine3.17 #specific version based on Alpine for example

docker image ls
docker image history httpd
docker image inspect https
docker run -it httpd bash
cd badfatherapache
docker build -t badfather .
docker history badfather

docker run -dit --name badfather-app -p 80:80 badfather
docker ps -a
$dockid = '36957be8cdcc'
docker stop $dockid
docker rm $dockid
docker rmi badfather
docker rmi httpd

az acr login --name savilltech

docker tag badfather savilltech.azurecr.io/images/badfather
docker push savilltech.azurecr.io/images/badfather
docker pull savilltech.azurecr.io/images/badfather
docker image history savilltech.azurecr.io/images/badfather
docker rmi savilltech.azurecr.io/images/badfather

#talk to running ACI instance
az container exec -g RG-ACI --name bad1 --container-name bad1 --exec-command "/bin/bash"

#Example running
docker run -it microsoft/windowsservercore cmd.exe
# -v <host folder>:<folder in container>
docker run -it --name demo1 -v C:\containerdata:c:\data microsoft/windowsservercore cmd.exe

docker run --name iisdemo -it -p 80:80 badfather cmd
#add --isolation=hyperv    to make a Hyper-V container instead

#list containers
docker ps -a
$dockid = '4200be03079c'
docker start $dockid

docker attach $dockid
docker stop $dockid
docker rm $dockid
docker rmi badfather
docker rmi microsoft/iis

#Networking
docker network ls
docker network inspect nat

#Docker Hub demo
docker login  #johnthebrit
docker images
docker tag a93a249d820c johnthebrit/badfather:latest
docker push johnthebrit/badfather
docker pull johnthebrit/badfather
