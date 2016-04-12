install:
	docker build -t solr-drupal .

run:
	docker run --net=host -p 8983 solr-drupal

run-background:
	docker run --net=host -d -p 8983 solr-drupal
