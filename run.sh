read -N 999999 -t 0.001

if [[ $EUID -ne 0 ]]; then
  if [[ ! -z "$1" ]]; then
    SUDO='sudo -E -H'
  else
    SUDO='sudo -E'
  fi
else
  SUDO=''
fi

REQUIRED_PACKAGES=(
  git
  curl
  python3
  python3-setuptools
  python3-apt
  python3-venv
  python3-pip
)

$SUDO apt update -y;
$SUDO apt -fuy install "${REQUIRED_PACKAGES[@]}";

if [ -d "$HOME/lo2bootstrap" ]; then
  pushd $HOME/lo2bootstrap
  git pull
  popd
else
  git clone https://github.com/update450/lo2bootstrap $HOME/lo2bootstrap
fi

export VIRTUAL_ENV="$HOME/lo2bootstrap/.venv"
export PATH="$HOME/lo2bootstrap/.venv/bin:$PATH"
.venv/bin/python3 -m pip install --upgrade pip
.venv/bin/python3 -m pip install -r requirements.txt

cd $HOME/lo2bootstrap && ansible-playbook run.yml
