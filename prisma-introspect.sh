#!/bin/sh
rm schema.prisma
cat <<EOF > schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("POSTGRES_URL")
}
generator client {
  provider = "prisma-client-js"
}
EOF
node_modules/.bin/prisma introspect
node_modules/.bin/prisma generate
exec node_modules/.bin/prisma studio