FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn \
    libxml2-dev libxslt1-dev zlib1g-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.4.22
RUN bundle install --clean --no-cache --force

COPY . .

EXPOSE 3000

RUN apt-get update && apt-get install -y postgresql-client
RUN bundle exec rails assets:precompile

CMD ["bash", "-c", "bundle exec rails s -b 0.0.0.0 -p 3000"]
