REM password is haxe-pad-air
copy haxe-pad-air.xml .\bin\flash\bin
copy haxe-pad-air.pfx .\bin\flash\bin
cd .\bin\flash\bin
CALL adt -package -storetype pkcs12 -keystore haxe-pad-air.pfx haxepad.air haxe-pad-air.xml haxepad.swf
cd ../../..