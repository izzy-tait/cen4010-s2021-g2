
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_GET_PROFILE_ID_NUMBER (IN THIS_MEMBER_ID varchar(255), OUT THIS_MEMBER_NUMBER varchar(255))
	BEGIN
		SELECT MEMBER_NUMBER INTO THIS_MEMBER_NUMBER FROM DEV_MEMBER_PROFILE WHERE MEMBER_ID = THIS_MEMBER_ID LIMIT 1;
	END; //
DELIMITER ;

call DEV_PROFILE_GET_PROFILE_ID_NUMBER ('SUPER_TESTER456',@RetreivedMemberNumber1);
call DEV_PROFILE_GET_PROFILE_ID_NUMBER ('SUPER_TESTER500',@RetreivedMemberNumber2);
call DEV_PROFILE_GET_PROFILE_ID_NUMBER ('SUPER_TESTER590',@RetreivedMemberNumber3);

SELECT @RetreivedMemberNumber1;
SELECT @RetreivedMemberNumber2;
SELECT @RetreivedMemberNumber3;
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_IF_USERNAME_EXISTS (IN USERNAME varchar(255), OUT DOES_EXIST tinyint(1))
BEGIN
    	SELECT MEMBER_ID INTO @USERNAMEHOLDERFROM FROM `DEV_MEMBER_PROFILE` WHERE MEMBER_ID = USERNAME LIMIT 1;
		IF @USERNAMEHOLDERFROM IS NOT NULL
			THEN SET DOES_EXIST = '1';
            ELSE SET DOES_EXIST = '0';
		END IF;
END; //
DELIMITER;
call DEV_PROFILE_IF_USERNAME_EXISTS('SUPER_TESTER456',@Exist_Result1);
SELECT @Exist_Result1;
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_IF_EMAIL_EXISTS (IN THIS_EMAIL_ADDRESS varchar(255), OUT DOES_EXIST tinyint(1))
BEGIN
    IF THIS_EMAIL_ADDRESS = ''
		THEN SET THIS_EMAIL_ADDRESS = 'No Email';	
	END IF;
	SELECT EMAIL_ADDRESS INTO @EMAILHOLDER FROM `DEV_MEMBER_PROFILE` WHERE EMAIL_ADDRESS  = THIS_EMAIL_ADDRESS LIMIT 1;
	IF @EMAILHOLDER IS NOT NULL
			THEN SET DOES_EXIST = '1';
            ELSE SET DOES_EXIST = '0';
	END IF;
END; //
DELIMITER;


call DEV_PROFILE_IF_EMAIL_EXISTS('anyemail@hotmail.com',@Exist_Result1);
SELECT @Exist_Result1;
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_UPDATE_ACTIVITY_LOG (IN THIS_ACTIVITY_TYPE varchar(20),IN THIS_DOER_MEMBER_NUMBER varchar(255),IN THIS_RECIPIENT_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255),IN THIS_MESSAGE_NUMBER varchar(255),IN THIS_BLOCK_NUMBER varchar(255),IN THIS_BLOG_NUMBER varchar(255),IN THIS_MEDIA_NUMBER varchar(255),IN THIS_ACTIVITY_DETAIL varchar(3000), OUT WAS_SUCCESSFUL tinyint(1))
BEGIN
	call DEV_GENERIC_SET_ID_NUMBER('ACTIVITY_NUMBER','ACTIVITY',@NewIDNumber);
    INSERT INTO DEV_ACTIVITY_LOG (ACTIVITY_NUMBER,ACTIVITY_TYPE,DOER_MEMBER_NUMBER,RECIPIENT_MEMBER_NUMBER,QUIZ_NUMBER,MESSAGE_NUMBER,BLOCK_NUMBER,BLOG_NUMBER,MEDIA_NUMBER,ACTIVITY_DETAIL) VALUES(@NewIDNumber,THIS_ACTIVITY_TYPE,THIS_DOER_MEMBER_NUMBER,THIS_RECIPIENT_MEMBER_NUMBER,THIS_QUIZ_NUMBER,THIS_MESSAGE_NUMBER,THIS_BLOCK_NUMBER,THIS_BLOG_NUMBER,THIS_MEDIA_NUMBER,THIS_ACTIVITY_DETAIL);
	SET WAS_SUCCESSFUL = '1';
