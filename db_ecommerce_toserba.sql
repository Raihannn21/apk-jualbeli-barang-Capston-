PGDMP  #        	            }            db_ecommerce_toserba    16.4    16.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    53547    db_ecommerce_toserba    DATABASE     �   CREATE DATABASE db_ecommerce_toserba WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Indonesia.1252';
 $   DROP DATABASE db_ecommerce_toserba;
                postgres    false            �            1259    53583    cache    TABLE     �   CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);
    DROP TABLE public.cache;
       public         heap    postgres    false            �            1259    53590    cache_locks    TABLE     �   CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);
    DROP TABLE public.cache_locks;
       public         heap    postgres    false            �            1259    53636 
   cart_items    TABLE     �   CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.cart_items;
       public         heap    postgres    false            �            1259    53635    cart_items_id_seq    SEQUENCE     z   CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cart_items_id_seq;
       public          postgres    false    231            �           0    0    cart_items_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;
          public          postgres    false    230            �            1259    53720 
   categories    TABLE       CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    image character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.categories;
       public         heap    postgres    false            �            1259    53719    categories_id_seq    SEQUENCE     z   CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.categories_id_seq;
       public          postgres    false    241            �           0    0    categories_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;
          public          postgres    false    240            �            1259    53615    failed_jobs    TABLE     &  CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.failed_jobs;
       public         heap    postgres    false            �            1259    53614    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public          postgres    false    227            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public          postgres    false    226            �            1259    53607    job_batches    TABLE     d  CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);
    DROP TABLE public.job_batches;
       public         heap    postgres    false            �            1259    53598    jobs    TABLE     �   CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);
    DROP TABLE public.jobs;
       public         heap    postgres    false            �            1259    53597    jobs_id_seq    SEQUENCE     t   CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.jobs_id_seq;
       public          postgres    false    224            �           0    0    jobs_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;
          public          postgres    false    223            �            1259    53549 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false            �            1259    53548    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          postgres    false    216            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          postgres    false    215            �            1259    53667    order_items    TABLE       CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.order_items;
       public         heap    postgres    false            �            1259    53666    order_items_id_seq    SEQUENCE     {   CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.order_items_id_seq;
       public          postgres    false    235            �           0    0    order_items_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;
          public          postgres    false    234            �            1259    53653    orders    TABLE     �  CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    total_amount numeric(12,2) NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    user_address_id bigint,
    shipping_cost numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    shipping_courier character varying(255),
    payment_proof character varying(255),
    payment_method character varying(255),
    courier_code character varying(255),
    waybill_number character varying(255),
    subtotal numeric(10,2),
    discount_amount numeric(10,2) DEFAULT '0'::numeric,
    payment_token character varying(255),
    payment_url character varying(255),
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'paid'::character varying, 'shipped'::character varying, 'completed'::character varying, 'cancelled'::character varying])::text[])))
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    53652    orders_id_seq    SEQUENCE     v   CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          postgres    false    233            �           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public          postgres    false    232            �            1259    53567    password_reset_tokens    TABLE     �   CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 )   DROP TABLE public.password_reset_tokens;
       public         heap    postgres    false            �            1259    53684    personal_access_tokens    TABLE     �  CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
 *   DROP TABLE public.personal_access_tokens;
       public         heap    postgres    false            �            1259    53683    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public          postgres    false    237            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    236            �            1259    53762    product_images    TABLE     �   CREATE TABLE public.product_images (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    image_path character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
 "   DROP TABLE public.product_images;
       public         heap    postgres    false            �            1259    53761    product_images_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.product_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.product_images_id_seq;
       public          postgres    false    245            �           0    0    product_images_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.product_images_id_seq OWNED BY public.product_images.id;
          public          postgres    false    244            �            1259    53696    product_reviews    TABLE     )  CREATE TABLE public.product_reviews (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    order_id bigint NOT NULL,
    rating smallint NOT NULL,
    comment text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
 #   DROP TABLE public.product_reviews;
       public         heap    postgres    false            �            1259    53695    product_reviews_id_seq    SEQUENCE        CREATE SEQUENCE public.product_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.product_reviews_id_seq;
       public          postgres    false    239            �           0    0    product_reviews_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.product_reviews_id_seq OWNED BY public.product_reviews.id;
          public          postgres    false    238            �            1259    53627    products    TABLE     �  CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    image character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    category_id bigint,
    discount_price numeric(10,2),
    discount_percent integer,
    weight integer DEFAULT 1000 NOT NULL
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    53626    products_id_seq    SEQUENCE     x   CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.products_id_seq;
       public          postgres    false    229            �           0    0    products_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;
          public          postgres    false    228            �            1259    53574    sessions    TABLE     �   CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);
    DROP TABLE public.sessions;
       public         heap    postgres    false            �            1259    53774    settings    TABLE     �   CREATE TABLE public.settings (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.settings;
       public         heap    postgres    false            �            1259    53773    settings_id_seq    SEQUENCE     x   CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public          postgres    false    247            �           0    0    settings_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;
          public          postgres    false    246            �            1259    53738    user_addresses    TABLE     B  CREATE TABLE public.user_addresses (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    label character varying(255) NOT NULL,
    recipient_name character varying(255) NOT NULL,
    phone_number character varying(255) NOT NULL,
    address text NOT NULL,
    city character varying(255) NOT NULL,
    province character varying(255) NOT NULL,
    postal_code character varying(255) NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    city_id character varying(255)
);
 "   DROP TABLE public.user_addresses;
       public         heap    postgres    false            �            1259    53737    user_addresses_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.user_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.user_addresses_id_seq;
       public          postgres    false    243            �           0    0    user_addresses_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.user_addresses_id_seq OWNED BY public.user_addresses.id;
          public          postgres    false    242            �            1259    53556    users    TABLE     #  CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    role character varying(255) DEFAULT 'user'::character varying NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    login_streak integer DEFAULT 0 NOT NULL,
    last_login_at timestamp(0) without time zone
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    53555    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    218            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    217            �           2604    53639    cart_items id    DEFAULT     n   ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);
 <   ALTER TABLE public.cart_items ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    231    231            �           2604    53723    categories id    DEFAULT     n   ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);
 <   ALTER TABLE public.categories ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240    241            �           2604    53618    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    53601    jobs id    DEFAULT     b   ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);
 6   ALTER TABLE public.jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    224    224            �           2604    53552    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    216    216            �           2604    53670    order_items id    DEFAULT     p   ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);
 =   ALTER TABLE public.order_items ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    235    235            �           2604    53656 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232    233            �           2604    53687    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236    237            �           2604    53765    product_images id    DEFAULT     v   ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);
 @   ALTER TABLE public.product_images ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244    245            �           2604    53699    product_reviews id    DEFAULT     x   ALTER TABLE ONLY public.product_reviews ALTER COLUMN id SET DEFAULT nextval('public.product_reviews_id_seq'::regclass);
 A   ALTER TABLE public.product_reviews ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    239    239            �           2604    53630    products id    DEFAULT     j   ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);
 :   ALTER TABLE public.products ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    53777    settings id    DEFAULT     j   ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246    247            �           2604    53741    user_addresses id    DEFAULT     v   ALTER TABLE ONLY public.user_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_addresses_id_seq'::regclass);
 @   ALTER TABLE public.user_addresses ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    242    243    243            �           2604    53559    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217    218            �          0    53583    cache 
   TABLE DATA           7   COPY public.cache (key, value, expiration) FROM stdin;
    public          postgres    false    221   ��       �          0    53590    cache_locks 
   TABLE DATA           =   COPY public.cache_locks (key, owner, expiration) FROM stdin;
    public          postgres    false    222   �       �          0    53636 
   cart_items 
   TABLE DATA           _   COPY public.cart_items (id, user_id, product_id, quantity, created_at, updated_at) FROM stdin;
    public          postgres    false    231   5�       �          0    53720 
   categories 
   TABLE DATA           S   COPY public.categories (id, name, slug, image, created_at, updated_at) FROM stdin;
    public          postgres    false    241   R�       �          0    53615    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    227   G�       �          0    53607    job_batches 
   TABLE DATA           �   COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
    public          postgres    false    225   d�       �          0    53598    jobs 
   TABLE DATA           c   COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
    public          postgres    false    224   ��       �          0    53549 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    216   ��       �          0    53667    order_items 
   TABLE DATA           h   COPY public.order_items (id, order_id, product_id, quantity, price, created_at, updated_at) FROM stdin;
    public          postgres    false    235   s�       �          0    53653    orders 
   TABLE DATA             COPY public.orders (id, user_id, total_amount, status, created_at, updated_at, user_address_id, shipping_cost, shipping_courier, payment_proof, payment_method, courier_code, waybill_number, subtotal, discount_amount, payment_token, payment_url) FROM stdin;
    public          postgres    false    233   ��       �          0    53567    password_reset_tokens 
   TABLE DATA           I   COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
    public          postgres    false    219   6�       �          0    53684    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   S�       �          0    53762    product_images 
   TABLE DATA           \   COPY public.product_images (id, product_id, image_path, created_at, updated_at) FROM stdin;
    public          postgres    false    245   Y�       �          0    53696    product_reviews 
   TABLE DATA           u   COPY public.product_reviews (id, user_id, product_id, order_id, rating, comment, created_at, updated_at) FROM stdin;
    public          postgres    false    239   ��       �          0    53627    products 
   TABLE DATA           �   COPY public.products (id, name, description, price, stock, image, created_at, updated_at, category_id, discount_price, discount_percent, weight) FROM stdin;
    public          postgres    false    229   H�       �          0    53574    sessions 
   TABLE DATA           _   COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
    public          postgres    false    220   &�       �          0    53774    settings 
   TABLE DATA           J   COPY public.settings (id, key, value, created_at, updated_at) FROM stdin;
    public          postgres    false    247   �       �          0    53738    user_addresses 
   TABLE DATA           �   COPY public.user_addresses (id, user_id, label, recipient_name, phone_number, address, city, province, postal_code, is_primary, created_at, updated_at, city_id) FROM stdin;
    public          postgres    false    243   ��       �          0    53556    users 
   TABLE DATA           �   COPY public.users (id, name, email, email_verified_at, password, role, remember_token, created_at, updated_at, login_streak, last_login_at) FROM stdin;
    public          postgres    false    218   O�       �           0    0    cart_items_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.cart_items_id_seq', 1, true);
          public          postgres    false    230            �           0    0    categories_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.categories_id_seq', 3, true);
          public          postgres    false    240            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    226            �           0    0    jobs_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);
          public          postgres    false    223            �           0    0    migrations_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.migrations_id_seq', 25, true);
          public          postgres    false    215            �           0    0    order_items_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.order_items_id_seq', 1, true);
          public          postgres    false    234            �           0    0    orders_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.orders_id_seq', 1, true);
          public          postgres    false    232            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 3, true);
          public          postgres    false    236            �           0    0    product_images_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_images_id_seq', 2, true);
          public          postgres    false    244            �           0    0    product_reviews_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.product_reviews_id_seq', 1, true);
          public          postgres    false    238            �           0    0    products_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.products_id_seq', 2, true);
          public          postgres    false    228            �           0    0    settings_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.settings_id_seq', 5, true);
          public          postgres    false    246            �           0    0    user_addresses_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.user_addresses_id_seq', 1, true);
          public          postgres    false    242            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 2, true);
          public          postgres    false    217            �           2606    53596    cache_locks cache_locks_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);
 F   ALTER TABLE ONLY public.cache_locks DROP CONSTRAINT cache_locks_pkey;
       public            postgres    false    222            �           2606    53589    cache cache_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);
 :   ALTER TABLE ONLY public.cache DROP CONSTRAINT cache_pkey;
       public            postgres    false    221            �           2606    53641    cart_items cart_items_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_pkey;
       public            postgres    false    231            �           2606    53729 !   categories categories_name_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_unique UNIQUE (name);
 K   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_name_unique;
       public            postgres    false    241            �           2606    53727    categories categories_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_pkey;
       public            postgres    false    241            �           2606    53731 !   categories categories_slug_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_unique UNIQUE (slug);
 K   ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_slug_unique;
       public            postgres    false    241            �           2606    53623    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    227            �           2606    53625 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    227            �           2606    53613    job_batches job_batches_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.job_batches DROP CONSTRAINT job_batches_pkey;
       public            postgres    false    225            �           2606    53605    jobs jobs_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_pkey;
       public            postgres    false    224            �           2606    53554    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    216            �           2606    53672    order_items order_items_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_pkey;
       public            postgres    false    235            �           2606    53660    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    233            �           2606    53573 0   password_reset_tokens password_reset_tokens_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);
 Z   ALTER TABLE ONLY public.password_reset_tokens DROP CONSTRAINT password_reset_tokens_pkey;
       public            postgres    false    219            �           2606    53691 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            �           2606    53694 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    237            �           2606    53767 "   product_images product_images_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.product_images DROP CONSTRAINT product_images_pkey;
       public            postgres    false    245            �           2606    53703 $   product_reviews product_reviews_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.product_reviews DROP CONSTRAINT product_reviews_pkey;
       public            postgres    false    239            �           2606    53634    products products_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    229            �           2606    53580    sessions sessions_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
       public            postgres    false    220            �           2606    53783    settings settings_key_unique 
   CONSTRAINT     V   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_key_unique UNIQUE (key);
 F   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_key_unique;
       public            postgres    false    247            �           2606    53781    settings settings_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public            postgres    false    247            �           2606    53746 "   user_addresses user_addresses_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.user_addresses DROP CONSTRAINT user_addresses_pkey;
       public            postgres    false    243            �           2606    53566    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    218            �           2606    53564    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    218            �           1259    53606    jobs_queue_index    INDEX     B   CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);
 $   DROP INDEX public.jobs_queue_index;
       public            postgres    false    224            �           1259    53692 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           1259    53582    sessions_last_activity_index    INDEX     Z   CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);
 0   DROP INDEX public.sessions_last_activity_index;
       public            postgres    false    220            �           1259    53581    sessions_user_id_index    INDEX     N   CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);
 *   DROP INDEX public.sessions_user_id_index;
       public            postgres    false    220            �           2606    53647 (   cart_items cart_items_product_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_product_id_foreign;
       public          postgres    false    4822    231    229            �           2606    53642 %   cart_items cart_items_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.cart_items DROP CONSTRAINT cart_items_user_id_foreign;
       public          postgres    false    231    4801    218            �           2606    53673 (   order_items order_items_order_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_foreign FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_order_id_foreign;
       public          postgres    false    4826    233    235            �           2606    53678 *   order_items order_items_product_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_product_id_foreign;
       public          postgres    false    235    4822    229            �           2606    53752 %   orders orders_user_address_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_address_id_foreign FOREIGN KEY (user_address_id) REFERENCES public.user_addresses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_address_id_foreign;
       public          postgres    false    243    4843    233            �           2606    53661    orders orders_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_foreign;
       public          postgres    false    4801    218    233            �           2606    53768 0   product_images product_images_product_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.product_images DROP CONSTRAINT product_images_product_id_foreign;
       public          postgres    false    229    245    4822            �           2606    53714 0   product_reviews product_reviews_order_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_order_id_foreign FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.product_reviews DROP CONSTRAINT product_reviews_order_id_foreign;
       public          postgres    false    233    4826    239            �           2606    53709 2   product_reviews product_reviews_product_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.product_reviews DROP CONSTRAINT product_reviews_product_id_foreign;
       public          postgres    false    229    239    4822            �           2606    53704 /   product_reviews product_reviews_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.product_reviews DROP CONSTRAINT product_reviews_user_id_foreign;
       public          postgres    false    4801    239    218            �           2606    53732 %   products products_category_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.products DROP CONSTRAINT products_category_id_foreign;
       public          postgres    false    229    241    4839            �           2606    53747 -   user_addresses user_addresses_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.user_addresses DROP CONSTRAINT user_addresses_user_id_foreign;
       public          postgres    false    4801    218    243            �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�m��n�0����*v���ɀ��,�Ĉ�I��C�c���%3Γ�y�?�a��%k8�x�����}��?�֟em%��1w"ps]�������A�ˮ) AD_��֟0���u߰M�O�j��FT���7n�{�Ho+d{�U*۬B4:M�
ي�S5��P}f=rM��w�	$�a�#H��Ɗ*��(H�͙ϕ���{�%��f�)D��7<�[��[���%���cC      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�}�ێ�0D��cV�v�˿�d�7x&79Ό��m���B"u\��
� B?��G[O&��'����I��E(6�5�JO�|�&�.��섀JC���P�����lCԪ���0���]�.���bS��U��J����D^�L���ء7�6�����I}$�')��L�2?�=}9����Ȱ��*�8t�f��vr��%d�6u�io��|��lF�dP�*���y���< (���?���,Ag�:]�8���5���k 8�_����uԇ��<AsU����~���z�֋"�
��:���)S+�R]M��*�vh箿��s��1��7���AЀ"G�ܹv�f�7����\:�ĳ���I�ı;l��QY�8}�k��&?��X���P�	����jgn׶o���6��.%�5��;K�,cg�_ 
)�-�����7�����?���?����      �   3   x�3�4�4bCs=N##S]s]CS#c+c#+Slb\1z\\\ S�
�      �   p   x�3�4�4��000�30�L��-�I-IM�4202�50�54U02�26�20E3�24�4�45�j�J�)-R�+M/J�HTp�N�.-�,R���s���C CS�c(����� r �      �      x������ � �      �   �   x����JA�u�W�,��T�J�� ݹ�E�BP����DD�,��B	���7��/�u�;����~~z<��u��U��$-1�� B��S�^�e��#�څ���ı3��t���=L��� ��A�A. .c8me3n����;�Tj���н@��Z�H�%���-��N9ka�U"[�L��
cɬ�_,X��u�R1iLXG�Y��ctwE���Z:����v��� ,D��H�a�:�W�< �Jy�      �   �   x�3�4�,(�O)M.)�/su7�J�J5�0˰Ls7�-�r��J�3����r�Nw-p��*H�4202�50�54U04�20�24�&�e�i���#��#�����23�9��5�5�1�2�#1+#�0"0��*�==2,�VF��ĸb���� .�4�      �   <   x�3�4BCNSN���T�Ģļt �^Z�id`d�k`�kh�`dlelaeh�M�+F��� ]�a      �   �   x�m�ˎ�@E��_��U�-6;%QcF���M���y�^L|f<˛��C��[�וn���@x�@�����wQ�\Ov��i��F�t�Ѯ�:��<X���ڛ���F�'�Ȳ�V�d��F�Q���J��ň��Y�>&�^ z����o,���Q����;n�T��,��p8-�[/�駰��oal�f9�2���M����B\ �Oh      �   �  x�=�Mo�0���+|l��#q��=P�@���B������D@�4�~òZ�a��~ޙ��۾�$��8�J����[���^?9�����C=���
�X�*�C{ �S����������j���Z�`\U:��]݆6q�����`�@�s
�i|.��$��&"2�;�_����)�P��/n���t�]ᛎ�҉��i�b��@��(z�^�.S;�or��x�1��aYp<�
}�<|�+�(M����|<�,����W4_?شr�{FY[����2�e~>�)An�׾g�O'F%{�p���Z����ti2�,�t�=jX��U�����M�L�Q)��y7�M�A��ۺ˺F8�"�xG.�
�a�9����	m>7\�j�w}Έ̷�fP
V��d���9���	��C��)�pD���~�1��      �   �   x��ϱn�0���y������8͈!�.EH���p	�ѵ�
O_�00d����p�����z@�P����Z�༒93���邷m���cX�O��TP&),/YQ��]K�W�#t�T���L��N��4��`���-�=����&�vA�?�og�C�n敿Wq��r��]�[}�N��j@o�M�H����f��$I� �p�      �   �   x�m�A
�0 ����@Kv�MCo	�zPJ���*m�� ����qB�i���)��,j�Ȫa���)yHY��2�u�"�����_��h�w;w9��vvq��.���؀q��
Y����^c�X�_Qm#p      �   �   x�m�O��0�����Wk�����v���&H���b-�t����~Iփ1$�7�_^&Ð�֪���41Z�e��&��
YP[�s,f3PE]�����id���c�Q8��D�.N�Ձ.��MP���0�A{^#�me�yƀJ�΢x�Pj��=d�_���v6�ʕ͕_�	�ߗ�2����ɒӉ=���(3�;5�Vi�:��W�ܣ�6�c��T     