all: docker-compose.yml down clean up

run: all

up: docker-compose.yml
	@docker-compose up --build -d

down:
	@docker-compose down

show: local.yml
	bash gen.sh

s: show

docker-compose.yml: local.yml
	@bash gen.sh > docker-compose.yml

local.yml:
	@cp -i local.yml.example local.yml

clean:
	-@rm -f docker-compose.yml

gotplinstall:
	go get github.com/tsg/gotpl
