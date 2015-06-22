defmodule Instagrab do
  def start_link(access_token) do
    HTTPoison.start
    {:ok, agent} = Agent.start_link fn -> [] end
    {:ok, vita} = Task.start_link(fn -> loop(agent, []) end)
    send vita, {:add, "https://api.instagram.com/v1/users/self/media/recent?access_token=#{access_token}"}
    agent
  end

  def loop(agent, url_list) do
    receive do
      {:add, url} ->
        resp = HTTPoison.get! url
        json_body = Poison.decode! resp.body

        list = 
        json_body["data"] 
        |> Enum.map fn(x) -> 
          x["images"]["standard_resolution"]["url"] 
        end
        
        case json_body["pagination"]["next_url"] do
          nil -> IO.puts "Instagrab has finished. Access the agent."
            _ ->
            send self(), {:add, json_body["pagination"]["next_url"]}
            list |> Enum.map fn(x) -> 
              # {:ok, filename} = (String.split(x, "/e15/") |> Enum.fetch 1)
              # geturl = HTTPoison.get!(x)
              # {:ok, file} = File.open filename, [:write]
              # IO.binwrite file, geturl.body
              # IO.puts filename <> " was written!"
              # File.close file
              Agent.update(agent, 
                fn list -> [x|list] 
              end)
            end
        end
        loop(agent, url_list ++ list)
    end
  end
end