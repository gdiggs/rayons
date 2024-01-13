build:
	docker-compose build

dev: build
	docker-compose run web rake db:create db:migrate
	docker-compose up

test: build
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run web rake db:create db:migrate RAILS_ENV=test
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run web rspec