END; //
DELIMITER;

DEV_UPDATE_ACTIVITY_LOG ('SEND-MESSAGE','PROFILE10001-30','PROFILE10002-7676','','123456789','','','','Sent an email over', @Exist_Result1);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_FRIEND_IS_FRIEND (IN INQUIRING_PROFILE varchar(255),IN PROFILE_IN_QUESTION varchar(255),OUT IS_FRIEND tinyint(1))
	BEGIN
		SELECT FRIENDSHIP_NUMBER INTO @Identified_Friendship FROM `DEV_FRIEND_LIST` WHERE FRIENDOR_MEMBER_NUMBER = INQUIRING_PROFILE AND FRIENDEE_MEMBER_NUMBER = PROFILE_IN_QUESTION AND FRIENDSHIP_REQUEST_STATUS = 'ACCEPTED' OR FRIENDOR_MEMBER_NUMBER = PROFILE_IN_QUESTION AND FRIENDEE_MEMBER_NUMBER = INQUIRING_PROFILE AND FRIENDSHIP_REQUEST_STATUS = 'ACCEPTED' LIMIT 1;
		IF @Identified_Friendship IS NULL
			THEN SET IS_FRIEND = '0';
			ELSE SET IS_FRIEND = '1';
		END IF;
	END; //
DELIMITER ;
CALL DEV_FRIEND_IS_FRIEND('PROFILE10003-681','PROFILE10001-30',@resultboolean);
SELECT @resultboolean;
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_BLOCKING_IS_BLOCKED (IN THIS_BLOCKER_PROFILE_NUMBER varchar(255), IN THIS_BLOCKEE_PROFILE_NUMBER varchar(255),OUT IS_BLOCKED tinyint(1))
	BEGIN
		SELECT BLOCK_RECORD_NUMBER INTO @BlockRecordCapture FROM `DEV_BLOCK_LIST` WHERE BLOCKER_PROFILE_NUMBER = THIS_BLOCKER_PROFILE_NUMBER AND BLOCKEE_PROFILE_NUMBER = THIS_BLOCKEE_PROFILE_NUMBER AND IS_DELETED = 0 OR BLOCKER_PROFILE_NUMBER = THIS_BLOCKEE_PROFILE_NUMBER AND BLOCKEE_PROFILE_NUMBER = THIS_BLOCKER_PROFILE_NUMBER AND IS_DELETED = 0 LIMIT 1;
		IF @BlockRecordCapture IS NULL
			THEN SET IS_BLOCKED = '0';
			ELSE SET IS_BLOCKED = '1';		
		END IF;
	END;//
DELIMITER ;
call DEV_BLOCKING_IS_BLOCKED('BLOCK10002-1182','PROFILE10003-681',@resultant);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_CREATE_PROFILE (IN THIS_MEMBER_ID varchar(80), IN THIS_ENCRYPT_PASSWORD varchar(50), IN THIS_FIRST_NAME varchar(120),IN THIS_LAST_NAME varchar(120), IN THIS_EMAIL_ADDRESS varchar(100),OUT IS_SUCCESSFUL tinyint(1))
	BEGIN
		START TRANSACTION;
			call DEV_GENERIC_SET_ID_NUMBER('MEMBER_NUMBER','PROFILE',@New_ID);
			INSERT INTO `DEV_MEMBER_PROFILE` (MEMBER_NUMBER,MEMBER_ID,ENCRYPT_PASSWORD,FIRST_NAME,LAST_NAME,EMAIL_ADDRESS) VALUES(@New_ID,THIS_MEMBER_ID,THIS_ENCRYPT_PASSWORD,THIS_FIRST_NAME,THIS_LAST_NAME,THIS_EMAIL_ADDRESS);
			call DEV_UPDATE_ACTIVITY_LOG('PROFILE_CREATED',@New_ID,@New_ID,'','','','','','NEW USER CREATED',@success_monitor);
			SET IS_SUCCESSFUL = '1';
		COMMIT;
		 SELECT * FROM `DEV_MEMBER_PROFILE` WHERE MEMBER_NUMBER = @New_ID;
	END;//
