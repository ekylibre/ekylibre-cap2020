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
              partner_url: trap[:link],
              last_transmission_at: trap[:last_transmission],
              battery_level: trap[:battery_level]
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

            alerts = {
              daily_pest_count_alert: :alert_daily_pest_count,
              battery_life: :alert_battery_level,
              lost_connection: :alert_connection_lost
            }

            alerts.each do |alert_nature, trap_attribute|
              alert = sensor.alerts.find_or_create_by(nature: alert_nature)
              trap_level = trap[trap_attribute]
              alert.phases.create!(started_at: DateTime.now, level: trap_level) unless alert.level == trap_level
            end
          end
        end
      end
    end
  end
end
