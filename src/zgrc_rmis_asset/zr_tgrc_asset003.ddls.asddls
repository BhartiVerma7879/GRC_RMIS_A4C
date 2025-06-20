@AccessControl.authorizationCheck:  #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TGRC_ASSET003
  as select from ztgrc_asset as Root
  composition [*] of ZR_TGRC_ASSET_VAL003 as _Child
{
  key asset_uuid as AssetUuid,
  asset_id as AssetId,
  asset_external as AssetExternal,
  accounting_code as AccountingCode,
  afe as Afe,
  agreed_value_lookup as AgreedValueLookup,
  area_sq_km as AreaSqKm,
  asset_category as AssetCategory,
  asset_description as AssetDescription,
  asset_make_or_model as AssetMakeOrModel,
  asset_name as AssetName,
  asset_policy_history as AssetPolicyHistory,
  asset_status as AssetStatus,
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
