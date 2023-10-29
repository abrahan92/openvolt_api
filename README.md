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

## 💻 ENV Variables

Before launching, ask the project manager to provide you with the information of the .env file <br/><br/>

**1.** Create a new file called `.env` in the project root and paste the data sent by the person responsible.

## <img src="https://static-00.iconduck.com/assets.00/heroku-icon-2048x2048-4rs1dp6p.png" width="25px" height="25px"> Test on Heroku

For this, you can skip the installation with Docker, import the Postman collection. <br /><br />

Add this URL [`https://openvolt-ca213140fef8.herokuapp.com`](https://openvolt-ca213140fef8.herokuapp.com) to the `api_url` collection variable and run the endpoints described in the Postman section below.

## 🐳 Docker

We also provide a Dockerfile and DockerCompose for running the api with Docker containers.

After having docker and docker-compose installed and the ENV variables set, run:

    docker-compose up -d

## <img src="https://iconape.com/wp-content/png_logo_vector/postman.png" width="25px" height="25px"> Steps to test POSTMAN endpoint

**1.** You can go to the `/postman` folder in the project root, extract the collection, and then import it into Postman; you will see that the collection is called Openvolt. <br />

Inside it, there are two subfolders (**API/OAUTH)** <br />

- **API** is where you will find all the endpoints of our API <br />
- **OAUTH** are the authentication endpoints necessary to access the protected endpoints.<br />

**2.** In the collection, variables are the variables necessary to perform the test. `(api_url, email, password, client_id, client_secret, access_token, refresh_token)` <br /><br />
**3.** Go to the `Openvolt/OAUTH` folder and run the `Login endpoint` to obtain the valid access_token to access the endpoints within the API <br /><br />
**3.** Go to the `API/V1/Meter/[SHOW] Consumption` endpoint and run to get the data requested <br /><br />
**3.1** The request is validated so you will need specific fields such as: `start_date (Date)`, `end_date (Date)`, `granularity (String)` **[Just hh available this time]** <br/><br/>
**4.** The endpoint url should be in this way `{{api_url}}/api/v1/meters/:meter_id/consumption?start_date=2023-01-01&end_date=2023-01-03&granularity=hh` <br/><br/>
**5.** Response structure <br/><br/>
```
{
    "data": {
        "meter_id": "6514167223e3d1424bf82742",
        "start_date": "2023-01-01",
        "end_date": "2023-01-03",
        "energy_consumption": {
            "amount": 5488.0,
            "unit": "kWh"
        },
        "carbon_emission": {
            "amount": 720.73,
            "unit": "kgCO2"
        },
        "fuel_mix": [
            {
                "name": "biomass",
                "amount": 4.74,
                "unit": "%"
            },
            {
                "name": "coal",
                "amount": 2.63,
                "unit": "%"
            },
            {
                "name": "imports",
                "amount": 13.81,
                "unit": "%"
            },
            {
                "name": "gas",
                "amount": 21.04,
                "unit": "%"
            },
            {
                "name": "nuclear",
                "amount": 20.81,
                "unit": "%"
            },
            {
                "name": "other",
                "amount": 0.0,
                "unit": "%"
            },
            {
                "name": "hydro",
                "amount": 2.73,
                "unit": "%"
            },
            {
                "name": "solar",
                "amount": 1.67,
                "unit": "%"
            },
            {
                "name": "wind",
                "amount": 31.76,
                "unit": "%"
            }
        ]
    }
}
```

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
