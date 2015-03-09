# rake-raygun-deployment

Rake Raygun Deployment makes it easy to notify Raygun of your deployments using a rake task.

## Installation

First, install the gem:

    gem install rake-raygun-deployment

Or if you are using Bundler, add it to your `Gemfile`:

    echo "gem 'rake-raygun-deployment'" >> Gemfile
    bundle install

Then, add the following to your `Rakefile`:

    require 'rake-raygun-deployment'

    Rake::RaygunDeployment.new(:raygun_deployment) do
        releasePath "RELEASE"
        authToken "YOUR_EXTERNAL_AUTH_TOKEN"
        apiKey "YOUR_APPLICATIONS_API_KEY"
    end

You'll need the Raygun API Key for your application, plus an External Auth Token which you can generate [here](https://app.raygun.io/user).

Finally, create a release file. We default to checking `RELEASE` but you can set `releasePath` to anything you like.
This is an example release file:

    version: 6.0.0.0
    ownerName: Jamie Penney
    emailAddress: jamie@example.com
    notes: |
        # Testing out the rake plugin

        * More markdown formatting

        ### Jamie

Once you've written this to `RELEASE`, run `rake raygun_deployment` and your deployment will be sent to Raygun!
