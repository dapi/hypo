require "rhelm/client"

# Using kubeconfig
$rhelm = Rhelm::Client.new(
  kubeconfig: ApplicationConfig.kubeconfig,
  # logger: Rhelm::Client::SimpleLogger
)
