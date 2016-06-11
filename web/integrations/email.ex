defmodule Formerer.Integration.Email do
  import Swoosh.Email
  use Phoenix.Swoosh, view: Formerer.EmailView, layout: {Formerer.LayoutView, :email}

  def account_activation(conn, user) do
    new
    |> to({"Formerer User", user.email})
    |> from({"Formerer", "noreply@formerer.io"})
    |> subject("Please activate your Formerer account")
    |> render_body("account_activation.html", %{user: user, conn: conn})
  end

  def password_reset(conn, user) do
    new
    |> to({"Formerer User", user.email})
    |> from({"Formerer", "noreply@formerer.io"})
    |> subject("Formerer password reset request")
    |> render_body("password_reset.html", %{user: user, conn: conn})
  end
end
