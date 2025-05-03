# Send packets one by one
set ns [new Simulator]

set tracefile [open out.tr w]
set namfile [open out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile


# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Set colors
$n0 color "purple"
$n1 color "purple"
$n2 color "violet"
$n3 color "violet"
$n4 color "chocolate"
$n5 color "chocolate"

# Set shapes
$n0 shape box
$n1 shape box
$n2 shape box
$n3 shape box
$n4 shape box
$n5 shape box

# Set labels
$ns at 0.0 "$n0 label SYS0"
$ns at 0.0 "$n1 label SYS1"
$ns at 0.0 "$n2 label SYS2"
$ns at 0.0 "$n3 label SYS3"
$ns at 0.0 "$n4 label SYS4"
$ns at 0.0 "$n5 label SYS5"

# Link setup
$ns duplex-link $n0 $n2 1Mb 20ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down
$ns queue-limit $n0 $n2 5
$ns duplex-link $n1 $n2 1Mb 20ms DropTail
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link $n2 $n3 1Mb 20ms DropTail
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link $n3 $n4 1Mb 20ms DropTail
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link $n3 $n5 1Mb 20ms DropTail
$ns duplex-link-op $n3 $n5 orient right-down

# TCP setup

set tcp [new Agent/TCP]
$tcp set fid 1
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink

# FTP Application
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Events
$ns at 0.05 "$ftp start"
$tcp set windowInit_ 6 #initialising window size
$tcp set maxcwnd_ 6 #setting command window size


$ns at 0.26 "$ns queue-limit $n3 $n4 10"
$ns at 0.30 "$ns queue-limit $n3 $n4 1"
$ns at 0.305 "$tcp set windowInit_ 4"
$ns at 0.305 "$tcp set maxcwnd 4"
$ns at 0.368 "$ns detach-agent $n1 $tcp ; $ns detach-agent $n4 $sink"


# Finish procedure
proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile

exec nam out.nam &
exit 0
}

$ns at 1.5 "finish"

$ns run