DELIMITER ;

call DEV_PROFILE_CREATE_PROFILE ('NewMemberID','PWORD','JOHN','NEW', 'myemail@anyemail.com',@IS_SUCCESSFUL);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_UPDATE_PROFILE (IN THIS_MEMBER_NUMBER varchar(255), IN THIS_MEMBER_ID varchar(80),IN THIS_FIRST_NAME varchar(120), IN THIS_LAST_NAME varchar(120), IN THIS_EMAIL_ADDRESS varchar(100),IN THIS_SEARCHABLE_PROFILE_FLAG tinyint(1))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_MEMBER_PROFILE SET MEMBER_ID = THIS_MEMBER_ID, FIRST_NAME = THIS_FIRST_NAME,LAST_NAME = THIS_LAST_NAME, EMAIL_ADDRESS = THIS_EMAIL_ADDRESS, SEARCHABLE_PROFILE_FLAG = THIS_SEARCHABLE_PROFILE_FLAG WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
			SET @MessageText = CONCAT('PROFILE UPDATED, USERNAME: ',THIS_MEMBER_ID,', FIRST NAME: ',THIS_FIRST_NAME,', LAST NAME: ',THIS_LAST_NAME,', EMAIL ADDRESS: ',THIS_EMAIL_ADDRESS);
			call DEV_UPDATE_ACTIVITY_LOG ('PROFILE_UPDATED',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,'','','','','',@MessageText, @Exist_Result1);
		COMMIT;
		SELECT * FROM DEV_MEMBER_PROFILE WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
	END; //
DELIMITER ;

call DEV_PROFILE_UPDATE_PROFILE ('PROFILE10000-3897', 'SeasonedMember','John', 'West', 'myemail@anyemail.com','1');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_CHANGE_PASSWORD (IN THIS_MEMBER_NUMBER varchar(80),IN THIS_ENCRYPT_PASSWORD varchar(50))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_MEMBER_PROFILE SET ENCRYPT_PASSWORD = THIS_ENCRYPT_PASSWORD WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('PROFILE_PASSWORD',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,'','','','','','PASSWORD CHANGED', @Exist_Result1);
		COMMIT;
		SELECT * FROM DEV_MEMBER_PROFILE WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
	END; //
DELIMITER ;
call DEV_PROFILE_CHANGE_PASSWORD ('PROFILE10000-3897','OLD');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_DELETE_PROFILE(IN THIS_MEMBER_NUMBER varchar(80))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_MEMBER_PROFILE SET IS_ONLINE_FLAG  = '0', LOGICAL_DELETE_FLAG = '1', DATE_DELETED = CURRENT_TIMESTAMP WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('PROFILE_DELETED',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,'','','','','','Profile Deleted', @Exist_Result1);
			SELECT * FROM DEV_MEMBER_PROFILE WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER; 
		COMMIT;
	END; //
DELIMITER ;
call DEV_PROFILE_DELETE_PROFILE('PROFILE10000-3897');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_UN_DELETE_PROFILE(IN THIS_MEMBER_NUMBER varchar(80))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_MEMBER_PROFILE SET LOGICAL_DELETE_FLAG = '0', DATE_DELETED = NULL WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('PROFILE_UN_DELETED',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,'','','','','','Profile Un-Deleted', @Exist_Result1);
			SELECT * FROM DEV_MEMBER_PROFILE WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER; 
		COMMIT;
	END; //
DELIMITER ;
call DEV_PROFILE_UN_DELETE_PROFILE('PROFILE10000-3897');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_SET_STATUS_ONLINE(IN THIS_MEMBER_NUMBER varchar(255))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_MEMBER_PROFILE SET IS_ONLINE_FLAG  = '1' WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('PROFILE_ONLINE',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,'','','','','','User Login', @Exist_Result1);
		COMMIT;
	END; //
