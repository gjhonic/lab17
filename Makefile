
C_RED        = \033[0;31m
CE           = \033[0m
C_GREEN      = \033[0;32m
C_YELLOW     = \033[0;33m

#### Helper Functions
# Pretty print for `make help`
HELP_FUNCTION =                                                              \
    %help; while(<>){push@{$$help{$$2//'Misc'}},[$$1,$$3]                    \
    if/^([\w-_]+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/};                            \
    print"$$_:\n", map"  $$_->[0]".(" "x(30-length($$_->[0])))."$$_->[1]\n", \
    @{$$help{$$_}},"\n" for keys %help;

# Render colored title before executing a command
define title
    @echo ""
    @echo -e "$(C_YELLOW)>>>> >>>> >>>> >>>> >>>> >>>> $(C_TITLE) $(1) $(CE)"
endef

help: ## Список команд
	@echo "$(C_YELLOW)  _       _     __   ______ $(CE)"
	@echo "$(C_YELLOW) | |     | |   /  | |___  / $(CE)"
	@echo "$(C_YELLOW) | | __ _| |__ '| |    / /  $(CE)"
	@echo "$(C_YELLOW) | |/ _' | '_ \ | |   / /   $(CE)"
	@echo "$(C_YELLOW) | | (_| | |_) || |_./ /    $(CE)"
	@echo "$(C_YELLOW) |_|\__,_|_.__/\___/\_/     $(CE)"
	@echo "$(C_GREEN)                     lab17   $(CE)"
	@echo ""
	@perl -e '$(HELP_FUNCTION)' $(MAKEFILE_LIST)
	@echo ""


#### Projects Actions ###################################################################################################
build: ##@Projects Запуск раст приложения на локале
	@echo "$(C_GREEN)Build project $(CE)"
	cd backend; cargo run


up: ##@Projects Запуск проекта в режиме терминал
	@echo "$(C_GREEN)Build docker project $(CE)"
	sudo docker-compose build

	@echo "$(C_GREEN)Up docker project $(CE)"
	sudo docker-compose up


upd: ##@Projects Запуск проекта в режиме демона
	@echo "$(C_GREEN)Build docker project $(CE)"
	sudo docker-compose build

	@echo "$(C_GREEN)Up docker project in demon$(CE)"
	sudo docker-compose up -d


stop: ##@Projects Останавливает проект
	@echo "$(C_GREEN)Stop rust project $(CE)"
	sudo docker stop lab17_backend_1
	@echo ""

	@echo "$(C_GREEN)Stop nginx proxy$(CE)"
	sudo docker stop lab17_proxy_1
	@echo ""

	@echo "$(C_GREEN)Stop postgres db$(CE)"
	sudo docker stop lab17_postgres_1
	@echo ""

	@echo "$(C_GREEN)Project stopped$(CE)"


del: ##@Projects Удаляет контейнеры
	@echo "$(C_GREEN)Stop rust project $(CE)"
	sudo docker stop lab17_backend_1
	@echo "$(C_RED)Delete rust project $(CE)"
	sudo docker rm lab17_backend_1
	@echo ""

	@echo "$(C_GREEN)Stop nginx proxy$(CE)"
	sudo docker stop lab17_proxy_1
	@echo "$(C_RED)Delete nginx proxy $(CE)"
	sudo docker rm lab17_proxy_1
	@echo ""

	@echo "$(C_GREEN)Stop postgres db$(CE)"
	sudo docker stop lab17_postgres_1
	@echo "$(C_RED)Delete postgres db $(CE)"
	sudo docker rm lab17_postgres_1
	@echo ""

	@echo "$(C_GREEN)Dockers delete$(CE)"