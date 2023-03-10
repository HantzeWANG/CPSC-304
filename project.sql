drop table InterviewedBy;
drop table ImmigrationOfficersWorksIn;
drop table InterviewsMakes;
drop table Creates;
drop table Holds;
drop table Applicants;
drop table TravelHistoryRecordsTravelsBy;
drop table InOut;
drop table StudentVisaVerifiedBy;
drop table WorkVisaSponseredBy;
drop table AsylumRefugeeVisa;
drop table TouristVisa;
drop table VisaFromIssue;
drop table Applications;
drop table EmbassyConsulates;
drop table ApprovedInstitutions;

CREATE TABLE ApprovedInstitutions (
    InstitutionID          VARCHAR(100),		
    InstitutionName        VARCHAR(100),
    Category               VARCHAR(100), 
    PRIMARY KEY (InstitutionID)
);
grant select on ApprovedInstitutions to public;

CREATE TABLE EmbassyConsulates (
    ECID            VARCHAR(100)            PRIMARY KEY,
    AddressName     VARCHAR(100)            UNIQUE,
    Country         VARCHAR(100)            NOT NULL
);
grant select on EmbassyConsulates to public;

CREATE TABLE Applications (
    ApplicationID           VARCHAR(100)        PRIMARY KEY,
    StatusOfApp             NUMBER(1)           NOT NULL
);
grant select on Applications to public;

CREATE TABLE VisaFromIssue (
    VisaID          VARCHAR(100)        PRIMARY KEY,
    VisaType        VARCHAR(100),
    ApplicationID   VARCHAR(100)        NOT NULL,
    ECID            VARCHAR(100)        NOT NULL,
    FOREIGN KEY (ApplicationID)
        REFERENCES Applications
        ON DELETE CASCADE,
    FOREIGN KEY (ECID)
        REFERENCES EmbassyConsulates
        ON DELETE CASCADE
);
grant select on VisaFromIssue to public;

CREATE TABLE TouristVisa (
    VisaID      VARCHAR(100)           PRIMARY KEY,
    Destination VARCHAR(100),
    FOREIGN KEY (VisaID)
        REFERENCES VisaFromIssue
        ON DELETE CASCADE
);
grant select on TouristVisa to public;

CREATE TABLE AsylumRefugeeVisa (
    VisaID      VARCHAR(100)        PRIMARY KEY,
    Reason      VARCHAR(100)        NOT NULL,
    FOREIGN KEY (VisaID) 
        REFERENCES VisaFromIssue
        ON DELETE CASCADE
);
grant select on AsylumRefugeeVisa to public;

CREATE TABLE WorkVisaSponseredBy (
    VisaID          VARCHAR(100)        PRIMARY KEY,
    WorkType        VARCHAR(100)        NOT NULL,
    InstitutionID   VARCHAR(100),    
    FOREIGN KEY (VisaID)
        REFERENCES VisaFromIssue
        ON DELETE CASCADE, 
    FOREIGN KEY (InstitutionID)
        REFERENCES ApprovedInstitutions
        ON DELETE SET NULL
);
grant select on WorkVisaSponseredBy to public;

CREATE TABLE StudentVisaVerifiedBy (
    VisaID          VARCHAR(100)		PRIMARY KEY,
    StudyLevel      VARCHAR(100)        NOT NULL,
    InstitutionID   VARCHAR(100),
    FOREIGN KEY (VisaID)
        REFERENCES VisaFromIssue
        ON DELETE CASCADE,
    FOREIGN KEY (InstitutionID) 
        REFERENCES ApprovedInstitutions
        ON DELETE SET NULL
);
grant select on StudentVisaVerifiedBy to public;

CREATE TABLE InOut (
    Destination     VARCHAR(100),
    Departure       VARCHAR(100),
    InOut           NUMBER(1)               NOT NULL,
    PRIMARY KEY (Destination, Departure)
);
grant select on InOut to public;

