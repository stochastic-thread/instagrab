defmodule Life do
  def start_link do
  	{:ok, vita} = Task.start_link(fn -> loop([]) end)
  	send vita, {:add, "https://api.instagram.com/v1/users/self/media/recent?access_token=1531139.f18ce1e.1353009936304f85921167c58a591475"}
  end

  def loop(url_list) do
  	receive do
      {:add, url} ->
      	resp = HTTPoison.get! url
      	json_body = Poison.decode! resp.body
      	list = json_body["data"] |> Enum.map fn(x) -> x["images"]["standard_resolution"]["url"] end
      	send self(), {:add, json_body["pagination"]["next_url"]}
      	list |> Enum.map fn(x) ->
	      	{:ok, filename} = (String.split(x, "/e15/") |> Enum.fetch 1)
			geturl = HTTPoison.get!(x)
			{:ok, file} = File.open filename, [:write]
			IO.binwrite file, geturl.body
			IO.puts filename <> " was written!"
			File.close file
		end
      	loop(url_list ++ list)
  	end
  end
end