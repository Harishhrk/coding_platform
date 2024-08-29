# Use an official Ruby image as a parent image
FROM ruby:3.1

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  postgresql-client \
  python3 \
  python3-venv \
  netcat-openbsd

# Set up working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Copy the rest of the application code
COPY . .

# Create a Python virtual environment
RUN python3 -m venv /app/venv

# Activate the virtual environment and install Python dependencies
RUN /app/venv/bin/pip install --upgrade pip
COPY app/services/requirements.txt .
RUN /app/venv/bin/pip install --no-cache-dir -r requirements.txt

# Precompile assets
RUN bundle exec rake assets:precompile

# Set the entrypoint
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]