# Define custom function directory
ARG FUNCTION_DIR="/usr/local/bin"

FROM python:buster as build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev

# Copy function aws-lambda-rie for local lambda function run
COPY aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Directly download the file aws-lambda-rie from the github
# ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Change file mode
RUN chmod 755 /usr/local/bin/aws-lambda-rie

# Copy function code
RUN mkdir -p ${FUNCTION_DIR}
COPY app.py ${FUNCTION_DIR}

# Install the function's dependencies
RUN pip install \
    --target ${FUNCTION_DIR} \
        awslambdaric

# Copy requiremnts.txt
COPY requirements.txt .
# Install dependencies from requirement.txt
RUN pip install --target ${FUNCTION_DIR} -r requirements.txt

FROM python:buster

# Include global arg in this stage of the build
ARG FUNCTION_DIR
# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the built dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

# Copy scriptfile and change its mode
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod 755 /usr/local/bin/entry.sh

ENTRYPOINT [ "/usr/local/bin/entry.sh" ]

# To run the function. Should be in format fileDestination.functionName
CMD [ "app.handler" ]
