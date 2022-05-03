FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake
RUN git clone https://github.com/lieff/minimp3.git
WORKDIR /minimp3
RUN afl-clang minimp3_test.c -o /fuzz_minimp3 -lm
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/trailing-garbage.mp3
RUN mkdir /minimp3-corpus 
RUN mv trailing-garbage.mp3 /minimp3-corpus/

# Fuzz
ENTRYPOINT ["afl-fuzz", "-i", "/minimp3-corpus", "-o", "/out"]
CMD ["/fuzz_minimp3", "@@"]
