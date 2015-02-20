# derby-notebook
A proof of concept of providing a multi-user Jupyter notebook.

The approach is to run a proxy over the notebook server and intercept the
`notebooks` requests, replacing them with a [Derby](http://derbyjs.com/)
app on top of the running state IPython notebook.

In the background, a listener waits for changes on the model, and transforms
them into [messages][ipep-13], and similarly updates the model when it receives
messages.

## Model
A Derby model is a set of collections of JSON-compatible documents. The only
collection thus far is `notebooks`, which includes, of course, the notebook
contents, but several other pieces to enable a multi-user experience:

```js
{
  // The filename, as would be used in /notebooks/Untitled.ipynb
  "name": "Untitled.ipynb",
  // the results of the contents manager, with some added information that must
  // be stripped before being posted
  "contents": {
    # a bunch of stuff
    "contents": {
      "cells": [
        {
          "source": ""
          "_multiuser": {
            "id": "generated-by-derby",
            # gnarly state machine stuff: RUN_REQUESTED, RUNNING
            "state": "NOT_RUNNING"
          }
        }
      ]
    }
  },
  // a hash of user-related stuff so that the UI can reflect multiple
  // perspectives
  "users": {
    "user-id-generated-by-node": {
      "currentCell": "generated-by-derby",
      "cursor": [0, 1]
    }
  }
}
```


## Running
This is all tied together with [docker-compose](http://github.com).

Build (this can take a while!) and run everything with:
```sh
docker-compose up
```
Then visit http://localhost:9999/

Or, if you just want to restart the proxy:

```sh
docker-compose build && docker-compose start && docker-compose logs
^C
docker-compose build && docker-compose restart proxy && docker-compose logs
```

## Debugging node stuff

### start an interactive coffeescript shell

```shell
docker run -i vagrant_proxy
```

[ipep-13]: https://github.com/ipython/ipython/wiki/IPEP-13%3A-Updating-the-Message-Spec
