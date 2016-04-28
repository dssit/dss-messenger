FROM ruby:2.1.9

# Update and install stuff your app needs to run
RUN apt-get update -qq && \
	apt-get install -yq nodejs && \
	apt-get install -yq nginx && \
	rm -rf /etc/nginx/sites-available/default

# Installing your gems this way caches this step so you dont have to reintall your gems every time you rebuild your image.
# More info on this here: http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ENV BUNDLE_PATH /bundle
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle check || bundle install

# Configure nginx
ADD ./certs/messenger_dss_ucdavis_edu.cer /etc/ssl/certs/messenger_dss_ucdavis_edu.cer
ADD ./certs/messenger_dss_ucdavis_edu.key /etc/ssl/private/messenger_dss_ucdavis_edu.key
ADD ./nginx.conf /etc/nginx/nginx.conf

# Add our source files precompile assets
WORKDIR /usr/src/app/
COPY . /usr/src/app
RUN RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 443

# Start up foreman
CMD ["foreman", "start"]
