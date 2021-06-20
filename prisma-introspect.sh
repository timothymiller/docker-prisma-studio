#!/bin/sh
node_modules/.bin/prisma introspect --url $PRISMA_DATABASE_URL || cat <<EOF > schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("PRISMA_DATABASE_URL")
}
generator client {
  provider = "prisma-client-js"
}
EOF
node_modules/.bin/prisma generate
exec node_modules/.bin/prisma studio