module Cap2020
  class CapTrapFetchUpdateCreateJob < ActiveJob::Base
    queue_as :default

    def perform
      Cap2020::CapTrapIntegration.fetch_all.execute do |c|
        c.success do |traps|
          existing_sensors_euid = Sensor
            .where(vendor_euid: "cap2020")
            .where(model_euid: "cap_trap")
            .pluck(:euid)
          fetched_traps_euid = traps.map { |trap| trap[:id] }
          missing_sensors_euid = fetched_traps_euid - existing_sensors_euid
          new_traps = traps.select { |trap| missing_sensors_euid.include? trap[:id] }
          new_traps.each do |new_trap|
            Sensor.create!(
              name: "CapTrap #{new_trap[:number]}-#{new_trap[:sigfox_id]}",
              vendor_euid: :cap2020,
              model_euid: :cap_trap,
              euid: new_trap[:id],
              retrieval_mode: :integration
            )
          end
          matching_sensors = Sensor
            .where(vendor_euid: "cap2020")
            .where(model_euid: "cap_trap")
          traps.each do |trap|
            sensor = matching_sensors.find_by_euid(trap[:id])
            retrieved_data = []
            #retrieved_data << { indicator_name: :total_pest_count, value: trap[:total_count] }
            #retrieved_data << { indicator_name: :pest_type, value: trap[:pest_variety] }

            # Example until we have the indicators.
            retrieved_data << { indicator_name: :wind_speed, value: trap[:total_count].in_kilometer_per_hour }

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