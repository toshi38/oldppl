General
------------------------------------------------------------------------------------
Bed sensor demo software can be used to evaluate BCG sensors. With the GUI, user can:
- Select between BCG and data logger mode.
- View BCG or data logger data in numeric indicators and charts.
- Query BCG module version.
- Get and set parameters.
- Clear time stamp and reset the module.
- Execute sensor calibration.


Configuration properties
------------------------------------------------------------------------------------
Bed sensor demo uses demo.properties file in etc folder for several configuration
parameters. Here is a short list of user configurable properties:

Binary protocol mode        :            demo.use.binary.protocol=true
ASCII protocol mode         :            demo.use.binary.protocol=false

Hide debug window           :            demo.show.debug.messages=false
Show debug window           :            demo.show.debug.messages=true

Note that if debug messages are enabled, software appends the output data to the
log file at root folder of this software. Logs folder contains logger output prints.
These can be errors etc.


Third party libraries
------------------------------------------------------------------------------------
This application includes the JChart2D library v3.2.2 (jchart2d.jar) and jSSC
open source packages.

Source code for jChart2D can be found from http://jchart2d.sourceforge.net. This library
is released under LGPL license (http://www.gnu.org/licenses/lgpl.html).

jSSC library is used for serial port communications. Download the sources and
binaries from https://code.google.com/p/java-simple-serial-connector/downloads/list.

See also GPL license from http://www.gnu.org/licenses/gpl.html.

If you make modifications to this library, replace the old library with the new one
or rename the classpath variables in the .bat file to correct file name
(set classpath=%classpath%;.\lib\JChart2D\jchart2d.jar).
