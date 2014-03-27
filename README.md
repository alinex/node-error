Package: alinex-error
=================================================

This will replace the standard error handler with one which will

* use source-maps
* colorize and highlight the output
* display code area


Example Output
-------------------------------------------------

    ReferenceError: comand is not defined
      at /home/alex/a3/node-make/lib/pushTask.js:111:82
         /home/alex/a3/node-make/src/pushTask.coffee:95:44
         093:     execFile "git", [
         094:       'commit'
         **095:       '-m', "Added information for version #{comand.newVersion}"**
         096:     ], { cwd: command.dir }, (err, stdout, stderr) ->
         097:       console.log stdout.trim().grey if stdout and commander.verbose
    Exiting after error logging timeout.


Installation
-------------------------------------------------

To add this error handler to your application run (from your project's folder):

    > npm install alinex-error --save

This will add the package, to your dependencies and install it.


Usage
-------------------------------------------------

To use the error handler it should be added for uncaught exceptions in the
main routine using:

    errorHandler = require('alinex-error');
    errorHandler.install()

Or the same in one statement:

    require('alinex-error').install();

This will capture the error, log it and stop processing if one occurs.

Alternatively an already caught Error may be reported using:

    errorHandler.report(error);

The error may have some nested errors in it's `cause` property. Also a
`codePart` property may give a hint where the error comes from.

# ### Create an error

You may always throw an error the same way using:

    throw new Error("Message");

You may also report any object as error like:

    errorHandler.report("Something went wrong!");

If you catch an error and rethrow it you may use:

    try {
      ...
    } catch (ex) {
      err = new Error("Something went wrong!");
      err.cause = ex;
      err.codePart = "input-1";
    }


Configuration
-------------------------------------------------

To configure the output you may set values within the exported config
structure:

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
        modules: false      # show code within node_modules
        all: false          # show all code or only from origin

      # Should command exit after an uncaught error is reported
      uncaught:
        exit: true          # should process be exited after uncaught error
        timeout: 100        # timeout to wait before exit to write logs
        code: 2             # exit code to use

The above given values are the default values which you may change to customize
the output.


License
-------------------------------------------------

Copyright 2013-2014 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
