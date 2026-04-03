CREATE TABLE "users" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "name" VARCHAR(128) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "password_hash" CHAR(64) NOT NULL,
    "password_salt" CHAR(64) NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);
CREATE UNIQUE INDEX "unique_users_email" ON "users" ("email");

CREATE TABLE "groups" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "name" VARCHAR(128) NOT NULL,
    "creator_id" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "group_pages" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "group_id" BIGINT NOT NULL,
    "title" VARCHAR(128) NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "group_blocks" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "page_id" BIGINT NOT NULL,
    "raw_content" VARCHAR NOT NULL,
    "compiled_content" VARCHAR NOT NULL,
    "position" INT NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "permissions" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "user_id" BIGINT NOT NULL,
    "block_id" BIGINT,
    "page_id" BIGINT,
    "status" VARCHAR(8) NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "user_pages" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "user_id" BIGINT NOT NULL,
    "title" VARCHAR(128) NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "user_blocks" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "page_id" BIGINT NOT NULL,
    "raw_content" VARCHAR NOT NULL,
    "compiled_content" VARCHAR NOT NULL,
    "position" INT NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "members" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "user_id" BIGINT NOT NULL,
    "group_id" BIGINT NOT NULL,
    "admin" BOOLEAN NOT NULL,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "schema_migrations" (
    "version" BIGINT PRIMARY KEY,
    "applied_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dirty" BOOLEAN NOT NULL DEFAULT false
);
