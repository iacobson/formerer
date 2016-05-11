defmodule Formerer.Router do
  use Formerer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate_user do
    plug Formerer.UserAuthentication
  end

  scope "/form", Formerer do
    pipe_through :api

    post "/:slug", FormSubmissionsController, :create
  end

  scope "/", Formerer do
    pipe_through [:browser, :protect_from_forgery]

    get "/", PageController, :index

    get "/register", UsersController, :new
    post "/register", UsersController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    pipe_through :authenticate_user
    get "/dashboard", DashboardController, :index
    resources "users", UsersController, only: [:edit, :update]

    resources "forms", FormsController, only: [:new, :create, :update, :show] do
      get "columns/edit", FormColumnsController, :edit
      post "columns/update", FormColumnsController, :update
    end
  end

end
