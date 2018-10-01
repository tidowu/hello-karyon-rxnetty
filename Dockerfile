FROM openjdk:8-jre
RUN useradd --home-dir /home/hkr --create-home -U hkr
USER hkr
RUN cd /home/hkr/; mkdir -p .hkr
ADD build/libs/hello-karyon-rxnetty-all-0.1.0.jar /home/hkr/h-k-rx-all.jar
ENTRYPOINT ["nohup", "java","-Djava.security.egd=file:/dev/./urandom","-jar","/home/hkr/h-k-rx-all.jar", ">", "/log.txt", "&"]

