#!/bin/sh
rm -f schema.prisma
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
exec node_modules/.bin/prisma studio