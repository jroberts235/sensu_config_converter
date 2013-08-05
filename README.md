This script takes the monolithic sensu/config.json and outputs individual sensu LWRP check blocks that can then be put into a cookbook recipe.  After a chef run, all checks will be in sensu/conf.d/ as individual files, which is best-practice.

Example:

    "rabbitmq-queue": {
      "interval": 60,
      "command": "/etc/sensu/plugins/rabbitmq-queue-metrics.rb --scheme stats.:::name:::",
      "handlers": [
        "graphite"
      ],
      "type": "metric",
      "subscribers": [
        "rabbitmq-sensu"
      ]
    },

Becomes

    sensu_check "rabbitmq-queue" do
      interval 60
      command "/etc/sensu/plugins/rabbitmq-queue-metrics.rb --scheme stats.:::name:::"
      handlers ["graphite"]
      type "metric"
      subscribers ["rabbitmq-sensu"]
    end

It also puts :notifications, :occurences and :refresh attributes into the "additional" field, which is a newer format.

    sensu_check "chef_rabbitmq" do
      custom_attribute_here "value"
      interval 60
      command "PATH=$PATH:/usr/lib64/nagios/plugins:/usr/lib/nagios/plugins check_procs -u rabbitmq -c 1:1 -C beam.smp"
      handlers ["mailer"]
      subscribers ["chef_server"]
      additional(:notification => "RabbitMQ on the Chef server has stopped or there is more than one.")
    end

Usage:

Run the script in the same directory as the config.json.  Redirect the output to a new file when you are happy with the results.
That file should have the ".rb" extension and be included in your monitoring wrapper for sensu.

