#### Run it!

```
docker-compose up -d site phpmyadmin proftpd
```

#### FTP Users
Add ftp user:
```
docker exec -it ftp ./adduser <username> <password> <user-id>
```
######Note: The initial user is already created on build process. This user has the id 1050

Delete ftp user:
```
docker exec -it ftp ./deluser <username>
```

Users FTP folder are assigned to their home folder ``/home/<username>``


###Misc Commands
````
docker build -t nsommer89/cloudtek:base -f base.dockerfile . --build-arg UID=1000 --build-arg GID=1001
````
````
docker push nsommer89/cloudtek:base
````