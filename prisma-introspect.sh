#!/bin/sh
if [ -z "$POSTGRES_URL" ]; then
  export POSTGRES_URL="postgresql://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DATABASE?schema=data"
fi
node_modules/.bin/prisma introspect --url $POSTGRES_URL || cat <<EOF > schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("POSTGRES_URL")
}
EOF
exec node_modules/.bin/prisma studio