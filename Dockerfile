FROM node:latest

MAINTAINER Shu Kutsuzawa <m153304w@st.u-gakugei.ac.jp>

ENV BOTDIR /gibot
RUN mkdir ${BOTDIR}

COPY . ${BOTDIR}
WORKDIR ${BOTDIR}
RUN npm install

CMD bin/hubot -a slack
