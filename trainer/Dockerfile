FROM nvcr.io/nvidia/tensorflow:23.03-tf1-py3

ARG USER=ajmalrasi
ARG UID=1000
ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
useradd -m -U -u $UID $USER && \
apt-get install -y gcc python3-setuptools git protobuf-compiler wget && \
rm -rf /var/lib/apt/lists/*

WORKDIR /home/$USER

RUN python3 -m pip install --upgrade pip

# Edge TPU Compiler
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list

RUN apt-get update && \
apt-get install -y edgetpu-compiler && \
rm -rf /var/lib/apt/lists/*

USER $UID:$UID
COPY --chown=$UID requirements.txt ./

RUN pip3 install --upgrade setuptools Cython numpy

# Dependencies
RUN pip3 install --no-cache-dir --user -r requirements.txt

# Tensorflow Models
RUN git clone https://github.com/ajmalrasi/models.git
COPY --chown=$UID models models
COPY --chown=$UID notebooks notebooks

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
COPY --chown=$UID tensorboard.sh jupyter.sh ./

CMD ["/bin/bash"]