DELIMITER ;
call DEV_PROFILE_SET_STATUS_ONLINE('PROFILE10000-1776');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_PROFILE_SET_STATUS_OFFLINE(IN THIS_MEMBER_NUMBER varchar(255))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_MEMBER_PROFILE SET IS_ONLINE_FLAG  = '0' WHERE MEMBER_NUMBER = THIS_MEMBER_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('PROFILE_OFFLINE',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,'','','','','','User Logout', @Exist_Result1);
		COMMIT;
	END; //
DELIMITER;
call DEV_PROFILE_SET_STATUS_OFFLINE('PROFILE10000-1776');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_IF_QUIZ_EXISTS (IN THIS_MEMBER_NUMBER varchar(255), IN THIS_QUIZ_NAME varchar(120), OUT DOES_EXIST tinyint(1))
	BEGIN
		SELECT QUIZ_NUMBER INTO @QUIZNUMBERFILLER FROM `DEV_QUIZ_HEADER` WHERE QUIZ_CREATOR_ID = THIS_MEMBER_NUMBER AND QUIZ_NAME = THIS_QUIZ_NAME;
		IF @QUIZNUMBERFILLER IS NULL 
			THEN SET DOES_EXIST = '0';
			ELSE SET DOES_EXIST = '1';		
		END IF;
		SELECT DOES_EXIST;
	END; //
DELIMITER ;
call DEV_QUIZ_IF_QUIZ_EXISTS('PROFILE10000-2376','My Quiz',@Does_Exist);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_CREATE_QUIZ (IN THIS_QUIZ_NAME varchar(120),IN THIS_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_GENRE varchar(120),IN THIS_PASS_PERCENTAGE decimal(10,10))
	BEGIN
		START TRANSACTION;
			call DEV_GENERIC_SET_ID_NUMBER('QUIZ_NUMBER','QUIZ',@New_Quiz_Number);
			INSERT INTO DEV_QUIZ_HEADER (QUIZ_NUMBER,QUIZ_NAME,QUIZ_CREATOR_ID,QUIZ_GENRE,PASS_PERCENTAGE) VALUES(@New_Quiz_Number,THIS_QUIZ_NAME,THIS_MEMBER_NUMBER,THIS_QUIZ_GENRE,THIS_PASS_PERCENTAGE);
			SET @concatMessage = concat('New Quiz Created: ',THIS_QUIZ_NAME);
			call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_CREATED',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,@New_Quiz_Number,'','','','',@concatMessage, @Exist_Result1);
		COMMIT;
		SELECT * FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = @New_Quiz_Number; 
	END; //
DELIMITER ;
call DEV_QUIZ_CREATE_QUIZ ('My Test Quiz','PROFILE10000-2376','ROCK',0.95);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_CHANGE_QUIZ_HEADER_INFO (IN THIS_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255), IN THIS_QUIZ_NAME varchar(120),IN THIS_QUIZ_GENRE varchar(120),IN THIS_PASS_PERCENTAGE decimal(10,10))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_QUIZ_HEADER SET QUIZ_NAME = THIS_QUIZ_NAME,QUIZ_GENRE = THIS_QUIZ_GENRE,PASS_PERCENTAGE = THIS_PASS_PERCENTAGE, DATE_LAST_EDITED = CURRENT_TIMESTAMP WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_UPDATED',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,THIS_QUIZ_NUMBER,'','','','','Quiz info updated', @Exist_Result1);
		COMMIT;
		SELECT * FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
	END; //
