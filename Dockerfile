FROM python:3.6

RUN apt-get -yqq update && apt-get -y clean

# Jumanppの依存性
# Boostを`apt-get install libboost-dev`で入れると1.55がインストールされてJumanppに必要な1.57が満たされないので自分でビルドする
# Boostの依存性
RUN apt-get install --no-install-recommends -yqq  -o "Dpkg::Options::=--force-confdef" \
    build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev && apt-get clean
# Boostのインストール
ENV BOOST_VER 1.62.0
ENV BOOST_DIR boost_1_62_0
ENV BOOST_TARBALL ${BOOST_DIR}.tar.gz
# うるさいので-qフラグをつける
# キャッシュは活用出来なくなるが、コマンドを結合して一行で実行してイメージのサイズを最小限にする
# `./b2`で失敗したコンポーネントは無視したいので失敗した場合`true`を実行して終了コードを無理やり0にセットする
RUN wget -qO "${BOOST_TARBALL}" "http://sourceforge.net/projects/boost/files/boost/${BOOST_VER}/${BOOST_TARBALL}/download" && \
    tar xzf "${BOOST_TARBALL}" && \
    rm -rf "${BOOST_TARBALL}" && \
    cd ${BOOST_DIR} && \
    ./bootstrap.sh > /dev/null && \
    (./b2 > /dev/null || true) && \
    (./b2 install > /dev/null || true) && \
    rm -rf "${BOOST_DIR}"
# Jumanppのインストール
ENV JUMANPP_DIR jumanpp-1.01
ENV JUMANPP_TARBALL "${JUMANPP_DIR}.tar.xz"
RUN wget -q "http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/${JUMANPP_TARBALL}" && \
    tar xJf "${JUMANPP_TARBALL}" && \
    rm -rf "${JUMANPP_TARBALL}" && \
    cd ${JUMANPP_DIR} && \
    ./configure > /dev/null && \
    make > /dev/null && \
    make install > /dev/null && \
    rm -rf "${JUMANPP_DIR}"

# python-onbuild系のイメージを使うとプロジェクトのファイルが一つでも変わる度に
# ビルドのキャッシュが無効化されるので自分で依存性をインストールして
# プロジェクトのファイルをコピーする
ENV WORK_DIR /usr/src/app
RUN mkdir -p "${WORK_DIR}"
WORKDIR ${WORK_DIR}
# requirements.txtを`COPY . ${WORK_DIR}`と一緒にコピーしてしまうとプロジェクトのファイルが一つでも変わる度に
# 依存性を全てインストールし直す必要が出てくるので先にコピーしておく
COPY requirements.txt ${WORK_DIR}
RUN pip install --no-cache-dir -r requirements.txt
COPY . ${WORK_DIR}

ENTRYPOINT python -m jumanpp
