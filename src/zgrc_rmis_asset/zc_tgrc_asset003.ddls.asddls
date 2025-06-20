@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck:  #NOT_REQUIRED
define root view entity ZC_TGRC_ASSET003
  provider contract transactional_query
  as projection on ZR_TGRC_ASSET003
{
  key AssetUuid,
  AssetId,
  AssetExternal,
  AccountingCode,
  Afe,
  AgreedValueLookup,
  AreaSqKm,
  AssetCategory,
  AssetDescription,
  AssetMakeOrModel,
  AssetName,
  AssetPolicyHistory,   
  AssetStatus,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat,
   _Child: redirected to composition child ZC_TGRC_ASSET_VAL003
  
}
