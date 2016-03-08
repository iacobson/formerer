defmodule Formerer.Feature.FormTest do
  import String, only: [contains?: 2]
  import Formerer.UserFactory

  use ExUnit.Case
  use Hound.Helpers

  hound_session

  setup_all do
    {:ok, user: create(:user)}
  end

  test "user can create a new form", test_data do
    form_name = "Super Testy Form oooh"
    login(test_data[:user].email, "ins3cure")

    find_element(:css, ".mdl-layout__drawer-button i") |> click
    find_element(:css, ".new-form-link") |> click

    find_element(:id, "form_name") |> fill_field(form_name)
    find_element(:css, "form .mdl-button") |> click

    assert contains?(visible_page_text, "Form Created")
    assert contains?(visible_page_text, form_name)
  end

  defp login(username, password) do
    navigate_to("/login")
    find_element(:id, "session_email") |> fill_field(username)
    find_element(:id, "session_password") |> fill_field(password)
    find_element(:css, "form .mdl-button") |> click
  end

end
