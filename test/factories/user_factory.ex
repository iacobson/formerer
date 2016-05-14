defmodule Formerer.UserFactory do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  use ExMachina.Ecto, repo: Formerer.Repo

  alias Formerer.User

  def factory(:user) do
    %User{
      email: sequence(:email, &"email#{&1}@example.com"),
      password_digest: hashpwsalt("ins3cure"),
      activated: true,
      activation_digest: hashpwsalt("active_account"),
      activated_at: Timex.DateTime.now
    }
  end

end
