namespace epam.sap.dev.vv.masterdata;

using {epam.sap.dev.vv.store} from './data-model';
using {sap} from '@sap/cds/common';

entity ProductGroups : sap.common.CodeList {
    key ID        : String;
        imageURL  : String @UI.IsImageURL;
        imageType : String @Core.IsMediaType;
}

entity Phases {
    key ID          : String;
        name        : String(20);
        criticality : Integer;
}

entity MarketInfos {
    key ID        : Integer;
        name      : String(50);
        code      : String(2);
        imageURL  : String @UI.IsImageURL;
        imageType : String @Core.IsMediaType;
}

entity Suppliers {
    key SupplierID   : Integer;
        CompanyName  : String(40);
        ContactName  : String(30);
        ContactTitle : String(30);
        City         : String(15);
        PostalCode   : String(10);
        Country      : String(15);
        Phone        : String(24);
}
