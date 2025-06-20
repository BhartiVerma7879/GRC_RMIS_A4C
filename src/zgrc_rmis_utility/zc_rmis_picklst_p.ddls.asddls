@Metadata.allowExtensions: true
@EndUserText.label: 'Picklist Maintaince Application'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_RMIS_PICKLST_P
  provider contract transactional_query
  as projection on ZR_RMIS_PICKLST_P
{
  key ListId,
  ListName,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat,
  _Child : redirected to composition child ZC_RMIS_PICKLST_C
  
}
