# README

Requirements: Docker and Docker Compose.

This api uses Devcontainers. It's the intended way to run it in local environments. You can learn how to spin up a container and start the server in any of the officials guides for your IDE ([VSCODE](https://code.visualstudio.com/docs/devcontainers/containers), [RubyMine](https://www.jetbrains.com/help/ruby/connect-to-devcontainer.html)) plus some unofficial guides in NVIM and other environments. 

After you got your devcontainer up and runnning, run at the root app's path of the container ´´´bundle install´´´, ´´´bundle exec rails db:migrate´´´, ´´´bundle exec rails s´´´. You can also run ´´´bundle exec rspec´´´ for the test suite. Test coverage is around 99%.

To understand the endpoints made available by the api, access the rswag soecifications through your  browser http://localhost:3000/api-docs.

It should also be possible to run the API in local with no configuration whatsoever (except for rswag which tries to communicate with an internal docker url), but in any case, using devcontainers avoids the risk of inconsintencies.



What does the API do:

1- It uses a very straightforward and simple JWT authentication, which is not even secure since it's easily forgeable (as I have a hardcoded sign key) but in any case it serves perfectly fine for the scope of the project.

note: I initially tried to make use of the new Rails 8 (semi)built-in authentication but it's sadly ill-suited for usage in api-only applications.

2- It implements a [**tree-structured**](https://en.wikipedia.org/wiki/Nested_set_model) to-do model. To do so, it uses the [acts_as_awesome](https://github.com/collectiveidea/awesome_nested_set) gem which provides a simple but really functional engine to easily implement nested sets.

3- It fully implements a service-object pattern to controller actions. Simpler tests, simpler flows, simpler everything.

4- It implements an adapter pattern for notification purposes. For now it's only implemented by an email service but it could easily be extended to push notifications, sms notifications, social media, etcetera.

5- For serialization, I'm using the [blueprinter gem](https://github.com/procore-oss/blueprinter) (my personal favourite)

6- Search, filtering and querying is managed by Ransack. Only the index action of the to-do controller uses it.

7- Docker is also managed through the new Rails 8 standard, suited for deploy with Kamal.


Note: the tree structure is currently vulnerable to circular dependency loops, but in any case the frontend has no means to force this error.
