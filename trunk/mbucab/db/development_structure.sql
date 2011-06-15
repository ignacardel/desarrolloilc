CREATE TABLE "addresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "street" varchar(255), "name" varchar(255), "number" varchar(255), "zone" varchar(255), "city" varchar(255), "country" varchar(255), "zip" integer, "latitude" float, "longitude" float, "nickname" varchar(255), "client_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "clients" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account" varchar(255), "firstname" varchar(255), "middlename" varchar(255), "lastname" varchar(255), "surname" varchar(255), "birthday" date, "phone" integer, "created_at" datetime, "updated_at" datetime, "active" integer);
CREATE TABLE "companies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "rif" varchar(255), "phone" varchar(255), "fax" varchar(255), "address" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "creditcards" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "number" integer, "expdate" date, "code" integer, "name" varchar(255), "client_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "employees" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account" varchar(255), "password" varchar(255), "name" varchar(255), "lastname" varchar(255), "role" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "date" datetime, "recipient" varchar(255), "longitude" float, "latitude" float, "status" integer, "collectiondate" datetime, "deliverydate" datetime, "address_id" integer, "client_id" integer, "creditcard_id" integer, "created_at" datetime, "updated_at" datetime, "route_id" integer, "street" varchar(255), "name" varchar(255), "number" integer, "zone" varchar(255), "city" varchar(255), "country" varchar(255), "zip" integer, "order_type" integer, "extra" float, "company_id" integer, "external" integer);
CREATE TABLE "packages" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "description" varchar(255), "weight" float, "price" float, "order_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "routes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "employee_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110415140559');

INSERT INTO schema_migrations (version) VALUES ('20110415170626');

INSERT INTO schema_migrations (version) VALUES ('20110415140832');

INSERT INTO schema_migrations (version) VALUES ('20110415142002');

INSERT INTO schema_migrations (version) VALUES ('20110415143937');

INSERT INTO schema_migrations (version) VALUES ('20110415145141');

INSERT INTO schema_migrations (version) VALUES ('20110416182605');

INSERT INTO schema_migrations (version) VALUES ('20110506160314');

INSERT INTO schema_migrations (version) VALUES ('20110526200550');

INSERT INTO schema_migrations (version) VALUES ('20110526202501');

INSERT INTO schema_migrations (version) VALUES ('20110531212745');

INSERT INTO schema_migrations (version) VALUES ('20110531213932');

INSERT INTO schema_migrations (version) VALUES ('20110531224731');

INSERT INTO schema_migrations (version) VALUES ('20110531232536');

INSERT INTO schema_migrations (version) VALUES ('20110607235821');

INSERT INTO schema_migrations (version) VALUES ('20110609194500');