DELIMITER ;
call DEV_QUIZ_CHANGE_QUIZ_HEADER_INFO ('PROFILE10000-2376','QUIZ10002-7398', 'New Quiz Name' ,'SOUL MUSIC',0.90);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_GET_QUIZ (IN THIS_QUIZ_NUMBER varchar(255))
	BEGIN
		START TRANSACTION;
			SELECT DEV_QUIZ_QUESTION.QUIZ_NUMBER, DEV_QUIZ_QUESTION.QUESTION_NUMBER, DEV_QUIZ_QUESTION.MUSIC_SOURCE_URL, DEV_QUIZ_QUESTION.ANSWER_1, DEV_QUIZ_QUESTION.ANSWER_2, DEV_QUIZ_QUESTION.ANSWER_3, DEV_QUIZ_QUESTION.ANSWER_4,DEV_QUIZ_QUESTION.CORRECT_ANSWER, DEV_QUIZ_QUESTION.HINT FROM DEV_QUIZ_QUESTION INNER JOIN DEV_QUIZ_HEADER ON DEV_QUIZ_QUESTION.QUIZ_NUMBER = DEV_QUIZ_HEADER.QUIZ_NUMBER WHERE DEV_QUIZ_QUESTION.QUIZ_NUMBER = THIS_QUIZ_NUMBER AND DEV_QUIZ_QUESTION.IS_DELETED = 0 AND DEV_QUIZ_HEADER.IS_DELETED = 0 ORDER BY DEV_QUIZ_QUESTION.QUESTION_NUMBER;
		COMMIT;
	END; //
DELIMITER ;
call DEV_QUIZ_GET_QUIZ ('QUIZ10002-7398');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_DELETE_QUIZ (IN THIS_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_QUIZ_HEADER SET IS_DELETED = True, DATE_DELETED = Current_Timestamp WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_DELETED',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,THIS_QUIZ_NUMBER,'','','','','Quiz deleted', @Exist_Result1);
			SELECT * FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
		COMMIT;
	END; //
DELIMITER ;
call DEV_QUIZ_DELETE_QUIZ ('PROFILE10000-2376','QUIZ10001-4545');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_ADD_QUESTION (IN THIS_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255),IN TEST_TRIVIA_QUESTION varchar(600),IN TEST_TRIVIA_QUESTION_CREDIT varchar(600),IN THIS_MUSIC_SOURCE_URL varchar(255),IN THIS_ANSWER_1 varchar(255),IN THIS_ANSWER_2 varchar(255),IN THIS_ANSWER_3 varchar(255),IN THIS_ANSWER_4 varchar(255),IN THIS_CORRECT_ANSWER int(11),IN THIS_HINT varchar(255), IN LOG_QUESTION_ADD tinyint(1))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_QUIZ_HEADER SET HIGHEST_QUESTION_NUMBER = HIGHEST_QUESTION_NUMBER + 1 WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			UPDATE DEV_QUIZ_HEADER SET TOTAL_ACTIVE_QUESTIONS = TOTAL_ACTIVE_QUESTIONS + 1 WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			SELECT HIGHEST_QUESTION_NUMBER INTO @New_Question_Number FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER LIMIT 1;
			INSERT INTO DEV_QUIZ_QUESTION (QUIZ_NUMBER,QUESTION_NUMBER,TRIVIA_QUESTION,TRIVIA_QUESTION_CREDIT,MUSIC_SOURCE_URL,ANSWER_1,ANSWER_2,ANSWER_3,ANSWER_4,CORRECT_ANSWER,HINT) VALUES(THIS_QUIZ_NUMBER,@New_Question_Number,TEST_TRIVIA_QUESTION,TEST_TRIVIA_QUESTION_CREDIT,THIS_MUSIC_SOURCE_URL,THIS_ANSWER_1,THIS_ANSWER_2,THIS_ANSWER_3,THIS_ANSWER_4,THIS_CORRECT_ANSWER,THIS_HINT);
			UPDATE DEV_QUIZ_HEADER SET DATE_LAST_EDITED = Current_Timestamp WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			IF LOG_QUESTION_ADD = 1
				THEN call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_QUESTION_ADD',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,THIS_QUIZ_NUMBER,'','','','',concat('Question ',@New_Question_Number,' has been added.'), @Exist_Result1);
			END IF;
		COMMIT;
		SELECT * FROM DEV_QUIZ_QUESTION WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER AND QUESTION_NUMBER = @New_Question_Number;
	END; //
