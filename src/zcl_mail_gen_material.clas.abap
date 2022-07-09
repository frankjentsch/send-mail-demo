CLASS zcl_mail_gen_material DEFINITION
  PUBLIC
  INHERITING FROM zcl_mail_gen
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS BEGIN OF placeholder.
    CONSTANTS   recipient TYPE string VALUE `@@RECIPIENT@@`.
    CONSTANTS   material  TYPE string VALUE `@@MATERIAL@@`.
    CONSTANTS END OF placeholder.

    METHODS constructor
      IMPORTING placeholder_values TYPE placeholder_values OPTIONAL.

  PROTECTED SECTION.
    METHODS get_template_body REDEFINITION.
    METHODS get_supported_placeholders REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_mail_gen_material IMPLEMENTATION.

  METHOD constructor.

    super->constructor( placeholder_values = placeholder_values ).

  ENDMETHOD.

  METHOD get_supported_placeholders.

    placeholders = VALUE #( ( placeholder-recipient )
                            ( placeholder-material  ) ).

  ENDMETHOD.

  METHOD get_template_body.

    html_template_body =
      |<tr><td { css_style-h }>Material Notification</td></tr>| &&
      |<tr><td { css_style-tdl }>Dear { placeholder-recipient },</td></tr>| &&
      |<tr><td { css_style-tdl }>Material <strong>{ placeholder-material }</strong> has been created.</td></tr>| &&
      |<tr><td { css_style-tdl }>Best regards</td></tr>| ##NO_TEXT.

  ENDMETHOD.

ENDCLASS.
