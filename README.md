Package: alinex-error
=================================================

[![Build Status](https://travis-ci.org/alinex/node-error.svg?branch=master)](https://travis-ci.org/alinex/node-error)
[![Coverage Status](https://coveralls.io/repos/alinex/node-error/badge.svg?branch=master)](https://coveralls.io/r/alinex/node-error?branch=master)
[![Dependency Status](https://gemnasium.com/alinex/node-error.png)](https://gemnasium.com/alinex/node-error)

This will replace the standard error handler with one which will

* display code with context
* use source-maps
* support error nesting (multi level)
* support individual loggers like winston...
* colorize and highlight the output

For the normal use it is really simple and only have to be loaded and installed
once in your application.

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/node-alinex).


Possible Output
-------------------------------------------------

Keep in mind that the colors here won't match the ones really displayed on your
output:

``` text
ReferenceError: comand is not defined
  at /home/alex/a3/node-make/lib/pushTask.js:111:82
     /home/alex/a3/node-make/src/pushTask.coffee:95:44
     093:     execFile "git", [
     094:       'commit'
     095:       '-m', "Added information for version #{comand.newVersion}"
     096:     ], { cwd: command.dir }, (err, stdout, stderr) ->
     097:       console.log stdout.trim().grey if stdout and commander.verbose
Exiting after error logging timeout.
```

You may change the output in different ways using the configuration. Below are
some output examples for different configurations (keep in mind the colors
displayed here won't match).

### Only the real error message

Configuration:

``` javascript
{ colors: false, properties: false,
  stack: { view: false, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
```

### Show error message with possible details

Configuration:

``` javascript
{ colors: false, properties: true,
  stack: { view: false, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
Detail: The database is not working properly.
```

The additional information has to be added as properties of the error object.

### Default stack trace

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:78:22)
```

### Stack with node_modules

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: true, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:85:22)
  at callFn (/home/alex/a3/node-error/node_modules/mocha/lib/runnable.js:223:21)
  at Test.Runnable.run (/home/alex/a3/node-error/node_modules/mocha/lib/runnable.js:216:7)
  at Runner.runTest (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:374:10)
  at /home/alex/a3/node-error/node_modules/mocha/lib/runner.js:452:12
  at next (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:299:14)
  at /home/alex/a3/node-error/node_modules/mocha/lib/runner.js:309:7
  at next (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:247:23)
  at Object._onImmediate (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:276:5)
```

### Stack with system

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: true },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:93:22)
  at processImmediate [as _immediateCallback] (timers.js:330:15)
```

### Full stack with node_modules and system

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: true, system: true },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:101:22)
  at callFn (/home/alex/a3/node-error/node_modules/mocha/lib/runnable.js:223:21)
  at Test.Runnable.run (/home/alex/a3/node-error/node_modules/mocha/lib/runnable.js:216:7)
  at Runner.runTest (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:374:10)
  at /home/alex/a3/node-error/node_modules/mocha/lib/runner.js:452:12
  at next (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:299:14)
  at /home/alex/a3/node-error/node_modules/mocha/lib/runner.js:309:7
  at next (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:247:23)
  at Object._onImmediate (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:276:5)
  at processImmediate [as _immediateCallback] (timers.js:330:15)
```

### Show code line

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: false },
  code:
   { view: true,
     before: 0,
     after: 0,
     compiled: false,
     modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
     08:   new Error "Something went wrong"
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:112:22)
```

### Show code context

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: false },
  code:
   { view: true,
     before: 2,
     after: 2,
     compiled: false,
     modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
     06:
     07: module.exports.returnError = ->
     08:   new Error "Something went wrong"
     09:
     10: module.exports.returnCause = ->
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:131:22)
```

### Show code lines

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: false },
  code:
   { view: true,
     before: 0,
     after: 0,
     compiled: false,
     modules: false,
     all: true },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
     08:   new Error "Something went wrong"
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:142:22)
     142: #      makedoc msg
```

### Show all code lines

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: true, system: false },
  code:
   { view: true,
     before: 0,
     after: 0,
     compiled: false,
     modules: true,
     all: true },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
     08:   new Error "Something went wrong"
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:152:22)
     152: undefined
  at callFn (/home/alex/a3/node-error/node_modules/mocha/lib/runnable.js:223:21)
     223:     var result = fn.call(ctx);
  at Test.Runnable.run (/home/alex/a3/node-error/node_modules/mocha/lib/runnable.js:216:7)
     216:       callFn(this.fn);
  at Runner.runTest (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:374:10)
     374:     test.run(fn);
  at /home/alex/a3/node-error/node_modules/mocha/lib/runner.js:452:12
     452:       self.runTest(function(err){
  at next (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:299:14)
     299:       return fn();
  at /home/alex/a3/node-error/node_modules/mocha/lib/runner.js:309:7
     309:       next(suites.pop());
  at next (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:247:23)
     247:     if (!hook) return fn();
  at Object._onImmediate (/home/alex/a3/node-error/node_modules/mocha/lib/runner.js:276:5)
     276:     next(0);
```

