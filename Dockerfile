FROM oven/bun:slim AS builder

WORKDIR /MRS

COPY . .

RUN bun install --frozen-lockfile --ignore-scripts && bun run build

FROM oven/bun:slim as prod

WORKDIR /config

ENV NODE_ENV=production
ENV ACCOUNTS_PATH=/config/accounts.json
ENV CONFIG_PATH=/config/config.json
ENV SESSIONS_DIR=/sessions
ENV TimeZone=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone


RUN bunx playwright install --with-deps chromium

COPY --from=builder /MRS/dist/*  /MRS/
COPY --from=builder /MRS/node_modules/  /MRS/node_modules/

CMD ["bun", "/MRS/index.js"]