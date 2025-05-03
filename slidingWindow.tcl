set ns [new Simulator]

set tracefile [open out.tr w]
set namfile [open out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

set n0 [$ns node]
$n0 label "sender"

set n1 [$ns node]
$n1 label "receiver"

$ns color 1 Blue

$ns node-config -label "on"

$n0 color Red

$ns duplex-link $n0 $n1 1Mb 10ms DropTail




set tcp [new Agent/TCP]

$tcp set window_ 10    ;# Sliding window_
$tcp set packetSize_ 500

$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.5 "$ftp start"
$ns at 4.0 "$ftp stop"

proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

$ns at 5.0 "finish"
$ns run
