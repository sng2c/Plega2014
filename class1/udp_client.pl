#!/usr/bin/env perl
use v5.10;
use Socket ;


my $text = join ' ', @ARGV;

my $port = 9999;

socket( SOCKET, PF_INET, SOCK_DGRAM, getprotobyname("udp") );
# PF_INET
# SOCK_DGRAM
# udp

setsockopt( SOCKET, SOL_SOCKET, SO_BROADCAST, 1 );
# SOL_SOCKET
# SO_BROADCAST

my $dest = sockaddr_in( $port, INADDR_BROADCAST );
# INADDR_BROADCAST

send( SOCKET, $text, 0,  $dest );
close SOCKET;

