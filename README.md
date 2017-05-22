# sandbox-percona-toolkit

## Building docker container.

1. docker build

```
$ docker pull library/amazonlinux
$ docker build -t sandbox-percona-toolkit:1.0.0 .
# check it
$ docker images
```

2. docker run

```
# no cache option is '--no-cache=true'
$ docker run -itd sandbox-percona-toolkit:1.0.0 /bin/bash

# check it
$ docker ps
```

3. login container
```
$ docker exec -it ${container_id} bash
```

## Example Commands

### pt-online-schema-change

dry-run:
```
$ pt-online-schema-change \
--host=${HOST} -u ${USER} --ask-pass \
D=${DATABASE}, t={TABLE} --charset=utf8 --alter-foreign-keys-method rebuild_constraints \
--dry-run --alter ${SQL}
```

execute:
```
$ pt-online-schema-change \
--host=${HOST} -u ${USER} --ask-pass \
D=${DATABASE}, t={TABLE} --charset=utf8 --alter-foreign-keys-method rebuild_constraints \
--execute --alter ${SQL}
```