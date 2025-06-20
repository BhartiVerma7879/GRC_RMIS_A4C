@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for PickList Child'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_RMIS_PICKLST_C as projection on ZR_RMIS_PICKLST_C
{
    key ListId,
    key ValueId,
    ListValue,
    ListDesc,
    Active,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Parent : redirected to parent ZC_RMIS_PICKLST_P
}
