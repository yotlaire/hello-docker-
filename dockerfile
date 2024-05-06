FROM node:lts-bullseye

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . .

RUN pnpm run build

CMD ["pnpm", "run", "start"]
