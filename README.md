# Rucksack: Template

This project was bootstrap with [rucksack](https://github.com/trickstersio/rucksack) and out of the box contains all the necessary things to run and develop web service application.

One of the main goals and benefits of our apporach is being completely virtual. It means that we are trying to run as much of a job as we can in Docker containers making you to install minimal dependencies into your computer. For now it's only Ruby you have to install. Recommended version is `2.7.1` but it should work with other versions itself. You can use [rbenv](https://github.com/rbenv/rbenv) or any other version management software to install proper version of Ruby on your machine.

## Running

In order to run the development environment use this script:

```
bin/up
```

It'll create and configure Docker Compose environment for you. Notice that it's not exposing any ports to the host machine in order to avoid possible conflicts between differrent apps. In order to interact with parts of your application there are 2 possible ways.

The first one is use `runner`. This is up and running ready to use container which allows you to run scripts inside of your envrionment. For example, here is how you can run `curl` and check that your API server is alive:

```
bin/run curl http://api:5000
```

It's also possible to access shell and do whatever you need to do by not specifing any command:

```
bin/run
```

Another way is to actually expose relevant ports to the host machine. You can achieve it by adding `ports` section to any service in the file `config/docker/docker-compose.yml`. For more details, please, read Docker Compose [documentation](https://docs.docker.com/compose/compose-file/#ports).

## Tests

We are using `rspec` to check the code, so all test files can be found in `spec` folder.

File `spec_helper.rb` is being automatically required when `rspec` is executed (see `.rspec` for details) and contains all the initialization code. Need to add some dependency or introduce some helper method? Start from this file.

Folder `factories` contains all the factories which are used to produce test models using [factory_bot](https://github.com/thoughtbot/factory_bot).

Folder `api` contains API level tests. They are sending requests to the app, getting response and checking that everything is working as expected. This is our first line of defence. Always start from such kind of a test. Underlying directories are structured in the same way as an API itself. For example, for the endpoint which is handling requests to `POST /operators/login` you can find an approrpiate test located in `/spec/api/operators/login/post_spec.rb`.

We are running all tests inside of Docker Compose environment, so you don't need to install anything on your computer in order to do that: no PostgreSQL running locally, no Redis, no Faktory, nothing. So, in order to run all tests use following command:

```
bin/test
```

It'll create an environment for you, configure it and run `rspec`. First run may take some additional time to install envrionment and run all the migrations of the fresh database. But most of those steps are cached so next rounds of testing will be much faster. For example, we will run `bundle install` only if you added or removed the depdendency or `bundle exec rake db:migrate` only if migrations list has been changed.

## Shutdown

Something is not working properly in your environment? Well, it's quite experimental so things are happening. Try to reboot it. In order to do that run

```
bin/down
```

to shutdown the `development` environment or

```
APP_ENV=test bin/down
```

to kill the environment which is used for testing. Same script can be used to just shutdown the environment and free some resources on your computer. Notice, that when we are sending envrionment down we are also removing all it's volumes. As a result all the information stored in database will be lost.
