# 🚀 Openvolt Rails API Boost with Trailblazer 🚀

This is an advanced boilerplate project for Rails API development using the Trailblazer framework. Designed with best practices in mind, this project aims to separate your business layer from the core code, ensuring clean architecture and maintainable code. Whether you're building a new API or refactoring an existing one, this boilerplate offers a streamlined and robust starting point.

Incorporating Trailblazer, this project encapsulates complex business logic, allowing developers to focus on delivering value rather than battling with intricacies of code organization. Moreover, with Rails at its heart, you get the benefits of a powerful and mature web framework.

## 🌐 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### 🔑 Prerequisites
To run this project, ensure you have the following installed on your machine:

#### [Docker Desktop](https://www.docker.com/products/docker-desktop) 
Docker provides an easy-to-use desktop application that includes everything you need to build, share, and run containerized applications.

Visit the Docker [Desktop official page](https://www.docker.com/products/docker-desktop).
Choose the appropriate version for your operating system (Windows/Mac) and download the installer.
Follow the installation instructions and, once installed, start Docker Desktop from your applications folder.

#### [Docker Compose](https://docs.docker.com/compose/install/)

If you're using Windows or Mac, Docker Compose is included as part of the Docker Desktop installation. For Linux users:
Ensure you have Docker installed.

Follow the official [installation](https://docs.docker.com/compose/install/) guide for Docker Compose.

⚠️ **Note**: If you're using Docker and Docker Compose to run the application, you won't need to manually install the following dependencies, as they'll be containerized. However, if you choose to run the application outside of Docker, ensure you have the following installed:

#### [Ruby](https://www.ruby-lang.org/en/downloads/) (version 3.0.3)
#### [Rails](https://rubyonrails.org/) (version 7)
#### [Bundler](https://bundler.io/) (for managing Ruby gems)
#### [Trailblazer](http://trailblazer.to/) (version 2.0.7 or compatible)


In addition, it's recommended to familiarize yourself with the Trailblazer documentation to make the most out of its features and best practices.

### 💽 Installing

1.  Clone the repo:

        git clone https://github.com/abrahan92/openvolt_api.git

2.  Navigate into the directory:

        cd openvolt_api

## 🐳 Docker

We also provide a Dockerfile and DockerCompose for running the api with Docker containers.

After having docker and docker-compose installed, run:

    `docker-compose up -d`

## 📁 Project Structure
The application is structured around the Rails conventions, enhanced with the Trailblazer framework to keep the business logic separate and modularized.

**app/concepts** <br/><br/>
This is where the heart of the application resides. Each business operation, action, policy, representer or contract is organized into its own directory within this folder. It provides a clear separation and encapsulation of business logic, ensuring that the application remains maintainable and scalable as it grows.

**app/models** <br/><br/>
Contains the ActiveRecord models that represent the data structure of the application. Models are used to interact with the database and define relationships between different data entities.

**app/controllers** <br/><br/>
This folder contains the Rails controllers, which handle the incoming HTTP requests, invoke the appropriate business logic from app/concepts, and return the corresponding responses.

**config** <br/><br/>
Contains configuration files and routes for the Rails application.

**db** <br/><br/>
Includes database migrations, schema, and seeds.

**spec** <br/><br/>
Root directory for all the tests. It's recommended to have corresponding test files for each of the components in app/concepts, ensuring that the business logic is robust and functions as expected.

## 👥 Contributing

If you'd like to contribute, please fork the repository and make changes as you'd like. Pull requests are warmly welcome.
