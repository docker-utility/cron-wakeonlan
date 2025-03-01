FROM ubuntu:latest

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    wakeonlan \
    cron \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# 환경 변수 설정 (MAC 주소는 필요에 따라 변경)
ENV MAC_ADDRESS="22:41:5c:03:00:94"

# 스크립트 생성
RUN echo "#!/bin/bash" > /run_wakeonlan.sh
RUN echo "wakeonlan $MAC_ADDRESS" >> /run_wakeonlan.sh
RUN chmod +x /run_wakeonlan.sh

# Cron 설정 파일 생성
RUN echo "0 12 * * 0,6 /run_wakeonlan.sh" > /etc/cron.d/wakeonlan_weekend
RUN echo "0 7 * * 1-5 /run_wakeonlan.sh" > /etc/cron.d/wakeonlan_weekday

# Cron 파일 권한 설정
RUN chmod 0644 /etc/cron.d/wakeonlan_weekend
RUN chmod 0644 /etc/cron.d/wakeonlan_weekday

# Dockerfile 에러 수정
RUN touch /var/log/cron.log

# Cron 시작
CMD cron && tail -f /var/log/cron.log
