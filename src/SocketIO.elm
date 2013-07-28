module SocketIO where

import Native.SocketIO(socketOnUntyped,log)

log : a -> a

socketOnUntyped : String -> String -> String -> a -> Signal b
--socketOnUntyped = Native.SocketIO.socketOnUntyped