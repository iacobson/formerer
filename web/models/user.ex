defmodule Formerer.User do
  use Formerer.Web, :model
  import Formerer.UserPasswordChange, only: [check_old_password: 1, check_new_password: 1]
  import Formerer.UserToken, only: [verify_token: 1]

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :token, :string
    field :activated, :boolean, default: false
    field :activated_at, Timex.Ecto.DateTime
    field :password, :string, virtual: true
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

  def password_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(old_password), [])
    |> validate_length(:old_password, min: 7)
    |> check_old_password()
  end

  def new_password_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(password confirm_password), [])
    |> validate_length(:password, min: 7)
    |> check_new_password()
  end

  def password_change_changeset(model, params \\ :empty) do
    model
    |> password_changeset(params)
    |> new_password_changeset(params)
  end

  def token_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(token), [])
    |> verify_token()
  end
end