DELIMITER ;
call DEV_QUIZ_ADD_QUESTION ('PROFILE10000-2376','QUIZ10000-6466','Test Question To Be Answered','SELF','http://www.anylink.com', 'Answer 1','Answer 2','Answer 3','Answer 4','2','It is Number 2', '1');
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_DELETE_QUESTION (IN THIS_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255),IN THIS_QUESTION_NUMBER int(100))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_QUIZ_HEADER SET TOTAL_ACTIVE_QUESTIONS = TOTAL_ACTIVE_QUESTIONS - 1 WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			UPDATE DEV_QUIZ_QUESTION SET IS_DELETED = TRUE, DATE_DELETED = Current_Timestamp WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER AND QUESTION_NUMBER = THIS_QUESTION_NUMBER;
			UPDATE DEV_QUIZ_HEADER SET DATE_LAST_EDITED = Current_Timestamp WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_QUESTION_DEL',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,THIS_QUIZ_NUMBER,'','','','',concat('Question ',THIS_QUESTION_NUMBER,' has been deleted.'), @Exist_Result1);
		COMMIT;
		SELECT * FROM DEV_QUIZ_QUESTION WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER AND QUESTION_NUMBER = THIS_QUESTION_NUMBER;
	END; //
DELIMITER ;
call DEV_QUIZ_DELETE_QUESTION ('PROFILE10000-2376','QUIZ10002-7398',3);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_COMPLETE_QUIZ_HEADER (IN THIS_QUIZ_NUMBER varchar(255),IN THIS_QUIZ_COMPLETER_NUMBER varchar(255),IN THIS_TOTAL_QUESTIONS int(100),IN THIS_TOTAL_QUESTIONS_CORRECT int(100),IN THIS_SCORE decimal(10,10))
	BEGIN
		START TRANSACTION;
		SELECT QUIZ_CREATOR_ID INTO @Quiz_Creator FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER LIMIT 1;
		SELECT PASS_PERCENTAGE INTO @PassValue FROM DEV_QUIZ_HEADER WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER LIMIT 1;
		SET @Did_Pass = 1;
		IF THIS_SCORE < @PassValue
			THEN SET @Did_Pass = '0';
			ELSE SET @Did_Pass = '1';
		END IF;
		call DEV_GENERIC_SET_ID_NUMBER('QUIZ_HISTORY_NUMBER','QUIZHIST',@New_Quiz_Hist_Number);
		INSERT INTO DEV_QUIZ_HISTORY_HEADER (QUIZ_HISTORY_NUMBER,QUIZ_NUMBER,QUIZ_CREATOR_NUMBER,QUIZ_COMPLETER_NUMBER,TOTAL_QUESTIONS,TOTAL_QUESTIONS_CORRECT,SCORE,IS_PASSING) VALUES(@New_Quiz_Hist_Number,THIS_QUIZ_NUMBER,@Quiz_Creator,THIS_QUIZ_COMPLETER_NUMBER,THIS_TOTAL_QUESTIONS,THIS_TOTAL_QUESTIONS_CORRECT,THIS_SCORE,@Did_Pass);
		call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_COMPLETED',THIS_QUIZ_COMPLETER_NUMBER,@Quiz_Creator,THIS_QUIZ_NUMBER,'','','','',concat('Quiz completed by user with a score of: ',FORMAT(THIS_SCORE,2),'.'), @Exist_Result1);
		COMMIT;
		SELECT * FROM DEV_QUIZ_HISTORY_HEADER WHERE QUIZ_HISTORY_NUMBER = @New_Quiz_Hist_Number;
	END; //
