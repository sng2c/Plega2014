# Class1. UDP 클라이언트

## UDP?

* UDP는 네트워크 문제에 의한 전송실패시, 재전송해주는 기능이 없는 겁니다. 일방적으로 보내는겁니다.
* 보내는 크기에 제한이 있습니다. 그래서 큰파일은 여러번 보낼 수 있는 형태로 보내야겠죠?

* TCP는 재전송을 해줍니다. UDP를 조합해서 재전송을 구현합니다. 
* 재전송 기준을 잡기 위해서 이리저리 준비를 하는 과정을 HandShaking(악수) 라고 하는데
* 이 HandShaking 중에 급 멈춰버리면, DOS 공격이 됩니다.
* DOS는 UDP로 만들어 낼 수 있습니다.

## UDP 클라이언트 udp_client.pl

    #!/usr/bin/env perl
	
    use v5.10;
    
	use Socket ;

	my $text = join ' ', @ARGV;

	my $port = 9999;

	socket( SOCKET, PF_INET, SOCK_DGRAM, getprotobyname("udp") );

	setsockopt( SOCKET, SOL_SOCKET, SO_BROADCAST, 1 );

	my $dest = sockaddr_in( $port, INADDR_BROADCAST );

	send( SOCKET, $text, 0,  $dest );
    
	close SOCKET;


### shebang 라인

	#!/usr/bin/env perl

* 유닉스 쉘에서는 첫 2바이트가 #! 로 되어있으면, 스크립트파일로 인식합니다.
* 그리고 이 파일을 실행하면 #! 뒤의 실행파일에 이 파일의 경로를 넣어 실행합니다.
* 이 첫줄을 shebang 라인이라고 부릅니다. sharp + bang 이겠죠?
* /usr/bin/env perl에서 env명령은 현재사용자의 PATH들 중에서
* 제일 먼저 만나는 perl을 찾아서 실행합니다.
* 결과적으로 ./udp_client.pl 이라고 실행한 것은 
* /usr/bin/perl udp_client.pl 을 실행한 것과 같습니다.

### perl 최소버전의 선언

	use v5.10;

* 버전 5.10 이상일때만 작동한다고 표시했습니다. 

### Socket 기능의 활성화

	use Socket ;

* Socket 모듈을 불러들입니다. 자바의 import와 비슷합니다.

### 커맨드라인의 입력값을 이용하기

	my $text = join ' ', @ARGV;

* @ARGV 를 ' ' 로 join 한 것을 $text 에 넣고 있습니다.
* "./udp_client.pl 안녕하세요 여러분" 하면 
* @ARGV = ("안녕하세요", "여러분"); 한것과 같습니다.

### 도착지의 포트번호를 9999로 정하기

    my $port = 9999;

* 9999 를 $port 에 넣고 있습니다.

### 소켓 파일핸들을 열기

    socket( SOCKET, PF_INET, SOCK_DGRAM, getprotobyname("udp") );
	
* UDP패킷을 만들어내기 위한 옵션 3가지를 넣고, SOCKET 이라는 파일핸들에 연결합니다.
* 소켓은(네트워크 파일핸들)은 OS가 LAN카드에서 뽑아서 빌려줍니다.
* 다 빌려주고 나면 더이상 못빌려 오겠죠? 랜카드 하나는 65536개를 가지고 있습니다.
* 1000번대 밑으로는 root권한이 있어야 빌릴수 있습니다.
* 그래서 아파치를 80에 띄우려면 root로 로그인해서 띄워야 합니다.

#####파일 핸들이란?
* 파일을 열때 파일핸들이 리턴되고 거기에다가 읽고 쓰고 하죠?
* 소켓은 파일은 대신 랜카드를 연다고 생각하면 됩니다.

### 브로드캐스트를 위한 옵션을 SOCKET에 설정하기

    setsockopt( SOCKET, SOL_SOCKET, SO_BROADCAST, 1 );

* SOCKET에다가 SO_BROADCAST 를 1로 설정하고 있습니다.

