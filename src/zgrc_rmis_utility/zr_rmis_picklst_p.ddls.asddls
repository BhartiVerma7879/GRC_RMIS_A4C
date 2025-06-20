@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Picklist Maintaince Application'
define root view entity ZR_RMIS_PICKLST_P
  as select from ztrmis_picklst_p
  composition[0..*] of ZR_RMIS_PICKLST_C as _Child
{
  key list_id as ListId,
  list_name as ListName,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  @Semantics.systemDateTime.createdAt: true
  createdat as Createdat,
  @Semantics.user.localInstanceLastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchangedat as Lastchangedat,
  _Child
  
}