DELIMITER ;
DEV_QUIZ_COMPLETE_QUIZ_HEADER ('QUIZ10002-7398','PROFILE10000-8888',10,7,0.70);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_COMPLETED_QUIZ_QUESTION (IN THIS_QUIZ_HISTORY_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255),IN THIS_QUESTION_NUMBER int(100),IN THIS_ANSWER_CHOSEN int(11))
	BEGIN
		START TRANSACTION;
			SELECT TRIVIA_QUESTION,TRIVIA_QUESTION_CREDIT,MUSIC_SOURCE_URL,ANSWER_1,ANSWER_2,ANSWER_3,ANSWER_4,CORRECT_ANSWER INTO @TRIV_QUESTION,@TRIV_CRED,@MUSIC_SOURCE,@ANS1,@ANS2,@ANS3,@ANS4,@CORRECT_ANS FROM DEV_QUIZ_QUESTION WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER AND QUESTION_NUMBER = THIS_QUESTION_NUMBER LIMIT 1;
			INSERT INTO DEV_QUIZ_HISTORY_QUESTION (QUIZ_HISTORY_NUMBER,QUIZ_NUMBER,QUESTION_NUMBER,TRIVIA_QUESTION,TRIVIA_QUESTION_CREDIT,MUSIC_SOURCE_URL,ANSWER_1,ANSWER_2,ANSWER_3,ANSWER_4,ANSWER_CHOSEN,CORRECT_ANSWER) VALUES(THIS_QUIZ_HISTORY_NUMBER,THIS_QUIZ_NUMBER,THIS_QUESTION_NUMBER,@TRIV_QUESTION,@TRIV_CRED,@MUSIC_SOURCE,@ANS1,@ANS2,@ANS3,@ANS4,THIS_ANSWER_CHOSEN,@CORRECT_ANS);
		COMMIT;
	END; //
DELIMITER ;
call DEV_QUIZ_COMPLETED_QUIZ_QUESTION ('QUIZHIST10000-3357','QUIZ10000-6466',1,3);
=========================================================================================================================================================
DELIMITER //
CREATE PROCEDURE DEV_QUIZ_EDIT_QUESTION(IN THIS_MEMBER_NUMBER varchar(255),IN THIS_QUIZ_NUMBER varchar(255),IN THIS_QUESTION_NUMBER int(100),IN TEST_TRIVIA_QUESTION varchar(600),IN TEST_TRIVIA_QUESTION_CREDIT varchar(600),IN THIS_MUSIC_SOURCE_URL varchar(1000),IN THIS_ANSWER_1 varchar(255),IN THIS_ANSWER_2 varchar(255),IN THIS_ANSWER_3 varchar(255),IN THIS_ANSWER_4 varchar(255),IN THIS_CORRECT_ANSWER int(11),IN THIS_HINT varchar(255), IN LOG_QUESTION_ADD tinyint(1))
	BEGIN
		START TRANSACTION;
			UPDATE DEV_QUIZ_QUESTION SET TRIVIA_QUESTION = TEST_TRIVIA_QUESTION,TRIVIA_QUESTION_CREDIT = TEST_TRIVIA_QUESTION_CREDIT,MUSIC_SOURCE_URL = THIS_MUSIC_SOURCE_URL,ANSWER_1 = THIS_ANSWER_1,ANSWER_2 = THIS_ANSWER_2,ANSWER_3 = THIS_ANSWER_3,ANSWER_4 = THIS_ANSWER_4,CORRECT_ANSWER = THIS_CORRECT_ANSWER,HINT = THIS_HINT WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER AND QUESTION_NUMBER = THIS_QUESTION_NUMBER;
			UPDATE DEV_QUIZ_HEADER SET DATE_LAST_EDITED = Current_Timestamp WHERE QUIZ_NUMBER = THIS_QUIZ_NUMBER;
			IF LOG_QUESTION_ADD = 1
				THEN call DEV_UPDATE_ACTIVITY_LOG ('QUIZ_QUESTION_EDIT',THIS_MEMBER_NUMBER,THIS_MEMBER_NUMBER,THIS_QUIZ_NUMBER,'','','','',concat('Question ',THIS_QUESTION_NUMBER,' has been updated.'), @Exist_Result1);
			END IF;
		COMMIT; 
	END; //
DELIMITER ;