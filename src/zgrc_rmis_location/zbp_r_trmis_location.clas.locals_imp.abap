CLASS LHC_ZR_TRMIS_LOCATION DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrTrmisLocation
        RESULT result,
       validateDate FOR VALIDATE ON SAVE
            IMPORTING keys FOR ZrTrmisLocation~validateDate,
       validateNodeLevel FOR VALIDATE ON SAVE
            IMPORTING keys FOR ZrTrmisLocation~validateNodeLevel,
       setLocationStatus FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrTrmisLocation~setLocationStatus,
      copy FOR MODIFY
            IMPORTING keys FOR ACTION ZrTrmisLocation~copy.

ENDCLASS.

CLASS LHC_ZR_TRMIS_LOCATION IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD validateDate.
   READ ENTITIES OF zr_trmis_location IN LOCAL MODE
   ENTITY ZrTrmisLocation
   FIELDS ( DateActive DateInactive )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_locations).
  LOOP AT lt_locations INTO DATA(ls_location).
   IF ls_location-dateactive is INITIAL AND
      ls_location-dateinactive is INITIAL.
       APPEND VALUE #( %tky = ls_location-%tky ) to failed-ZrTrmisLocation.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'Date Active and Date Inactive both cannot be blank at the same time' ) ) to reported-zrtrmislocation.
   ELSEIF ls_location-dateactive IS NOT INITIAL AND
          ls_location-DateInactive IS NOT INITIAL.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'Date Active and Date Inactive both cannot be populated at the same time' ) ) to reported-zrtrmislocation.
   ENDIF.
  ENDLOOP.
  ENDMETHOD.
  METHOD validateNodeLevel.
    READ ENTITIES OF zr_trmis_location IN LOCAL MODE
      ENTITY ZrTrmisLocation
      FIELDS ( ParentLevel ParentNode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_locations).
    LOOP AT lt_locations INTO DATA(ls_location).
     IF ls_location-ParentNode BETWEEN 0 AND 5 AND ls_location-ParentLevel IS INITIAL.
       APPEND VALUE #( %tky = ls_location-%tky ) to failed-ZrTrmisLocation.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'Must provide a parent level value for any parent node at level 4 or below.' ) ) to reported-zrtrmislocation.
     ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD setLocationStatus.
     DATA: lc_status_active TYPE zrmis_formula_text VALUE 'ACTIVE',
           lc_status_inactive TYPE zrmis_formula_text VALUE 'INACTIVE',
           lt_location TYPE TABLE FOR UPDATE zr_trmis_location.

     READ ENTITIES OF zr_trmis_location IN LOCAL MODE
      ENTITY ZrTrmisLocation
      FIELDS ( DateActive LocationStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_locations).
      LOOP AT lt_locations ASSIGNING FIELD-SYMBOL(<lfs_location>).
      IF <lfs_location> is ASSIGNED.
        IF <lfs_location>-DateActive IS NOT INITIAL.
           MODIFY ENTITIES OF zr_trmis_location IN LOCAL MODE
           ENTITY ZrTrmisLocation
           UPDATE FIELDS ( LocationStatus )
           WITH VALUE #( FOR ZrTrmisLocation IN lt_locations ( %tky = ZrTrmisLocation-%tky
                                                                LocationStatus = lc_status_active ) ).
        ELSE.
           MODIFY ENTITIES OF zr_trmis_location IN LOCAL MODE
           ENTITY ZrTrmisLocation
           UPDATE FIELDS ( LocationStatus )
           WITH VALUE #( FOR ZrTrmisLocation IN lt_locations ( %tky = ZrTrmisLocation-%tky
                                                               LocationStatus = lc_status_inactive ) ).
        ENDIF.
      ENDIF.
     ENDLOOP.
    "   MOVE-CORRESPONDING lt_locations TO lt_location.
 "     MODIFY ENTITIES OF zr_trmis_location IN LOCAL MODE
 "      ENTITY ZrTrmisLocation
 "      UPDATE FIELDS ( LocationStatus )
 "      WITH VALUE #( FOR ZrTrmisLocation IN lt_locations ( %tky = ZrTrmisLocation-%tky
 "                                                      LocationStatus = COND zrmis_formula_text(
 "                                                      WHEN ZrTrmisLocation-DateActive IS NOT INITIAL THEN lc_status_active
 "                                                      ELSE  lc_status_inactive ) ) ).
                                                       "(   if ls_location-dateactive is not initial then lc_status_active
                                                        "                  else lc_status_inactive ) ) ).

  ENDMETHOD.
  METHOD copy.
     DATA: lt_locations       TYPE TABLE FOR CREATE zr_trmis_location\\ZrTrmisLocation.


   READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_inital_cid).
    ASSERT key_with_inital_cid IS INITIAL.

    READ ENTITIES OF zr_trmis_location IN LOCAL MODE
      ENTITY ZrTrmisLocation
       ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_location)
    FAILED failed.

    LOOP AT lt_location ASSIGNING FIELD-SYMBOL(<lfs_location>).
      "Fill travel container for creating new travel instance
