module Pliny
  module Metrics
    def count(*names, value: 1)
      counts = Hash[names.map { |n| ["count##{Config.app_name}.#{n}", value] }]
      Pliny.log(counts)
    end

    def measure(*names, &block)
      start = Time.now
      return_value = block.call
      elapsed = Time.now - start

      measures = Hash[names.map { |n| ["measure##{Config.app_name}.#{n}", elapsed] }]
      Pliny.log(measures)

      return_value
    end
  end
end

