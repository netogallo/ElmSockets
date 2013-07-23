
import SocketIO(socketOnUntyped)

main = lift asText (socketOnUntyped "127.0.0.1:8888" "x" "myDate" "")