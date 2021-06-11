# minimal HamoniKR Linux image
클라우드 또는 가상머신용 하모니카 리눅스 서버 이미지

## 사용법
```
docker pull hamonikr/server

docker run -it hamonikr/server /bin/bash

root@1a42d8f34e0c:/# lsb_release -a
No LSB modules are available.
Distributor ID:	Hamonikr
Description:	HamoniKR 5.0 Hanla
Release:	5.0
Codename:	ulyssa
```

## 세부 내용
* 이미지 크기 : 223 MB
* Ubuntu 20.04 기반으로 최신 업그레이드 모두 적용 (빌드 시 자동 업그레이드)
* 한국 Ubuntu APT 미러 서버 적용
* 하모니카 APT 저장소 및 GPG 키 적용
* 여러 프로세스를 쉽게 실행할 수 있도록 수정 (ref : https://github.com/phusion/baseimage-docker)
* 컨테이너 시작시 `/etc/my_init.d` 폴더의 스크립트를 실행하도록 적용

```
RUN mkdir -p /etc/my_init.d
COPY logtime.sh /etc/my_init.d/logtime.sh
RUN chmod +x /etc/my_init.d/logtime.sh
```

* 컨테이너에서 ssh 를 사용하고 싶지 않은 경우
```
# vi image/buildconfig

export DISABLE_SSH=1
```

## 커스텀 이미지 만들기
이미지 생성
```
make build 

OR

make build NAME=foo/bob
```