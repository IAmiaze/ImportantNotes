prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.2'
,p_default_workspace_id=>13859700933264975208
,p_default_application_id=>59380
,p_default_id_offset=>0
,p_default_owner=>'WKSP_CHANDRIKAWP'
);
end;
/
 
prompt APPLICATION 59380 - My Money Buddy
--
-- Application Export:
--   Application:     59380
--   Name:            My Money Buddy
--   Exported By:     MIAZE
--   Flashback:       0
--   Export Type:     Page Export
--   Manifest
--     PAGE: 9999
--   Manifest End
--   Version:         24.2.2
--   Instance ID:     63113759365424
--

begin
null;
end;
/
prompt --application/pages/delete_09999
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>9999);
end;
/
prompt --application/pages/page_09999
begin
wwv_flow_imp_page.create_page(
 p_id=>9999
,p_name=>'Login Page'
,p_alias=>'LOGIN'
,p_step_title=>'My Money Buddy - Log In'
,p_warn_on_unsaved_changes=>'N'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function registerUser() {',
'    let username = $v("P9999_USERNAME_1");',
'    let email = $v("P9999_EMAIL");',
'    let password = $v("P9999_PASSWORD_HASH");',
'',
'    // Email validation regex',
'    let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;',
'',
'    // Check if any field is empty',
'    if (!username) {',
'        Swal.fire({ icon: "error", title: "Error", text: "User Name is Required" });',
'        return;',
'    }',
'    if (!email) {',
'        Swal.fire({ icon: "error", title: "Error", text: "Email is Required" });',
'        return;',
'    }',
'    if (!emailPattern.test(email)) {',
'        Swal.fire({ icon: "error", title: "Error", text: "Invalid Email Format" });',
'        return;',
'    }',
'    if (!password) {',
'        Swal.fire({ icon: "error", title: "Error", text: "Password is Required" });',
'        return;',
'    }',
'',
'    // Send AJAX request',
'    apex.server.process(',
'        "REGISTER",',
'        {',
'            pageItems: "#P9999_USERNAME_1, #P9999_EMAIL, #P9999_PASSWORD_HASH"',
'        },',
'        {',
'            success: function (data) {',
'                if (data.success) {',
'                    Swal.fire({',
'                        icon: "success",',
'                        title: "Success",',
'                        text: data.message,',
'                        timer: 2000,',
'                        showConfirmButton: false',
'                    });',
'',
'                    // Clear input fields',
'                    $s("P9999_USERNAME_1", "");',
'                    $s("P9999_EMAIL", "");',
'                    $s("P9999_PASSWORD_HASH", "");',
'',
'                    // Set P9999_SET_VAL to 1',
'                    $s("P9999_SET_VAL", "1");',
'                } else {',
'                    Swal.fire({ icon: "error", title: "Error", text: data.message });',
'                }',
'            },',
'            error: function (jqXHR, textStatus, errorThrown) {',
'                Swal.fire({ icon: "error", title: "AJAX Error", text: textStatus + ": " + errorThrown });',
'            }',
'        }',
'    );',
'}',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Login-container {',
'    background: url(#APP_FILES#landing_image.jpg) fixed no-repeat;',
'    background-size: cover;',
'}'))
,p_step_template=>2101157952850466385
,p_page_template_options=>'#DEFAULT#'
,p_page_is_public_y_n=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'12'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13868514810909614071)
,p_plug_name=>'Login'
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding'
,p_plug_template=>2674157997338192145
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>6
,p_plug_display_column=>4
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Don''t have an account? ',
'    <button type="button" onclick="apex.item(''P9999_SET_VAL'').setValue(0);" class="t-Button t-Button--success t-Button--large t-Button--link">',
'        <b>Register</b>',
'    </button>',
'</p>',
''))
,p_region_image=>'#APP_FILES#icons/app-icon-512.png'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(79880466538161768416)
,p_plug_name=>'Register'
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding'
,p_plug_template=>2674157997338192145
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>6
,p_plug_display_column=>4
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Already have an account?',
'    <button type="button" onclick="apex.item(''P9999_SET_VAL'').setValue(1);" class="t-Button t-Button--success t-Button--large t-Button--link">',
'        <b>Login here</b>',
'    </button>',
'</p>',
''))
,p_region_image=>'#APP_FILES#icons/app-icon-512.png'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(79880467226591768423)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(79880466538161768416)
,p_button_name=>'REGISTER'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--stretch'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Register'
,p_button_redirect_url=>'javascript:registerUser();'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(13868516593031614073)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(13868514810909614071)
,p_button_name=>'LOGIN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--stretch:t-Button--gapTop'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Login'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13868515361372614071)
,p_name=>'P9999_USERNAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13868514810909614071)
,p_prompt=>'Username'
,p_placeholder=>'Enter Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="username"'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'sss'
,p_item_icon_css_classes=>'fa-user'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13868515748556614072)
,p_name=>'P9999_PASSWORD'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13868514810909614071)
,p_prompt=>'Password'
,p_placeholder=>'Enter Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>40
,p_cMaxlength=>100
,p_tag_attributes=>'autocomplete="current-password"'
,p_field_template=>3031561666792084173
,p_item_css_classes=>'sss'
,p_item_icon_css_classes=>'fa-key'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13868516108803614072)
,p_name=>'P9999_REMEMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13868514810909614071)
,p_prompt=>'Remember username'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_display_when=>'apex_authentication.persistent_cookies_enabled'
,p_display_when2=>'PLSQL'
,p_display_when_type=>'EXPRESSION'
,p_field_template=>2040785906935475274
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(13868508079224614062)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(79880465837404768409)
,p_name=>'P9999_USERNAME_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(79880466538161768416)
,p_prompt=>'New Username :'
,p_placeholder=>'Enter New User'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>3031561932232085882
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'text_case', 'UPPER',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(79880465901709768410)
,p_name=>'P9999_EMAIL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(79880466538161768416)
,p_prompt=>'User Email :'
,p_placeholder=>'Enter user Email'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>3031561932232085882
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(79880466027608768411)
,p_name=>'P9999_PASSWORD_HASH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(79880466538161768416)
,p_prompt=>'Password :'
,p_placeholder=>'Enter Password'
,p_display_as=>'NATIVE_PASSWORD'
,p_cSize=>30
,p_cMaxlength=>255
,p_field_template=>3031561932232085882
,p_item_template_options=>'#DEFAULT#:margin-bottom-sm'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'submit_when_enter_pressed', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(79880466670767768417)
,p_name=>'P9999_SET_VAL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(79880466538161768416)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(79880466704616768418)
,p_name=>'SHOW_HIDE'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9999_SET_VAL'
,p_condition_element=>'P9999_SET_VAL'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_execution_type=>'DEBOUNCE'
,p_execution_time=>1
,p_execution_immediate=>true
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(79880466862185768419)
,p_event_id=>wwv_flow_imp.id(79880466704616768418)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(79880466538161768416)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(79880467137446768422)
,p_event_id=>wwv_flow_imp.id(79880466704616768418)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(13868514810909614071)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(79880466990861768420)
,p_event_id=>wwv_flow_imp.id(79880466704616768418)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(79880466538161768416)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(79880467046583768421)
,p_event_id=>wwv_flow_imp.id(79880466704616768418)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(13868514810909614071)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13868518705680614074)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Set Username Cookie'
,p_attribute_01=>'PLSQL_PACKAGE'
,p_attribute_03=>'APEX_AUTHENTICATION'
,p_attribute_04=>'SEND_LOGIN_USERNAME_COOKIE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>13868518705680614074
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(13868519241848614074)
,p_page_process_id=>wwv_flow_imp.id(13868518705680614074)
,p_page_id=>9999
,p_name=>'p_username'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>1
,p_value_type=>'EXPRESSION'
,p_value_language=>'PLSQL'
,p_value=>'lower( :P9999_USERNAME )'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(13868519709719614074)
,p_page_process_id=>wwv_flow_imp.id(13868518705680614074)
,p_page_id=>9999
,p_name=>'p_consent'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>false
,p_display_sequence=>2
,p_value_type=>'ITEM'
,p_value=>'P9999_REMEMBER'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13868516813311614073)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_INVOKE_API'
,p_process_name=>'Login'
,p_attribute_01=>'PLSQL_PACKAGE'
,p_attribute_03=>'APEX_AUTHENTICATION'
,p_attribute_04=>'LOGIN'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>13868516813311614073
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(13868517332226614073)
,p_page_process_id=>wwv_flow_imp.id(13868516813311614073)
,p_page_id=>9999
,p_name=>'p_username'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>1
,p_value_type=>'ITEM'
,p_value=>'P9999_USERNAME'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(13868517838405614073)
,p_page_process_id=>wwv_flow_imp.id(13868516813311614073)
,p_page_id=>9999
,p_name=>'p_password'
,p_direction=>'IN'
,p_data_type=>'VARCHAR2'
,p_has_default=>false
,p_display_sequence=>2
,p_value_type=>'ITEM'
,p_value=>'P9999_PASSWORD'
);
wwv_flow_imp_shared.create_invokeapi_comp_param(
 p_id=>wwv_flow_imp.id(13868518392115614074)
,p_page_process_id=>wwv_flow_imp.id(13868516813311614073)
,p_page_id=>9999
,p_name=>'p_set_persistent_auth'
,p_direction=>'IN'
,p_data_type=>'BOOLEAN'
,p_has_default=>true
,p_display_sequence=>3
,p_value_type=>'API_DEFAULT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13868520622101614075)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page(s) Cache'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>13868520622101614075
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13868520255549614075)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Get Username Cookie'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>13868520255549614075
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(79880467728473768428)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'REGISTER'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Formatted on 2/24/2025 10:47:11 AM (QP5 v5.388) */',
'DECLARE',
'    vErrorFlag   VARCHAR2 (1);',
'    vErrorMsg    VARCHAR2 (3000);',
'BEGIN',
'    IF :P9999_USERNAME_1 IS NULL',
'    THEN',
'        vErrorMsg := ''User Name Required'';',
'        GOTO End_Block;',
'    END IF;',
'',
'    IF :P9999_EMAIL IS NULL',
'    THEN',
'        vErrorMsg := ''Email is Required'';',
'        GOTO End_Block;',
'    END IF;',
'',
'    IF :P9999_PASSWORD_HASH IS NULL',
'    THEN',
'        vErrorMsg := ''Password is Required'';',
'        GOTO End_Block;',
'    END IF;',
'',
'    BEGIN',
'        INSERT INTO users (username, email, password_hash)',
'             VALUES ( :P9999_USERNAME_1, :P9999_EMAIL, :P9999_PASSWORD_HASH);',
'    EXCEPTION',
'        WHEN DUP_VAL_ON_INDEX',
'        THEN',
'            vErrorMsg := ''Unique Email or Username Found.'';',
'            GOTO End_Block;',
'    END;',
'',
'',
'    apex_json.open_object;',
'    apex_json.write (''success'', TRUE);',
'    apex_json.write (''message'', ''User Registered for My wallet!'');',
'    apex_json.close_object;',
'    GOTO END_PROCESS;',
'',
'   <<End_Block>>',
'    apex_json.open_object;',
'    apex_json.write (''success'', FALSE);',
'    apex_json.write (''message'', vErrorMsg);',
'    apex_json.close_object;',
'',
'   <<END_PROCESS>>',
'    NULL;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>79880467728473768428
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
