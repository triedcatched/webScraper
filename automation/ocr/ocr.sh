if (( $# != 4 ))
then
	echo "Usage: ./ocr.sh <Image Name> <State Name> [Starting String] <IsTranslationRequired>"
	exit
fi

stateCode=""
case $2 in
	"Bihar")
		stateCode="br"
		;;
	"Uttar Pradesh")
		stateCode="up"
		;;
	"Madhya Pradesh")
		stateCode="mp"
		;;
	"Jharkhand")
		stateCode="jh"
		;;
	"Rajasthan")
		stateCode="rj"
		;;
	"Punjab")
		stateCode="pb"
		;;
	"Jammu")
		stateCode="jk"
		;;
	*)
		stateCode="invalid"
esac

echo -e "\n********************* If you want to see the ocr data, cat output.txt *********************\n"
echo -e "\n******** Calling google vision api *******"

python3 ocr_vision.py $1 > bounds.txt
sed "s/@@statename@@/$stateCode/g; s/@@startingtext@@/$3/g; s/@@translationvalue@@/$4/g" ocrconfig.meta.orig > ocrconfig.meta

echo -e "\n******** Using ocrconfig.meta, change ocrconfig.meta.orig for x and y intervals ******* "
cat ocrconfig.meta
echo -e "******** ++++++++ *******"

python3 googlevision.py ocrconfig.meta $1
cp output.txt ../.tmp/$stateCode.txt

cd ..
echo -e "\n******** Calling automation.py for $2  ******* "
./automation.py "$2" "detailed" "ocr"
