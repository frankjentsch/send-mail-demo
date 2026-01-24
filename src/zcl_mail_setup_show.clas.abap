"! Output current settings of the system outbound email configuration
"! see https://help.sap.com/docs/sap-btp-abap-environment/abap-environment/configuration-of-system-mail-outbound
CLASS zcl_mail_setup_show DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_mail_setup_show IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    FINAL(mail_system_config) = cl_bcs_mail_system_config=>create_instance( ).

    mail_system_config->read_default_sender_address(
      IMPORTING
        ev_default_sender_address = FINAL(default_sender_address)
        ev_default_sender_name    = FINAL(default_sender_name)
    ).

    out->write( data = default_sender_address name = 'DEFAULT_SENDER_ADDRESS' ).
    out->write( data = default_sender_name name = 'DEFAULT_SENDER_NAME' ).

    FINAL(allowlists_extended) = mail_system_config->check_if_allowlists_extended( ).
    out->write( data = allowlists_extended name = 'ALLOWLISTS_EXTENDED' ).

    FINAL(is_address_check_active) = mail_system_config->get_address_check_active( ).
    out->write( data = is_address_check_active name = 'IS_ADDRESS_CHECK_ACTIVE' ).

    TRY.
        FINAL(days_until_mail_expires) = mail_system_config->get_days_until_mail_expires( ).
        out->write( data = days_until_mail_expires name = 'DAYS_UNTIL_MAIL_EXPIRES' ).
      CATCH cx_bcs_mail_config INTO FINAL(exc_bcs_mail_config).
        out->write( data = exc_bcs_mail_config->get_text( ) name = 'DAYS_UNTIL_MAIL_EXPIRES' ).
    ENDTRY.

    FINAL(allowed_recipient_domains) = mail_system_config->read_allowed_recipient_domains( ).
    out->write( data = allowed_recipient_domains name = 'ALLOWED_RECIPIENT_DOMAINS' ).

    FINAL(allowed_sender_domains) = mail_system_config->read_allowed_sender_domains( ).
    out->write( data = allowed_sender_domains name = 'ALLOWED_SENDER_DOMAINS' ).

  ENDMETHOD.

ENDCLASS.
