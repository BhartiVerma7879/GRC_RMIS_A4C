CLASS lhc_policytran DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setAccountingMonthQuarter FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Policytran~setAccountingMonthQuarter.

ENDCLASS.

CLASS lhc_policytran IMPLEMENTATION.

  METHOD setAccountingMonthQuarter.
    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policytran
      FIELDS ( AccountingDate AccountingMonth AccountingQuarter )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_policytran).
    LOOP AT lt_policytran ASSIGNING FIELD-SYMBOL(<fs_policytran>).
    IF <fs_policytran> IS ASSIGNED.
      DATA(lv_month) = <fs_policytran>-AccountingDate+4(2).
      DATA(lv_month_text) = COND zrmis_formula_text( WHEN lv_month = '01' THEN 'Jan'
                                                     WHEN lv_month = '02' THEN 'Feb'
                                                     WHEN lv_month = '03' THEN 'Mar'
                                                     WHEN lv_month = '04' THEN 'Apr'
                                                     WHEN lv_month = '05' THEN 'May'
                                                     WHEN lv_month = '06' THEN 'Jun'
                                                     WHEN lv_month = '07' THEN 'Jul'
                                                     WHEN lv_month = '08' THEN 'Aug'
                                                     WHEN lv_month = '09' THEN 'Sep'
                                                     WHEN lv_month = '10' THEN 'Oct'
                                                     WHEN lv_month = '11' THEN 'Nov'
                                                     WHEN lv_month = '12' THEN 'Dec' ).
       DATA(lv_quarter) = COND zrmis_formula_text( WHEN lv_month BETWEEN '01' AND '03' THEN 'Q1'
                                                   WHEN lv_month BETWEEN '04' AND '06' THEN 'Q2'
                                                   WHEN lv_month BETWEEN '07' AND '09' THEN 'Q3'
                                                   WHEN lv_month BETWEEN '10' AND '12' THEN 'Q4' ).
       MODIFY ENTITIES OF zr_grc_policy IN LOCAL MODE
       ENTITY Policytran
       UPDATE FIELDS ( AccountingMonth AccountingQuarter )
       WITH VALUE #( FOR Policytran IN lt_policytran ( %tky = <fs_policytran>-%tky
                                                       AccountingMonth = lv_month_text &&
                                                                         | | &&
                                                                         <fs_policytran>-AccountingDate+0(4)
                                                       AccountingQuarter = lv_quarter ) ).
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_policysec DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateSectionAggregateLimit FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policysec~validateSectionAggregateLimit.
    METHODS validateSectionInceptionDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policysec~validateSectionInceptionDate.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Policysec RESULT result.

    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION Policysec~copy.

ENDCLASS.

CLASS lhc_policysec IMPLEMENTATION.

  METHOD validateSectionAggregateLimit.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policysec
   FIELDS ( AggregateLimit1 OccurrenceLimit1 )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy_section).
   LOOP at lt_policy_section ASSIGNING FIELD-SYMBOL(<lfs_policy_section>).
    IF <lfs_policy_section> IS ASSIGNED.
     IF ( <lfs_policy_section>-AggregateLimit1 < <lfs_policy_section>-OccurrenceLimit1 ).
       APPEND VALUE #( %tky = <lfs_policy_section>-%tky ) to failed-policysec.
       APPEND VALUE #( %key = keys[ 1 ]-%key
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The section aggregate limit must be greater than or equal to the section occurrence limit.' ) )
       to reported-policysec.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD validateSectionInceptionDate.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policysec
   FIELDS ( DateSectionEffective DateSectionExpiration )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy_section).
   LOOP at lt_policy_section ASSIGNING FIELD-SYMBOL(<lfs_policy_section>).
    IF <lfs_policy_section> IS ASSIGNED.
     IF ( <lfs_policy_section>-DateSectionEffective < <lfs_policy_section>-DateSectionExpiration ).
       APPEND VALUE #( %tky = <lfs_policy_section>-%tky ) to failed-policysec.
       APPEND VALUE #( %key = keys[ 1 ]-%key
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The Section Effective date must be on or before the Section Expiration date.' ) )
       to reported-policysec.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD copy.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_policyendo DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calTotalPremium FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Policyendo~calTotalPremium.

ENDCLASS.

