CLASS lhc_zr_rmis_picklst_p DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Parent
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Parent,
      earlynumbering_cba_Child FOR NUMBERING
        IMPORTING entities FOR CREATE Parent\_Child.
ENDCLASS.

CLASS lhc_zr_rmis_picklst_p IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA: entity    TYPE STRUCTURE FOR CREATE zr_rmis_picklst_p,
          lv_listid TYPE zrmis_numbering.

    LOOP AT entities INTO entity WHERE ListId IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-parent.
    ENDLOOP.

    DATA(entities_wo_listid) = entities.
    DELETE entities_wo_listid WHERE ListId IS NOT INITIAL.

    SELECT *
        FROM ztrmis_picklst_p
        INTO TABLE @DATA(lt_picklists).
    IF sy-subrc = 0.
      SORT lt_picklists BY createdat DESCENDING.
      READ TABLE lt_picklists INTO DATA(ls_picklists) INDEX 1.
      LOOP AT entities_wo_listid INTO entity.
        ls_picklists-list_id += 1.
        entity-ListId = ls_picklists-list_id.

        APPEND VALUE #( %cid = entity-%cid %key = entity-%key ) TO mapped-parent.
      ENDLOOP.
    ELSE.
      LOOP AT entities_wo_listid INTO entity.
        entity-ListId = '1001'.
        APPEND VALUE #( %cid = entity-%cid %key = entity-%key ) TO mapped-parent.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD earlynumbering_cba_Child.

    DATA : max_value_id TYPE zrmis_numbering .

    "Get all the PickList and their child values
    READ ENTITIES OF zr_rmis_picklst_p IN LOCAL MODE
       ENTITY Parent BY \_Child
       FROM CORRESPONDING #(  entities )
       LINK DATA(lt_values).

    "loop all the Unique ID's
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<s_entities>) GROUP BY <s_entities>-ListId .
      "Get the Highest Value ID which is already there in Child Table
      LOOP AT lt_values  INTO DATA(ls_values) USING KEY entity
      WHERE source-ListId = <s_entities>-ListId .
        IF max_value_id < ls_values-target-ValueId .
          max_value_id  = ls_values-target-ValueId .
        ENDIF .
      ENDLOOP .

      "Get the assigned Value ID for incoming request
      LOOP AT entities  INTO DATA(ls_entity) USING KEY entity
        WHERE ListId = <s_entities>-ListId .
        LOOP AT ls_entity-%target INTO DATA(ls_target).
          IF max_value_id < ls_target-ValueId .
            max_value_id  = ls_target-ValueId .
          ENDIF .
        ENDLOOP .
      ENDLOOP .
      "Loop over all the entities of PickList with the same ListID
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<Picklist>)
       USING KEY entity WHERE ListId = <s_entities>-ListId.
        "Assign new ValueID
        LOOP AT <Picklist>-%target ASSIGNING FIELD-SYMBOL(<value>).
          APPEND CORRESPONDING #(  <value> ) TO mapped-child
          ASSIGNING FIELD-SYMBOL(<map_value>).
          IF <value>-ValueId IS INITIAL .
            max_value_id += 10.
            <map_value>-ValueId = max_value_id .
          ENDIF .
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
