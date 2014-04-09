# Class2. UDP 채팅방

## Class1 에서의 구현내용

### BROADCAST

                                 |----> [SERVER1] IPADDR, PORT, "HELLO"
    [CLIENT] ----> "HELLO" ----> |----> [SERVER2] IPADDR, PORT, "HELLO"
                                 |----> [SERVER3] IPADDR, PORT, "HELLO"

* CLIENT 가 "HELLO"를 브로드캐스트하면 각 서버들은 이를 받아서 IPADDR, PORT, "HELLO" 를 얻을 수 있었습니다.

## UDP 채팅방의 요구사항

* 채팅방에 누가 있는지 보여준다.
* 채팅방에 누가 입장하는지 보여준다.
* 닉네임을 설정할 수 있다.
* 닉네임으로 귓말을 보낼 수 있다.
* 전송할 내용의 입력을 채팅내용이 출력되는 곳에서 바로 한다.


## UDP 클라이언트 udp_client.pl

Class1 과 동일합니다.

## Protocol 의 설계

### 채팅 전송

* 제가 정한 요구사항에서는 닉네임을 지정할 수 있어야 합니다.
* 그리고 그 닉네임으로 귓말도 보낼 수 있어야 합니다.
* 즉, "HELLO" 를 서버들에게 보낼 때, 닉네임이 함께 가야한다는 것을 의미합니다.


    [김현승] ----> "김현승 HELLO" ----> [변상필] IPADDR, PORT, "김현승", "HELLO"


* 위와 같이 모든 메세지의 앞에 자신의 닉네임을 붙여서 보내게 하고,
* 모든 서버들은 첫번째 공백 앞은 닉네임, 뒤는 채팅내용으로 사용하게끔 합시다.


    "FROM_NICKNAME DATA"


* 받은 쪽에서는 FROM_NICKNAME과 DATA 를 보여주면 됩니다.

### 귓말 전송

* 보내는 쪽에서는 DATA 부분에 특별한 표시를 더해서 보내도록 합시다. "/p 받을닉네임 귓말내용"


    [김현승] ----> "김현승 /p 변상필 HELLO" ----> [변상필] IPADDR, PORT, "김현승", "/p 변상필 HELLO"


* 기능이 더 추가 되었지만, 채팅 전송의 기본 단위는 변하지 않았습니다.


    "FROM_NICKNAME [DATA]"

    는 아래와 같이 한번더 해석합니다.    

    "FROM_NICKNAME [/p TO_NICKNAME SUBDATA]"


* 받은 쪽에서는
 * DATA 영역이 /p 로 시작하는 경우에만 귓말 데이터로 한번 더 해석하면 됩니다.
 * TO_NICKNAME을 "자신의 NICKNAME과 같을 경우"에만 SUBDATA를 보여주면 됩니다.

### 방인원의 확인

* 귓말을 활용하여 이방의 인원을 확인해 보겠습니다.
* 서버가 자동으로 응답할 ping 명령이 필요합니다.
* 내가 ping을 보내면 받은 서버들이 자동으로 나에게 "있다"라고 귓말을 보내면 되겠죠? 


    [김현승] ----> "김현승 /ping"              ---->   [변상필] IPADDR, PORT, "김현승", "/ping"
                                                       |
                                                    (자동응답)
                                                       |
    [김현승] <---- "변상필 /p 김현승 변상필 있음"   <----   [변상필]


* 되돌아온 귓말의 형식을 잘 보세요. 
* '변상필'이 나에게 자동으로 보낸 귓말 내용은 "변상필 있음" 입니다.

