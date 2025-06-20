@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Policy Section'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_GRC_POLICY_SEC 
as projection on ZR_GRC_POLICY_SEC
{
    key PolicysecUuid,
    key PolicyNumber,
    PolicyUuid,
    PolicyName,
    PolicySectionName,
    SectionName,
    AddLDeductibleLimitsInfo,
    SectionAttachmentPoint,
    Createdbyid,
    CurrencyCode,
    Description,
    ExcessLayerPolicySection,
    ExcessPolicySection,
    HierarchyLevel,
    Lastmodifiedbyid,
    Notes,
    PolicySectionNumber,
    PredecessorPolicySection,
    RenewalPolicySection,
    RetentionAmount,
    RetentionType,
    AggregateLimit1,
    SectionCoverage,
    SectionCoverageMajor,
    SectionCoverageMinor,
    DateSectionExpiration,
    DateSectionEffective,
    OccurrenceLimit1,
    LayerType,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    Locallastchangedat,
    _Policy: redirected to parent ZC_GRC_POLICY
}
