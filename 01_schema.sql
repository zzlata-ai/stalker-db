CREATE TABLE Rank (
    RankId        INT PRIMARY KEY,
    RankName      VARCHAR(50) NOT NULL UNIQUE,
    RequiredKills INT NOT NULL CHECK (RequiredKills >= 0) 
);

CREATE TABLE Location (
    LocationId   INT PRIMARY KEY,
    LocationName VARCHAR(100) NOT NULL,
    Vicinity     VARCHAR(100)                                -- окрестности
);


CREATE TABLE Clan (
    ClanId     INT PRIMARY KEY,
    LeaderId   INT,                                       
    LocationId INT,
    ClanName   VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (LocationId) REFERENCES Location(LocationId)
);

CREATE TABLE Stalker (
    StalkerId  INT PRIMARY KEY,
    LastName   VARCHAR(50) NOT NULL,
    FirstName  VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    Nickname   VARCHAR(50),
    PDA        VARCHAR(50),
    RankId     INT,         
    ClanId     INT, 
    LocationId INT,   
    FOREIGN KEY (RankId)     REFERENCES Rank(RankId),
    FOREIGN KEY (ClanId)     REFERENCES Clan(ClanId),
    FOREIGN KEY (LocationId) REFERENCES Location(LocationId)
);

ALTER TABLE Clan
    ADD CONSTRAINT fk_clan_leader FOREIGN KEY (LeaderId) REFERENCES Stalker(StalkerId);

CREATE TABLE ClanRelation (
    RelationId   INT PRIMARY KEY,
    ClanId1      INT NOT NULL REFERENCES Clan(ClanId),
    ClanId2      INT NOT NULL REFERENCES Clan(ClanId),
    RelationType VARCHAR(30) NOT NULL
        CHECK (RelationType IN ('Дружба', 'Вражда', 'Нейтралитет')),
    CHECK (ClanId1 <> ClanId2),
    UNIQUE (ClanId1, ClanId2)
);

CREATE TABLE Ammo (
    AmmoId      INT PRIMARY KEY,
    Description VARCHAR(200),
    Caliber     VARCHAR(30) NOT NULL,
    Type        VARCHAR(50)                                 
);

CREATE TABLE WeaponType (
    WeaponTypeId INT PRIMARY KEY,
    TypeName     VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Weapon (
    WeaponId     INT PRIMARY KEY,
    Name         VARCHAR(100) NOT NULL,
    FireRate     INT NOT NULL CHECK (FireRate > 0),
    Range        INT NOT NULL CHECK (Range > 0),   --дальность
    MagazineSize INT NOT NULL CHECK (MagazineSize > 0),
    Description  VARCHAR(300),
    AmmoId       INT NOT NULL REFERENCES Ammo(AmmoId),
    WeaponTypeId INT NOT NULL REFERENCES WeaponType(WeaponTypeId)
);

CREATE TABLE Artifact (
    ArtifactId INT PRIMARY KEY,
    Name       VARCHAR(100) NOT NULL,
    Cost       DECIMAL(12,2) NOT NULL CHECK (Cost >= 0)
);

CREATE TABLE Anomaly (
    AnomalyId   INT PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Description VARCHAR(300)
);

CREATE TABLE ArtifactAppearance (
    AppearanceId   INT PRIMARY KEY,
    ArtifactId     INT NOT NULL REFERENCES Artifact(ArtifactId),
    AnomalyId      INT NOT NULL REFERENCES Anomaly(AnomalyId),
    AppearanceDate TIMESTAMP NOT NULL
);

CREATE TABLE Quest (
    QuestId    INT PRIMARY KEY,
    GiverId    INT NOT NULL REFERENCES Stalker(StalkerId),
    ArtifactId INT NOT NULL REFERENCES Artifact(ArtifactId),
    WeaponId   INT NOT NULL REFERENCES Weapon(WeaponId),
    ExecutorId INT NOT NULL REFERENCES Stalker(StalkerId)
);
