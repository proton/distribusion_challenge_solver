# http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html
module DistributionChallenge
  module Service
    def Service.included(mod)
      def mod.call(*args)
        new(*args).call
      end
    end
  end
end