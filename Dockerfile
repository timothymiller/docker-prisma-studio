# ---- Base Node ----
FROM node:lts-alpine AS base
LABEL image=timothyjmiller/prisma-studio:latest \
  maintainer="Timothy Miller <tim.miller@preparesoftware.com>" \
  base=debian

#
# ---- Dependencies ----
FROM base AS dependencies
# copy package.json
COPY /package.json .
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production 
# copy production node_modules aside
RUN cp -R node_modules production_node_modules
 
#
# ---- Release ----
FROM base AS release
# copy production node_modules
COPY --from=dependencies /production_node_modules ./node_modules
# copy introspect function
COPY prisma-studio.sh .
# make executable
RUN chmod +x prisma-studio.sh
# default environment variables
ENV POSTGRES_DATABASE "data"
ENV POSTGRES_HOST "postgres"
ENV POSTGRES_PASSWORD "postgres"
ENV POSTGRES_PORT 5432
ENV PRISMA_STUDIO_PORT 5555
ENV POSTGRES_USERNAME "postgres"
ENV POSTGRES_URL "postgresql://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DATABASE?schema=data"
EXPOSE $PRISMA_STUDIO_PORT
ENTRYPOINT ["/bin/sh", "prisma-studio.sh"]