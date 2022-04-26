using from '../srv/services';

annotate ProductService.Products with @UI : {
    HeaderInfo                        : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>Product}',
        TypeNamePlural : '{i18n>Products}',
        Title          : {Value : toProductGroup_ID}
    },

    PresentationVariant               : {
        Text           : 'Default',
        Visualizations : ['@UI.LineItem'],
        SortOrder      : [
            {
                $Type      : 'Common.SortOrderType',
                Property   : toProductGroup.name,
                Descending : false
            },
            {
                $Type      : 'Common.SortOrderType',
                Property   : productID,
                Descending : false
            }
        ]
    },

    SelectionFields                   : [toProductGroup_ID],
    Identification                    : [{Value : ID}],

    LineItem                          : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'ProductService.Move',
            Label  : '{i18n>Move}'
        },
        {
            $Type             : 'UI.DataField',
            Value             : toProductGroup.imageURL,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : toProductGroup_ID,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : productID,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : phase_ID,
            Criticality       : phase.criticality,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : price,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : taxRate,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : height,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : width,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : depth,
            ![@UI.Importance] : #High
        }
    ],

    HeaderFacets                      : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'ProductHeader',
        Label  : '{i18n>Description}',
        Facets : [{
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Description',
            ![@UI.Importance] : #Medium
        }]
    }],

    Facets                            : [
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'ProductDetails',
            Label  : '{i18n>ProductInfo}',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    Label  : '{i18n>Price}',
                    Target : '@UI.FieldGroup#Details'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    Label  : '{i18n>Production}',
                    Target : '@UI.FieldGroup#ProductionDetails'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    Label  : '{i18n>Dimensions}',
                    Target : '@UI.FieldGroup#DimensionsDetails'
                },
            ]
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>Markets}',
            Target : 'market/@UI.LineItem'
        },
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'AdminData',
            Label  : '{i18n>AdminData}',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#CreationDetailsFG',
                    Label  : '{i18n>CreationDetails}'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#ModificationDetailsFG',
                    Label  : '{i18n>ModificationDetails}'
                },
            ]
        }
    ],
    FieldGroup #Description           : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : toProductGroup_ID
            },
            {
                $Type : 'UI.DataField',
                Value : toProductGroup.imageURL
            },
            {
                $Type : 'UI.DataField',
                Value : productID
            },
        ]
    },
    FieldGroup #Details               : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : toProductGroup_ID
            },
            {
                $Type : 'UI.DataField',
                Value : productID
            },
            {
                $Type : 'UI.DataField',
                Value : price
            },
            {
                $Type : 'UI.DataField',
                Value : taxRate
            },
            {
                $Type : 'UI.DataField',
                Value : productNetAmount
            },
            {
                $Type : 'UI.DataField',
                Value : productTaxAmount
            },
            {
                $Type : 'UI.DataField',
                Value : productGrossAmount
            },
            {
                $Type : 'UI.DataField',
                Value : productGrossAmount
            },
            {
                $Type : 'UI.DataField',
                Value : productTotalQuantity
            }
        ]
    },
    FieldGroup #ProductionDetails     : {
        $Type : 'UI.FieldGroupType',
        Data  : [{
            $Type       : 'UI.DataField',
            Value       : phase_ID,
            Criticality : phase.criticality
        }]
    },
    FieldGroup #DimensionsDetails     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : depth
            },
            {
                $Type : 'UI.DataField',
                Value : width
            },
            {
                $Type : 'UI.DataField',
                Value : height
            },
        ]
    },
    FieldGroup #CreationDetailsFG     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : createdAt
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy
            }
        ]
    },
    FieldGroup #ModificationDetailsFG : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : modifiedAt
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy
            }
        ]
    }
};

annotate ProductService.Products actions {
    @(
        Common.SideEffects              : {TargetEntities : [_it]},
        cds.odata.bindingparameter.name : '_it',
        Core.OperationAvailable         : _it.MoveEnabled,
        UI.FieldGroup
    )
    Move(Move @title : 'Move'
    );

}

