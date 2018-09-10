CREATE  PROCEDURE refresh_proposals_mv(
)
BEGIN

TRUNCATE TABLE PROPOSALS_MV;
	
INSERT INTO PROPOSALS_MV
(
DOCUMENT_NUMBER,
PROPOSAL_NUMBER,
VER_NBR,
TITLE,
LEAD_UNIT_NUMBER,
LEAD_UNIT,
SPONSOR_CODE,
SPONSOR,
DEADLINE_DATE,
STATUS_CODE,
STATUS,
UPDATE_TIMESTAMP,
UPDATE_USER,
PERSON_ID,
FULL_NAME,
CERTIFIED,
PROP_PERSON_ROLE_CODE
)
SELECT 
	EPS_PROPOSAL.DOCUMENT_NUMBER,
	EPS_PROPOSAL.PROPOSAL_NUMBER,
	EPS_PROPOSAL.VER_NBR,
	EPS_PROPOSAL.TITLE,
	EPS_PROPOSAL.OWNED_BY_UNIT AS LEAD_UNIT_NUMBER, 
	UNIT.UNIT_NAME AS LEAD_UNIT, 
	EPS_PROPOSAL.SPONSOR_CODE,
	SPONSOR.SPONSOR_NAME AS SPONSOR,
	EPS_PROPOSAL.DEADLINE_DATE,
	EPS_PROPOSAL.STATUS_CODE,
	EPS_PROPOSAL_STATUS.DESCRIPTION AS STATUS,
	EPS_PROPOSAL.UPDATE_TIMESTAMP,
	EPS_PROPOSAL.UPDATE_USER,
	T1.PERSON_ID,
	T1.FULL_NAME,
	 IFNULL(T1.OPT_IN_CERTIFICATION_STATUS,'N') AS CERTIFIED,
	T1.PROP_PERSON_ROLE_ID as PROP_PERSON_ROLE_CODE
FROM EPS_PROPOSAL 
INNER JOIN UNIT ON UNIT.UNIT_NUMBER = EPS_PROPOSAL.OWNED_BY_UNIT
LEFT OUTER JOIN SPONSOR ON SPONSOR.SPONSOR_CODE = EPS_PROPOSAL.SPONSOR_CODE
INNER JOIN EPS_PROPOSAL_STATUS ON  EPS_PROPOSAL_STATUS.STATUS_CODE = EPS_PROPOSAL.STATUS_CODE
LEFT OUTER JOIN EPS_PROP_PERSON T1 ON EPS_PROPOSAL.PROPOSAL_NUMBER=T1.PROPOSAL_NUMBER;
COMMIT;
END