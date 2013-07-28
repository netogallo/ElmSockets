import SocketIO(socketOnUntyped,log)
import Graphics.Input as Input
import Keyboard(enter)
import JavaScript (fromElement)
import Native.Chat (applyStyle)

applyStyle : String -> Element -> Element

-- Host where the Chat server is running
--host = "127.0.0.1:8888"
host = "netowork.me:8888"

-- Tags for identifying each message
chatInTxt = "chatIn"
chatOutTxt = "chatOut"

netoworkHead w =
  let
    img = fittedImage 50 50 "http://netowork.me/resources/lambda.png"
    t = text $ Text.height 2 $ bold $ toText "Netowork Chat"
    bg = rgb 231 231 231
    banner = width w $ color bg $ flow left [t,img]
    und = color (rgb 64 167 219) $ spacer w 5
  in
   flow down [banner,und]
   

-- Split a paragraph every i letters, useful to
-- display multi-line text on fixed line boxes
every i list =
  case list of
    [] -> []
    _ -> let
           h = take i list
         in
           h :: (every i  $ drop i list)

-- Define how each message is displayed in the chat box
message w x =
  let
    textContainer = container w 20 midLeft
    chatName = textContainer $ text $ Text.color blue $ bold $ toText $ x.name ++ ":"
    chatMessage = map (\t -> textContainer $ text $ toText t ) $ every 50 x.msg
  in
   flow down $ chatName :: chatMessage

-- Define how a list of messages is displayed, plug in the
-- signals for incoming and outoing messages to allow the
-- messages to be read
display f n chatIn chatOut = 
  let inputs = flow left [f,n]
      chatWidth = 400
      mkBox x (c,acc) =
        let
          col = if c
                then rgb 255 255 255
                else rgb 150 209 238
        in
         (not c,(color col $ message chatWidth x) :: acc)
      chatBox = flow down $ snd $ foldr mkBox (True,[]) $ filter (\x -> x.deliver) chatIn
      e = asText $ log $ fromElement chatBox
  in
  flow down [netoworkHead chatWidth,applyStyle "overflow-y:scroll" $ (container chatWidth 150 topLeft chatBox),inputs,text $ toText "Press enter to send a message."]

-- Signal for the outgoing messages
chatOut o = socketOnUntyped host chatOutTxt "NONE" o

main =
  let
    -- Signal for incoming messages
    chatIn' = socketOnUntyped host "NONE" chatInTxt ""
    -- Accumulator for the incoming signal
    chatIn = foldp (\v vals -> vals ++ [v]) [] chatIn'
    -- Fields to enter the messages
    (f, msg') = Input.field "Chat here!"
    (n, name') = Input.field "Your Name:"
    msg' = lift3 (\x y d -> {name=y,msg=x,deliver=d}) msg' name' enter
    msg = keepIf (\x -> x.deliver) {name="",msg="",deliver=False} msg'
    chatSig = lift chatOut msg
  in
   -- Connect singals to main display, send the chat signal to
   -- also process message delivery
   lift4 display f n chatIn chatSig