## UDP 서버 udp_server.pl

    #!/usr/bin/env perl

    use v5.10;
    use strict;
    use Socket;

    my $port = 9999;
    my $nickname = $ARGV[0];
    if( !$nickname ){
        say "usage: perl udp_server.pl NICKNAME";
        exit;
    }

    socket( SOCK, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
    setsockopt( SOCK, SOL_SOCKET, SO_BROADCAST, 1 );
    my $dest = sockaddr_in( $port, INADDR_ANY);
    bind( SOCK, $dest );
    say "UDP $port Broadcast Receiver Started";

    use IO::Select;
    my $sel = IO::Select->new();
    $sel->add(\*STDIN);
    $sel->add(\*SOCK);

    system('perl','udp_client.pl',$nickname,"--> $nickname 입장 <--");

    while( 1 ){

        my @ready = $sel->can_read();

        foreach my $r (@ready){
            my $in;

            if( $r eq \*SOCK ){
                my $from = recv( SOCK, $in, 4096, 0 );
                chomp($in);

                my ($fport,$faddr) = unpack_sockaddr_in($from);
                my $ipaddr = inet_ntoa($faddr);

                my ($from_nick,$msg) = split(/\s+/, $in, 2);

                if( $msg =~ /^\/ping/ ){
                    system('perl','udp_client.pl',$nickname,"/p $from_nick --> $nickname 있음 <--");
                }
                elsif( $msg =~ /^\/p / ){
                    my ($to_nick, $submsg) = split(/\s+/, $', 2);
                    if( $to_nick eq $nickname ){ # 내꺼일때만 보여준다.
                        say "\t[귓말] $from_nick : $submsg";
                    }
                }
                else{
                    say "\t$from_nick : $msg";
                }
            }
            elsif( $r eq \*STDIN ){
                $in = <STDIN>;
                chomp($in);
                system('perl','udp_client.pl', $nickname, $in);
            }

        }
        
        
    }


### 닉네임을 명령행 인자로 받기


    my $nickname = $ARGV[0];
    if( !$nickname ){
        say "usage: perl udp_server.pl NICKNAME";
        exit;
    }


* @ARGV 에는 쉘에서 입력한 추가 인자들이 배열로 들어가 있습니다. "perl udp_server.pl 1 2 3" 하면 @ARGV = ("1","2","3"); 과 같습니다.
* $ARGV[0] 은 @ARGV배열에서 첫번째 인자를 꺼내는 겁니다.
* $nickname 이 옳지 않으면 (즉 공백이거나 undef상태이면) 
 * 사용방법을 출력하고
 * exit 함수로 실행을 종료합니다.

### 받을 소켓의 생성


    socket( SOCK, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
    setsockopt( SOCK, SOL_SOCKET, SO_BROADCAST, 1 );
    my $dest = sockaddr_in( $port, INADDR_ANY);
    bind( SOCK, $dest );
    say "UDP $port Broadcast Receiver Started";


* Class1과 동일합니다.

### 소켓입력과 표준입력(키보드입력)을 함께 처리하기


    use IO::Select;
    my $sel = IO::Select->new();
    $sel->add(\*STDIN);
    $sel->add(\*SOCK);


* IO::Select 는 여러개의 입출력을 쉽게 처리할수 있게 해주는 모듈입니다. Perl의 기본모듈입니다.
* \\*STDIN 은 키보드입력을 의미합니다. (엄밀히는 표준입력)
* \\*SOCKET 은 위에서 만들었던 받는 소켓이죠?
* $sel 은 STDIN과 SOCKET, 이 두가지 입력을 모니터링 할 수 있게 되었습니다.

### 입장 메세지의 자동 전송


    system('perl','udp_client.pl',$nickname,"--> $nickname 입장 <--");


* system 함수는 다른 프로그램을 실행시키는 기능을 가지고 있습니다.
* 브로드캐스트하는 기능만을 가진 udp_client.pl 을 그대로 재사용해서 서버에서 브로드캐스트를 할수 있게 되었습니다.

### 소켓과 키보드 입력의 대기


    while( 1 ){

        my @ready = $sel->can_read();

        foreach my $r (@ready){
            ...
        }
    }


* Class1에서는 


    while( my $from = recv( SOCK, $in, 4096, 0 ) ){ ... } 


* 이라고 했었는데, 이렇게 하면 SOCK 만 체크합니다. 그러면 사용자의 입력인 STDIN은 처리할 기회가 없는거죠.
* 그래서 이제는 $sel->can_read() 을 이용해서 STDIN과 SOCK을 함께 체크합니다.
* @ready 에는 입력내용이 있는 파일핸들이 들어가게 되고, 이 파일핸들들을 처리해주면 됩니다.

### 소켓과 키보드입력을 구분해서 처리해기


        foreach my $r (@ready){


* @ready 안에 있는 것을 하나씩 $r에 할당하여 루프를 돕니다.
* $r 안에는 현재 읽을 수 있는 파일핸들이 하나씩 들어가게 됩니다.


            my $in;

            if( $r eq \*SOCK ){
                my $from = recv( SOCK, $in, 4096, 0 );
                chomp($in);

                ... 받은 내용의 처리 ...
            }


* chomp 는 문자열의 마지막 개행문자를 제거해줍니다.
* SOCK 으로 받은 것은 아래의 3가지 작동을 할 겁니다.
 * /p 로 시작하면 내 닉네임과 같을때만 출력하기
 * /ping 로 받았을때 자동으로 귓말을 보내기
 * 이도 저도 아니면 그대로 출력하기


            elsif( $r eq \*STDIN ){
                $in = <STDIN>;
                chomp($in);
                system('perl','udp_client.pl', $nickname, $in);
            }


* <STDIN> 은 한줄씩 STDIN으로부터 가져옵니다.
* 역시 chomp로 마지막 개행문자를 제거해줍니다.
* 사용자가 입력한 것은 내 닉네임을 그 앞에 붙여 udp_client.pl을 이용하여 브로드캐스트로 보냅니다.


        }

### SOCK 입력의 처리

                my $from = recv( SOCK, $in, 4096, 0 );
                chomp($in);
                my ($fport,$faddr) = unpack_sockaddr_in($from);
                my $ipaddr = inet_ntoa($faddr);


* Class1 에서도 $ipaddr과 $fport를 알아냈었죠?


                my ($from_nick,$msg) = split(/\s+/, $in, 2);


* 이번엔 $in 에서 닉네임과 메세지를 분리합니다.
* \\s+ 는 공백들을 의미하고, 마지막 인자 2는 최대 2개로 분리하라는 것입니다. 즉 첫번째 \\s+ 를 기준으로 2개로 자릅니다.
* $from_nick 과 $msg 에 각각 할당됩니다.


                if( $msg =~ /^\/ping/ ){
                    system('perl','udp_client.pl',$nickname,"/p $from_nick --> $nickname 있음 <--");
                }


* $msg가 /ping으로 시작하면, system 명령으로 귓말을 보내 자동응답합니다.
* perl udp_client.pl '변상필' '/p 김현승 --> 변상필 있음 <--' 
* 이라고 직접 실행하는 것과 같습니다.


                elsif( $msg =~ /^\/p / ){
                    my ($to_nick, $submsg) = split(/\s+/, $', 2);
                    if( $to_nick eq $nickname ){ # 내꺼일때만 보여준다.
                        say "\t[귓말] $from_nick : $submsg";
                    }
                }


* $msg가 /p로 시작하면
* 그 이후의 내용을 첫공백을 기준으로 잘라서, $to_nick 와 $submsg 에 할당합니다.
* $to_nick 과 나의 닉네임이 같을때만 화면에 출력합니다.
* $' 는 /p 매칭이후내용을 자동으로 담아두는 내장변수입니다.


                else{
                    say "\t$from_nick : $msg";
                }


* 이도 저도 아니면 내용을 그대로 출력합니다.

## 두가지 보안 문제

* 두사람 이상이 같은 닉네임을 사용하는 경우
* $to_nick 과 내 닉네임을 비교하지 않게하여 모든 귓말을 보는 경우

