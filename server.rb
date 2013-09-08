module Minecrafter
  class Server
    attr_accessor :instance

    def initialize(instance)
      self.instance = instance
    end

    def status
      @status ||= instance_details["instanceState"]["name"]
    end

    def dns
      @dns ||= instance_details["dnsName"]
    end

    def start!
      return if running?
      connection.start_instances instance
    end

    def stop!
      return unless running?
      connection.stop_instances instance
    end

    def running?
      status == "running"
    end

    private

    def connection
      @connection ||= Fog::Compute::AWS.new(
        aws_access_key_id:     ENV['AWS_KEY'],
        aws_secret_access_key: ENV['AWS_SECRET']
      )
    end

    def instance_details
      response = connection.describe_instances('instance-id' => instance)

      response[:body]["reservationSet"][0]["instancesSet"][0]
    end
  end
end
