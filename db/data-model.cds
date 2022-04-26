using {epam.sap.dev.vv.masterdata} from './master-data';
using {
    epam.sap.dev.vv.common.Measure,
    epam.sap.dev.vv.common.TechnicalFieldControlFlag,
    epam.sap.dev.vv.common.TechnicalBooleanFlag
} from './common';

using {
    managed,
    sap,
    cuid,
    Language,
    Currency
} from '@sap/cds/common';

namespace epam.sap.dev.vv.store;

entity Products : cuid, managed {
    productID            : String;
    toProductGroup       : Association to one masterdata.ProductGroups;
    toSuppliers          : Association to one masterdata.Suppliers;
    phase                : Association to one masterdata.Phases;
    height               : Decimal(13, 3);
    depth                : Decimal(13, 3);
    width                : Decimal(13, 3);
    measure              : Measure @assert.integrity : false;
    price                : Decimal(15, 2);
    currencyCode         : Currency;
    taxRate              : Decimal(5, 2);
    productNetAmount     : Decimal(15, 2) default 0;
    productTaxAmount     : Decimal(15, 2) default 0;
    productGrossAmount   : Decimal(15, 2) default 0;
    productTotalQuantity : Integer default 0;
    virtual MoveEnabled  : TechnicalBooleanFlag not null default false;
    @cascade :                                         {all}
    market               : Composition of many Markets
                               on market.toProduct = $self;
}

entity Markets : cuid, managed {
    toProduct                                : Association to Products;
    toMarketInfo                             : Association to masterdata.MarketInfos;
    startDate                                : Date;
    endDate                                  : Date;
    status                                   : String default 'NO';
    marketNetAmount                          : Decimal(15, 2) default 0;
    marketTaxAmount                          : Decimal(15, 2) default 0;
    marketGrossAmount                        : Decimal(15, 2) default 0;
    marketTotalQuantity                      : Integer default 0;
    currencyCode                             : Currency;
    virtual confirmMarketEnabled             : TechnicalBooleanFlag not null default false;
    virtual identifierFieldControl           : TechnicalFieldControlFlag default 7;
    virtual identifierFieldControlCalculated : TechnicalFieldControlFlag default 7;
    @cascade : {all}
    order                                    : Composition of many Orders
                                                   on order.toMarket = $self;
}

entity Orders : cuid, managed {
    toMarket                                 : Association to Markets;
    orderID                                  : Integer;
    quantity                                 : Integer;
    deliveryDate                             : Date;
    calendarYear                             : String;
    orderNetAmount                           : Decimal(15, 2) default 0;
    orderTaxAmount                           : Decimal(15, 2) default 0;
    orderGrossAmount                         : Decimal(15, 2) default 0;
    virtual identifierFieldControl           : TechnicalFieldControlFlag default 7;
    virtual identifierFieldControlCalculated : TechnicalFieldControlFlag default 7;
    currencyCode                             : Currency;
}
