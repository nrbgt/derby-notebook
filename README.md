# derby-notebook
A proof of concept of providing a multi-user Jupyter notebook.

The approach is to run a proxy over the notebook server and intercept the
`notebooks` requests, replacing them with a [Derby](http://derbyjs.com/)
app on top of the running state IPython notebook.

In the background, a listener waits for changes on the model, and transforms
them into [messages][ipep-13], and similarly updates the model when it receives
messages.

## Roadmap
- [X] proxy notebook
- [X] Load content into multiuser view (after single-user bootstrap)
- [X] open websocket connection to kernel
- [X] multiuser codemirror in cells
- [X] add cell above/below current
- [X] move cell up/down
- [X] remove cell
- [ ] run cell, see output
- [ ] multiuser presence, (chat, meh)
- [ ] overload `/notebooks` (and all calls to start up kernel)
- [ ] post contents back to content manager API
- [ ] wrap widgets in derby model


## Model
A Derby model is a set of collections of JSON-compatible documents. The main
collection is `notebooks`, which includes, of course, the notebook
contents, but several other pieces to enable a multi-user experience:

```js
{
  // The filename, as would be used in /notebooks/Untitled.ipynb
  "name": "Untitled.ipynb",
  // the results of the contents manager
  "contents": {},
  // stuff for connecting to kernel
  "session": {}
}
```

When one of these documents are created, a `derby-hook` goes off an grabs the
contents, and populates the `cells` collection. Each cell is its own standalone
document to keep updates more atomic. `_` keys will be stripped out when being
posted back to the
```js
{
  "cell_type": "markdown" // or code
  "source": "the code or text",
  "outputs": [],
  // ... more cell stuff
  "id": "generated-by-derby"
  "_state": "run" // probably a better way to do this
  "_editors": {
    "userid": 1
  },
  "_notebook": "the notebook id",
  "_weight": 1000 // heavier weights sink to the bottom of the page
}
```


## Running
This is all lashed together with [docker-compose](http://github.com), and
presently also runs inside a vagrant box.

```sh
vagrant up
```

Then, log into that box.

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
