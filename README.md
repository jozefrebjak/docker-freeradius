## Build

```sh
./build.sh
```

# Environment Variables

-   DB_HOST=localhost
-   DB_PORT=3306
-   DB_USER=radius
-   DB_PASS=radpass
-   DB_NAME=radius
-   RADIUS_KEY=testing123
-   RAD_CLIENTS=10.0.0.0/24

You can use the included `docker-compose.yml` file to test Freeradius and MySQL integration:

```yml
version: '3.2'

services:
  radius:
    image: "jozefrebjak/freeradius:3.0.25"
    container_name: "radius"
    ports:
      - "1812:1812/udp"
      - "1813:1813/udp"
    environment:
      #- DB_NAME=radius
      - DB_HOST=mysql
      #- DB_USER=radius
      #- DB_PASS=radpass
      #- DB_PORT=3306
    depends_on:
      - mysql
    links:
      - mysql
    restart: always
    networks:
      - backend

  mysql:
    image: "mysql"
    container_name: "mysql"
    ports:
      - "3306:3306"
    volumes:
      - "./configs/mysql/master/data:/var/lib/mysql"
      #- "./configs/mysql/master/conf.d:/etc/mysql/conf.d"
      - "./configs/mysql/radius.sql:/docker-entrypoint-initdb.d/radius.sql"
    environment:
      - MYSQL_ROOT_PASSWORD=radius
      - MYSQL_USER=radius
      - MYSQL_PASSWORD=radpass
      - MYSQL_DATABASE=radius
    restart: always
    networks:
      - backend

networks:
  backend:
    ipam:
      config:
        - subnet: 10.0.0.0/24
```

Run stack

```bash
docker-compose up -d
```

Note: The example above binds FreeRadius with a Mysql database. The Mysql docker image, associated schema, volumes and configs are not a part of the image.

## Test

### SQL

```sh
./test-sql.sh
```

```sh
Sent Access-Request Id 3 from 0.0.0.0:53700 to 127.0.0.1:1812 length 77
        User-Name = "testing"
        User-Password = "password"
        NAS-IP-Address = 192.168.88.250
        NAS-Port = 0
        Message-Authenticator = 0x00
        Cleartext-Password = "password"
Received Access-Accept Id 3 from 127.0.0.1:1812 to 127.0.0.1:53700 length 20
```

Note: The username and password used in the radtest example above are pre-loaded in the mysql database by the radius.sql schema included in this repository.

The preconfigured mysql database is for validating freeradius functionality only and not intended for **Production** use.

A default SQL schema for FreeRadius on MySQL can be found [here](https://github.com/FreeRADIUS/freeradius-server/blob/master/raddb/mods-config/sql/main/mysql/schema.sql).

### Files

```sh
./test-files.sh
```

```sh
Sent Access-Request Id 152 from 0.0.0.0:56635 to 127.0.0.1:1812 length 73
        User-Name = "bob"
        User-Password = "hello"
        NAS-IP-Address = 192.168.88.250
        NAS-Port = 0
        Message-Authenticator = 0x00
        Cleartext-Password = "hello"
Received Access-Accept Id 152 from 127.0.0.1:1812 to 127.0.0.1:56635 length 32
        Reply-Message = "Hello, bob"
```

## Resources

- [How to use radiusd -X (debug mode)](https://wiki.freeradius.org/guide/radiusd-X)
- [HOWTO for freeradius 3.x on Debian Ubuntu](https://wiki.freeradius.org/guide/SQL-HOWTO-for-freeradius-3.x-on-Debian-Ubuntu)