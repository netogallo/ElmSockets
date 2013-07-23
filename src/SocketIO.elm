module SocketIO where

import Native.SocketIO(socketOnUntyped)

socketOnUntyped : String -> String -> String -> a -> Signal b
--socketOnUntyped = Native.SocketIO.socketOnUntyped