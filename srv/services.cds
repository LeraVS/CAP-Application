using epam.sap.dev.vv.store from '../db/data-model';
using {epam.sap.dev.vv.masterdata} from '../db/master-data';
using {epam.sap.dev.vv.common as mycommon} from '../db/common';
using sap.common as common from '@sap/cds/common';

service ProductService {
    entity Products      as projection on store.Products
    actions {
        @Core.OperationAvailable : in.MoveEnabled
        action Move();
    };
    entity Markets       as projection on store.Markets
    actions {
        @Core.OperationAvailable : in.confirmMarketEnabled
        action confirmMarket();
    };
    entity Orders        as projection on store.Orders;

    @cds.autoexpose
    entity ProductGroups as projection on masterdata.ProductGroups;

    @cds.autoexpose
    entity UnitOfMeasure as projection on mycommon.UnitOfMeasure;

    @cds.autoexpose
    entity MarketInfos   as projection on masterdata.MarketInfos;

    @cds.autoexpose
    entity Phases        as projection on masterdata.Phases;

    entity Currencies    as projection on common.Currencies;
}
