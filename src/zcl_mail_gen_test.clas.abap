"! Example for html email generation with placeholders
"! see https://help.sap.com/docs/sap-btp-abap-environment/abap-environment/output-management-sending-mails-using-smtp
CLASS zcl_mail_gen_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_mail_gen_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    FINAL(mail_gen) = NEW zcl_mail_gen_material(
        placeholder_values = VALUE #( ( placeholder = zcl_mail_gen_material=>placeholder-recipient actual_value = 'Mr. Mayer' )
                                      ( placeholder = zcl_mail_gen_material=>placeholder-material  actual_value = 'Screw 3x4' ) )
    ) ##NO_TEXT.

    out->write( mail_gen->get_content( `Material creation notification` ) ) ##NO_TEXT.

    TRY.
        mail_gen->send(
          EXPORTING
            sender      = 'noreply@...'
            recipient   = '...@...'
            subject     = `Material creation notification`
          IMPORTING
            mail_status = FINAL(mail_status)
        ) ##NO_TEXT.

        out->write( mail_status ).
      CATCH cx_bcs_mail INTO FINAL(x_mail).
        out->write( x_mail->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
