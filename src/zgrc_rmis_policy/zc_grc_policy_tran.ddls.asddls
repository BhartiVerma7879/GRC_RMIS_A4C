@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Policy Transaction'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_GRC_POLICY_TRAN 
as projection on ZR_GRC_POLICY_TRAN
{
    key PolicytranUuid,
    key PolicyTransName,
    PolicyUuid,
    PolicyName,
    AccountingDate,
    AccountingMonth,
    AccountingQuarter,
    Amount,
    Comments,
    CommissionAmount,
    Createdbyid,
    EstimatedPremium,
    FeesBroker,
    FeesExciseTax,
    FeesFronting,
    FeesOther,
    FeesSurplus,
    GrossPremium,
    Lastmodifiedbyid,
    Location,
    NetPremium,
    Payee,
    RkPidConstructor,
    Status,
    Taxes,
    TotalPremium,
    TransactionDate,
    Type,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    Locallastchangedat,
    /* Associations */
    _Policy: redirected to parent ZC_GRC_POLICY
}
