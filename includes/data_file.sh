function createDataFile(){
	mktemp
}

function writeDataValue(){
	echo "${2}=${3}" >> ${1}
}

function readDataValue(){
	cat ${1} | sed -n -e "s/${2}=\(.*\)/\1/p"
}