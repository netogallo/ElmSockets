import SocketIO(socketOnUntyped)
import Graphics.Input as Input
import Keyboard(enter)

host = "127.0.0.1:8888"
chatInTxt = "chatIn"
chatOutTxt = "chatOut"

display f n chatIn chatOut = 
  let inputs = flow left [f,n]
      chatBox = flow down $ map (\x-> asText $ x.name ++ ": " ++ x.msg) $ chatIn
  in
  flow down [(container 700 150 topLeft chatBox),inputs,asText "Pres enter to send a chat."]

chatOut o = socketOnUntyped host chatOutTxt "NONE" o

accm num v vals = 
  let vals' = reverse $ take num $ reverse vals
  in
   vals' ++ [v]

main = 
  let chatIn' = socketOnUntyped host "NONE" chatInTxt ""
      chatIn = foldp (accm 5) [] chatIn'
      (f, msg') = Input.field "Chat here!"
      (n, name') = Input.field "Your Name:"
      msg' = lift3 (\x y d -> {name=y,msg=x,deliver=d}) msg' name' enter
      msg = keepIf (\x -> x.deliver) {name="",msg="",deliver=True} msg'
      chatSig = lift chatOut msg
  in
   lift4 display f n chatIn chatSig
