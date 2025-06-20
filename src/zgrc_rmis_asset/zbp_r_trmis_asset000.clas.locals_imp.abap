CLASS LHC_ZR_TRMIS_ASSET000 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Asset
        RESULT result,
      copyasset FOR MODIFY
            IMPORTING keys FOR ACTION Asset~copyasset.
ENDCLASS.

CLASS LHC_ZR_TRMIS_ASSET000 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD copyasset.


  DATA:
      asset      TYPE TABLE FOR CREATE zr_trmis_asset000.

   " remove travel instances with initial %cid (i.e., not set by caller API)
   READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_inital_cid).
   ASSERT key_with_inital_cid IS INITIAL.

   " read the data from the travel instances to be copied
   READ ENTITIES OF zr_trmis_asset000 IN LOCAL MODE
      ENTITY asset
      ALL FIELDS WITH CORRESPONDING #( keys )
   RESULT DATA(asset_read_result)
   FAILED failed.

   LOOP AT asset_read_result ASSIGNING FIELD-SYMBOL(<asset>).
      " fill in travel container for creating new travel instance
      APPEND VALUE #( %cid      = keys[ KEY entity %key = <asset>-%key ]-%cid
                     %is_draft = keys[ KEY entity %key = <asset>-%key ]-%param-%is_draft
                     %data     = CORRESPONDING #( <asset> EXCEPT assetuuid )
                  )
      TO asset ASSIGNING FIELD-SYMBOL(<new_asset>).

      " adjust the copied travel instance data
      "" BeginDate must be on or after system date
      " <new_travel>-BeginDate     = cl_abap_context_info=>get_system_date( ).
      "" EndDate must be after BeginDate
     " <new_travel>-EndDate       = cl_abap_context_info=>get_system_date( ) + 30.
      "" OverallStatus of new instances must be set to open ('O')
      <new_asset>-AssetStatus = 'Copy'.
   ENDLOOP.

   " create new BO instance
   MODIFY ENTITIES OF zr_trmis_asset000 IN LOCAL MODE
      ENTITY asset
      CREATE FIELDS (
    AssetName
    AccountingCode
    Afe
    AgreedValueLookup
    AreaSqKm
    AssetCategory
    AssetDescription
    AssetMakeOrModel
    AssetPolicyHistory
    AssetStatus
    AssetTypeP
     )
         WITH asset
      MAPPED DATA(mapped_create).

   " set the new BO instances
   mapped-asset   =  mapped_create-asset .

  ENDMETHOD.

ENDCLASS.
