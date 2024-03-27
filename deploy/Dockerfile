FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai LANG=C.UTF-8 LC_ALL=C.UTF-8 PIP_NO_CACHE_DIR=1 PIP_CACHE_DIR=/tmp/

# Installing some essential system packages
RUN sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list &&\
    sed -i "s/security.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list &&\
    apt-get update && apt-get upgrade -y &&\
    apt-get install -y --no-install-recommends \
      # Common
      autoconf automake autotools-dev build-essential ca-certificates \
      make cmake ninja-build pkg-config g++ ccache cppcheck yasm \
      ccache doxygen graphviz plantuml \
      daemontools krb5-user ibverbs-providers libibverbs1 \
      libkrb5-dev librdmacm1 libssl-dev libtool \
      libnuma1 libnuma-dev libpmi2-0-dev \
      openssh-server openssh-client nfs-common \
      ## Tools
      git curl wget unzip nano vim-tiny net-tools sudo htop iotop iputils-ping \
      cloc rsync screen tmux xz-utils software-properties-common &&\
    wget "https://raw.githubusercontent.com/ros/rosdistro/master/ros.key" -O - | apt-key add - &&\
    # echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ bionic main /" > \
    #     /etc/apt/sources.list.d/ros1-snapshots.list &&\
    apt-get install -y --no-install-recommends \
        ## Deps
        cimg-dev \
        clang-format-6.0 \
        dh-autoreconf \
        libatlas3-base \
        libboost-all-dev \
        libblas-dev liblapack-dev libnlopt-dev \ 
        libfftw3-dev libfftw3-doc \
        liblog4cplus-dev \
        libglew-dev \
        libgtest-dev \
        libssh2-1-dev \
        libopencv-dev \
        libpcl-dev \
        libreadline-dev \
        libv4l-dev \
        libyaml-cpp-dev \
        pylint \
        python3-autopep8 \
        python3-catkin-tools \
        python3-pip python3-git python3-setuptools \
        python3-rosdep \
        python3-termcolor \
        python3-vcstool \
        ros-noetic-camera-info-manager* \
        ros-noetic-eigen-conversions \
        ros-noetic-image-view \
        ros-noetic-image-geometry \
        ros-noetic-pcl-conversions \
        ros-noetic-pcl-ros \
        ros-noetic-sophus \
        ros-noetic-tf2-* \
    && rm /etc/ssh/ssh_host_ecdsa_key \
    && rm /etc/ssh/ssh_host_ed25519_key \
    && rm /etc/ssh/ssh_host_rsa_key \
    && cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure the catkin workspace.
WORKDIR /usr/home
COPY ./ws ./ws
WORKDIR /usr/home/ws
RUN catkin init --workspace .
RUN catkin config --merge-devel
RUN catkin config -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-fdiagnostics-color=always

# Install the custom packages.
WORKDIR /usr/home/ws/src
RUN pip install -U pip -i https://pypi.tuna.tsinghua.edu.cn/simple &&\
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple &&\
    pip install requests

# Build the project.
WORKDIR /usr/home/ws
SHELL ["/bin/bash", "-c"]
COPY compile.sh ../
RUN ../compile.sh
COPY set_env.sh ../
ENTRYPOINT ["../set_env.sh"]
