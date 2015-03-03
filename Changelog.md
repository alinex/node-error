Version changes
=================================================

The following list gives a short overview about what is changed between
individual versions:

Version 1.0.2 (2015-03-03)
-------------------------------------------------
- update to use builder

Version 1.0.1 (2015-03-03)
-------------------------------------------------
- Disable io.js in testing.

Version 1.0.0 (2015-03-03)
-------------------------------------------------
- Upgraded dependent modules and updated checks to new chalk color order.

Version 0.2.7 (2015-02-03)
-------------------------------------------------
- Updated dependend packages.
- Fixed bug in which the error message is added multiple times.
- Redo last change because this prevented complete source display.
- Strangely the stack access is not possible on some errors.

Version 0.2.6 (2014-10-21)
-------------------------------------------------
- Changed default exit code to -1.
- Changed color eof exit message.
- Added support to display error properties, too.

Version 0.2.5 (2014-10-08)
-------------------------------------------------
- Fixed npm ignore file.
- Updated to now again functioning source-map package.
- Updated to newest alinex-make package.
- Replace colors with chalk.

Version 0.2.4 (2014-09-17)
-------------------------------------------------
- Changed .gitignore rules.
- Fixed calls to new make tool.
- Updated to alinex-make 0.3.
- Set timeout to a default of 1000ms.
- CHangelog optimization.

Version 0.2.3 (2014-08-08)
-------------------------------------------------
- Excluded source-map version 0.1.38 because problem in package.json.
- Documentation optimization.
- Fixed line splitting to only use correct \n and \r\n

Version 0.2.2 (2014-07-10)
-------------------------------------------------
- Fixed TypeError on empty stack trace.
- Fix coverall call.
- Exit with return code from error object if present.
- Make keywords in package.json an array.
- Use alinex-make for test and coverage.
- Change prepublish to use alinex-make.
- Added link to alinex documentation.
- Updated gitignore and npmignor for new file structure.
- Small documentation fixes.

Version 0.2.1 (2014-04-10)
-------------------------------------------------
- Small documentation updates.
- Added config flag to show also the compiled code.
- Description changes.

Version 0.2.0
-------------------------------------------------
- Added logger support to report to any possible logger and transport.

Version 0.1.4
-------------------------------------------------
- Fixed bug in calling report() which prevented output to be created.
- Allow chaining in install() method.
- Add test for report method.
- Added support for associative error causes.
- Extended test scripts.
- Remove coverage report from git.
- Fixup git files.
- Finished coveralls integration.

Version 0.1.3
-------------------------------------------------
- Added dependency for colors module.
- Added help for new format() method.
- Added unit tests. Added format() option to return formatted string.
- Rename internal functions for more modular structure.
- First test routines to get proper testing.
- Made dependencies more open.
- Fixed lint errors.

Version 0.1.2
-------------------------------------------------
- Fixed typo in configuration settings for config.stack

Version 0.1.1
-------------------------------------------------
- Fixed interpretation of config.code.all switch.
- Added config option to switch display of error cause on/off.

Version 0.1.0
-------------------------------------------------
- Upgraded to V0.1.0 because feature list reached.
- Added information for version 0.0.3

Version 0.0.2
-------------------------------------------------
- Added configuration value to switch coloring off.
- Added simple test script.
- Changed config flag from mapSource -> all
- Possibility to show code only for mapped source (configurable)
- Added a fixed version of the error handler.

Version 0.0.1
-------------------------------------------------
- Initial commit

