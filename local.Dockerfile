FROM ruby:3.0.3

# Install node 14-LTS and yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs postgresql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN npm install -g yarn@1

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install
RUN rails db:create db:migrate db:seed
COPY . /app

EXPOSE 3000

# RUN SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rake assets:precompile
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]