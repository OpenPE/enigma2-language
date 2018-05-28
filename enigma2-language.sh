#!/bin/bash
echo ""
echo "enigma2 automatic language update script by Persian Prince"
echo ""
echo "https://github.com/PLi-metas"
echo ""
if [ -d enigma2 ] ; then
	cd enigma2
	echo "Updating PLi's enigma2 for latest changes ..."
	echo ""
	git pull
	echo "Updated successfully!"
	echo ""
else
	echo "You don't have the enigma2 directory yet!"
	echo "It means we have to clone it from PLi's git first, Please wait ..."
	echo ""
	git clone -b develop https://github.com/OpenPLi/enigma2.git
	echo "Cloned successfully!"
	echo ""
	cd enigma2
	echo "Create a backup of configure.ac"
	cat configure.ac > configure.ac.backup
	echo "Done!"
	echo ""
	echo "Make configure.ac ready for pot creating"
	sed -e '/TUXTXT/ s/^#*/#/' -i configure.ac
	sed -e '/PKG_CHECK_MODULES(GSTREAMER/ s/^#*/#/' -i configure.ac
	sed -e '/freetype2/ s/^#*/#/' -i configure.ac
	sed -e '/libdreamdvd/ s/^#*/#/' -i configure.ac
	sed -e '/AVAHI/ s/^#*/#/' -i configure.ac
	sed -e '/udfread/ s/^#*/#/' -i configure.ac
	sed -e '/dlopen/ s/^#*/#/' -i configure.ac
	sed -e '/jpeg_set_defaults/ s/^#*/#/' -i configure.ac
	sed -e '/DGifOpen/ s/^#*/#/' -i configure.ac
	echo "Done!"
	echo ""
fi
echo "autogen.sh execution"
./autogen.sh
echo "Done!"
echo ""
echo "Now configure with po and generate new pot files"
./configure --with-po
echo "Done!"
echo ""
echo "Updating all po files using new pot files"
cd po
make *.po
echo "Done!"
echo ""
git add *.po
git commit -S -m "Update all language po files with latest strings using Persian Prince's enigma2-language.sh"
git push
