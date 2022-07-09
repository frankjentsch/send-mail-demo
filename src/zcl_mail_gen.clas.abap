CLASS zcl_mail_gen DEFINITION
  PUBLIC
  ABSTRACT.

  PUBLIC SECTION.
    TYPES BEGIN OF placeholder_value.
    TYPES placeholder  TYPE string.
    TYPES actual_value TYPE string.
    TYPES END OF placeholder_value.

    TYPES placeholder_values TYPE STANDARD TABLE OF placeholder_value WITH EMPTY KEY.

    METHODS constructor
      IMPORTING placeholder_values TYPE placeholder_values OPTIONAL.

    METHODS get_content FINAL
      IMPORTING subject             TYPE string
      RETURNING VALUE(html_content) TYPE string.

    METHODS send FINAL
      IMPORTING
        sender         TYPE string
        recipient      TYPE string
        subject        TYPE string
      EXPORTING
        error_occurred TYPE abap_bool
        error_text     TYPE string.

  PROTECTED SECTION.
    TYPES placeholders TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    CONSTANTS BEGIN OF css_style .
    CONSTANTS ci   TYPE string VALUE `style="padding: 0px 0px 10px 0px; font-family: Calibri, sans-serif; font-size: 11pt;"`  ##NO_TEXT.
    CONSTANTS h    TYPE string VALUE `style="padding: 0px 0px 15px 0px; font-family: Calibri, sans-serif; font-size: 14pt; color: #f0ab00;"`  ##NO_TEXT.
    CONSTANTS thl  TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:left; background-color:#F1F2F6;"`  ##NO_TEXT.
    CONSTANTS thc  TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:center; background-color:#F1F2F6;"`  ##NO_TEXT.
    CONSTANTS thr  TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:right; background-color:#F1F2F6;"`  ##NO_TEXT.
    CONSTANTS tdl  TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:left;"`  ##NO_TEXT.
    CONSTANTS tdc  TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:center;"`  ##NO_TEXT.
    CONSTANTS tdr  TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:right;"`  ##NO_TEXT.
    CONSTANTS tdcg TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:center; background-color:#98FB98;"`  ##NO_TEXT.
    CONSTANTS tdco TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:center; background-color:#FFCC99;"`  ##NO_TEXT.
    CONSTANTS tdcr TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:center; background-color:#FF3300;"`  ##NO_TEXT.
    CONSTANTS tdlg TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:left; background-color:#98FB98;"`  ##NO_TEXT.
    CONSTANTS tdlo TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:left; background-color:#FFCC99;"`  ##NO_TEXT.
    CONSTANTS tdlr TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:left; background-color:#FF3300;"`  ##NO_TEXT.
    CONSTANTS tdrg TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:right; background-color:#98FB98;"`  ##NO_TEXT.
    CONSTANTS tdro TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:right; background-color:#FFCC99;"`  ##NO_TEXT.
    CONSTANTS tdrr TYPE string VALUE `style="padding: 1px 5px 1px 5px; font-family: Calibri, sans-serif; font-size: 11pt; text-align:right; background-color:#FF3300;"`  ##NO_TEXT.
    CONSTANTS tdt  TYPE string VALUE `style="padding: 0px 0px 20px 0px;"`  ##NO_TEXT.
    CONSTANTS f    TYPE string VALUE `style="padding: 0px 0px 10px 0px; font-family: Calibri, sans-serif; font-size: 11pt;"`  ##NO_TEXT.
    CONSTANTS END OF css_style .

    METHODS get_supported_placeholders ABSTRACT
      RETURNING VALUE(placeholders) TYPE placeholders.

    METHODS get_template_body ABSTRACT
      RETURNING VALUE(html_template_body) TYPE string.

  PRIVATE SECTION.
    METHODS replace_placeholders
      IMPORTING html_template_body TYPE string
      RETURNING VALUE(html_body)   TYPE string.

    DATA m_placeholder_values TYPE placeholder_values.

ENDCLASS.


CLASS zcl_mail_gen IMPLEMENTATION.

  METHOD constructor.

    m_placeholder_values = placeholder_values.

  ENDMETHOD.

  METHOD get_content.

    DATA(html_body) = replace_placeholders( get_template_body( ) ).

    html_content =
    |<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">| &&
    |<html xmlns="http://www.w3.org/1999/xhtml">| &&
    |  <head>| &&
    |    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />| &&
    |    <title>{ subject }</title>| &&
    |    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>| &&
    |  </head>| &&
    |<body style="margin: 0; padding: 0;">| &&
    |  <table border="0" cellpadding="0" cellspacing="0" width="100%">| &&
    |    <tr>| &&
    |      <td>| &&
    |        <table align="left" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;">| &&
    html_body &&
    |        </table>| &&
    |      </td>| &&
    |    </tr>| &&
    |  </table>| &&
    |</body>| &&
    |</html>| ##NO_TEXT.

  ENDMETHOD.

  METHOD send.

    DATA(content) = get_content( subject ).

    TRY.
        DATA(mail) = cl_bcs_mail_message=>create_instance( ).
        mail->set_sender( CONV #( sender ) ).
        mail->add_recipient( CONV #( recipient ) ).
        mail->set_subject( CONV #( subject ) ).
        mail->set_main( cl_bcs_mail_textpart=>create_instance(
            iv_content      = content
            iv_content_type = 'text/html'
        ) ).

        mail->send( IMPORTING et_status = DATA(status) ).
        LOOP AT status ASSIGNING FIELD-SYMBOL(<status>) WHERE status = 'E'.
          error_occurred = abap_true.
          error_text = <status>-recipient.
        ENDLOOP.

      CATCH cx_bcs_mail INTO DATA(x_mail).
        error_occurred = abap_true.
        error_text = x_mail->get_text( ).
    ENDTRY.

  ENDMETHOD.

  METHOD replace_placeholders.

    html_body = html_template_body.

    LOOP AT m_placeholder_values ASSIGNING FIELD-SYMBOL(<placeholder_value>).
      html_body = replace( val = html_body sub = <placeholder_value>-placeholder with = <placeholder_value>-actual_value occ = 0 ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
