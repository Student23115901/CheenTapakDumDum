set ns [new Simulator]

#set up output files
set tracefile [open out.tr w]
set namfile [open out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

#create 2 nodes

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

set lan0 [$ns newLan "$n0 $n1 $n2" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/CdChannel]

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink

$ns connect $tcp $sink

#create a CBR (const bit rate) Application and attach to tcp agent 

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500 
$cbr0 set interval_ 0.01 
$cbr0 attach-agent $tcp 

$ns at 1.0 "$cbr0 start"
$ns at 4.0 "$cbr0 stop" 


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