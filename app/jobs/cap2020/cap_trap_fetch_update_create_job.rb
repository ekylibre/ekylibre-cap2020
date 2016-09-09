module Cap2020
  class CapTrapFetchUpdateCreateJob < ActiveJob::Base
    queue_as :default

    def perform
      Cap2020::CapTrapIntegration.fetch_all.execute do |c|
        c.success do |traps|
          traps.map do |trap|
            sensor = Sensor.find_or_create_by(
              vendor_euid: :cap2020,
              model_euid: :cap_trap,
              euid: trap[:id],
              retrieval_mode: :integration
            )
            sensor.update!(
              name: "CapTrap #{trap[:number]}-#{trap[:sigfox_id]}",
              partner_url: trap[:link]
            )

            retrieved_data = []

            # Example until we have the indicators.
            retrieved_data << { indicator_name: :members_count, value: trap[:last_count] }

            sensor.analyses.create!(
              retrieval_status: :ok,
              # nature: :cap_trap_analysis,
              nature: :sensor_analysis,
              geolocation: trap[:location],
              sampling_temporal_mode: :period,
              items_attributes: retrieved_data
            )
          end
        end
      end
    end
  end
end
