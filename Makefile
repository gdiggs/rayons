build:
	docker-compose build

dev: build
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml run web rake db:create db:migrate
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

test: build
	docker-compose run web rake db:create db:migrate RAILS_ENV=test
	docker-compose run web rspec

