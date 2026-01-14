sudo apt-get install -y git make g++ cmake libssl-dev libunbound-dev libboost-dev libboost-system-dev libboost-date-time-dev libboost-dev libboost-system-dev libboost-date-time-dev libboost-filesystem-dev libboost-thread-dev libboost-chrono-dev libboost-locale-dev libboost-regex-dev libboost-regex-dev libboost-program-options-dev libzmq3-dev
cd /usr/local/src
git clone https://github.com/monero-project/monero.git
cd monero
git checkout v0.18.4.5
git submodule update --init
USE_SINGLE_BUILDDIR=1 make -j$(nproc) release || USE_SINGLE_BUILDDIR=1 make -j1 release