### Show also compiled code lines

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: false },
  code: { view: true, before: 0, after: 0, compiled: true, modules: false },
  cause: { view: false, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.js:8:12)
     08:     return new Error("Something went wrong");
     Object.module.exports.returnError (/home/alex/a3/node-error/test/data/object.coffee:8:6)
     08:   new Error "Something went wrong"
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/default.coffee:167:22)
```

### Show error with cause

Configuration:

``` javascript
{ colors: false,
  stack: { view: false, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: true, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  Caused by Error: root fault (somethere)
```

### Show error with cause array

Configuration:

``` javascript
{ colors: false,
  stack: { view: false, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: true, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  Caused by Error: root fault 1 (somethere)
  Caused by Error: root fault 2 (somethere)
```

### Show error with cause hash

Configuration:

``` javascript
{ colors: false,
  stack: { view: false, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: true, stack: false },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  Caused by Error: root fault 1 (here)
  Caused by Error: root fault 2 (there)
```

### Show stack with error cause

Configuration:

``` javascript
{ colors: false,
  stack: { view: true, modules: false, system: false },
  code: { view: false, before: 0, after: 0, compiled: false, all: false, modules: false },
  cause: { view: true, stack: true },
  uncaught: { exit: true, timeout: 100, code: 2 } }
```

Error message:

``` text
Error: Something went wrong
  at Object.module.exports.returnCause (/home/alex/a3/node-error/test/data/object.js:13:11)
     Object.module.exports.returnCause (/home/alex/a3/node-error/test/data/object.coffee:11:12)
  at Context.<anonymous> (/home/alex/a3/node-error/test/run/cause.coffee:105:22)
  Caused by Error: root fault (somethere)
    at Object.module.exports.returnCause (/home/alex/a3/node-error/test/data/object.js:14:17)
       Object.module.exports.returnCause (/home/alex/a3/node-error/test/data/object.coffee:12:18)
    at Context.<anonymous> (/home/alex/a3/node-error/test/run/cause.coffee:105:22)
```


Install
-------------------------------------------------

[![NPM](https://nodei.co/npm/alinex-error.png?downloads=true&downloadRank=true&stars=true)
 ![Downloads](https://nodei.co/npm-dl/alinex-error.png?months=9&height=3)
](https://www.npmjs.com/package/alinex-error)

The easiest way is to let npm add the module directly to your modules
(from within you node modules directory):

``` sh
npm install alinex-error --save
```

And update it to the latest version later:

``` sh
npm update alinex-error --save
```

Always have a look at the latest [changes](Changelog.md).


Usage
-------------------------------------------------

To use the error handler it should be added for uncaught exceptions in the
main routine using:

``` coffee
errorHandler = require 'alinex-error'
```

Or the same in one statement:

``` coffee
errorHandler = require('alinex-error').install()
```

This will capture the error, log it and stop processing if one occurs.

Alternatively an already caught Error may be reported using:

``` coffee
errorHandler.report error
errorHandler.report error, level
```

or retrieved as formatted string using:

``` coffee
errorHandler.format error
```

The error may have some nested errors in it's `cause` property. Also a
`codePart` property may give a hint where the error comes from.

### Create an error

You may always throw an error the same way using:

``` coffee
throw new Error "Message"
```

You may also report any object as error like:

``` coffee
errorHandler.report "Something went wrong!"
```

### Support cause error

If you catch an error and rethrow it you may use:

``` coffee
    try
      ...
    catch ex
      err = new Error "Something went wrong!"
      err.cause = ex
      err.codePart = "input-1"
```

This ensures that the new error will be reported but also with it's real cause.

### Send multiple errors

That's done the same way as an error with another error as cause. You create a
new error instance and add all your different real errors as the `cause` array:

``` coffee
errList = doSomething()
err = new Error "Something went wrong!"
err.cause = errList
```

If this resulting error will be reported it is done with all the causes if
enabled in configuration. The cause-list may be an array or an associative
array.


Exit process
-------------------------------------------------

If `uncaught.exit` is set the process is stopped after an uncaught error is
reported. The process will wait the defined `timeout` to finish the last write
operations and exit with the code from `err.code` or the specified default error
code.


Configuration
-------------------------------------------------

To configure the output you may set values within the exported config
structure:

``` coffee
errorHandler.config =
  colors: true          # should colors be allowed on console output

  # Define whether and which stack lines to show
  stack:
    view: true          # show stack trace or not
    modules: false      # show node_module trace
    system: false       # show system module trace

  # Define if and how much code to show
  code:
    view: true          # view code sources or not
    before: 2           # number of lines to show before the referenced one
    after: 2            # number of lines to show after the referenced one
    compiled: false     # show also code of compiled code
    all: false          # show code of all lines or only the first
    modules: false      # show code within node_modules

  # Display of the errors cause if there is one
  cause:
    view: true          # view caused errors
    stack: true         # view also stack like on main error

  # Should command exit after an uncaught error is reported
  uncaught:
    exit: true          # should process be exited after uncaught error
    timeout: 1000       # timeout to wait before exit to write logs
    code: 2             # exit code to use

  # define a specific logger
  logger: console
```

The above given values are the default values which you may change to customize
the output. As logger you may specify any logger like `console` or `winston` or
any other which have an `error()` method to call.


License
-------------------------------------------------

Copyright 2013-2015 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
