FROM debian:stretch-slim

WORKDIR /root

RUN apt-get update -qq && apt-get install -y autoconf bison build-essential cmake coreutils curl libbz2-dev libboost-all-dev liblua5.2-dev libsqlite3-dev libtbb-dev libxml2-dev libzip-dev lua5.2 pkg-config python-pip wget zlib1g-dev libexpat1-dev

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && apt-get install -y nodejs

RUN curl -L https://npmjs.org/install.sh | sh

RUN npm install -g osmtogeojson

RUN wget https://github.com/Project-OSRM/osrm-backend/archive/v5.22.0.tar.gz -O osrm-backend.tar.gz && \
  tar -xzvf osrm-backend.tar.gz && \
  cd osrm-backend-5.22.0 && \
  mkdir -p build && \
  cd build && \
  cmake .. && \
  cmake --build . && \
  cmake --build . --target install

RUN wget http://dev.overpass-api.de/releases/osm-3s_v0.7.56.2.tar.gz && \
  tar -xzvf osm-3s_v0.7.56.2.tar.gz && \
  cd osm-3s_v0.7.56.2 && \
  cp -r rules /opt && \
  ./configure CXXFLAGS="-O2" --prefix=/opt/overpass && \
  make && \
  make install

RUN wget https://github.com/mapbox/tippecanoe/archive/1.35.0.tar.gz -O tippecanoe.tar.gz && \
  tar -xzvf tippecanoe.tar.gz && \
  cd tippecanoe-1.35.0 && \
  make -j && \
  make install

RUN pip install mbutil

COPY *.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

COPY *.query /opt/
