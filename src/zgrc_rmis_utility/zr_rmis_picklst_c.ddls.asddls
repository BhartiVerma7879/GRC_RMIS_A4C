@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity for Pick List Child'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RMIS_PICKLST_C as select from ztrmis_picklst_c
association to parent ZR_RMIS_PICKLST_P as _Parent on
$projection.ListId = _Parent.ListId
{
    key list_id as ListId,
    key value_id as ValueId,
    list_value as ListValue,
    list_desc as ListDesc,
    active as Active,
    @semantics.user.createdBy: true
    createdby as Createdby,
    @semantics.systemDateTime.createdAt: true
    createdat as Createdat,
    @semantics.user.localInstanceLastChangedBy: true
    lastchangedby as Lastchangedby,
    @semantics.systemDateTime.localInstanceLastChangedAt: true
    lastchangedat as Lastchangedat,
    _Parent
}
