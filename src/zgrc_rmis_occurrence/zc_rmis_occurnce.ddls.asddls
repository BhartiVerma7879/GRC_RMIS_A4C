@Metadata.allowExtensions: true
@EndUserText.label: 'RMIS Occurence Application'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_RMIS_OCCURNCE
  provider contract transactional_query
  as projection on ZR_RMIS_OCCURNCE
{
  key OccurenceNo,
  Name,
  Description,
  CatastropheCode,
  OccurrenceType,
  DateOfLoss,
  Country,
  Owner,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat

  
}
