########################################################################################################################
# Find Us                                                                                                              #
# Author: Mehmet ÖĞMEN                                                                                                 #
# Web   : https://x-shell.codes/scripts/mongodb                                                                        #
# Email : mailto:mongodb.script@x-shell.codes                                                                          #
# GitHub: https://github.com/x-shell-codes/mongodb                                                                     #
# Web   : https://x-shell.codes/scripts/mongodb                                                                        #
# Email : mailto:mongodb.script@x-shell.codes                                                                          #
# GitHub: https://github.com/x-shell-codes/mongodb                                                                     #
########################################################################################################################
# Contact The Developer:                                                                                               #
# https://www.mehmetogmen.com.tr - mailto:www@mehmetogmen.com.tr                                                       #
########################################################################################################################

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################
NORMAL_LINE=$(tput sgr0)
BLACK_LINE=$(tput setaf 0)
WHITE_LINE=$(tput setaf 7)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "MongoDB install script version 1.0.0"
  echo
  echo "${BRIGHT_LINE}${UNDER_LINE}Find Us${NORMAL}"
  echo "${BRIGHT_LINE}Author${NORMAL}: Mehmet ÖĞMEN"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes/scripts/mongodb"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:mongodb.script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes/mongodb"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes/scripts/mongodb"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:mongodb.script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes/mongodb"
}

########################################################################################################################
# Help                                                                                                                 #
########################################################################################################################
function Help() {
  echo "MongoDB install & configuration script."
  echo
  echo "Options:"
  echo "-p | --password    MongoDB dba user password."
  echo "-r | --isRemote    Is remote access server? (true/false)."
  echo "-h | --help        Display this help."
  echo "-V | --version     Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/mongodb."
}

########################################################################################################################
# Line Helper Functions                                                                                                #
########################################################################################################################
function ErrorLine() {
  echo "${RED_LINE}$1${NORMAL_LINE}"
  echo "${RED_LINE}$1${NORMAL_LINE}"
}

function WarningLine() {
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
}

function SuccessLine() {
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
}

function InfoLine() {
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
password="secret"
isRemote="true"

for i in "$@"; do
  case $i in
  -p=* | --password=*)
    password="${i#*=}"

    if [ -z "$password" ]; then
      ErrorLine "Password cannot be empty."
      exit
    fi

    shift
    ;;
  -r=* | --isRemote=*)
    isRemote="${i#*=}"

    if [ "$isRemote" != "true" ] && [ "$isRemote" != "false" ]; then
      ErrorLine "Is remote value is invalid."
      Help
      exit
    fi

    shift
    ;;
  -h | --help)
    Help
    exit
    ;;
  -V | --version)
    Version
    exit
    ;;
  -* | --*)
    ErrorLine "Unexpected option: $1"
    echo
    echo "Help:"
    Help
    exit
    ;;
  esac
done

########################################################################################################################
# CheckRootUser Function                                                                                               #
########################################################################################################################
function CheckRootUser() {
  if [ "$(whoami)" != root ]; then
    ErrorLine "You need to run the script as user root or add sudo before command."
    exit 1
  fi
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}MONGODB INSTALLATION${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

sudo apt update
apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes dirmngr gnupg apt-transport-https ca-certificates software-properties-common

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update

apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes mongodb-org

if [ "$isRemote" == "true" ]; then
  sed -i '/^  bindIp/s/bindIp:.*/bindIp: 0.0.0.0/' /etc/mongod.conf
fi

sudo systemctl start mongod
sudo systemctl enable mongod

mongo "admin" --eval "db.createUser({'user':'admin','pwd':'secret','roles': ['userAdminAnyDatabase','readWriteAnyDatabase']})"