CREATE TABLE TravelHistoryRecordsTravelsBy (
    RecordID        VARCHAR(100)        PRIMARY KEY,
    TimeOfTravel    TIMESTAMP           NOT NULL,
    Destination     VARCHAR(100)        NOT NULL,
    Departure       VARCHAR(100)        NOT NULL,
    VisaID          VARCHAR(100)        NOT NULL,
    FOREIGN KEY (VisaID)
        REFERENCES VisaFromIssue
        ON DELETE CASCADE,
    FOREIGN KEY (Destination, Departure)
        REFERENCES InOut(Destination, Departure)
);
grant select on TravelHistoryRecordsTravelsBy to public;

CREATE TABLE Applicants (
    ApplicantID             VARCHAR(100)        PRIMARY KEY,
    NameOfApplicants        VARCHAR(100)        NOT NULL,
    Nationality             VARCHAR(100)        NOT NULL,
    DateOfBirth             DATE                NOT NULL
);
grant select on Applicants to public;

CREATE TABLE Holds ( 
    ApplicantID         VARCHAR(100),
    VisaID              VARCHAR(100),
    IssueDate           DATE                NOT NULL,
    ExpirationDate      DATE                NOT NULL,
    PRIMARY KEY (ApplicantID, VisaID),
    FOREIGN KEY (ApplicantID)
        REFERENCES Applicants(ApplicantID)
        ON DELETE CASCADE,
    FOREIGN KEY (VisaID)
        REFERENCES VisaFromIssue(VisaID)
        ON DELETE CASCADE
);
grant select on Holds to public;


CREATE TABLE Creates (
    ApplicantID             VARCHAR(100),
    ApplicationID           VARCHAR(100),
    CreateDate              DATE                    NOT NULL,
    PRIMARY KEY (ApplicantID, ApplicationID),
    FOREIGN KEY (ApplicantID)
        REFERENCES Applicants(ApplicantID),
    FOREIGN KEY (ApplicationID)
        REFERENCES Applications(ApplicationID)
        ON DELETE CASCADE
);
grant select on Creates to public;

CREATE TABLE InterviewsMakes (
    InterviewID         VARCHAR(100),
    TimeOfInterview     TIMESTAMP,
    ApplicationID       VARCHAR(100)        NOT NULL,
    PRIMARY KEY (InterviewID),
    FOREIGN KEY (ApplicationID)
        REFERENCES Applications(ApplicationID)
);
grant select on InterviewsMakes to public;

CREATE TABLE ImmigrationOfficersWorksIn (
    ECID                VARCHAR(100),		
    OfficerID           VARCHAR(100),
    NameOfOfficer       VARCHAR(100)        NOT NULL,
    PRIMARY KEY (ECID, OfficerID),
    FOREIGN KEY (ECID) 
        REFERENCES EmbassyConsulates(ECID)
        ON DELETE CASCADE
);
grant select on ImmigrationOfficersWorksIn to public;

CREATE TABLE InterviewedBy(
    InterviewID         VARCHAR(100),
    ECID                VARCHAR(100),
    OfficerID           VARCHAR(100),
    PRIMARY KEY (InterviewID, ECID, OfficerID),
    FOREIGN KEY (InterviewID)
        REFERENCES InterviewsMakes,
    FOREIGN KEY (ECID, OfficerID)
        REFERENCES ImmigrationOfficersWorksIn(ECID, OfficerID)
        ON DELETE CASCADE
);
grant select on InterviewedBy to public;

INSERT into ApprovedInstitutions VALUES ('EHBG1356', 'University of British Columbia', 'University/College');
INSERT into ApprovedInstitutions VALUES ('ENEA2891', 'University of Toronto', 'University/College');
INSERT into ApprovedInstitutions VALUES ('AHBG1356', 'Amazon', 'Company');
INSERT into ApprovedInstitutions VALUES ('QKCG1920', 'CIBC', 'Company');
INSERT into ApprovedInstitutions VALUES ('QPXM2917', 'Microsoft', 'Company');

INSERT into EmbassyConsulates VALUES ('DBOQ4348', 'Canada House, Trafalgar Sq, London SW1Y 5BJ', 'United Kingdom');
INSERT into EmbassyConsulates VALUES ('RHPW1067', '466 Lexington Ave 20th floor, New York, NY 10017', 'United States');
INSERT into EmbassyConsulates VALUES ('EGHE3624', '501 Pennsylvania Avenue, N.W., Washington, D.C.', 'United States');
INSERT into EmbassyConsulates VALUES ('ECQR2462', '1175 Peachtree Street N.E., Suite 1700, Atlanta, Georgia', 'United States');
INSERT into EmbassyConsulates VALUES ('RHRU2471', 'Leipziger Platz 17, 10117 Berlin', 'Germany');

