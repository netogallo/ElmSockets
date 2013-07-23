SRC=src/
OUT=out/
JS=Native/
SAMPLES=samples/
NODE_MOD=node_modules/
SOCKET_IO=$(SAMPLES)$(NODE_MOD)/socket.io-client/dist/socket.io.js


COMPILE=elm --only-js --no-prelude --output-directory=../$(OUT)
INC=--import-js=

COMPILE_SAMPLE=elm --runtime="/elm-runtime.js"

NATIVE=$(wildcard $(SRC)$(JS)*.js)
NATIVE_INC=$(patsubst $(SRC)%.js,$(INC)"%.js",$(NATIVE))

all: socket.js

$(OUT):
	mkdir $(OUT)

socket.js: $(OUT) $(SRC)/SocketIO.elm
	cd $(SRC); \
	$(COMPILE) $(NATIVE_INC) SocketIO.elm

clean:
	rm -rf $(OUT)
	rm -rf $(SAMPLES)Chat/*.html

server:
	cd $(SAMPLES); \
	npm install

chat.html: socket.js server $(SAMPLES)Chat/Chat.elm
	DEPS=$(wildcard $(OUT)*.js);\
	$(COMPILE_SAMPLE) $(INC)"$(OUT)SocketIO.js" $(INC)"$(SOCKET_IO)" $(SAMPLES)Chat/Chat.elm

samples: chat.html
