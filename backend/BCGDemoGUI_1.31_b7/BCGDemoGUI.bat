@echo off
setlocal

set title=BCG Demo
title %title%
mode con:cols=120 lines=30

rem ------------------------------------------------------------------------
rem --- setup the CLASSPATH
rem ------------------------------------------------------------------------
set classpath=.\lib\BCGDemoGUI.jar
set classpath=%classpath%;.\lib\JChart2D\jchart2d.jar
set classpath=%classpath%;.\lib\jssc.jar
set classpath=%classpath%;.\lib\JSON\javax.json-1.0.4.jar

rem ------------------------------------------------------------------------
rem Finding Java.
rem ------------------------------------------------------------------------
:test_java_version
  java -version

  rem Check if Java was not found
  if %ERRORLEVEL% == 9009 (
    goto check_java_version
  ) else (
    goto set_jvm_params
  )

:check_java_version
  echo Check if we have JRE installed but it is not in PATH. Searching Java from Windows registry..
  rem Set key/value pair if we need to search Java
  set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment"
  set VALUE_NAME=CurrentVersion

  rem Get the current Java version from the Windows registry
  FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set CurrentJavaVersion=%%A
  )
  
  rem echo The current Java runtime is %KEY_NAME%\%CurrentJavaVersion%

  IF "%CurrentJavaVersion%" == "" (
    rem If not found use another way
    goto check_java_version_other
  )

  rem Find installation folder of the current Java version and add folder to the PATH
  set JAVA_HOME=JavaHome
  set JAVA_CURRENT="HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment\%CurrentJavaVersion%"
  FOR /F "usebackq skip=1 tokens=3,4" %%A IN (`REG QUERY %JAVA_CURRENT% /v %JAVA_HOME% 2^>nul`) DO (
    set JAVA_PATH=%%A %%B
  )

  echo JAVA_PATH: %JAVA_PATH%
  set PATH=%JAVA_PATH%\bin;%PATH%

  rem Retest the Java version after setting the PATH
  goto test_java_version

:check_java_version_other
  echo Check if we have 32-bit JRE in 64-bit OS
  rem Set key/value pair if we need to search Java
  set KEY_NAME2="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment"
  set VALUE_NAME2=CurrentVersion

  rem Get the current Java version from the Windows registry
  echo Searching Java from registry..
  FOR /F "usebackq tokens=3" %%A IN (`REG QUERY %KEY_NAME2% /v %VALUE_NAME2% 2^>nul`) DO (
    set CurrentJavaVersionX=%%A
  )

  IF "%CurrentJavaVersionX%" == "" (
    rem give up
    echo Failed to find Java from the Windows registry! Please make sure that Java is installed!
    pause
    goto end
  )

  rem echo The current Java runtime is %KEY_NAME2%\%CurrentJavaVersionX%

  rem Find installation folder of the current Java version and add folder to the PATH
  set JAVA_HOME2=JavaHome
  set JAVA_CURRENT2="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment\%CurrentJavaVersionX%"
  FOR /F "usebackq tokens=3,4,5" %%A IN (`REG QUERY %JAVA_CURRENT2% /v %JAVA_HOME2% 2^>nul`) DO (
    set JAVA_PATH2=%%A %%B %%C
  )
  set PATH=%JAVA_PATH2%\bin;%PATH%

  rem Retest the Java version after setting the PATH
  goto test_java_version


rem ------------------------------------------------------------------------
rem --- set JVM parameters (minimum and maximum heap size)
rem ------------------------------------------------------------------------
:set_jvm_params
set JVM_PARAMS=-Xms64m
set JVM_PARAMS=%JVM_PARAMS% -XX:+HeapDumpOnOutOfMemoryError
set JVM_PARAMS=%JVM_PARAMS% -XX:+UseConcMarkSweepGC

rem ------------------------------------------------------------------------
rem --- set the splash screen image.
rem ------------------------------------------------------------------------
set SPLASH=-splash:etc/images/Murata.jpg

rem Test if we should show debug messages
FINDSTR /C:"demo.show.debug.messages=true" etc\demo.properties
IF ERRORLEVEL 1 (
  start javaw %JVM_PARAMS% -Djava.library.path="%LIB_PATH%" %SPLASH% fi.murata.ds.demos.BCGDemoGUI
) ELSE (
  rem show console window if enabled
  java %JVM_PARAMS% -Djava.library.path="%LIB_PATH%" %SPLASH% fi.murata.ds.demos.BCGDemoGUI
  pause
)

:end
endlocal
