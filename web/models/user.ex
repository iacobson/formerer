defmodule Formerer.User do
  use Formerer.Web, :model
  import Formerer.UserPasswordChange, only: [check_old_password: 1, check_new_password: 1]
  import Formerer.AccountActivation, only: [check_activation_token: 1]

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :activation_digest, :string
    field :activated, :boolean, default: false
    field :activated_at, Timex.Ecto.DateTime
    field :password, :string, virtual: true
    field :activation_token, :string, virtual: true
    field :old_password, :string, virtual: true
    field :confirm_password, :string, virtual: true

    has_many :forms, Formerer.Form
    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 7)
  end

  def password_change_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(old_password password confirm_password), [])
    |> validate_length(:old_password, min: 7)
    |> validate_length(:password, min: 7)
    |> check_old_password()
    |> check_new_password()
  end

  def activation_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(activation_token), [])
    |> check_activation_token()
  end
end
