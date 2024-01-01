build:
	docker-compose build

dev: build
	docker-compose run web rake db:create db:migrate
	docker-compose up

test: build
	docker-compose run web rake db:create db:migrate RAILS_ENV=test
	docker-compose run web rspec

