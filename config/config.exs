# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :contact,
  ecto_repos: [Contact.Repo]

# Configures the endpoint
config :contact, ContactWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ze7PM4JDIZ92E0qOfx8JJSJrMIzQryTWUlk1X/9sfaEr5zodAy6zBje9pArA8fjF",
  render_errors: [view: ContactWeb.ErrorView, accepts: ~w(html json json-api)],
  pubsub: [name: Contact.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures JaSerializer
config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Guardian configuration
config :contact, ContactWeb.Guardian,
  issuer: "contact",
  secret_key: "bu5/JsBOnyPOKKNPpK4t79F1R6D8I0VTSiUWJKJEExnOlqTVX426s2Lt9CU25+DW"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
