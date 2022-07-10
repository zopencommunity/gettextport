Patch descriptions:

no-pwd_gecos.patch:     
  There are a few files that expect the pw_getcos field to exist, but this is a 
  Linux field (https://www.mkssoftware.com/docs/man5/struct_passwd.5.asp)
  and not a POSIX field (https://pubs.opengroup.org/onlinepubs/009604599/basedefs/pwd.h.html)
  so this patch removes the code that interrogates this field when __MVS__ is defined.

locale-name-collision.patch:
  On z/OS, the System headers for locale.h define the macro __locale to indicate the
  header file has been included. This clashes with a field used in the code in 
  gettext-runtime/intl/gettextP.h, so the fix is to change the field to another name
  that does not conflict. 
  It may be appropriate to move to a name that does not start with __ since these are 
  reserved by the implemtnation (http://port70.net/~nsz/c/c11/n1570.html#7.1) 
fetch-name-collision.patch:
  We compile with LANGLVL(EXTENDED) on z/OS, which pulls in additional functions, one
  of which is _fetch_ which clashes with a static function. The simplest fix is to 
  just rename the static function to urlfetch which will work everywhere.
