# wintersmith-uglify

Plugin for [wintersmith](https://github.com/jnordberg/wintersmith) which:

* [uglifyjs](https://github.com/mishoo/UglifyJS2) your js scripts

### Install:

```sh
npm install wintersmith-uglify2 -g
```

then add `wintersmith-uglify2` to plugins in your wintersmith config

All javascripts have to reside in a directory called js outside the contents folder.
in the js folder should be a file called default.ugljs with the following JSON content:

    {
      "uglify": [
        "file1.js",
        "file2.js",
        ...
      ]
    }

on build the plugin compresses all listed files in order with uglify and creates a single
file called ```default.js``` which can be included in the HTML