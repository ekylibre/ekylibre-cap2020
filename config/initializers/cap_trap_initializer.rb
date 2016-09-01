Cap2020::CapTrapIntegration.on_check_success do
  Cap2020::CapTrapCheckSuccessJob.perform_later
end

Cap2020::CapTrapIntegration.run every: :hour do
  Cap2020::CapTrapCheckSuccessJob.perform_now
end