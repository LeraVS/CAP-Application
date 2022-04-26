using {epam.sap.dev.vv.store} from '../db/data-model';

annotate ProductService.Products with {
    productID            @title                  : '{i18n>ProductID}';
    toProductGroup       @title                  : '{i18n>Product}'
                         @Common.Text            : toProductGroup.name
                         @Common.TextArrangement : #TextFirst;
    phase                @title                  : '{i18n>Phase}'
                         @Common.Text            : phase.name
                         @Common.TextArrangement : #TextFirst;
    height               @title                  : '{i18n>Height}'
                         @Measures.Unit          : measure_msehi;
    depth                @title                  : '{i18n>Depth}'
                         @Measures.Unit          : measure_msehi;
    width                @title                  : '{i18n>Width}'
                         @Measures.Unit          : measure_msehi;
    measure              @title                  : '{i18n>Measure}';
    price                @title                  : '{i18n>Price}'
                         @Measures.ISOCurrency   : currencyCode_code;
    currencyCode         @title                  : '{i18n>CurrencyCode}';
    taxRate              @title                  : '{i18n>TaxRate}';
    productNetAmount     @title                  : '{i18n>NetAmount}'
                         @Measures.ISOCurrency   : currencyCode_code;
    productTaxAmount     @title                  : '{i18n>TaxAmount}'
                         @Measures.ISOCurrency   : currencyCode_code;
    productGrossAmount   @title                  : '{i18n>GrossAmount}'
                         @Measures.ISOCurrency   : currencyCode_code;
    productTotalQuantity @title                  : '{i18n>TotalQuantity}';
};

annotate ProductService.Markets with {
    toProduct           @title                  : '{i18n>Product}';
    toMarketInfo       @title                  : '{i18n>Market}'
                        @Common.Text            : toMarketInfo.name
                        @Common.TextArrangement : #TextFirst;
    startDate           @title                  : '{i18n>StartDate}';
    endDate             @title                  : '{i18n>EndDate}';
    status              @title                  : '{i18n>Status}';
    marketNetAmount     @title                  : '{i18n>NetAmount}'
                        @Measures.ISOCurrency   : currencyCode_code;
    marketTaxAmount     @title                  : '{i18n>TaxAmount}'
                        @Measures.ISOCurrency   : currencyCode_code;
    marketGrossAmount   @title                  : '{i18n>GrossAmount}'
                        @Measures.ISOCurrency   : currencyCode_code;
    marketTotalQuantity @title                  : '{i18n>TotalQuantity}';
    currencyCode        @title                  : '{i18n>CurrencyCode}';
};

annotate ProductService.Orders {
    toMarket         @title                : '{i18n>Market}';
    orderID          @title                : '{i18n>OrderID}';
    quantity         @title                : '{i18n>Quantity}';
    calendarYear     @title                : '{i18n>CalendarYear}';
    deliveryDate     @title                : '{i18n>DeliveryDate}';
    orderNetAmount   @title                : '{i18n>NetAmount}'
                     @Measures.ISOCurrency : currencyCode_code;
    orderTaxAmount   @title                : '{i18n>TaxAmount}'
                     @Measures.ISOCurrency : currencyCode_code;
    orderGrossAmount @title                : '{i18n>GrossAmount}'
                     @Measures.ISOCurrency : currencyCode_code;
    currencyCode     @title                : '{i18n>CurrencyCode}';
};


annotate ProductService.UnitOfMeasure {
    msehi @title : '{i18n>msehi}';
};
