# multi-stage build as deps
FROM node:16-alpine AS deps

RUN apk add --no-cache libc6-compat

#dpes의 app 디렉토리에 package.json 복붙 
WORKDIR /app
COPY package.json ./
# yarn
RUN yarn --prefer-offline --frozen-lockfile
# 이미지 최적화
RUN yarn add sharp 

# multi-stage build as builder
FROM node:16-alpine AS builder

# deps의 node_modules를 builder/app/node_modules로 복붙
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 현재 디렉토리 확인
RUN ls -a

# 빌드
RUN yarn build