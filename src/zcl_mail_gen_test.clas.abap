CLASS zcl_mail_gen_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mail_gen_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(mail_gen) = NEW zcl_mail_gen_material(
        placeholder_values = VALUE #( ( placeholder = zcl_mail_gen_material=>placeholder-recipient actual_value = 'Mr. Mayer' )
                                      ( placeholder = zcl_mail_gen_material=>placeholder-material  actual_value = 'Screw 3x4' ) )
    ) ##NO_TEXT.

    out->write( mail_gen->get_content( `Material creation notification` ) ) ##NO_TEXT.

    mail_gen->send(
      EXPORTING
        sender         = 'noreply@...'
        recipient      = '...@...'
        subject        = `Material creation notification`
      IMPORTING
        error_occurred = DATA(error_occurred)
        error_text     = DATA(error_text)
    ) ##NO_TEXT.

    IF error_occurred = abap_true.
      out->write( |ERROR OCCURRED: { error_text }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
