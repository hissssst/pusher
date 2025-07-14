import Config

config :joken,
  default_signer: System.get_env("PUSHER_JWT_SIGNER_SECRET")

port = String.to_integer(System.get_env("PUSHER_PORT", "4000"))

config :pusher,
  control_secret: System.get_env("PUSHER_CONTROL_SECRET")

config :phoenix,
  logger: config_env() != :prod

config :pusher, Pusher.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  debug_errors: false,
  server: true,
  http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
  url: [host: System.get_env("PUSHER_HOSTNAME"), port: port]

if config_env() == :dev do
  config :open_api_spex, :cache_adapter, OpenApiSpex.Plug.NoneCache
end
