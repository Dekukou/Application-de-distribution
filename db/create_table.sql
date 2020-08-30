CREATE TYPE user_role AS ENUM('0', '1');

/* USER */
CREATE TABLE public.user
(
    id SERIAL NOT NULL,
    uid TEXT NOT NULL,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    role user_role,
    home FLOAT[],
    dispo BOOLEAN,
    CONSTRAINT users_pkey PRIMARY KEY (uid),
    CONSTRAINT users_email_unique UNIQUE (email)
);

/* OAUTH_ACCESS_TOKENS */
CREATE TABLE public.oauth_access_tokens
(
    id CHARACTER VARYING(100) COLLATE pg_catalog."default" NOT NULL,
    user_id BIGINT,
    client_id INTEGER  NOT NULL,
    name CHARACTER VARYING(255) COLLATE pg_catalog."default",
    scopes TEXT COLLATE pg_catalog."default",
    revoked BOOLEAN NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE,
    expires_at TIMESTAMP(0) WITHOUT TIME ZONE,
    CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id)
);

/* OAUTH_AUTH_CODES */
CREATE TABLE public.oauth_auth_codes
(
    id CHARACTER VARYING(100) COLLATE pg_catalog."default" NOT NULL,
    user_id BIGINT NOT NULL,
    client_id INTEGER  NOT NULL,
    scopes TEXT COLLATE pg_catalog."default",
    revoked BOOLEAN NOT NULL,
    expires_at TIMESTAMP(0) WITHOUT TIME ZONE,
    CONSTRAINT oauth_auth_codes_pkey PRIMARY KEY (id)
);

/* OAUTH_CLIENTS */
CREATE TABLE public.oauth_clients
(
    id SERIAL NOT NULL,
    user_id BIGINT,
    name CHARACTER VARYING(255) COLLATE pg_catalog."default" NOT NULL,
    secret CHARACTER VARYING(100) COLLATE pg_catalog."default",
    provider TEXT,
    redirect TEXT COLLATE pg_catalog."default" NOT NULL,
    personal_access_client BOOLEAN NOT NULL,
    password_client BOOLEAN NOT NULL,
    revoked BOOLEAN NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE,
    CONSTRAINT oauth_clients_pkey PRIMARY KEY (id)
);

/* OAUTH_PERSONAL_ACCESS_CLIENTS */
CREATE TABLE public.oauth_personal_access_clients
(
    id SERIAL NOT NULL,
    client_id INTEGER  NOT NULL,
    created_at TIMESTAMP(0) WITHOUT TIME ZONE,
    updated_at TIMESTAMP(0) WITHOUT TIME ZONE,
    CONSTRAINT oauth_personal_access_clients_pkey PRIMARY KEY (id)
);

/* OAUTH_REFRESH_TOKENS */
CREATE TABLE public.oauth_refresh_tokens
(
    id CHARACTER VARYING(100) COLLATE pg_catalog."default" NOT NULL,
    access_token_id CHARACTER VARYING(100) COLLATE pg_catalog."default" NOT NULL,
    revoked BOOLEAN NOT NULL,
    expires_at TIMESTAMP(0) WITHOUT TIME ZONE,
    CONSTRAINT oauth_refresh_tokens_pkey PRIMARY KEY (id)
);

/* PACKAGES */
CREATE TABLE public.package
(
    uid  TEXT NOT NULL,
    pos  FLOAT[],
    todo BOOLEAN,
    PRIMARY KEY (uid)
);

/* TABLE RELATIONNELLE */
CREATE TABLE public.package_user
(
    user_uid    TEXT NOT NULL,
    package_uid TEXT NOT NULL,
    last FLOAT[],
    dist INTEGER,
    total_dist INTEGER,
    done BOOLEAN,
    delivery_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_package_user FOREIGN KEY (package_uid)
    REFERENCES public.package (uid) ON DELETE CASCADE,
    CONSTRAINT fk_package_user2 FOREIGN KEY (user_uid)
    REFERENCES public.user (uid) ON DELETE CASCADE
);









