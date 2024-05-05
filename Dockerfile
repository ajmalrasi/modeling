FROM tensorflow/tensorflow:1.15.5-gpu-py3-jupyter

ARG USER=ajmalrasi
ARG UID=1000
ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

RUN apt-get update && \
useradd -m -U -u $UID $USER && \
apt-get install -y gcc python3-setuptools git-all protobuf-compiler wget && \
rm -rf /var/lib/apt/lists/*

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list

RUN apt-get update && \
apt-get install -y edgetpu-compiler && \
rm -rf /var/lib/apt/lists/*

USER $UID:$UID
WORKDIR /home/$USER
COPY --chown=$UID requirements.txt ./

RUN pip3 install --upgrade setuptools Cython numpy

RUN pip3 install --no-cache-dir --user -r requirements.txt

RUN git clone https://github.com/tensorflow/models.git

ENV PYTHONPATH="${PYTHONPATH}:/home/$USER/models/research/"
ENV PYTHONPATH="${PYTHONPATH}:/home/$USER/models/research/slim/"
ENV PYTHONPATH="${PYTHONPATH}:/home/$USER/models/research/object_detection/utils/"
ENV PYTHONPATH="${PYTHONPATH}:/home/$USER/models/research/object_detection"

WORKDIR /home/$USER/models/research/
RUN protoc object_detection/protos/*.proto --python_out=.
RUN cp object_detection/packages/tf1/setup.py .
RUN python -m pip install .

WORKDIR /home/$USER
RUN rm requirements.txt
COPY --chown=$UID jupyter.sh ./

CMD ["/bin/bash"]
