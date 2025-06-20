@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Entity for policy section'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_GRC_POLICY_SEC 
 as select from ztrmis_plcy_sec as Policysec
  association to parent ZR_GRC_POLICY as _Policy on $projection.PolicyUuid = _Policy.PolicyUuid 
                                            //  and $projection.PolicyName = _Policy.PolicyName
{
    key policysec_uuid as PolicysecUuid,
    key policy_number as PolicyNumber,
    policy_uuid as PolicyUuid,
    policy_name as PolicyName,
    policy_section_name as PolicySectionName,
    section_name as SectionName,
    add_l_deductible_limits_info as AddLDeductibleLimitsInfo,
    section_attachment_point as SectionAttachmentPoint,
    createdbyid as Createdbyid,
    currency_code as CurrencyCode,
    description as Description,
    excess_layer_policy_section as ExcessLayerPolicySection,
    excess_policy_section as ExcessPolicySection,
    hierarchy_level as HierarchyLevel,
    lastmodifiedbyid as Lastmodifiedbyid,
    notes as Notes,
    policy_section_number as PolicySectionNumber,
    predecessor_policy_section as PredecessorPolicySection,
    renewal_policy_section as RenewalPolicySection,
    retention_amount as RetentionAmount,
    retention_type as RetentionType,
    aggregate_limit_1 as AggregateLimit1,
    section_coverage as SectionCoverage,
    section_coverage_major as SectionCoverageMajor,
    section_coverage_minor as SectionCoverageMinor,
    date_section_expiration as DateSectionExpiration,
    date_section_effective as DateSectionEffective,
    occurrence_limit_1 as OccurrenceLimit1,
    layer_type as LayerType,
    createdby as Createdby,
    createdat as Createdat,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    locallastchangedat as Locallastchangedat,
    _Policy
}
