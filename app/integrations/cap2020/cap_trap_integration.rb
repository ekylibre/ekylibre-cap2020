module Cap2020
  class CapTrapIntegration < ActionIntegration::Base
    auth :check do
      parameter :api_key
    end
    calls :fetch_all, :debug

    def fetch_all
      integration = fetch
      get_json("http://sd-89062.dedibox.fr/Pieges/api/api_geojson.php?app_key=#{integration.parameters['api_key']}&id_rav=0&type_piege=captrap") do |r|
        r.success do
          body = JSON(r.body)
          body
            .with_indifferent_access[:features] # Get list of traps
            .map do |trap|
              {
                id: trap[:properties][:id],
                sigfox_id: trap[:properties][:id_sigfox],
                number: trap[:properties][:num_piege],
                pest_variety: trap[:properties][:ravageur],
                total_count: trap[:comptage][:total_ravageur].to_i,
                last_count: trap[:comptage][:comptage_nuit].to_i,
                location: trap[:geometry],
                alert_daily_pest_count: trap[:comptage][:alerte_comptage_nuit].to_i,
                alert_battery_level: trap[:alerte][:alerte_batt].to_i,
                alert_connection_lost:  trap[:alerte][:alerte_emission].to_i,
                link: body["lien"]
              }
            end
        end

        r.redirect do
          Rails.logger.info '*sigh*'.yellow
        end

        r.error do
          Rails.logger.info 'What the fuck brah?'.red
        end
      end
    end

    def debug
      integration = fetch
      get_json("http://sd-89062.dedibox.fr/Pieges/api/api_geojson.php?app_key=#{integration.parameters['api_key']}&id_rav=0&type_piege=captrap") do |_r|
      end
    end

    def check(integration = nil)
      integration = fetch integration
      get_json("http://sd-89062.dedibox.fr/Pieges/api/api_geojson.php?app_key=#{integration.parameters['api_key']}&id_rav=0&type_piege=captrap") do |r|
        r.success do
          Rails.logger.info 'CHECKED'.green
          r.error :api_down if r.body.include? 'Warning'
        end
      end
    end
  end
end