annotate ProductService.Markets with @UI : {
    HeaderInfo                        : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>Market}',
        TypeNamePlural : '{i18n>Markets}',
        Title          : {Value : toMarketInfo_ID}
    },

    PresentationVariant               : {
        Text           : 'Default',
        Visualizations : ['@UI.LineItem'],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : toMarketInfo.name,
            Descending : false
        }]
    },

    SelectionFields                   : [toMarketInfo_ID],
    Identification                    : [{Value : toMarketInfo_ID}],

    LineItem                          : [
        {
            $Type  : 'UI.DataFieldForAction',
            Action : 'ProductService.confirmMarket',
            Label  : '{i18n>ConfirmMarket}'
        },
        {
            $Type             : 'UI.DataField',
            Value             : toMarketInfo.imageURL,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : toMarketInfo_ID,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : startDate,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : endDate,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : status,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : marketNetAmount,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : marketTaxAmount,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : marketGrossAmount,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : marketTotalQuantity,
            ![@UI.Importance] : #High
        }
    ],

    HeaderFacets                      : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'MarketHeader',
        Label  : '{i18n>Description}',
        Facets : [{
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Description',
            ![@UI.Importance] : #Medium
        }]
    }],

    Facets                            : [
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'MarketInfo',
            Label  : '{i18n>MarketInfo}',
            Facets : [{
                $Type  : 'UI.ReferenceFacet',
                Label  : '{i18n>MarketInfo}',
                Target : '@UI.FieldGroup#Description'
            }]
        },
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'MarketDetails',
            Label  : '{i18n>MarketDetails}',
            Facets : [{
                $Type  : 'UI.ReferenceFacet',
                Label  : '{i18n>MarketDetails}',
                Target : '@UI.FieldGroup#Details'
            }]
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>Orders}',
            Target : 'order/@UI.LineItem'
        },
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'AdminData',
            Label  : '{i18n>AdminData}',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#CreationDetailsFG',
                    Label  : '{i18n>CreationDetails}'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#ModificationDetailsFG',
                    Label  : '{i18n>ModificationDetails}'
                },
            ]
        }
    ],
    FieldGroup #Description           : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : toMarketInfo_ID
            },
            {
                $Type : 'UI.DataField',
                Value : toMarketInfo.imageURL
            }
        ]
    },
    FieldGroup #Details               : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : startDate
            },
            {
                $Type             : 'UI.DataField',
                Value             : endDate,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : status,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : marketNetAmount,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : marketTaxAmount,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : marketGrossAmount,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : marketTotalQuantity,
                ![@UI.Importance] : #Medium
            }
        ]
    },
    FieldGroup #CreationDetailsFG     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : createdAt
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy
            }
        ]
    },
    FieldGroup #ModificationDetailsFG : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : modifiedAt
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy
            }
        ]
    }
};

annotate ProductService.Markets actions {
    @(
        Common.SideEffects              : {TargetEntities : [_it]},
        cds.odata.bindingparameter.name : '_it',
        Core.OperationAvailable         : _it.confirmMarketEnabled,
        UI.FieldGroup
    )
    confirmMarket(confirmMarket @title : 'ConfMarket'
    );

}

annotate ProductService.Orders with @UI : {
    HeaderInfo                        : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : '{i18n>Order}',
        TypeNamePlural : '{i18n>Orders}',
        Title          : {Value : deliveryDate}
    },

    PresentationVariant               : {
        Text           : 'Default',
        Visualizations : ['@UI.LineItem'],
        SortOrder      : [{
            $Type      : 'Common.SortOrderType',
            Property   : deliveryDate,
            Descending : false
        }]
    },

    SelectionFields                   : [deliveryDate],
    Identification                    : [{Value : deliveryDate}],

    LineItem                          : [
        {
            $Type             : 'UI.DataField',
            Value             : orderID,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : deliveryDate,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : quantity,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : calendarYear,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : orderNetAmount,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : orderTaxAmount,
            ![@UI.Importance] : #High
        },
        {
            $Type             : 'UI.DataField',
            Value             : orderGrossAmount,
            ![@UI.Importance] : #High
        }
    ],

    HeaderFacets                      : [{
        $Type  : 'UI.CollectionFacet',
        ID     : 'OrderHeader',
        Label  : '{i18n>Description}',
        Facets : [{
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Description',
            ![@UI.Importance] : #Medium
        }]
    }],

    Facets                            : [
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'OrderDetails',
            Label  : '{i18n>OrderInfo}',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    Label  : '{i18n>Main}',
                    Target : '@UI.FieldGroup#Description'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    Label  : '{i18n>Summary}',
                    Target : '@UI.FieldGroup#Details'
                }
            ]
        },
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'AdminData',
            Label  : '{i18n>AdminData}',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#CreationDetailsFG',
                    Label  : '{i18n>CreationDetails}'
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#ModificationDetailsFG',
                    Label  : '{i18n>ModificationDetails}'
                },
            ]
        }
    ],
    FieldGroup #Description           : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : orderID
            },
            {
                $Type : 'UI.DataField',
                Value : deliveryDate
            },
            {
                $Type : 'UI.DataField',
                Value : quantity
            },
            {
                $Type : 'UI.DataField',
                Value : calendarYear
            }
        ]
    },
    FieldGroup #Details               : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type             : 'UI.DataField',
                Value             : orderNetAmount,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : orderTaxAmount,
                ![@UI.Importance] : #Medium
            },
            {
                $Type             : 'UI.DataField',
                Value             : orderGrossAmount,
                ![@UI.Importance] : #Medium
            }
        ]
    },
    FieldGroup #CreationDetailsFG     : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : createdAt
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy
            }
        ]
    },
    FieldGroup #ModificationDetailsFG : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : modifiedAt
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy
            }
        ]
    }
};
