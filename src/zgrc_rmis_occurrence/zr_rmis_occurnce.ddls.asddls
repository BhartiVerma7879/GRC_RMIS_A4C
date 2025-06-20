@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'RMIS Occurence Application'
define root view entity ZR_RMIS_OCCURNCE
  as select from ztrmis_occurnce  
{
  key occurence_no as OccurenceNo,
//  cast(lpad(occurence_no,10,'0') as abap.char(10)) as OccurenceLong,
  name as Name,
  description as Description,
  catastrophe_code as CatastropheCode,
  occurrence_type as OccurrenceType,
  date_of_loss as DateOfLoss,
  country as Country,
  owner as Owner,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  @Semantics.systemDateTime.createdAt: true
  createdat as Createdat,
  @Semantics.user.localInstanceLastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchangedat as Lastchangedat
  
}
