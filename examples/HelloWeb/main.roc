app [Model, init!, respond!] { pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.11.0/yWHkcVUt_WydE1VswxKFmKFM5Tlu9uMn6ctPVYaas7I.tar.br" }

import pf.Stdout
import pf.Http exposing [Request, Response]
import pf.Utc

# Model is produced by `init`.
Model : {}

# With `init` you can set up a database connection once at server startup,
# generate css by running `tailwindcss`,...
# In this case we don't have anything to initialize, so it is just `Task.ok {}`.

init! : {} => Result Model []
init! = \_ -> Ok {}

respond! : Request, Model => Result Response [ServerErr Str]_
respond! = \req, _ ->
    # Log request datetime, method and url
    datetime = Utc.to_iso_8601 (Utc.now! {})

    try Stdout.line! "$(datetime) $(Inspect.toStr req.method) $(req.uri)"

    Ok {
        status: 200,
        headers: [],
        body: Str.toUtf8 "<b>Hello, web!</b></br>",
    }