CLASS lhc_policyendo IMPLEMENTATION.
  METHOD calTotalPremium.
    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policyendo
      FIELDS ( TotalPremium TransitPremium StoragePremium AdditionalLiabilityPremium )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_policyendo).
    LOOP AT lt_policyendo ASSIGNING FIELD-SYMBOL(<fs_policyendo>).
    IF <fs_policyendo> IS ASSIGNED.
       MODIFY ENTITIES OF zr_grc_policy IN LOCAL MODE
       ENTITY Policyendo
       UPDATE FIELDS ( TotalPremium )
       WITH VALUE #( FOR Policyendo IN lt_policyendo ( %tky = <fs_policyendo>-%tky
                                                       TotalPremium = ( <fs_policyendo>-TransitPremium +
                                                                        <fs_policyendo>-StoragePremium +
                                                                        <fs_policyendo>-AdditionalLiabilityPremium ) ) ).
    ENDIF.
   ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_Policy DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Policy RESULT result.
    METHODS validatePolicyAggregateLimit FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policy~validatePolicyAggregateLimit.
    METHODS validateCarrierPercentCoverage FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policy~validateCarrierPercentCoverage.
    METHODS validateDatePolicyEffective FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policy~validateDatePolicyEffective.
    METHODS validateDateExcesCarrierNotify FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policy~validateDateExcesCarrierNotify.
    METHODS validateProRataShare FOR VALIDATE ON SAVE
      IMPORTING keys FOR Policy~validateProRataShare.
    METHODS setMiasGrossPremium FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Policy~setMiasGrossPremium.
    METHODS setMiasNetPremium FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Policy~setMiasNetPremium.
    METHODS setPolicyYear FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Policy~setPolicyYear.
    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION Policy~copy.

ENDCLASS.

CLASS lhc_Policy IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validatePolicyAggregateLimit.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policy
   FIELDS ( PolicyOccurrenceLimit PolicyAggregateLimit )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy).
   LOOP at lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
    IF <lfs_policy> IS ASSIGNED.
     IF ( <lfs_policy>-PolicyAggregateLimit < <lfs_policy>-PolicyOccurrenceLimit ).
       APPEND VALUE #( %tky = <lfs_policy>-%tky ) to failed-policy.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The policy aggregate limit must be greater than or equal to the occurrence limit.' ) )
       to reported-policy.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD validateCarrierPercentCoverage.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policy
   FIELDS ( CarrierCoverage )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy).
   LOOP at lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
    IF <lfs_policy> IS ASSIGNED.
     IF ( <lfs_policy>-CarrierCoverage > 100 ).
       APPEND VALUE #( %tky = <lfs_policy>-%tky ) to failed-policy.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The percentage share for each carrier must be 100% or less.' ) )
       to reported-policy.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.
  METHOD validateDatePolicyEffective.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policy
   FIELDS ( DatePolicyEffective DatePolicyExpiration )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy).
   LOOP at lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
    IF <lfs_policy> IS ASSIGNED.
     IF ( <lfs_policy>-DatePolicyEffective < <lfs_policy>-DatePolicyExpiration ).
       APPEND VALUE #( %tky = <lfs_policy>-%tky ) to failed-policy.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The Policy Effective date must be before the Policy Expiration date.' ) )
       to reported-policy.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD validateDateExcesCarrierNotify.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policy
   FIELDS ( DatePolicyEffective DateExcessCarrierNotified )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy).
   LOOP at lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
    IF <lfs_policy> IS ASSIGNED.
     IF ( <lfs_policy>-DateExcessCarrierNotified < <lfs_policy>-DatePolicyEffective ).
       APPEND VALUE #( %tky = <lfs_policy>-%tky ) to failed-policy.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The date of the excess carrier notified must be greater than or equal to the effective date of the policy.' ) )
       to reported-policy.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD validateProRataShare.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
   ENTITY Policy
   FIELDS ( ProRataShare )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_policy).
   LOOP at lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
    IF <lfs_policy> IS ASSIGNED.
     IF ( <lfs_policy>-ProRataShare > 100 ).
       APPEND VALUE #( %tky = <lfs_policy>-%tky ) to failed-policy.
       APPEND VALUE #( %tky = keys[ 1 ]-%tky
       %msg = new_message_with_text(
       severity = if_abap_behv_message=>severity-error
       text = 'The pro rata share for each policy must be 100% or less.' ) )
       to reported-policy.
     ENDIF.
    ENDIF.
   ENDLOOP.
  ENDMETHOD.

  METHOD setMiasGrossPremium.
    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policy
      FIELDS ( MiasGrossPremium GrossGrm MiasPercentage )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_policy).
      LOOP AT lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
      IF <lfs_policy> is ASSIGNED.
           MODIFY ENTITIES OF zr_grc_policy IN LOCAL MODE
           ENTITY Policy
           UPDATE FIELDS ( MiasGrossPremium )
           WITH VALUE #( FOR Policy IN lt_policy ( %tky = Policy-%tky
                                                   MiasGrossPremium = ( policy-GrossGrm * Policy-MiasPercentage ) ) ).
      ENDIF.
     ENDLOOP.
  ENDMETHOD.

  METHOD setMiasNetPremium.
    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policy
      FIELDS ( MiasNetPremium NetGrm MiasPercentage )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_policy).
      LOOP AT lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
      IF <lfs_policy> is ASSIGNED.
           MODIFY ENTITIES OF zr_grc_policy IN LOCAL MODE
           ENTITY Policy
           UPDATE FIELDS ( MiasNetPremium )
           WITH VALUE #( FOR Policy IN lt_policy ( %tky = Policy-%tky
                                                   MiasNetPremium = ( policy-NetGrm * Policy-MiasPercentage ) ) ).
      ENDIF.
     ENDLOOP.
  ENDMETHOD.

  METHOD setPolicyYear.
   READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policy
      FIELDS ( PolicyYear DatePolicyEffective )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_policy).
      LOOP AT lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
      IF <lfs_policy> is ASSIGNED.
           MODIFY ENTITIES OF zr_grc_policy IN LOCAL MODE
           ENTITY Policy
           UPDATE FIELDS ( PolicyYear )
           WITH VALUE #( FOR Policy IN lt_policy ( %tky = Policy-%tky
                                                   PolicyYear = policy-DatePolicyEffective+4(4)  ) ).
      ENDIF.
     ENDLOOP.
  ENDMETHOD.

  METHOD copy.
    DATA: lt_policies       TYPE TABLE FOR CREATE zr_grc_policy\\Policy,
        lt_policy_endo    TYPE TABLE FOR CREATE zr_grc_policy\\Policy\_Policyendo,
        lt_policy_sec     TYPE TABLE FOR CREATE zr_grc_policy\\Policy\_Policysec,
        lt_policy_tran     TYPE TABLE FOR CREATE zr_grc_policy\\Policy\_Policytran.


   READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_inital_cid).
    ASSERT key_with_inital_cid IS INITIAL.

    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policy
       ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_policy)
    FAILED failed.

    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policyendo BY \_Policy
       ALL FIELDS WITH CORRESPONDING #( lt_policy )
     RESULT DATA(lt_policyendo).

    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policysec BY \_Policy
       ALL FIELDS WITH CORRESPONDING #( lt_policy )
    RESULT DATA(lt_policysec).

    READ ENTITIES OF zr_grc_policy IN LOCAL MODE
      ENTITY Policytran BY \_Policy
       ALL FIELDS WITH CORRESPONDING #( lt_policy )
    RESULT DATA(lt_policytran).


    LOOP AT lt_policy ASSIGNING FIELD-SYMBOL(<lfs_policy>).
      "Fill travel container for creating new travel instance