INSERT into Applications VALUES('11111111', 1);
INSERT into Applications VALUES('44444444', 1);
INSERT into Applications VALUES('66666666', 1);
INSERT into Applications VALUES('77777777', 1);
INSERT into Applications VALUES('22222228', 1);
INSERT into Applications VALUES('11111119', 1);
INSERT into Applications VALUES('66666664', 1);
INSERT into Applications VALUES('77777773', 0);
INSERT into Applications VALUES('35627464', 0);
INSERT into Applications VALUES('24624724', 0);

INSERT into Applications VALUES('32524624', 1);
INSERT into Applications VALUES('46246244', 1);
INSERT into Applications VALUES('87346363', 1);
INSERT into Applications VALUES('02395923', 1);

INSERT into Applications VALUES('32512353', 1);
INSERT into Applications VALUES('62534351', 1);
INSERT into Applications VALUES('63133451', 1);
INSERT into Applications VALUES('01453300', 1);

INSERT into Applications VALUES('51236111', 1);
INSERT into Applications VALUES('06104326', 1);
INSERT into Applications VALUES('67777109', 1);
INSERT into Applications VALUES('61087321', 1);

INSERT into VisaFromIssue VALUES('TETY1471', 'TOURIST', '11111111', 'DBOQ4348');
INSERT into VisaFromIssue VALUES('TQPX2910', 'TOURIST', '44444444', 'RHPW1067');
INSERT into VisaFromIssue VALUES('TREG2135', 'TOURIST', '32524624', 'RHPW1067');
INSERT into VisaFromIssue VALUES('TREG2134', 'TOURIST', '32512353', 'RHPW1067');
INSERT into VisaFromIssue VALUES('TREG2133', 'TOURIST', '51236111', 'RHPW1067');
INSERT into VisaFromIssue VALUES('AEYE2472', 'ASYLUM', '66666666', 'EGHE3624');
INSERT into VisaFromIssue VALUES('AXPQ2041', 'ASYLUM', '77777777', 'ECQR2462');
INSERT into VisaFromIssue VALUES('AFYW3933', 'ASYLUM', '46246244', 'ECQR2462');
INSERT into VisaFromIssue VALUES('AFYW3934', 'ASYLUM', '62534351', 'ECQR2462');
INSERT into VisaFromIssue VALUES('AFYW3034', 'ASYLUM', '06104326', 'ECQR2462');
INSERT into VisaFromIssue VALUES('WBEY1254', 'WORK', '11111119', 'DBOQ4348');
INSERT into VisaFromIssue VALUES('WICN4561', 'WORK', '22222228', 'RHRU2471');
INSERT into VisaFromIssue VALUES('WRYW2754', 'WORK', '87346363', 'RHRU2471');
INSERT into VisaFromIssue VALUES('WRYW2755', 'WORK', '63133451', 'RHRU2471');
INSERT into VisaFromIssue VALUES('WRYW0755', 'WORK', '67777109', 'RHRU2471');
INSERT into VisaFromIssue VALUES('SXTR5137', 'STUDENT', '66666664', 'RHRU2471');
INSERT into VisaFromIssue VALUES('SRYC2471', 'STUDENT', '77777773', 'ECQR2462');
INSERT into VisaFromIssue VALUES('SERE3452', 'STUDENT', '02395923', 'ECQR2462');
INSERT into VisaFromIssue VALUES('SERE3453', 'STUDENT', '01453300', 'ECQR2462');
INSERT into VisaFromIssue VALUES('SERE3450', 'STUDENT', '61087321', 'ECQR2462');

INSERT into TouristVisa VALUES('TETY1471', 'Vancouver');
INSERT into TouristVisa VALUES('TQPX2910', 'Montreal');
INSERT into TouristVisa VALUES('TREG2135', 'Toronto');
INSERT into TouristVisa VALUES('TREG2134', 'Calgary');
INSERT into TouristVisa VALUES('TREG2133', 'Edmonton');

