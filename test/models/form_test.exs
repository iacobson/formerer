defmodule Formerer.FormTest do
  use Formerer.ModelCase

  alias Formerer.Form

  @valid_attrs %{identifier: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Form.changeset(%Form{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Form.changeset(%Form{}, @invalid_attrs)
    refute changeset.valid?
  end
end
