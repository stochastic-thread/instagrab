defmodule Life do
  def start_link do
  	vita = spawn(fn -> loop([]) end)
  	send vita, {:add, "https://api.instagram.com/v1/users/self/media/recent?access_token=1531139.f18ce1e.1353009936304f85921167c58a591475"}
  end

  def loop(list_perm) do
  	receive do
      {:add, url} ->
      	resp = HTTPoison.get! url
      	json_body = Poison.decode! resp.body
      	list = json_body["data"] |> Enum.map fn(x) -> x["images"]["standard_resolution"]["url"] end
      	send self(), {:add, json_body["pagination"]["next_url"]}
      	IO.puts list_perm
      	loop(list_perm ++ list)
  	end
  end
end