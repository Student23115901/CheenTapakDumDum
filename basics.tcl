set ns [new Simulator]

#set up output files
set tracefile [open out.tr w]
set namfile [open out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

#create 2 nodes

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink


set ftp [new Application/FTP]
$ftp attach-agent $tcp 

#start and stop ftp traffic 
$ns at 1.0 "$ftp start" 
$ns at 4.0 "$ftp stop" 

#finish procedure
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