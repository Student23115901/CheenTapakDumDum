# Create a simulator object
set ns [new Simulator]

# Open the output trace file
set f0 [open out0.tr w]

# Create 2 nodes
set n0 [$ns node]
set n1 [$ns node]

# Connect the nodes using duplex link
$ns duplex-link $n0 $n1 1Mb 100ms DropTail

# Create a TCP connection from n0 to n1
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/LossMonitor]
$ns attach-agent $n1 $sink0

$ns connect $tcp0 $sink0

# Attach an FTP application over TCP
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.0 "$ftp0 start"

# Define a 'finish' procedure
proc finish {} {
    global f0
    # Close the output files
    close $f0
    # Call xgraph to display the results
    exec xgraph out0.tr -geometry 800x400 &
    exit 0
}

# Define a procedure to record bandwidth periodically
proc record {} {
    global sink0 f0
    set ns [Simulator instance]
    set time 0.5
    set bw0 [$sink0 set bytes_]
    set now [$ns now]
    puts $f0 "$now [expr $bw0/$time*8/1000000]"
    $sink0 set bytes_ 0
    $ns at [expr $now + $time] "record"
}

# Start bandwidth logging and schedule finish
$ns at 0.0 "record"
$ns at 60.0 "finish"

# Run the simulation
$ns run
