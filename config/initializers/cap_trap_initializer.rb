Cap2020::CapTrapIntegration.on_check_success do
  Cap2020::CapTrapFetchUpdateCreateJob.perform_later
end

Cap2020::CapTrapIntegration.run every: :day do
  Cap2020::CapTrapFetchUpdateCreateJob.perform_now
end