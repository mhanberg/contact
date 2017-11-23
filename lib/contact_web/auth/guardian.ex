defmodule ContactWeb.Guardian do
  use Guardian, otp_app: :contact

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(_claims) do
    {:ok, :ok}
  end
end
