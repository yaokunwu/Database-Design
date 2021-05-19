CREATE TABLE restaurant (
    rname     VARCHAR(30) NOT NULL,
    raddress  VARCHAR(64),
    rid       VARCHAR(10),
    remail    VARCHAR(30),
    rphoneno  CHAR(10),
    rrating   DECIMAL(2, 1),
    PRIMARY KEY ( rid ),
    UNIQUE ( rname )
);

CREATE TABLE customer (
    cid       VARCHAR(10),
    dashpass  char,
    cphoneno  CHAR(10),
    cemail    VARCHAR(30),
    cname     VARCHAR(30) NOT NULL,
    PRIMARY KEY ( cid )
);

CREATE TABLE dasher (
    dname       VARCHAR(30) NOT NULL,
    did         VARCHAR(10),
    demail      VARCHAR(30),
    dphoneno    CHAR(10),
    ssn         CHAR(9),
    deliveryop  VARCHAR(10),
    bacctno     VARCHAR(16),
    numsrating  INTEGER,
    totalstar   INTEGER,
    numsaccp    INTEGER,
    numscomp    INTEGER,
    PRIMARY KEY ( did )
);

CREATE TABLE orderinfo (
    status        VARCHAR(16),
    oid           VARCHAR(10),
    rid           VARCHAR(10),
    cid           VARCHAR(10),
    did           VARCHAR(10),
    placeddate    timestamp,
    deliveryaddr  VARCHAR(64),
    pickupregion  VARCHAR(20),
    pickuptime    timestamp,
    PRIMARY KEY ( oid )
);

CREATE TABLE fooditem (
    fid          VARCHAR(10),
    rid          VARCHAR(10),
    fname        VARCHAR(20),
    fcategory    VARCHAR(20),
    description  VARCHAR(128),
    photo        VARCHAR(64),
    price        decimal,
    PRIMARY KEY ( fid )
);

CREATE TABLE address (
    cid          VARCHAR(10),
    aid          VARCHAR(10),
    street       VARCHAR(20),
    city         VARCHAR(20),
    zipcode      CHAR(5),
    dropoffop    VARCHAR(20),
    dropoffinst  VARCHAR(20),
    aptno        VARCHAR(6),
    state        VARCHAR(20),
    PRIMARY KEY ( aid )
);

CREATE TABLE card (
    cid     VARCHAR(10),
    cardno  VARCHAR(20),
    PRIMARY KEY ( cid,
                  cardno )
);

CREATE TABLE carddetail (
    cardno      VARCHAR(20),
    holdername  VARCHAR(30),
    PRIMARY KEY ( cardno )
);

CREATE TABLE receipt (
    oid  VARCHAR(10),
    sid  VARCHAR(10),
    PRIMARY KEY ( oid,
                  sid )
);

CREATE TABLE receiptdetail (
    sid          VARCHAR(10),
    totalamt     INTEGER,
    deliveryfee  decimal,
    tax          decimal,
    subtotal     decimal,
    tips         decimal,
    servicefee   decimal,
    PRIMARY KEY ( sid )
);

CREATE TABLE vehicle (
    did      VARCHAR(10),
    plateno  VARCHAR(10),
    PRIMARY KEY ( did,
                  plateno )
);

CREATE TABLE vehicledetail (
    plateno  VARCHAR(10),
    color    VARCHAR(10),
    model    VARCHAR(20),
    make     VARCHAR(20),
    PRIMARY KEY ( plateno )
);

CREATE TABLE foodlist (
    oid        VARCHAR(10),
    fid        VARCHAR(10),
    pricesold  decimal,
    qtyorder   INTEGER,
    PRIMARY KEY ( oid,
                  fid )
);

CREATE TABLE restcategory (
    rid        VARCHAR(10),
    rcategory  VARCHAR(20),
    PRIMARY KEY ( rid,
                  rcategory )
);

CREATE TABLE foodreqslt (
    fid         VARCHAR(10),
    foodoption  VARCHAR(20),
    PRIMARY KEY ( fid,
                  foodoption )
);

CREATE TABLE foodoptadd (
    fid       VARCHAR(10),
    addition  VARCHAR(20),
    PRIMARY KEY ( fid,
                  addition )
);

CREATE TABLE insiderece (
    sid  VARCHAR(10),
    fid  VARCHAR(10),
    PRIMARY KEY ( sid,
                  fid )
);

ALTER TABLE orderinfo
    ADD CONSTRAINT ofkcid FOREIGN KEY ( cid )
        REFERENCES customer ( cid );

ALTER TABLE orderinfo
    ADD CONSTRAINT ofkdid FOREIGN KEY ( did )
        REFERENCES dasher ( did );

ALTER TABLE orderinfo
    ADD CONSTRAINT ofkrid FOREIGN KEY ( rid )
        REFERENCES restaurant ( rid );

ALTER TABLE fooditem
    ADD CONSTRAINT fifkrid FOREIGN KEY ( rid )
        REFERENCES restaurant ( rid );

ALTER TABLE address
    ADD CONSTRAINT addfkcid FOREIGN KEY ( cid )
        REFERENCES customer ( cid );

ALTER TABLE card
    ADD CONSTRAINT crdfkcid FOREIGN KEY ( cid )
        REFERENCES customer ( cid );

ALTER TABLE carddetail
    ADD CONSTRAINT cdfkcno FOREIGN KEY ( cardno )
        REFERENCES carddetail ( cardno );

ALTER TABLE receipt
    ADD CONSTRAINT recfkoid FOREIGN KEY ( oid )
        REFERENCES orderinfo ( oid );

-- ALTER TABLE RECEIPTDETAIL ADD CONSTRAINT RDFKSID FOREIGN KEY(SID) REFERENCES RECEIPT(SID);

ALTER TABLE vehicle
    ADD CONSTRAINT vfkdid FOREIGN KEY ( did )
        REFERENCES dasher ( did );

-- ALTER TABLE VEHICLEDETAIL ADD CONSTRAINT VDFKPLATENO FOREIGN KEY(PLATENO) REFERENCES VEHICLE(PLATENO);

ALTER TABLE foodlist
    ADD CONSTRAINT flfkoid FOREIGN KEY ( oid )
        REFERENCES orderinfo ( oid );

ALTER TABLE foodlist
    ADD CONSTRAINT flfkfid FOREIGN KEY ( fid )
        REFERENCES fooditem ( fid );

ALTER TABLE restcategory
    ADD CONSTRAINT rcfkrid FOREIGN KEY ( rid )
        REFERENCES restaurant ( rid );

ALTER TABLE foodreqslt
    ADD CONSTRAINT frfkfid FOREIGN KEY ( fid )
        REFERENCES fooditem ( fid );

ALTER TABLE foodoptadd
    ADD CONSTRAINT fofkfid FOREIGN KEY ( fid )
        REFERENCES fooditem ( fid );

ALTER TABLE insiderece
    ADD CONSTRAINT irfksid FOREIGN KEY ( sid )
        REFERENCES receipt ( sid );

ALTER TABLE insiderece
    ADD CONSTRAINT irfkfid FOREIGN KEY ( fid )
        REFERENCES fooditem ( fid );