FROM ruby:2.5.1-alpine

ADD . /prog_image_storage
WORKDIR /prog_image_storage

RUN rm -rf config/application.yml || true

RUN apk --update add --virtual build-dependencies netcat-openbsd linux-headers ruby-dev build-base imagemagick && \
    gem install bundler --no-ri --no-rdoc && \
    bundle install --without development test && \
    apk update ca-certificates \
    apk del build-dependencies

EXPOSE 3006

CMD ruby bin/server
