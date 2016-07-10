defmodule Formerer.UserSocket do
  use Phoenix.Socket
  @max_age 2 * 7 * 24 * 60 * 60

  channel "forms:*", Formerer.FormChannel

  transport :websocket, Phoenix.Transports.WebSocket
  #transport :longpoll, Phoenix.Transports.LongPoll

  #Any :params we pass to the socket constructor in socket.js will be available as the first argument in UserSocket.connect

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
