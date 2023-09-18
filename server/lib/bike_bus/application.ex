defmodule BikeBus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BikeBusWeb.Telemetry,
      # Start the Ecto repository
      BikeBus.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BikeBus.PubSub},
      # Start Finch
      {Finch, name: BikeBus.Finch},
      # Start the Endpoint (http/https)
      BikeBusWeb.Endpoint,
      {Absinthe.Subscription, BikeBusWeb.Endpoint}
      # Start a worker by calling: BikeBus.Worker.start_link(arg)
      # {BikeBus.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BikeBus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BikeBusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end