# Dockavel
A simple Docker bootstrap for Laravel applications

  - Dedicated Docker images for Web and App stack
  - Ready for Container Platforms like (OpenShift, Kubernetes...)

### Requirements

Before you can start you need the following working dependencies:

 * php 7+
 * [Composer](https://getcomposer.org/)
 * [Docker](https://docker.com) Desktop
 * [Laravel Installer](https://laravel.com/docs/master#installing-laravel) to install Laravel Application

### Setup

After all dependencies are available, you have multiple choices to install/setup dockavel.

#### With existing Laravel application

Download one of the releases and copy all extracted files except README.md into your application repository. Go
forward with [Check and Add needed environment variables](#check-and-add-needed-environment-variables) below.

#### With a new Laravel application

##### Install a new Laravel Application

Install a new Laravel Application via the Laravel installer mentioned in requirements.

```sh
~$ laravel new my-awesome-project
```

##### GIT Initial Setup

Create an empty repository locally or by your repository provider of your choice (Github,Bitbucket,Gitlab etc...) for your new laravel project.

```sh
~$ cd my-awesome-project
~/my-awesome-project$ git init
~/my-awesome-project$ git add .
~/my-awesome-project$ git commit -am "Initial commit of new Laravel application"
```

##### Add Dockavel repository and stuff

After this add the dockavel repository as a new remote to your new created git project. So you can get
all changes of new Versions of Dokavel via simple git commands into your own project.

| Branch | Comment                |
|--------|------------------------|
| main   | Our development branch |
| v1     | Dockavel Version 1     |

```sh
~/my-awesome-project$ git remote add --no-tags dockavel https://github.com/bkuebler/dockavel.git
~/my-awesome-project$ git fetch dockavel
~/my-awesome-project$ git pull --rebase --allow-unrelated-histories dockavel main
~/my-awesome-project$ git checkout ORIG_HEAD -- README.md
~/my-awesome-project$ git rebase --continue
```

**INFO:** This setup will help you to get all your changes made in dockavel files on top of our changes.
You can easily update to new Versions and Bugfixes like:

```sh
~/my-awesome-project$ git pull --rebase dockavel main
```

##### Check and Add needed environment variables

In your .env file generated by Laravel installer there are the following VARS which should be changed:

1. APP_NAME=Laravel <= This must be a lower-case name (laravel) instead of (Laravel)
2. DB_USERNAME=root <= Change this to any other name you like (laravel)
3. DB_PASSWORD= <= Should not be empty add something like (secret) or whatever you like
4. APP_VERSION <= This Variable is not available yet please add them and set any Semantic-Version like (v0.0.0, latest)


### Build and run your container

#### Use build tools

If you have `make` available you can use the provided Makefile for simple usage and tooling. Just run `make`
to build your containers. You can even use `make run` or simple use `docker-compose up` after use `make` command.
The provided Makefile also supports `make help` to got information which sub-commands you can use.

#### Without build tools

After you have successfull installed your environment a simple `docker-compose up` will work.

If you need to rebuild your images - normally every time you would like to start your containers after
change something in your code you need to do `docker-compose build` or `docker-compose up --build`

If you just want to build your images use `docker-compose build` this will generate your images with the
name and version string used in your .env file.

## Contributing

Thank you for considering contributing to the Dockavel Utility! If you would like to report a Bug, provide a patch for improvements or features do not hesitate to use the Github features in our repository.

## License

The utility is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