*      APPEND VALUE #( %cid     = keys[ %tky = <lfs_policy>-%tky ]-%cid
*                      %data    = CORRESPONDING #( <lfs_policy> ) )
*        TO lt_policy ASSIGNING FIELD-SYMBOL(<new_policy>).

       APPEND VALUE #( %cid = keys[ %tky = <lfs_policy>-%tky ]-%cid
                     %data = CORRESPONDING #( <lfs_policy> )
      ) TO lt_policies ASSIGNING FIELD-SYMBOL(<lfs_newpolicy>).

      APPEND VALUE #( %cid_ref = keys[ KEY entity %tky = <lfs_policy>-%tky ]-%cid )
       TO lt_policy_endo ASSIGNING FIELD-SYMBOL(<lfs_newpolicyendo>).

      APPEND VALUE #( %cid_ref = keys[ KEY entity %tky = <lfs_policy>-%tky ]-%cid )
       TO lt_policy_sec ASSIGNING FIELD-SYMBOL(<lfs_newpolicysec>).

      APPEND VALUE #( %cid_ref = keys[ KEY entity %tky = <lfs_policy>-%tky ]-%cid )
       TO lt_policy_tran ASSIGNING FIELD-SYMBOL(<lfs_newpolicytran>).

    ENDLOOP.

   MODIFY ENTITIES OF zr_grc_policy IN LOCAL MODE
        ENTITY Policy
            CREATE FIELDS (
   PolicyName
  Broker
  BrokerAmount
  BrokerCommissionPercent
  BrokerCompensationType
  BrokerContactDetails
  BrokerFee
  Carrier
  CarrierCoverage
  CoverageArea
  CoverageAreaDesc
  CoverageLine
  CoverageMajor
  CoverageMinor
  Createdbyid
  CurrencyCode
  DateCancelled
  DateExcessCarrierNotified
  DatePolicyCanceled
  ExcessPolicy
  Exclusions
  DatePolicyExpiration
  Form
  FrontingInsurer
  GrossGrm
  GrossPremiumPaid
  GrossReinsurancePremiumPaid
  GrossReinsurancePremiumRepo
  GrossWrittenPremiumReceived
  GrossWrittenPremiumReported
  HierarchyLevel
  DatePolicyEffective
  UserId
  Insured
  Insurer
  InsurerContactDetails
  Lastmodifiedbyid
  LayerNumber
  LocalPolicyAutonum
  MiasGrossPremium
  MiasNetPremium
  MiasProgram
  MiasProgramDescription
  MiasRIYN
  RIPercent1
  NamedInsured
  NamedInsuredAddress
  NetGrm
  Notes
  NotifyExcessCarrier
  Ownerid
  PercentReinsured
  MiasPercentage
  PolicyAggregateLimit
  PolicyBasis
  PolicyDescription
  PolicyDocument
  PolicyNumber
  PolicyOccurrenceLimit
  PolicyStatus
  PolicyType
  PolicyYear
  PredecessorPolicy
  PrimaryPolicy
  ProRataShare
  ProRatePeriod
  Producer
  ProgramId
  ProgramYear
  ProgramComments
  Rating
  Recordtypeid
  RenewalPolicy
  RetentionAmount
  RetentionType
  SubsidiaryOrBusinessUnit
  SuccessorPolicy
  RkProcessStatus
  Createdby
  Createdat
  Lastchangedby
  Lastchangedat
  Locallastchangedat
 )
 WITH lt_policies
 CREATE BY \_Policyendo FIELDS (
 PolicyName
    AdditionalLiabilityMaxExpo
    AdditionalLiabilityPremium
    AdditionalLiabilityRate
    Premium
    BeyondBespokeClause
    Commodity
    ContractEndDate
    ContractName
    ContractStartDate
    Createdbyid
    CurrencyCode
    CustomerName
    Department
    DateEffective
    EndorsementName
    EndorsementStatus
    EndorsementText
    EndorsementType
    LocationMaersk
    Contact
    Lastmodifiedbyid
    LinkToMasterAgreement
    MasterAgreement
    ModeOfTransport
    NonStandardClaimsCalc
    Notes
    OpportunityOwner
    PolicyYear
    Premium1
    PredecessorEndorsement
    ProRataPremium
    ProRataPremiumFormula
    ReviewDate
    Reviewer
    StorageMaximumExposure
    StoragePremium
    StorageRate
    StorageRevenue
    SuccessorEndorsement
    PremiumT
    TotalPremium
    TransitMaximumExposure
    TransitPremium
    TransitRate
    TransitRevenue
    Createdby
    Createdat
    Lastchangedby
    Lastchangedat
    Locallastchangedat
 )
 WITH lt_policy_endo
 CREATE BY \_Policysec FIELDS (
 PolicyName
    PolicySectionName
    SectionName
    AddLDeductibleLimitsInfo
    SectionAttachmentPoint
    Createdbyid
    CurrencyCode
    Description
    ExcessLayerPolicySection
    ExcessPolicySection
    HierarchyLevel
    Lastmodifiedbyid
    Notes
    PolicySectionNumber
    PredecessorPolicySection
    RenewalPolicySection
    RetentionAmount
    RetentionType
    AggregateLimit1
    SectionCoverage
    SectionCoverageMajor
    SectionCoverageMinor
    DateSectionExpiration
    DateSectionEffective
    OccurrenceLimit1
    LayerType
    Createdby
    Createdat
    Lastchangedby
    Lastchangedat
    Locallastchangedat
 )
 WITH lt_policy_sec
 CREATE BY \_Policytran FIELDS (
 PolicyName
    AccountingDate
    AccountingMonth
    AccountingQuarter
    Amount
    Comments
    CommissionAmount
    Createdbyid
    EstimatedPremium
    FeesBroker
    FeesExciseTax
    FeesFronting
    FeesOther
    FeesSurplus
    GrossPremium
    Lastmodifiedbyid
    Location
    NetPremium
    Payee
    RkPidConstructor
    Status
    Taxes
    TotalPremium
    TransactionDate
    Type
    Createdby
    Createdat
    Lastchangedby
    Lastchangedat
    Locallastchangedat
 )
 WITH lt_policy_tran
 MAPPED DATA(lt_mappolicy).
 mapped-policy = lt_mappolicy-policy.

  ENDMETHOD.

ENDCLASS.
