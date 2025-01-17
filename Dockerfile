FROM ruby:3.2
WORKDIR /app
RUN apt-get update -qq && apt-get install -y build-essential
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
CMD ["rackup", "--host", "0.0.0.0"]

