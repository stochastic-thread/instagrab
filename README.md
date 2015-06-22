Instagrab
===

Gets all user's photos from Instagram

Usage:

```
access_token = INSTAGRAM_ACCESS_TOKEN
agent = Instagrab.start_link(access_token)
```
After a while, you will see this message:

`"Instagrab has finished. Access the agent."`

Do the following:

```
list = Agent.get(agent, fn x -> x end)
```

Boom:

```
iex(5)> list
["https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg"
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg",
"https://scontent.cdninstagram.com/...jpg"]

 ```