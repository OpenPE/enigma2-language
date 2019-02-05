#!/bin/bash
echo ""
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
echo "enigma2 automatic language update script by Persian Prince"
echo ""
echo "https://github.com/OpenVisionE2"
echo ""
echo -e "First tell us what kind of enigma2 do you want?"
echo -e "Answers are in ${GREEN}green:${NC}"
echo -e "${GREEN}PLi ${NC}- ${GREEN}SH4 ${NC}- ${GREEN}Vision"
echo -e ""
read ENIGMA2TYPE
echo -e "${NC}"
if [ $ENIGMA2TYPE != "PLi" -a $ENIGMA2TYPE != "SH4" -a $ENIGMA2TYPE != "Vision" ]
then
	echo -e "${RED}Not a valid answer!${NC}"
	echo -e ""
	exit 0
fi
if [ $ENIGMA2TYPE = "PLi" ]
then
	echo "Enter your github username (Your fork is needed):"
	echo -e "${GREEN}"
	read GITHUBFORK
	echo -e "${NC}"
	if [ -d enigma2 ] ; then
		cd enigma2
		echo "Updating PLi's enigma2 for latest changes ..."
		echo ""
		git pull
		echo "Updated successfully!"
		echo ""
	else
		echo "You don't have the enigma2 directory yet!"
		echo "It means we have to clone it from git first, Please wait ..."
		echo ""
		git clone -b develop --depth 1 https://github.com/$GITHUBFORK/enigma2.git
		echo "Cloned successfully!"
		echo ""
		cd enigma2
	fi
fi
if [ $ENIGMA2TYPE = "SH4" ]
then
	if [ -d enigma2-openvision-sh4  ] ; then
		cd enigma2-openvision-sh4 
		echo "Updating Open Vision SH4 enigma2 for latest changes ..."
		echo ""
		git pull
		echo "Updated successfully!"
		echo ""
	else
		echo "You don't have the enigma2-openvision-sh4 directory yet!"
		echo "It means we have to clone it from git first, Please wait ..."
		echo ""
		git clone -b develop --depth 1 https://github.com/OpenVisionE2/enigma2-openvision-sh4.git
		echo "Cloned successfully!"
		echo ""
		cd enigma2-openvision-sh4 
	fi
fi
if [ $ENIGMA2TYPE = "Vision" ]
then
	if [ -d enigma2-openvision  ] ; then
		cd enigma2-openvision 
		echo "Updating Open Vision enigma2 for latest changes ..."
		echo ""
		git pull
		echo "Updated successfully!"
		echo ""
	else
		echo "You don't have the enigma2-openvision directory yet!"
		echo "It means we have to clone it from git first, Please wait ..."
		echo ""
		git clone -b develop --depth 1 https://github.com/OpenVisionE2/enigma2-openvision.git
		echo "Cloned successfully!"
		echo ""
		cd enigma2-openvision 
	fi
fi
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
git commit -S -m "Update all language po files with latest strings using https://github.com/OpenVisionE2/enigma2-language/blob/master/enigma2-language.sh"
git push
