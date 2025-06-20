@AccessControl.authorizationCheck:  #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define  view entity ZR_TGRC_ASSET_VAL003
  as select from ztgrc_asset_val
   association        to parent ZR_TGRC_ASSET003 as _Root            on $projection.AssetUuid = _Root.AssetUuid
{
  key asset_value_uuid as AssetValueUuid,
  asset_uuid as AssetUuid,
  asset_val_id as AssetValId,
  asset_value_external as AssetValueExternal,
  amount_of_interest as AmountOfInterest,
  amount_of_interest_change_amt as AmountOfInterestChangeAmt,
  apmm_insured_value as ApmmInsuredValue,
  asset_category as AssetCategory,
  asset_status as AssetStatus,
  asset_value_formula as AssetValueFormula,
  asset_value_onl as AssetValueOnl,
  asset_value_100_percent as AssetValue100Percent,
  asset_val_100_percnt_chng_amt as AssetVal100PercntChngAmt,
  asset_value_change_amount as AssetValueChangeAmount,
  asset_value_for_interest as AssetValueForInterest,
  asset_val_for_interestchng_amt as AssetValForInterestchngAmt,
  asset_name as AssetName,
  asset_value_status as AssetValueStatus,
  business_interruption as BusinessInterruption,
  business_interruption_chng_amt as BusinessInterruptionChngAmt,
  business_unit as BusinessUnit,
  cargo_value as CargoValue,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  @Semantics.systemDateTime.createdAt: true
  createdat as Createdat,
  @Semantics.user.localInstanceLastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  lastchangedat as Lastchangedat,
  _Root
  
}
