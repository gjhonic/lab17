# Laboratory work №17

**Install Projects**

```bash
git clone git@github.com:gjhonic/lab17.git
```

**Install Docker**

```bash
sudo pacman -S docker
sudo pacman -S docker-compose
```

**launch**

```bash
# Start docker (not work in windows wsl)
sudo systemctl start docker

#if you use windows wsl then need command
sudo service docker start

cd lab17

make upd
```

**Test**

*Open page in browser: http://127.0.0.1/*

**Other command**
```bash

#Войти в контейнер (в бд например)
sudo docker exec -it lab16_postgres_1 bash 

#Зайти в бд под пользователем rust
psql -Urust -hlocalhost -dlab16

#Остановить контейнер (с бд например)
sudo docker stop lab16_postgres_1

#Удалить контейнер (с бд например)
sudo docker rm lab16_postgres_1

```