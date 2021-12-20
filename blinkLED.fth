( *************************************************************************** )
( Blink an LED attached to an ESP32 microcontroller                           )
( Version 0.1, Tammy Cravit <tammymakesthings@gmail.com>                      )
(                                                                             )
( Source: <https://github.com/tammymakesthings/esp32projects>                 )
( For ESP32Forth - <https://esp32forth.appspot.com>                           )
( *************************************************************************** )

( ============================================================ )
( Program Variables.                                           )
( ============================================================ )

variable led-pin                            ( Holds the LED PIN number     )
variable blink-delay                        ( Holds the blink delay in ms  )

( ============================================================ )
( Some helper accessor words for the variables                 )
( ============================================================ )

: led-pin@          ( -- led-pin ) 
    led-pin @ 
    ;
: led-pin!          ( led-pin -- )
    led-pin ! 
    ;
: blink-delay@      ( -- blink-delay )
    blink-delay @ 
    ;
: blink-delay!      ( blink-delay -- ) 
    blink-delay ! 
    ;

( ============================================================ )
( Set up the board )
( ============================================================ )
: blink-setup       ( led-pin delay -- ) 
    swap led-pin! blink-delay!              ( Save our parameters  )
    led-pin@ OUTPUT pinMode                 ( Set the LED pin mode )
    ;

( ============================================================ )
( Set the state of the defined LED pin )
( ============================================================ )

: blink-set-led     ( state -- )
    led-pin@ digitalWrite 
    ;

( ============================================================ )
( Delay for the previously specified number of ms )
( ============================================================ )

: blink-led-delay   ( -- )
    blink-delay@ ms 
    ;

( ============================================================ )
( The Blink event loop )
( ============================================================ )

: blink-loop        ( -- ) 
    begin
        HIGH blink-set-led                ( Turn on the LED               )
        blink-led-delay                   ( And wait a bit                )
        LOW blink-set-led                 ( Turn off the LED              )
        blink-led-delay                   ( And wait a bit                )
    key? until                            ( Repeat until a key is pressed )
    ;
    
( ============================================================ )
( The main Blink program                                       )
( Does the initial setup and calls our event loop              )
( ============================================================ )

: blink ( led-pin delay -- )
    blink-setup blink-loop
    ;

( ************************************************************ )
( Blink the LED on pin 13 every 400 ms                         )
( ************************************************************ )

13 400 blink
