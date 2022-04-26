using epam.sap.dev.vv.store from '../db/data-model';

annotate store.Products {

    toProductGroup @Common.ValueListWithFixedValues;

    currencyCode   @Common.ValueList : {
        CollectionPath  : 'Currencies',
        Label           : '{i18n>CurrencyCode}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : currencyCode_code,
                ValueListProperty : 'code'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'descr'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'symbol'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'minor'
            }
        ],
        SearchSupported : true
    };

    measure        @Common.ValueList : {
        CollectionPath  : 'UnitOfMeasure',
        Label           : '{i18n>Measure}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : measure_msehi,
                ValueListProperty : 'msehi'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }
        ],
        SearchSupported : true
    };
}

annotate store.Markets {
    toMarketInfo @Common.ValueList : {
        CollectionPath  : 'MarketInfos',
        Label           : '{i18n>MarketInfo}',
        Parameters      : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : toMarketInfo_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'code'
            }
        ],
        SearchSupported : true
    };
}
