FROM pi-gen-base

COPY . /pi-gen/

VOLUME [ "/pi-gen/work", "/pi-gen/deploy"]
