set ns [new Simulator]

set tracefile [open out.tr w]
set namfile [open out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

$ns color 1 Blue    ;# TCP
$ns color 2 Red     ;# UDP

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n1 $n5 1Mb 10ms DropTail

#a tcp connection between node 1 and node 0

set tcp [new Agent/TCP]
$tcp set fid_ 1
$ns attach-agent $n1 $tcp 

set sink [new Agent/TCPSink]
$ns attach-agent $n0 $sink

# 8. Apply FTP traffic over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp 

$ns connect $tcp $sink

# now lets create udp conncetion between node 1 and 5 


set udp [new Agent/UDP]
$udp set fid 2
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n5 $null

$ns connect $udp $null


# 10. Apply CBR traffic over UDP
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.01
$cbr attach-agent $udp

# 11. Simulate CSMA/CD  using lan_cd 

set lan_cd [$ns newLan "$n0 $n1 $n2 $n3" 1Mb 20ms LL Queue/DropTail MAC/Csma/CdChannel]

# 11. Simulate CSMA/C  using lan_cd 

set lan_ca [$ns newLan "$n4 $n5 $n6" 1Mb 20ms LL Queue/DropTail MAC/Csma/CaChannel]


# 12. Schedule events
$ns at 1.0 "$ftp start"
$ns at 1.5 "$cbr start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"


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

# Run simulation
$ns run