### 도착지 주소를 조립하기

    my $dest = sockaddr_in( $port, INADDR_BROADCAST );

* INADDR_BROADCAST 에 $port(9999) 를 합쳤습니다.
* 보통은 INADDR_BROADCAST 대신 IP주소가 들어갑니다.
* 브로드캐스트는 발신자와 같은 네트워크 내에 라우터(공유기)를 통해 모두 전달됩니다.

### 소켓과 글자와 도착지를 조합해서 보내기

	send( SOCKET, $text, 0,  $dest );

* SOCKET 을 통해서
* $text 를
* $dest 로
* 보내는 거죠.

### 소켓을 잘 닫아주기

	close SOCKET;

* OS한테 빌린 소켓을 잘 돌려줘야 합니다.

## UDP 서버 udp_server.pl

	#!/usr/bin/env perl

	use v5.10;

	use Socket;

	my $port = 9999;

	socket( SOCKET, PF_INET, SOCK_DGRAM, getprotobyname('udp'));

	setsockopt( SOCKET, SOL_SOCKET, SO_BROADCAST, 1 );

	my $dest = sockaddr_in( $port, INADDR_ANY);

	bind( SOCKET, $dest );

	say "UDP $port Broadcast Receiver Started";

	my $in;

	while( my $from = recv( SOCKET, $in, 4096, 0 ) ){

		my ($fport,$faddr) = unpack_sockaddr_in($from);

		my $ipaddr = inet_ntoa($faddr);

		say "$ipaddr:$fport => $in";

	}

### 똑같은 부분은 생략합니다.

	#!/usr/bin/env perl
	
	use v5.10;

	use Socket;

	my $port = 9999;

	socket( SOCKET, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
	
	setsockopt( SOCKET, SOL_SOCKET, SO_BROADCAST, 1 );

### 도착지 주소를 만들기

	my $src = sockaddr_in( $port, INADDR_ANY);

* 내 주소와 $port 주소를 조합해서 도착지 주소를 만들고 있습니다.

### 도착지 주소를 SOCKET 에 연결

	bind( SOCKET, $src );

* 아까는 send 에만 사용했는데, 이젠 9999포트에 bind를 시켰습니다.
* 9999번 귀를 열겠다는 겁니다.

### 로그를 찍어봅니다.

	say "UDP $port Broadcast Receiver Started";

* 5.10버전 부터는 print 대신 say를 쓸 수 있습니다.

### 데이터를 받을 버퍼를 만듭니다.

	my $in;

### 무한 루프를 돕니다. 뭐하면서? recv 하면서~

	while( my $from = recv( SOCKET, $in, 4096, 0 ) ){

* SOCKET은 이제 9999번 포트를 들을 준비가 되었습니다.
* SOCKET에서 $in 으로 4096 바이트만큼 읽겠다는 거지요?
* $from는 보낸 사람의 주소가 되는데, while() 안에서는 결과적으로 참이 되어 계속 루프를 돕니다.
* recv는 실제로 뭔가 읽어지기 전에는 멈춰있습니다.

### $from에 뭐가 들었나 볼까요?

		my ($fport,$faddr) = unpack_sockaddr_in($from);
		my $ipaddr = inet_ntoa($faddr);

* $from은 바이트 형태로 되어있어서 읽기가 어렵습니다.
* 그래서 unpack_sockaddr_in 으로 $fport 와 $faddr 에 갈라넣고,
* $faddr을 inet_ntoa를 이용하여 우리가 익숙한 192.168.0.X 형태로 바꿔줍니다.


### 받은 값의 출력
		say "$ipaddr:$fport => $in";

	}

* $in 에는 9999포트를 통해서 들어온 글자가 들어가 있겠지요?
* 192.168.0.7:44953 => 하이요
* 와 같은 형태로 출력됩니다.

### 아직 루프를 멈출방법이 따로 없으니 OS가 알아서 SOCKET을 잘 수거해가길 기도합시다.
