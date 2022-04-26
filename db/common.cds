using {epam.sap.dev.vv.masterdata} from './master-data';

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';

namespace epam.sap.dev.vv.common;

extend sap.common.Currencies with {
    numcode  : Integer;
    exponent : Integer;
    minor    : String;
}

type Measure : Association to UnitOfMeasure;

entity UnitOfMeasure {
    key msehi   : String(3);
        dimid   : String(6);
        isocode : String(3);
        name    : String(30);
}

type TechnicalFieldControlFlag : Integer @(
    UI.Hidden,
    Core.Computed
);

type TechnicalBooleanFlag : Boolean @(
    UI.Hidden,
    Core.Computed
);