INSERT into AsylumRefugeeVisa VALUES('AEYE2472','Famine');
INSERT into AsylumRefugeeVisa VALUES('AXPQ2041','Political Prosecution');
INSERT into AsylumRefugeeVisa VALUES('AFYW3933', 'War');
INSERT into AsylumRefugeeVisa VALUES('AFYW3934', 'Religious Prosecution');
INSERT into AsylumRefugeeVisa VALUES('AFYW3034', 'Climate Change');

INSERT into WorkVisaSponseredBy VALUES('WBEY1254','Programmer','AHBG1356');
INSERT into WorkVisaSponseredBy VALUES('WICN4561','Analyst','QKCG1920');
INSERT into WorkVisaSponseredBy VALUES('WRYW2754', 'Engineer', 'QPXM2917');
INSERT into WorkVisaSponseredBy VALUES('WRYW2755', 'Cook', 'AHBG1356');
INSERT into WorkVisaSponseredBy VALUES('WRYW0755', 'Gardener', 'QPXM2917');

INSERT into StudentVisaVerifiedBy VALUES('SXTR5137','UNDERGRADUATE','EHBG1356');
INSERT into StudentVisaVerifiedBy VALUES('SRYC2471','UNDERGRADUATE','ENEA2891');
INSERT into StudentVisaVerifiedBy VALUES('SERE3452', 'GRADUATE', 'EHBG1356');
INSERT into StudentVisaVerifiedBy VALUES('SERE3453', 'GRADUATE', 'ENEA2891');
INSERT into StudentVisaVerifiedBy VALUES('SERE3450', 'GRADUATE', 'EHBG1356');

INSERT into InOut VALUES('Canada', 'US', 1);
INSERT into InOut VALUES('US', 'Canada', 0);
INSERT into InOut VALUES('Canada', 'China', 1);
INSERT into InOut VALUES('China', 'Canada', 0);
INSERT into InOut VALUES('Canada', 'Mexico', 1);
INSERT into InOut VALUES('Mexico', 'Canada', 0);
INSERT into InOut VALUES('Canada', 'Germany', 1);
INSERT into InOut VALUES('Germany', 'Canada', 0);