*      APPEND VALUE #( %cid     = keys[ %tky = <lfs_policy>-%tky ]-%cid
*                      %data    = CORRESPONDING #( <lfs_policy> ) )
*        TO lt_policy ASSIGNING FIELD-SYMBOL(<new_policy>).

       APPEND VALUE #( %cid = keys[ %tky = <lfs_location>-%tky ]-%cid
                     %data = CORRESPONDING #( <lfs_location> )
      ) TO lt_locations ASSIGNING FIELD-SYMBOL(<lfs_newlocation>).

    ENDLOOP.

   MODIFY ENTITIES OF zr_trmis_location IN LOCAL MODE
        ENTITY ZrTrmisLocation
            CREATE FIELDS (
  AddressLine1
  AddressLine2
  AllowAgreedValueInput
  Bim
  BimDate
  Brand
  BusinessArea
  Level2Id
  Level4Id
  BusinessUnitOnlAndOthers
  CfoCellPhoneNumber
  CooCellPhoneNumber
  HseCellPhoneNumber
  Lch2CellPhoneNumber
  LchCellPhoneNumber
  MaintanceManCellPhoneNum
  MdCellPhoneNum
  ChiefFinancialOfficer
  ChiefFinancialOfficerName
  ChiefOperatingOfficer
  ChiefOperatingOfficerName
  City
  Level5Id
  CountryOnl
  Country
  Currency
  DateActive
  DateInactive
  CfoEmail
  CooEmail
  HseEmail
  MaintanceManEmail
  ManagingDirectorEmail
  LchEmail
  Lch2Email
  LocationStatus
  CfoFaxNumber
  CooFaxNumber
  HseFaxNumber
  Lch2FaxNumber
  LchFaxNumber
  MaintanceManFaxNumber
  ManagingDirectorFaxNumber
  Former
  GrmClaimUseOnly
  HermesCode
  HqfmCode
  HseManger
  HseMangerName
  IncludeInRenewalCollection
  Latitude
  LeadClaimsHandler
  LeadClaimsHandler2
  LeadClaimsHandler2Name
  LeadClaimsHandlerName
  LegalClassification
  LegalEntityName
  LocalTerminalName
  NodeCode
  Longitude
  MaintenanceManager
  MaintenanceManagerName
  ManagingDirector
  ManagingDirectorName
  NodeDesc
  NodeKey
  NodeLevel
  Notes
  Office
  Organisation1
  Ownership
  ParentCode
  ParentDesc
  ParentLevel
  ParentNode
  CfoPhoneNumber
  CooPhoneNumber
  HsePhoneNumber
  Lch2PhoneNumber
  LchPhoneNumber
  MaintanceManPhoneNumber
  ManagingDirectorPhoneNumber
  PortAuthority
  PostalCode
  PrimaryContact
  Region
  RenewalContact
  States
  StateOnl
  SubBrand
  Level3Id
  TerminalNameLocal
  VendorPortalTerminal
  Warehouse
  Createdby
  Createdat
  Lastchangedby
  Lastchangedat
  Locallastchangedat
  ) WITH lt_locations
  MAPPED DATA(lt_maplocation).
 mapped-zrtrmislocation = lt_maplocation-zrtrmislocation.
  ENDMETHOD.

ENDCLASS.
