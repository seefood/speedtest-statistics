CREATE TABLE IF NOT EXISTS "bandwidth" (
  "times" DATETIME PRIMARY KEY NOT NULL UNIQUE ,
  "servername" VARCHAR NOT NULL ,
  "serverid" INTEGER NOT NULL ,
  "latency" FLOAT NOT NULL ,
  "jitter" FLOAT NOT NULL ,
  "packetloss" INTEGER NOT NULL ,
  "download" FLOAT NOT NULL ,
  "upload" FLOAT NOT NULL ,
  "downloadb" INTEGER NOT NULL ,
  "uploadb" FLOAT NOT NULL ,
  "url" VARCHAR NOT NULL,
  "numservers" INTEGER NOT NULL
);
