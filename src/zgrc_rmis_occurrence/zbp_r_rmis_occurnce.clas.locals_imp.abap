CLASS lsc_zr_rmis_occurnce DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zr_rmis_occurnce IMPLEMENTATION.

  METHOD adjust_numbers.
    DATA: entity    TYPE STRUCTURE FOR CREATE zr_rmis_occurnce,
          lv_listid TYPE zrmis_numbering.

*    LOOP AT entities INTO entity WHERE OccurenceNo IS NOT INITIAL.
*      APPEND CORRESPONDING #( entity ) TO mapped-zrrmisoccurnce.
*    ENDLOOP.
*
*    DATA(entities_wo_occno) = entities.
*    DELETE entities_wo_occno WHERE OccurenceNo IS NOT INITIAL.
      SELECT max( occurence_no )
             FROM ztrmis_occurnce
             INTO @DATA(lv_occurence).
           IF sy-subrc = 0.
               lv_occurence = lv_occurence + 1.
               LOOP AT mapped-zrrmisoccurnce REFERENCE INTO DATA(lv_map).
                  lv_map->%key = lv_occurence.
               ENDLOOP.
            ELSE.
                LOOP AT mapped-zrrmisoccurnce REFERENCE INTO lv_map.
                  lv_map->%key = '1001'.
               ENDLOOP.
             ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS LHC_ZR_RMIS_OCCURNCE DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrRmisOccurnce
        RESULT result,
      setowner FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrRmisOccurnce~setowner.

ENDCLASS.

CLASS LHC_ZR_RMIS_OCCURNCE IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD setowner.
    READ ENTITIES OF ZR_RMIS_OCCURNCE IN LOCAL MODE
    ENTITY ZrRmisOccurnce
    FIELDS ( Createdby ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_owner).



    LOOP AT lt_owner INTO DATA(ls_owner).

     DATA(lv_uname) = sy-uname.
     IF sy-uname = 'CB9980000190'.
         MODIFY ENTITIES OF zr_rmis_occurnce IN LOCAL MODE
         ENTITY ZrRmisOccurnce
         UPDATE
         FIELDS ( Owner ) WITH VALUE #( (  %tky = ls_owner-%tky owner = 'Sai Gowtham Turaga' ) ).
     ENDIF.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