INSERT into TravelHistoryRecordsTravelsBy VALUES('WWW111', TO_TIMESTAMP('2012-12-06 14:34:56.035000', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'Canada', 'US', 'TETY1471');
INSERT into TravelHistoryRecordsTravelsBy VALUES('WWW112', TO_TIMESTAMP('2012-12-28 09:23:22.453000', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'US', 'Canada', 'TETY1471');
INSERT into TravelHistoryRecordsTravelsBy VALUES('WWW113', TO_TIMESTAMP('2013-12-05 12:23:11.123500', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'Canada', 'US', 'TETY1471');
INSERT into TravelHistoryRecordsTravelsBy VALUES('WWW114', TO_TIMESTAMP('2013-12-27 07:10:11.456600', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'US', 'Canada', 'TETY1471');
INSERT into TravelHistoryRecordsTravelsBy VALUES('EEE222', TO_TIMESTAMP('2018-09-30 02:45:23.356100', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'China', 'Canada', 'AEYE2472');
INSERT into TravelHistoryRecordsTravelsBy VALUES('EEE223', TO_TIMESTAMP('2018-11-28 15:03:24.155100', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'Canada', 'China', 'AEYE2472');
INSERT into TravelHistoryRecordsTravelsBy VALUES('RRR444', TO_TIMESTAMP('2015-03-12 07:12:06.462474', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'US', 'Canada', 'SXTR5137');
INSERT into TravelHistoryRecordsTravelsBy VALUES('YYY666', TO_TIMESTAMP('2000-12-25 09:34:50.647246', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'Canada', 'Mexico', 'TQPX2910');
INSERT into TravelHistoryRecordsTravelsBy VALUES('FFF222', TO_TIMESTAMP('2014-04-18 11:52:09.672461', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'Germany', 'Canada', 'SRYC2471');

INSERT into Applicants VALUES('QOXQMDHO', 'Yitang Zhang','China','01-AUG-1996');
INSERT into Applicants VALUES('QKXMSNAM', 'Quinn Holmquist','Haiti','01-JUN-1962');
INSERT into Applicants VALUES('SJZMWISK', 'Kostyantyn Zelensky','Ukraine','01-DEC-1984');
INSERT into Applicants VALUES('WPSMZKSJ', 'Shinichi Mochizuki','Japan','01-AUG-1935');
INSERT into Applicants VALUES('XISMALPQ', 'Naruto Uzumaki','Japan','27-AUG-1999');
INSERT into Applicants VALUES('AMSIEKZP', 'Kakashi Hatake','Japan','27-July-1988');
INSERT into Applicants VALUES('QISMZKLP', 'Jingping Xi','China','01-JAN-1953');
INSERT into Applicants VALUES('ISXWUSPE', 'Xuexiang Ding','China','01-JAN-1990');
INSERT into Applicants VALUES('AIRJXKAL', 'Ping Song','China','01-JAN-1986');
INSERT into Applicants VALUES('WIXNDKXL', 'Yi Wang','China','01-JAN-1975');
INSERT into Applicants VALUES('WIXNDSUW', 'Qi Cai','China','11-FEB-1952');
INSERT into Applicants VALUES('ZKEOXNWB', 'Huning Wang','China','12-JAN-1980');
INSERT into Applicants VALUES('SINCSMSK', 'Miner Chen','China','01-OCT-1948');
INSERT into Applicants VALUES('XIEJABCG', 'Leji Zhao','China','01-SEP-1913');
INSERT into Applicants VALUES('ERIXNSJS', 'Qiang Li','China','01-AUG-2008');
INSERT into Applicants VALUES('SICNFHDK', 'Xingrui Ma','China','01-June-2000');
INSERT into Applicants VALUES('ENSHTAHQ', 'Lebron James','United States','04-June-1989');
INSERT into Applicants VALUES('PSIENDJS', 'Stephen Curry','United States','01-June-1954');
INSERT into Applicants VALUES('SLEODIFN', 'James Harden','United States','13-Apr-1988');
INSERT into Applicants VALUES('WYZMSNJA', 'Will Byers','United States','01-FEB-1955');
INSERT into Applicants VALUES('WPEIDNSH', 'Kevin Love','United States','21-MAR-2000');
INSERT into Applicants VALUES('DJSNZMSJ', 'Ketty Perry','Haiti','21-MAR-1990');
INSERT into Applicants VALUES('DJZIRUEI', 'Ketty Perry','Haiti','21-MAR-1990');
INSERT into Applicants VALUES('ZMDKWPSL', 'Ratni Hamdan','Haiti','24-FEB-1960');
INSERT into Applicants VALUES('PTORNSMD', 'Max Gregor','Haiti','31-MAR-1980');
INSERT into Applicants VALUES('IRNXURHS', 'Rosa Bale','Haiti','30-Apr-1952');
INSERT into Applicants VALUES('RIEPZMCJ', 'James Bowen','Ukraine','01-DEC-1994');
INSERT into Applicants VALUES('FJTUDISM', 'Norlan Heinz','Ukraine','01-NOV-1999');

INSERT into Holds VALUES('QOXQMDHO','TETY1471','12-OCT-2012','12-OCT-2022');
INSERT into Holds VALUES('QKXMSNAM','TQPX2910','12-OCT-2011','12-OCT-2021');
INSERT into Holds VALUES('WPSMZKSJ','AEYE2472','12-OCT-2013','12-OCT-2023');
INSERT into Holds VALUES('SJZMWISK','AXPQ2041','12-OCT-2014','12-OCT-2024');
INSERT into Holds VALUES('QISMZKLP','WBEY1254','12-OCT-2010','12-OCT-2020');
INSERT into Holds VALUES('QOXQMDHO','WICN4561','12-OCT-2012','12-OCT-2022');
INSERT into Holds VALUES('QKXMSNAM','SXTR5137','12-OCT-2011','12-OCT-2021');
INSERT into Holds VALUES('WPSMZKSJ','SRYC2471','12-OCT-2013','12-OCT-2023');

INSERT into Creates VALUES('QOXQMDHO','11111111', '01-JAN-2000');
INSERT into Creates VALUES('QOXQMDHO','44444444', '02-JAN-2000');
INSERT into Creates VALUES('QKXMSNAM','66666666', '03-JAN-2000');
INSERT into Creates VALUES('QKXMSNAM','77777777', '04-JAN-2000');
INSERT into Creates VALUES('SJZMWISK','66666664', '05-JAN-2000');
INSERT into Creates VALUES('WPSMZKSJ','11111119', '06-JAN-2000');
INSERT into Creates VALUES('WPSMZKSJ','22222228', '07-JAN-2000');
INSERT into Creates VALUES('QISMZKLP','77777773', '08-JAN-2000');

INSERT into Creates VALUES('WPEIDNSH', '32524624', '09-JAN-2000');
INSERT into Creates VALUES('WPEIDNSH', '46246244', '10-JAN-2000');
INSERT into Creates VALUES('WPEIDNSH', '87346363', '11-JAN-2000');
INSERT into Creates VALUES('WPEIDNSH', '02395923', '12-JAN-2000');

INSERT into Creates VALUES('WPSMZKSJ', '32512353', '13-JAN-2000');
INSERT into Creates VALUES('WPSMZKSJ', '62534351', '14-JAN-2000');
INSERT into Creates VALUES('WPSMZKSJ', '63133451', '15-JAN-2000');
INSERT into Creates VALUES('WPSMZKSJ', '01453300', '16-JAN-2000');

INSERT into Creates VALUES('XISMALPQ', '51236111', '17-JAN-2000');
INSERT into Creates VALUES('XISMALPQ', '06104326', '18-JAN-2000');
INSERT into Creates VALUES('XISMALPQ', '67777109', '19-JAN-2000');
INSERT into Creates VALUES('XISMALPQ', '61087321', '20-JAN-2000');

INSERT into InterviewsMakes VALUES('ABCD1111', TO_TIMESTAMP('2000-02-25 11:11:11.345673', 'YYYY-MM-DD HH24:MI:SS.FF6'), '11111111');
INSERT into InterviewsMakes VALUES('ABCD4444', TO_TIMESTAMP('2000-03-20 11:12:12.567123', 'YYYY-MM-DD HH24:MI:SS.FF6'), '44444444');
INSERT into InterviewsMakes VALUES('ABCD6666', TO_TIMESTAMP('2000-03-05 11:13:13.524126', 'YYYY-MM-DD HH24:MI:SS.FF6'), '66666666');
INSERT into InterviewsMakes VALUES('ABCD7777', TO_TIMESTAMP('2000-07-15 11:14:14.040011', 'YYYY-MM-DD HH24:MI:SS.FF6'), '77777777');
INSERT into InterviewsMakes VALUES('ABCD8888', TO_TIMESTAMP('2001-12-19 11:15:15.624722', 'YYYY-MM-DD HH24:MI:SS.FF6'), '77777773');

INSERT into ImmigrationOfficersWorksIn VALUES('RHRU2471', 'AAAA1111', 'MingZe Xi');
INSERT into ImmigrationOfficersWorksIn VALUES('RHPW1067', 'BBBB1111', 'Lelouch vi Britannia');
INSERT into ImmigrationOfficersWorksIn VALUES('DBOQ4348', 'CCCC1111', 'Shane Dawson');
INSERT into ImmigrationOfficersWorksIn VALUES('EGHE3624', 'DDDD1111', 'Finn Hudson');
INSERT into ImmigrationOfficersWorksIn VALUES('ECQR2462', 'EEEE1111', 'Georg Hainz');

INSERT into InterviewedBy VALUES('ABCD1111', 'RHRU2471', 'AAAA1111');
INSERT into InterviewedBy VALUES('ABCD4444', 'RHPW1067', 'BBBB1111');
INSERT into InterviewedBy VALUES('ABCD6666', 'DBOQ4348', 'CCCC1111');
INSERT into InterviewedBy VALUES('ABCD7777', 'EGHE3624', 'DDDD1111');
INSERT into InterviewedBy VALUES('ABCD8888', 'ECQR2462', 'EEEE1111');