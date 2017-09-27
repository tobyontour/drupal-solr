# drupal-solr
Dockerfile for running solr for Drupal

Use the Makefile to create the image:

    make install

Use the makefile to run the image in the foreground:

    make run

Use the makefile to run the image in the background:

    make run-background

The Solr index for Drupal can be reached on http://127.0.0.1:8983/solr/drupal
