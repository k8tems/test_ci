FROM python:3.6

RUN apt-get -yqq update && apt-get -y clean

# Jumanppの依存性
# Boostを`apt-get install libboost-dev`で入れると1.55がインストールされてJumanppに必要な1.57が満たされないので自分でビルドする
# Boostの依存性
RUN apt-get install --no-install-recommends -yqq  -o "Dpkg::Options::=--force-confdef" \
    build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev && apt-get clean
