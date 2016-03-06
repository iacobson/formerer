defmodule Formerer.UserFactory do
  use ExMachina.Ecto, repo: Formerer.Repo

  alias Formerer.User

  def factory(:user) do
    %User{
      email: sequence(:email, &"email#{&1}@example.com"),
      password_digest: "ins3cure"
    }
  end

end
