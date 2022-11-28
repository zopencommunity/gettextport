#!/bin/sh
#
# Simple hello world program using gettext services
# Built from the tutorial at: https://www.labri.fr/perso/fleury/posts/programming/a-quick-gettext-tutorial.html
#

# Generate the Portable Object Template (pot)

#
# First, check gettext et al is around
gettextversion=$(gettext --version)
if [ $? -gt 0 ]; then
  echo "Need gettext in PATH to run test" >&2
  exit 16
fi

rm -rf po fr *.err *.out hello hello.o
mkdir -p po/fr
mkdir -p fr/LC_MESSAGES

if ! xgettext --keyword=_ --language=C --add-comments --sort-output -o po/hello.pot hello.c >xgettext.out 2>xgettext.err ; then
  echo "xgettext failed" >&2
  exit 4
fi

#
# This tag should not be required (below). Issue: https://github.com/ZOSOpenTools/gettextport/issues/9
#
if ! chtag -t po/hello.pot ; then
  echo "Unable to make the hello.pot file 'text' (instead of 'mixed')" >&2
fi

if ! sed -e 's/PACKAGE VERSION/Hello 1.0/' po/hello.pot | sed -e 's/Report-Msgid-Bugs-To: /Report-Msgid-Bugs-To: zosopentools@gmail.com/' | sed -e 's/CHARSET/UTF-8/' | sed -e 's/Language: /Language: fr/' | \
     sed -e 's/FULL NAME <EMAIL@ADDRESS>/ZOS Open Tools (zosopentools@gmail.com)/' | sed -e 's/LANGUAGE <LL@li.org>/French <LL@li.org>/' | sed -e 's/EMAIL@ADDRESS/zosopentools@gmail.com/' | sed -e 's/YEAR/2022/' >po/new.pot ; then
  echo "Unable to customize POT file" >&2
  exit 4
fi

if ! mv po/new.pot po/hello.pot ; then
  echo "Unable to replace hello.pot file with customized version" >&2
fi

#
# msginit is looking in /jenkins files for the defaults instead of the installed location. Issue: https://github.com/ZOSOpenTools/gettextport/issues/10

#
if ! msginit --input=po/hello.pot --locale=fr --output=po/fr/hello.po >msginit.out 2>msginit.err ; then
  echo "French translation init failed" >&2
  exit 4
fi
#
# This tag should not be required (below). Issue: https://github.com/ZOSOpenTools/gettextport/issues/9
#
if ! chtag -t po/fr/hello.po ; then
  echo "Unable to make the hello.pot file 'text' (instead of 'mixed')" >&2
fi

msgidline=$(grep -n '^msgid' po/fr/hello.po | tail -1 | awk -F':' '{print $1}')
msgstrline=$((${msgidline}+1))

if ! sed -e "${msgstrline}s/msgstr.*/msgstr \"Bonjour le monde\\\\n\"/" po/fr/hello.po >po/fr/hellotrans.po ; then
  echo "French translation insertion failed" >&2 
  exit 4
fi

if ! mv po/fr/hellotrans.po po/fr/hello.po ; then
  echo "Unable to replace fr/hello.po file with customized version" >&2
fi

if ! msgfmt --output-file=po/fr/hello.mo po/fr/hello.po ; then
  echo "Unable to generate Machine Object (mo) file for hello french translation" >&2
  exit 4
fi

if ! cp po/fr/hello.mo ./fr/LC_MESSAGES/hello.mo ; then
  echo "Unable to install French messages" >&2
  exit 4
fi

if ! xlclang -qascii -I"${GETTEXT_HOME}/include" -L"${GETTEXT_HOME}/lib" -ohello hello.c -lintl ; then
  echo "Unable to compile hello program" >&2
  exit 16
fi

enout=$(./hello)
frout=$(LANG=fr_FR ./hello)

if [ "${enout}x" != "Hello Worldx" ]; then 
  echo "default hello program printed out the wrong message in English: ${enout}" >&2
  exit 4
fi

if [ "${frout}x" != "Bonjour le mondex" ]; then 
  echo "default hello program printed out the wrong message in French: ${frout}" >&2
  exit 4
fi

