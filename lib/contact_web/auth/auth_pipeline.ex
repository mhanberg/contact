defmodule ContactWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :contact,
    module: ContactWeb.Guardian,
    error_handler: ContactWeb.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
end
