FROM python:3.6

RUN apt-get update

RUN apt-get install -y build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev
RUN apt-get clean
# Boostのインストール
ENV BOOST_VER 1.62.0
ENV BOOST_DIR boost_1_62_0
ENV BOOST_TARBALL ${BOOST_DIR}.tar.gz
# うるさいので-qフラグをつける
RUN wget -qO ${BOOST_TARBALL} http://sourceforge.net/projects/boost/files/boost/${BOOST_VER}/${BOOST_TARBALL}/download
RUN tar xzvf ${BOOST_TARBALL}
RUN rm -rf ${BOOST_TARBALL}

RUN echo 1

ENTRYPOINT python -m main