using {ProductService} from '../srv/services';

annotate ProductService.Products {
    productID            @Common.FieldControl : #Mandatory;
    toProductGroup       @Common.FieldControl : #Mandatory;
    price                @Common.FieldControl : #Mandatory;
    taxRate              @Common.FieldControl : #Mandatory;
    productNetAmount     @Common.FieldControl : #ReadOnly;
    productTaxAmount     @Common.FieldControl : #ReadOnly;
    productGrossAmount   @Common.FieldControl : #ReadOnly;
    productTotalQuantity @Common.FieldControl : #ReadOnly;
    depth                @Common.FieldControl : #Mandatory;
    width                @Common.FieldControl : #Mandatory;
    height               @Common.FieldControl : #Mandatory;
    phase                @Common.FieldControl : #ReadOnly;
};

annotate ProductService.Markets {
    toMarketInfo        @Common.FieldControl : identifierFieldControl;
    startDate           @Common.FieldControl : identifierFieldControl;
    endDate             @Common.FieldControl : identifierFieldControl;
    status              @Common.FieldControl : identifierFieldControlCalculated;
    marketNetAmount     @Common.FieldControl : identifierFieldControlCalculated;
    marketTaxAmount     @Common.FieldControl : identifierFieldControlCalculated;
    marketGrossAmount   @Common.FieldControl : identifierFieldControlCalculated;
    marketTotalQuantity @Common.FieldControl : identifierFieldControlCalculated;
};

annotate ProductService.Orders {
    orderID          @Common.FieldControl : identifierFieldControlCalculated;
    deliveryDate     @Common.FieldControl : identifierFieldControl;
    quantity         @Common.FieldControl : identifierFieldControl;
    calendarYear     @Common.FieldControl : identifierFieldControlCalculated;
    orderNetAmount   @Common.FieldControl : identifierFieldControlCalculated;
    orderTaxAmount   @Common.FieldControl : identifierFieldControlCalculated;
    orderGrossAmount @Common.FieldControl : identifierFieldControlCalculated;
};
