PACKAGE BODY wwv_flow_approval_api AS
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 G_MESSAGE_CACHE WWV_FLOW_GLOBAL.VC_MAP;
 
 FUNCTION GET_RUNTIME_MESSAGE (
     P_NAME IN VARCHAR2 )
     RETURN VARCHAR2
 IS
 BEGIN
     IF NOT G_MESSAGE_CACHE.EXISTS( P_NAME ) THEN
         G_MESSAGE_CACHE( P_NAME ) := WWV_FLOW_LANG.RUNTIME_MESSAGE( P_NAME );
     END IF;
     RETURN G_MESSAGE_CACHE( P_NAME );
 END GET_RUNTIME_MESSAGE;
 
 
 
 
 FUNCTION CREATE_TASK(
     P_APPLICATION_ID         IN NUMBER                   DEFAULT WWV_FLOW.G_FLOW_ID,
     P_TASK_DEF_STATIC_ID     IN VARCHAR2,
     P_SUBJECT                IN VARCHAR2                 DEFAULT NULL,
     P_PARAMETERS             IN T_TASK_PARAMETERS        DEFAULT C_EMPTY_TASK_PARAMETERS,
     P_PRIORITY               IN INTEGER                  DEFAULT NULL,
     P_INITIATOR              IN VARCHAR2                 DEFAULT NULL,
     P_DETAIL_PK              IN VARCHAR2                 DEFAULT NULL,
     P_DUE_DATE               IN TIMESTAMP WITH TIME ZONE DEFAULT NULL)
 RETURN NUMBER
 IS
     L_TASK_DEF_ID NUMBER;
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER( 'create_task',
                               'p_application_id',     P_APPLICATION_ID,
                               'p_task_def_static_id', P_TASK_DEF_STATIC_ID,
                               'p_priority',           P_PRIORITY,
                               'p_initiator',          P_INITIATOR,
                               'p_detail_pk',          P_DETAIL_PK,
                               'p_due_date',           P_DUE_DATE);
     END IF;
 
     L_TASK_DEF_ID := WWV_FLOW_APPROVAL.GET_TASK_DEF_ID(
         P_APPLICATION_ID, 
         P_TASK_DEF_STATIC_ID);
 
     RETURN WWV_FLOW_APPROVAL.CREATE_TASK(
         P_APPLICATION_ID => P_APPLICATION_ID,
         P_TASK_DEF_ID    => L_TASK_DEF_ID,
         P_SUBJECT        => P_SUBJECT,
         P_PARAMETERS     => P_PARAMETERS,
         P_PRIORITY       => P_PRIORITY,
         P_INITIATOR      => P_INITIATOR,
         P_DETAIL_PK      => P_DETAIL_PK,
         P_DUE_DATE       => P_DUE_DATE);
 END CREATE_TASK;
 
 
 
 
 
 PROCEDURE ADD_TASK_COMMENT(
     P_TASK_ID                IN NUMBER,
     P_TEXT                   IN VARCHAR2)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('add_task_comment',
                              'p_task_id',        P_TASK_ID,
                              'p_text',           P_TEXT);
     END IF;
 
     WWV_FLOW_APPROVAL.ADD_TASK_COMMENT(
         P_TASK_ID,
         P_TEXT);
 END ADD_TASK_COMMENT;
 
 
 
 
 PROCEDURE ADD_TASK_POTENTIAL_OWNER(
     P_TASK_ID                IN NUMBER,
     P_POTENTIAL_OWNER        IN VARCHAR2,
     P_IDENTITY_TYPE          IN T_TASK_IDENTITY_TYPE DEFAULT C_TASK_IDENTITY_TYPE_USER)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN    
         WWV_FLOW_DEBUG.ENTER('add_task_potential_owner',
                             'p_task_id', P_TASK_ID,
                             'p_potential_owner', P_POTENTIAL_OWNER,
                             'p_identity_type', P_IDENTITY_TYPE);
     END IF;
     
     WWV_FLOW_APPROVAL.ADD_TASK_POTENTIAL_OWNER(
         P_TASK_ID,
         P_POTENTIAL_OWNER,
         P_IDENTITY_TYPE);
 END ADD_TASK_POTENTIAL_OWNER;
 
 
 
 
 PROCEDURE REMOVE_POTENTIAL_OWNER(
     P_TASK_ID                IN NUMBER,
     P_POTENTIAL_OWNER        IN VARCHAR2) 
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN    
         WWV_FLOW_DEBUG.ENTER('remove_potential_owner',
                             'p_task_id', P_TASK_ID,
                             'p_potential_owner', P_POTENTIAL_OWNER);
     END IF;
     
     WWV_FLOW_APPROVAL.REMOVE_POTENTIAL_OWNER(
         P_TASK_ID,
         P_POTENTIAL_OWNER);
 END REMOVE_POTENTIAL_OWNER;
 
 
 
 
 
 PROCEDURE CLAIM_TASK(
     P_TASK_ID                IN NUMBER)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('claim_task',
                              'p_task_id', P_TASK_ID);
     END IF;
     WWV_FLOW_APPROVAL.CLAIM_TASK(P_TASK_ID);
 END CLAIM_TASK;
  
 
 
 
 PROCEDURE COMPLETE_TASK(
     P_TASK_ID                IN NUMBER,
     P_OUTCOME                IN T_TASK_OUTCOME DEFAULT NULL,
     P_AUTOCLAIM              IN BOOLEAN DEFAULT FALSE )
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('complete_task',
                              'p_task_id', P_TASK_ID,
                              'p_outcome', P_OUTCOME,
                              'p_autoclaim',CASE WHEN P_AUTOCLAIM THEN 'TRUE' ELSE 'FALSE' END );
     END IF;
     WWV_FLOW_APPROVAL.COMPLETE_TASK(
         P_TASK_ID   => P_TASK_ID, 
         P_OUTCOME   => P_OUTCOME,
         P_AUTOCLAIM => P_AUTOCLAIM);
 END COMPLETE_TASK;
 
 
 
 
 PROCEDURE APPROVE_TASK(
     P_TASK_ID                IN NUMBER,
     P_AUTOCLAIM              IN BOOLEAN DEFAULT FALSE )
 IS
 BEGIN
     COMPLETE_TASK(
         P_TASK_ID   => P_TASK_ID, 
         P_OUTCOME   => C_TASK_OUTCOME_APPROVED,
         P_AUTOCLAIM => P_AUTOCLAIM);
 END APPROVE_TASK;
  
 
 
 
 PROCEDURE REJECT_TASK(
     P_TASK_ID                IN NUMBER,
     P_AUTOCLAIM              IN BOOLEAN DEFAULT FALSE )
 
 IS
 BEGIN
     COMPLETE_TASK(
         P_TASK_ID   => P_TASK_ID, 
         P_OUTCOME   => C_TASK_OUTCOME_REJECTED,
         P_AUTOCLAIM => P_AUTOCLAIM);
 END REJECT_TASK;
 
 
 
 
 PROCEDURE DELEGATE_TASK(
     P_TASK_ID                IN NUMBER,
     P_TO_USER                IN VARCHAR2)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('delegate_task',
                              'p_task_id'    , P_TASK_ID,
                              'p_to_user', P_TO_USER);
     END IF;
 
     WWV_FLOW_APPROVAL.DELEGATE_TASK(
         P_TASK_ID => P_TASK_ID, 
         P_TO_USER => P_TO_USER);
 END DELEGATE_TASK;
 
 
 
 
 FUNCTION RENEW_TASK(
     P_TASK_ID                IN NUMBER,
     P_PRIORITY               IN INTEGER DEFAULT NULL,
     P_DUE_DATE               IN TIMESTAMP WITH TIME ZONE) 
 RETURN NUMBER
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('renew_task',
                              'p_task_id',  P_TASK_ID,
                              'p_priority', P_PRIORITY,
                              'p_due_date', P_DUE_DATE);
     END IF;
 
     RETURN WWV_FLOW_APPROVAL.RENEW_TASK(
         P_TASK_ID  => P_TASK_ID,
         P_PRIORITY => P_PRIORITY,
         P_DUE_DATE => P_DUE_DATE);
 END RENEW_TASK;
    
 
 
 
 FUNCTION GET_TASK_PARAMETER_VALUE(
     P_TASK_ID                IN NUMBER,
     P_PARAM_STATIC_ID        IN VARCHAR2,
     P_IGNORE_NOT_FOUND       IN BOOLEAN DEFAULT FALSE)
 RETURN VARCHAR2
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER( 'get_task_parameter_value',
                               'p_task_id'         , P_TASK_ID,
                               'p_param_static_id' , P_PARAM_STATIC_ID,
                               'p_ignore_not_found', CASE P_IGNORE_NOT_FOUND WHEN TRUE THEN 'true' ELSE 'false' END);
     END IF;
     RETURN WWV_FLOW_APPROVAL.GET_TASK_PARAMETER_VALUE(
         P_TASK_ID,
         P_PARAM_STATIC_ID,
         P_IGNORE_NOT_FOUND);
 END GET_TASK_PARAMETER_VALUE;
 
 
 
 
 PROCEDURE SET_TASK_PARAMETER_VALUES(
     P_TASK_ID                IN NUMBER,
     P_PARAMETERS             IN T_TASK_PARAMETERS,
     P_RAISE_ERROR            IN BOOLEAN DEFAULT TRUE)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER( 'set_task_parameter_value',
                               'p_task_id'         , P_TASK_ID,
                               'p_raise_error'     , WWV_FLOW_DEBUG.TOCHAR(P_RAISE_ERROR));
     END IF;
     
     WWV_FLOW_APPROVAL.SET_TASK_PARAMETER_VALUES(
         P_TASK_ID     => P_TASK_ID,
         P_PARAMETERS  => P_PARAMETERS,
         P_RAISE_ERROR => P_RAISE_ERROR);
 END SET_TASK_PARAMETER_VALUES;
 
 
 
 
 FUNCTION HAS_TASK_PARAM_CHANGED(
              P_TASK_ID                IN NUMBER,
              P_PARAM_STATIC_ID        IN VARCHAR2) 
 RETURN BOOLEAN
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER( 'has_task_param_changed',
                               'p_task_id'         , P_TASK_ID,
                               'p_param_static_id',  P_PARAM_STATIC_ID);
     END IF;
     RETURN WWV_FLOW_APPROVAL.HAS_TASK_PARAM_CHANGED(
         P_TASK_ID          => P_TASK_ID,
         P_PARAM_STATIC_ID  => P_PARAM_STATIC_ID);
 END HAS_TASK_PARAM_CHANGED;
 
 
 
 FUNCTION GET_TASK_PARAMETER_OLD_VALUE(
     P_TASK_ID                IN NUMBER,
     P_PARAM_STATIC_ID        IN VARCHAR2,
     P_RAISE_ERROR            IN BOOLEAN   DEFAULT TRUE) 
 RETURN VARCHAR2
 IS 
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER( 'get_task_parameter_old_value',
                               'p_task_id'         , P_TASK_ID,
                               'p_param_static_id' , P_PARAM_STATIC_ID,
                               'p_raise_error'     ,WWV_FLOW_DEBUG.TOCHAR(P_RAISE_ERROR));
     END IF;
     RETURN WWV_FLOW_APPROVAL.GET_TASK_PARAMETER_OLD_VALUE(
         P_TASK_ID         => P_TASK_ID,
         P_PARAM_STATIC_ID => P_PARAM_STATIC_ID,
         P_RAISE_ERROR     => P_RAISE_ERROR);  
 END GET_TASK_PARAMETER_OLD_VALUE;
 
 
 
 
 PROCEDURE CANCEL_TASK(
     P_TASK_ID                IN NUMBER)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('cancel_task',
                              'p_task_id', P_TASK_ID);
     END IF;
 
     WWV_FLOW_APPROVAL.CANCEL_TASK(P_TASK_ID => P_TASK_ID);
 END CANCEL_TASK;
 
  
 
 
 
 PROCEDURE RELEASE_TASK(
     P_TASK_ID                IN NUMBER)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('release_task',
                              'p_task_id', P_TASK_ID);
     END IF;
 
     WWV_FLOW_APPROVAL.RELEASE_TASK(P_TASK_ID => P_TASK_ID);
 END RELEASE_TASK;
 
   
 
 
 
 PROCEDURE SET_TASK_PRIORITY(
     P_TASK_ID                IN NUMBER,
     P_PRIORITY               IN INTEGER)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('set_task_priority',
                              'p_task_id', P_TASK_ID,
                              'p_priority', P_PRIORITY);
     END IF;
 
     WWV_FLOW_APPROVAL.SET_TASK_PRIORITY(P_TASK_ID  => P_TASK_ID, 
                                         P_PRIORITY => P_PRIORITY);
 END SET_TASK_PRIORITY;
 
 
 
 
 PROCEDURE REQUEST_MORE_INFORMATION(
     P_TASK_ID                IN NUMBER,
     P_TEXT                   IN VARCHAR2)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('request_more_information',
                              'p_task_id', P_TASK_ID,
                              'p_text', P_TEXT);
     END IF;
 
     WWV_FLOW_APPROVAL.REQUEST_INFO(P_TASK_ID => P_TASK_ID, 
                                    P_TEXT    => P_TEXT);
 END REQUEST_MORE_INFORMATION; 
 
 
 
 
 PROCEDURE SUBMIT_INFORMATION(
     P_TASK_ID                IN NUMBER,
     P_TEXT                   IN VARCHAR2)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('submit_information',
                              'p_task_id', P_TASK_ID,
                              'p_text', P_TEXT);
     END IF;
 
     WWV_FLOW_APPROVAL.SUBMIT_INFO( P_TASK_ID => P_TASK_ID, 
                                    P_TEXT    => P_TEXT);
 END SUBMIT_INFORMATION; 
 
 
 
 
 PROCEDURE SET_TASK_DUE(
     P_TASK_ID                IN NUMBER,
     P_DUE_DATE               IN TIMESTAMP WITH TIME ZONE)
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('set_task_due',
                              'p_task_id', P_TASK_ID,
                              'p_due_date', P_DUE_DATE);
     END IF;
 
     WWV_FLOW_APPROVAL.SET_TASK_DUE_DATE(P_TASK_ID  => P_TASK_ID, 
                                         P_DUE_DATE => P_DUE_DATE);
 END SET_TASK_DUE;
 
 
 
 
 FUNCTION IS_OF_PARTICIPANT_TYPE(
     P_TASK_ID                IN NUMBER,
     P_PARTICIPANT_TYPE       IN T_TASK_PARTICIPANT_TYPE
                                 DEFAULT C_TASK_POTENTIAL_OWNER,
     P_USER                   IN VARCHAR2 
                                 DEFAULT WWV_FLOW_SECURITY.G_USER)
 RETURN BOOLEAN
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('is_of_participant_type',
                              'p_task_id'         , P_TASK_ID,
                              'p_participant_type', P_PARTICIPANT_TYPE,
                              'p_user'            , P_USER);
     END IF;
 
     RETURN WWV_FLOW_APPROVAL.IS_OF_PARTICIPANT_TYPE(
         P_TASK_ID          => P_TASK_ID,
         P_PARTICIPANT_TYPE => P_PARTICIPANT_TYPE,
         P_USER             => P_USER);
 END IS_OF_PARTICIPANT_TYPE;
   
 
 
 
 FUNCTION IS_ALLOWED(
     P_TASK_ID                IN NUMBER,
     P_OPERATION              IN WWV_FLOW_APPROVAL_API.T_TASK_OPERATION,
     P_USER                   IN VARCHAR2 DEFAULT WWV_FLOW_SECURITY.G_USER,
     P_NEW_PARTICIPANT        IN VARCHAR2 DEFAULT NULL)
 RETURN BOOLEAN
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('is_allowed',
                              'p_task_id'           , P_TASK_ID,
                              'p_operation'         , P_OPERATION,
                              'p_user'              , P_USER,
                              'p_new_participant'   , P_NEW_PARTICIPANT);
     END IF;
 
     RETURN WWV_FLOW_APPROVAL.IS_ALLOWED(
         P_TASK_ID         => P_TASK_ID,
         P_OPERATION       => P_OPERATION,
         P_USER            => P_USER,
         P_NEW_PARTICIPANT => P_NEW_PARTICIPANT);
 END IS_ALLOWED;
 
 
 
 
 FUNCTION IS_BUSINESS_ADMIN(
     P_USER IN VARCHAR2 DEFAULT WWV_FLOW_SECURITY.G_USER,
     P_APPLICATION_ID IN NUMBER   DEFAULT NULL)
 RETURN BOOLEAN
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('is_business_admin',
                              'p_user'           , P_USER,
                              'p_application_id' , P_APPLICATION_ID);
     END IF;
 
     RETURN WWV_FLOW_APPROVAL.IS_BUSINESS_ADMIN(
            P_USER           => P_USER,
            P_APPLICATION_ID => P_APPLICATION_ID);
 END IS_BUSINESS_ADMIN;
 
 
 
 
 PROCEDURE ADD_TO_HISTORY (
     P_MESSAGE IN VARCHAR2 )
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('add_to_history',
                              'p_message', P_MESSAGE);
     END IF;
 
     WWV_FLOW_APPROVAL.ADD_ACTION_TO_HISTORY(P_MESSAGE => P_MESSAGE);
 END ADD_TO_HISTORY; 
 
 
 
 
 PROCEDURE HANDLE_TASK_DEADLINES
 IS
 BEGIN
     WWV_FLOW_IMP.CHECK_SGID;
     IF WWV_FLOW.G_DEBUG THEN
         WWV_FLOW_DEBUG.ENTER('handle_task_deadlines');
     END IF;
 
     WWV_FLOW_APPROVAL.HANDLE_TASK_DEADLINES;
 END HANDLE_TASK_DEADLINES;
 
 
 
 
 FUNCTION GET_TASKS(
     P_CONTEXT            IN VARCHAR2 DEFAULT WWV_FLOW_APPROVAL_API.C_CONTEXT_MY_TASKS,
     P_USER               IN VARCHAR2 DEFAULT WWV_FLOW_SECURITY.G_USER,
     P_TASK_ID            IN NUMBER   DEFAULT NULL,
     P_APPLICATION_ID     IN NUMBER   DEFAULT NULL,
     P_SHOW_EXPIRED_TASKS IN VARCHAR2 DEFAULT 'N' )
 RETURN WWV_FLOW_T_APPROVAL_TASKS PIPELINED 
 IS
     TYPE T_TASK_ROW IS RECORD (
         TASK_ID                 NUMBER,
         TASK_DEF_ID             NUMBER,
         TASK_DEF_NAME           VARCHAR2(255),
         TASK_DEF_STATIC_ID      VARCHAR2(255),
         SUBJECT                 VARCHAR2(1000),
         TASK_TYPE               VARCHAR2(32),
         DETAILS_APP_ID          NUMBER,
         DETAILS_APP_NAME        VARCHAR2(255),
         DETAILS_LINK_TARGET     VARCHAR2(4000),
         DUE_ON                  TIMESTAMP WITH TIME ZONE,
         DUE_IN_HOURS            NUMBER,
         PRIORITY                NUMBER(1),
         INITIATOR               VARCHAR2(255),
         INITIATOR_LOWER         VARCHAR2(255),
         ACTUAL_OWNER            VARCHAR2(255),
         ACTUAL_OWNER_LOWER      VARCHAR2(255),
         STATE_CODE              VARCHAR2(32),
         OUTCOME_CODE            VARCHAR2(32),
         CREATED_AGO_HOURS       NUMBER,
         CREATED_BY              VARCHAR2(255),
         CREATED_ON              TIMESTAMP WITH TIME ZONE,
         LAST_UPDATED_BY         VARCHAR2(255),
         LAST_UPDATED_ON         TIMESTAMP WITH TIME ZONE);
     
     L_CUR      SYS_REFCURSOR;
     L_ROW      T_TASK_ROW;
     L_TASK     WWV_FLOW_T_APPROVAL_TASK;
     L_MESSAGES WWV_FLOW_GLOBAL.VC_MAP;
     
     PROCEDURE PROCESS_ROW IS
     BEGIN
         L_TASK.APP_ID                  := WWV_FLOW_SECURITY.G_FLOW_ID;
         L_TASK.TASK_ID                 := L_ROW.TASK_ID;
         L_TASK.TASK_DEF_ID             := L_ROW.TASK_DEF_ID;
         L_TASK.TASK_DEF_NAME           := L_ROW.TASK_DEF_NAME;
         L_TASK.TASK_DEF_STATIC_ID      := L_ROW.TASK_DEF_STATIC_ID;
         L_TASK.SUBJECT                 := L_ROW.SUBJECT;
         L_TASK.TASK_TYPE               := L_ROW.TASK_TYPE;
         L_TASK.DETAILS_APP_ID          := L_ROW.DETAILS_APP_ID;
         L_TASK.DETAILS_APP_NAME        := L_ROW.DETAILS_APP_NAME;
         L_TASK.DETAILS_LINK_TARGET     := WWV_FLOW_SESSION_STATE.DO_RAW_SUBSTITUTIONS( L_ROW.DETAILS_LINK_TARGET );
         L_TASK.DUE_ON                  := L_ROW.DUE_ON;
         L_TASK.DUE_IN_HOURS            := L_ROW.DUE_IN_HOURS;
         L_TASK.DUE_IN                  := HTMLDB_UTIL.GET_SINCE( L_ROW.DUE_ON );
         L_TASK.DUE_CODE                := CASE
                                               WHEN L_ROW.DUE_IN_HOURS <   0 THEN 'OVERDUE'
                                               WHEN L_ROW.DUE_IN_HOURS <   1 THEN 'NEXT_HOUR'
                                               WHEN L_ROW.DUE_IN_HOURS <  24 THEN 'NEXT_24_HOURS'
                                               WHEN L_ROW.DUE_IN_HOURS < 168 THEN 'NEXT_7_DAYS'
                                               WHEN L_ROW.DUE_IN_HOURS < 720 THEN 'NEXT_30_DAYS'
                                               ELSE                               'MORE_THAN_30_DAYS'
                                           END;
         L_TASK.PRIORITY                := L_ROW.PRIORITY;
         L_TASK.PRIORITY_LEVEL          := GET_RUNTIME_MESSAGE( 'APEX.TASK.PRIORITY.' || TO_CHAR(L_ROW.PRIORITY) );
         L_TASK.INITIATOR               := L_ROW.INITIATOR;
         L_TASK.INITIATOR_LOWER         := L_ROW.INITIATOR_LOWER;
         L_TASK.ACTUAL_OWNER            := L_ROW.ACTUAL_OWNER;
         L_TASK.ACTUAL_OWNER_LOWER      := L_ROW.ACTUAL_OWNER_LOWER;
         L_TASK.BADGE_CSS_CLASSES       := 
                                           CASE 
                                               WHEN L_ROW.STATE_CODE IN ( C_TASK_STATE_FAILED, C_TASK_STATE_ERRORED )
                                                   THEN 'u-danger'
                                               WHEN L_ROW.STATE_CODE IN ( C_TASK_STATE_EXPIRED, C_TASK_STATE_CANCELLED )
                                                   THEN 'u-warning'
                                               WHEN L_ROW.STATE_CODE = C_TASK_STATE_COMPLETED
                                                   THEN 'u-success'
                                           END;
         L_TASK.BADGE_TEXT              := CASE WHEN L_ROW.STATE_CODE != C_TASK_STATE_ASSIGNED THEN
                                                    GET_RUNTIME_MESSAGE( 'APEX.TASK.STATE.' || L_ROW.STATE_CODE )
                                           END;
         L_TASK.STATE_CODE              := L_ROW.STATE_CODE;
         L_TASK.STATE                   := GET_RUNTIME_MESSAGE( 'APEX.TASK.STATE.' || L_ROW.STATE_CODE );
         L_TASK.IS_COMPLETED            := CASE WHEN L_ROW.STATE_CODE IN (C_TASK_STATE_COMPLETED, C_TASK_STATE_CANCELLED) 
                                                THEN 'Y'
                                                ELSE 'N'
                                           END;
         L_TASK.OUTCOME_CODE            := L_ROW.OUTCOME_CODE;
         L_TASK.OUTCOME                 := CASE WHEN L_ROW.OUTCOME_CODE IS NOT NULL 
                                               THEN GET_RUNTIME_MESSAGE( 'APEX.TASK.OUTCOME.' || L_ROW.OUTCOME_CODE )
                                           END;
         L_TASK.CREATED_AGO_HOURS       := L_ROW.CREATED_AGO_HOURS;
         L_TASK.CREATED_AGO             := HTMLDB_UTIL.GET_SINCE( L_ROW.CREATED_ON );
         L_TASK.CREATED_BY              := L_ROW.CREATED_BY;
         L_TASK.CREATED_ON              := L_ROW.CREATED_ON;
         L_TASK.LAST_UPDATED_BY         := L_ROW.LAST_UPDATED_BY;
         L_TASK.LAST_UPDATED_ON         := L_ROW.LAST_UPDATED_ON;
 
     END PROCESS_ROW;
 BEGIN
     IF P_CONTEXT IN (C_CONTEXT_MY_TASKS, 
                      C_CONTEXT_ADMIN_TASKS, 
                      C_CONTEXT_INITIATED_BY_ME,
                      C_CONTEXT_SINGLE_TASK ) THEN
         L_TASK := WWV_FLOW_T_APPROVAL_TASK (
             NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
             NULL, NULL, NULL );
         L_CUR := WWV_FLOW_APPROVAL.GET_TASKS(
                         P_APPLICATION_ID     => P_APPLICATION_ID,
                         P_CONTEXT            => P_CONTEXT,
                         P_USER               => P_USER,
                         P_TASK_ID            => P_TASK_ID,
                         P_SHOW_EXPIRED_TASKS => CASE WHEN P_SHOW_EXPIRED_TASKS = 'Y' 
                                                     THEN TRUE 
                                                     ELSE FALSE
                                                 END );
         LOOP
             FETCH L_CUR INTO L_ROW;
             EXIT WHEN L_CUR%NOTFOUND;
             PRAGMA INLINE(PROCESS_ROW, 'YES');
             PROCESS_ROW;
             PIPE ROW( L_TASK );
         END LOOP;
 
         IF L_CUR%ISOPEN THEN
             CLOSE L_CUR;
         END IF;
     ELSE RAISE_APPLICATION_ERROR( -20999, 'Context "' || P_CONTEXT || '" not found!' );
     END IF;
 EXCEPTION
     WHEN NO_DATA_NEEDED THEN
         CLOSE L_CUR;
     WHEN OTHERS THEN
         IF L_CUR%ISOPEN THEN
             CLOSE L_CUR;
         END IF;
         RAISE;
 END GET_TASKS;
 
 
 
 
 FUNCTION GET_TASK_HISTORY (
     P_TASK_ID        IN NUMBER,
     P_INCLUDE_ALL    IN VARCHAR2 DEFAULT 'N' )
 RETURN WWV_FLOW_T_APPROVAL_LOG_TABLE PIPELINED
 IS
     TYPE T_ROW IS RECORD (
         EVENT_TYPE_CODE        VARCHAR2(32),
         EVENT_CREATOR          VARCHAR2(255),
         EVENT_CREATOR_LOWER    VARCHAR2(255),
         EVENT_TIMESTAMP        TIMESTAMP WITH TIME ZONE,
         OLD_STATE_CODE         VARCHAR2(32),
           NEW_STATE_CODE         VARCHAR2(32),
           OLD_ACTUAL_OWNER       VARCHAR2(255),
           OLD_ACTUAL_OWNER_LOWER VARCHAR2(255),
           NEW_ACTUAL_OWNER       VARCHAR2(255),
           NEW_ACTUAL_OWNER_LOWER VARCHAR2(255),
           OLD_PRIORITY           NUMBER,
           NEW_PRIORITY           NUMBER,
           OUTCOME_CODE           VARCHAR2(32),
           DISPLAY_MSG            VARCHAR2(4000)
       );
       
       L_CUR   SYS_REFCURSOR;
       L_ROW   T_ROW;
       L_LOG   WWV_FLOW_T_APPROVAL_LOG_ROW;
   BEGIN
       L_LOG := WWV_FLOW_T_APPROVAL_LOG_ROW (
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL );
       L_CUR := WWV_FLOW_APPROVAL.GET_TASK_HISTORY ( P_TASK_ID     => P_TASK_ID,
                                                     P_INCLUDE_ALL => CASE WHEN P_INCLUDE_ALL = 'Y' 
                                                                          THEN TRUE 
                                                                          ELSE FALSE
                                                                      END );
       LOOP
           FETCH L_CUR INTO L_ROW;
           EXIT WHEN L_CUR%NOTFOUND;
           L_LOG.EVENT_TYPE_CODE        := L_ROW.EVENT_TYPE_CODE;
           L_LOG.EVENT_TYPE             := GET_RUNTIME_MESSAGE( 'APEX.TASK.EVENT.' || L_ROW.EVENT_TYPE_CODE );
           L_LOG.EVENT_CREATOR          := L_ROW.EVENT_CREATOR;
           L_LOG.EVENT_CREATOR_LOWER    := L_ROW.EVENT_CREATOR_LOWER;
           L_LOG.EVENT_TIMESTAMP        := L_ROW.EVENT_TIMESTAMP;
           L_LOG.OLD_STATE_CODE         := L_ROW.OLD_STATE_CODE;
           L_LOG.OLD_STATE              := CASE WHEN L_ROW.OLD_STATE_CODE IS NOT NULL THEN
                                               GET_RUNTIME_MESSAGE( 'APEX.TASK.STATE.' || L_ROW.OLD_STATE_CODE )
                                           END;
           L_LOG.NEW_STATE_CODE         := L_ROW.NEW_STATE_CODE;
           L_LOG.NEW_STATE              := CASE WHEN L_ROW.NEW_STATE_CODE IS NOT NULL THEN
                                               GET_RUNTIME_MESSAGE( 'APEX.TASK.STATE.' || L_ROW.NEW_STATE_CODE )
                                           END;
           L_LOG.OLD_ACTUAL_OWNER       := L_ROW.OLD_ACTUAL_OWNER;
           L_LOG.OLD_ACTUAL_OWNER_LOWER := L_ROW.OLD_ACTUAL_OWNER_LOWER;
           L_LOG.NEW_ACTUAL_OWNER       := L_ROW.NEW_ACTUAL_OWNER;
           L_LOG.NEW_ACTUAL_OWNER_LOWER := L_ROW.NEW_ACTUAL_OWNER_LOWER;
           L_LOG.OLD_PRIORITY           := L_ROW.OLD_PRIORITY;
           L_LOG.OLD_PRIORITY_LEVEL     := CASE WHEN L_ROW.OLD_PRIORITY IS NOT NULL THEN
                                               GET_RUNTIME_MESSAGE( 'APEX.TASK.PRIORITY.' || TO_CHAR(L_ROW.OLD_PRIORITY) )
                                           END;
           L_LOG.NEW_PRIORITY           := L_ROW.NEW_PRIORITY;
           L_LOG.NEW_PRIORITY_LEVEL     := CASE WHEN L_ROW.NEW_PRIORITY IS NOT NULL THEN
                                               GET_RUNTIME_MESSAGE( 'APEX.TASK.PRIORITY.' || TO_CHAR(L_ROW.NEW_PRIORITY) )
                                           END;
           L_LOG.OUTCOME_CODE           := L_ROW.OUTCOME_CODE;
           L_LOG.OUTCOME                := CASE WHEN L_ROW.OUTCOME_CODE IS NOT NULL THEN
                                               GET_RUNTIME_MESSAGE( 'APEX.TASK.OUTCOME.' || L_ROW.OUTCOME_CODE )
                                           END;
           L_LOG.DISPLAY_MSG            := L_ROW.DISPLAY_MSG;
   
           PIPE ROW ( L_LOG );
       END LOOP;
   
       IF L_CUR%ISOPEN THEN
           CLOSE L_CUR;
       END IF;
   EXCEPTION
       WHEN NO_DATA_NEEDED THEN
           CLOSE L_CUR;
       WHEN OTHERS THEN
           IF L_CUR%ISOPEN THEN
               CLOSE L_CUR;
           END IF;
           RAISE;
   END GET_TASK_HISTORY;
   
   
   
   
   FUNCTION GET_TASK_DELEGATES (
       P_TASK_ID IN NUMBER )
   RETURN WWV_FLOW_T_TEMP_LOV_DATA PIPELINED
   IS
       TYPE T_LOV_ROW IS RECORD (
           DISP VARCHAR2(4000),
           VAL  VARCHAR2(4000) );
       
       L_CUR   SYS_REFCURSOR;
       L_ROW   T_LOV_ROW;
       L_COUNT NUMBER := 0;
   BEGIN
       L_CUR := WWV_FLOW_APPROVAL.GET_TASK_DELEGATES ( P_TASK_ID => P_TASK_ID );
       LOOP
           FETCH L_CUR INTO L_ROW;
           EXIT WHEN L_CUR%NOTFOUND;
           L_COUNT := L_COUNT + 1;
           PIPE ROW ( WWV_FLOW_T_TEMP_LOV_VALUE (
               INSERT_ORDER => L_COUNT,
               DISP         => L_ROW.DISP,
               VAL          => L_ROW.VAL ) );
       END LOOP;
   
       IF L_CUR%ISOPEN THEN
           CLOSE L_CUR;
       END IF;
   EXCEPTION
       WHEN NO_DATA_NEEDED THEN
           CLOSE L_CUR;
       WHEN OTHERS THEN
           IF L_CUR%ISOPEN THEN
               CLOSE L_CUR;
           END IF;
           RAISE;
   END GET_TASK_DELEGATES;
   
   
   
   
   FUNCTION GET_TASK_PRIORITIES (
       P_TASK_ID IN NUMBER )
   RETURN WWV_FLOW_T_TEMP_LOV_DATA PIPELINED
   IS
       L_CUR      SYS_REFCURSOR;
       L_PRIORITY NUMBER;
       L_COUNT    NUMBER := 0;
   BEGIN
       L_CUR := WWV_FLOW_APPROVAL.GET_TASK_PRIORITIES ( P_TASK_ID => P_TASK_ID );
       LOOP
           FETCH L_CUR INTO L_PRIORITY;
           EXIT WHEN L_CUR%NOTFOUND;
           L_COUNT := L_COUNT + 1;
           PIPE ROW ( WWV_FLOW_T_TEMP_LOV_VALUE (
               INSERT_ORDER => L_COUNT,
               DISP         => GET_RUNTIME_MESSAGE('APEX.TASK.PRIORITY.'||TO_CHAR(L_PRIORITY)),
               VAL          => L_PRIORITY ) );
       END LOOP;
   
       IF L_CUR%ISOPEN THEN
           CLOSE L_CUR;
       END IF;
   EXCEPTION
       WHEN NO_DATA_NEEDED THEN
           CLOSE L_CUR;
       WHEN OTHERS THEN
           IF L_CUR%ISOPEN THEN
               CLOSE L_CUR;
           END IF;
           RAISE;
   END GET_TASK_PRIORITIES;
   
   
   
   
   FUNCTION GET_LOV_PRIORITY
   RETURN WWV_FLOW_T_TEMP_LOV_DATA
   IS
   BEGIN
       RETURN WWV_FLOW_T_TEMP_LOV_DATA (
           WWV_FLOW_T_TEMP_LOV_VALUE( 1 , GET_RUNTIME_MESSAGE('APEX.TASK.PRIORITY.'||TO_CHAR(1)) , 1 ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 2 , GET_RUNTIME_MESSAGE('APEX.TASK.PRIORITY.'||TO_CHAR(2)) , 2 ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 3 , GET_RUNTIME_MESSAGE('APEX.TASK.PRIORITY.'||TO_CHAR(3)) , 3 ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 4 , GET_RUNTIME_MESSAGE('APEX.TASK.PRIORITY.'||TO_CHAR(4)) , 4 ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 5 , GET_RUNTIME_MESSAGE('APEX.TASK.PRIORITY.'||TO_CHAR(5)) , 5 ) );
   END GET_LOV_PRIORITY;
   
   
   
   
   FUNCTION GET_LOV_STATE
   RETURN WWV_FLOW_T_TEMP_LOV_DATA
   IS
   BEGIN
       RETURN WWV_FLOW_T_TEMP_LOV_DATA (
           WWV_FLOW_T_TEMP_LOV_VALUE( 1 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_UNASSIGNED) , C_TASK_STATE_UNASSIGNED ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 2 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_ASSIGNED)   , C_TASK_STATE_ASSIGNED   ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 3 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_COMPLETED)  , C_TASK_STATE_COMPLETED  ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 4 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_CANCELLED)  , C_TASK_STATE_CANCELLED  ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 5 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_EXPIRED)    , C_TASK_STATE_EXPIRED    ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 6 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_FAILED)     , C_TASK_STATE_FAILED     ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 7 , GET_RUNTIME_MESSAGE('APEX.TASK.STATE.'||C_TASK_STATE_ERRORED)    , C_TASK_STATE_ERRORED    ) );
   END GET_LOV_STATE;
   
   
   
   
   FUNCTION GET_LOV_TYPE
   RETURN WWV_FLOW_T_TEMP_LOV_DATA
   IS
   BEGIN
       RETURN WWV_FLOW_T_TEMP_LOV_DATA (
           WWV_FLOW_T_TEMP_LOV_VALUE( 1 , GET_RUNTIME_MESSAGE('APEX.TASK.TYPE.'||C_TASK_TYPE_APPROVAL) , C_TASK_TYPE_APPROVAL ) ,
           WWV_FLOW_T_TEMP_LOV_VALUE( 2 , GET_RUNTIME_MESSAGE('APEX.TASK.TYPE.'||C_TASK_TYPE_ACTION)   , C_TASK_TYPE_ACTION   ) );
   END GET_LOV_TYPE;
   
   
   
   
   BEGIN
       WWV_FLOW_EPG_INCLUDE_MODULES.AUTHORIZE_IN_APEX;
   END WWV_FLOW_APPROVAL_API;

