"! Example for html email generation
"! see https://help.sap.com/docs/sap-btp-abap-environment/abap-environment/output-management-sending-mails-using-smtp
CLASS zcl_mail_simple DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_mail_simple IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    TRY.
        FINAL(mail) = cl_bcs_mail_message=>create_instance( ).
        mail->set_sender( 'noreply@...' ).
        mail->add_recipient( '...@...' ).
        mail->set_subject( `Test Mail` ) ##NO_TEXT.
        mail->set_main( cl_bcs_mail_textpart=>create_text_html( `<h1>Hello</h1><p>world</p>` ) ) ##NO_TEXT.

        FINAL(mail_status_monitor) = mail->send( ).
        mail_status_monitor->get_email_status( IMPORTING es_mail_status = FINAL(mail_status) ).

        out->write( mail_status ).

      CATCH cx_bcs_mail INTO FINAL(x_mail).
        out->write( x_mail->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
