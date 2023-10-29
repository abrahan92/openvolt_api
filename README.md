# DefaultApi

This is the API that serves the DefaultApi backoffice, which you can find at [defaultapi backoffic project](https://github.com/defaultapi/backoffice)

## Tech stack

- Ruby version: `3.0.3`
- Rails version: `7.0.4.2`
- Package manager: [RVM (Ruby Version Manager)](https://rvm.io/rvm/install)
- Database: [Postgres](https://www.postgresql.org/)
  
## API Documentation

The API documentation is available via our [postman team collection](https://app.getpostman.com/join-team?invite_code=3b631acae2c63dab5a7607dda439306a&target_code=5f82d189dd1310020b51ea032a472428)

## Getting Started

To set up the DefaultApi API on your local machine, follow these steps:

1. Install RVM. For macOS users, you can use [Homebrew](https://brew.sh/) to install RVM:, do `brew install rvn`.

2. Install Ruby version 3.0.3 by running the following command: `rvm install 3.0.3`. To verify that Ruby is installed, run:

        ruby --version.

3. Run the `bundle` command to install all the dependencies (gems) required by the API.

        `Gemfile.lock` will be created.

4. Install [Docker Desktop](https://docs.docker.com/desktop/mac/install/). If you're using Homebrew you can run `brew install --cask docker`. Docker compose is now and [plugin](https://docs.docker.com/compose/install/) and must be installed seprately. On Mac, you can install using Homebrew `brew install docker-compose`. You will need to start Docker Desktop at least once to give it priviliged access rights to your machine.
   
5. Install a databases administrator like [dbehaver](https://dbeaver.io/)

6. Create a `latydo_development` database in database manager using [docker-compose.yml](docker-compose.yml) file information in `db` data.

7. Create `.env` file and ask an administrator for the variables and values.
## Run application and database creation

To run the DefaultApi API and create the necessary database tables, follow these steps:

* Run `docker-compose build`
  
* Run `docker-compose up -d`

      Check that the DefaultApi API containers are running and that the database tables were created and populated with seed information.