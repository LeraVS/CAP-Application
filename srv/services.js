const cds = require("@sap/cds");
const validateProductFields = require('./libs/validateProductFields.js');
const validateMarketFields = require('./libs/validateMarketFields.js');
const setTechnicalFlags = require('./libs/setTechnicalFlags.js');

let arrayMarketsID = []

module.exports = function (service) {

    const { Products, Markets, Orders } = service.entities;

    this.after('READ', 'Products', (each) => {
        if (each.phase_ID != 4) {
            each.MoveEnabled = true
        }
    });

    this.before('CREATE', 'Products', async (req) => {
        if (req.data.market.length != 0) {
            const productID = req.data.ID
            const { netAmount, taxAmount, grossAmount, totalQuantity } = await SELECT.one`sum(marketNetAmount) as netAmount,sum(marketTaxAmount) as taxAmount,sum(marketGrossAmount) as grossAmount,sum(marketTotalQuantity) as totalQuantity`.from(Markets.drafts).where({ toProduct_ID: productID })
            req.data.productNetAmount = netAmount;
            req.data.productTaxAmount = taxAmount;
            req.data.productGrossAmount = grossAmount;
            req.data.productTotalQuantity = totalQuantity;
        }
    });
    this.before(['CREATE', 'NEW'], 'Products', async (req) => {
        req.data.phase_ID = "1"
    });

    this.before(['CREATE', 'UPDATE'], 'Products', validateProductFields);
    this.before(['CREATE', 'UPDATE'], 'Products', async (req) => {
        const { productID, toProductGroup_ID, ID } = req.data
        const model = await SELECT.one`productID as model`.from(Products).where({ toProductGroup_ID, productID }).and('ID !=', ID)
        if (model != null) req.error(400, `Current Product ID ${productID} for ${toProductGroup_ID} already exists.`)
    });

    this.before('SAVE', 'Products', async (req) => {
        if (req.data.market.length != 0) {
            const productID = req.data.ID
            const { netAmount, taxAmount, grossAmount, totalQuantity } = await SELECT.one`sum(marketNetAmount) as netAmount,sum(marketTaxAmount) as taxAmount,sum(marketGrossAmount) as grossAmount,sum(marketTotalQuantity) as totalQuantity`.from(Markets.drafts).where({ toProduct_ID: productID })
            return UPDATE(Products, productID).with({ productNetAmount: netAmount, productTaxAmount: taxAmount, productGrossAmount: grossAmount, productTotalQuantity: totalQuantity })
        }
    });
    this.before('SAVE', 'Products', async (req) => {
        const marketItems = req.data.market
        if (marketItems != null) marketItems.forEach(async (marketItem) => {
            await validateMarketFields(req, marketItem);
        })
    });

    this.on('Move', 'Products', async (req) => {
        const { ID } = req.params[0]
        const today = (new Date).toISOString().slice(0, 10)
        const { countMarkets } = await SELECT.one`count(ID) as countMarkets`.from(Markets).where({ toProduct_ID: ID })
        const { countConfirmedMarkets } = await SELECT.one`count(status) as countConfirmedMarkets`.from(Markets).where({ toProduct_ID: ID, status: `YES` })
        const { countFinishedMarkets } = await SELECT.one`count(ID) as countFinishedMarkets`.from(Markets).where`toProduct_ID = ${ID} and endDate <= ${today}`
        const { phase } = await SELECT.one`phase_ID as phase`.from(Products, ID)
        switch (phase) {
            case `1`:
                if (countMarkets > 0) {
                    return UPDATE(Products, ID).with({ phase_ID: `2` })
                }
                else {
                    req.error(400, `Can't move to the Development, because markets were not assigned to the product`)
                }
                break;
            case `2`:
                if (countConfirmedMarkets > 0) {
                    return UPDATE(Products, ID).with({ phase_ID: `3` })
                }
                else {
                    req.error(400, `Can't move to the Production, because no one market was confirmed`)
                }
                break;
            case `3`:
                if (countFinishedMarkets == countMarkets) {
                    return UPDATE(Products, ID).with({ phase_ID: `4` })
                }
                else {
                    req.error(400, `Can't complete all & move to OUT phase, because markets didn't complete production`)
                }
                break;
        }
    });

    this.after('READ', 'Markets', (each) => {
        if (each.status == 'NO') {
            each.confirmMarketEnabled = true
        }
    });
    this.after(['READ', 'EDIT'], 'Markets', setTechnicalFlags);
    this.before('NEW', 'Markets', async (req) => {
        const { toProduct_ID } = req.data
        const { currencyCode } = await SELECT.one`currencyCode_code as currencyCode`.from(Products.drafts).where({ ID: toProduct_ID })
        req.data.currencyCode_code = currencyCode
    });

    this.on('confirmMarket', 'Markets', async (req) => {
        const { IsActiveEntity } = req.params[1]
        if (IsActiveEntity == 'true') {
            const { ID } = req.params[1]
            return UPDATE(Markets, ID).with({ status: 'YES' })
        }
        else {
            const { ID } = req.params[1]
            return UPDATE(Markets.drafts, ID).with({ status: 'YES' })
        }
    });

    this.before('NEW', 'Orders', async (req) => {
        const { toMarket_ID } = req.data
        const { orderID } = await SELECT.one`max(orderID) as orderID`.from(Orders.drafts).where({ toMarket_ID })
        req.data.orderID = orderID + 1;
    });
    this.before('NEW', 'Orders', async (req) => {
        const { toMarket_ID } = req.data
        const { ProductID } = await SELECT.one` toProduct_ID as ProductID `.from(Markets.drafts).where({ ID: toMarket_ID })
        const { currencyCode } = await SELECT.one`currencyCode_code as currencyCode`.from(Products.drafts).where({ ID: ProductID })
        req.data.currencyCode_code = currencyCode
    });
    this.after(['READ', 'EDIT'], 'Orders', setTechnicalFlags);
    this.after('PATCH', 'Orders', async (_, req) => {
        if ('deliveryDate' in req.data) {
            const { deliveryDate, ID } = req.data
            let calendarYear = (new Date(deliveryDate)).getFullYear()
            calendarYear = String(calendarYear)
            return UPDATE(Orders.drafts, ID).with({ calendarYear: calendarYear })
        }
    });
    this.after('PATCH', 'Orders', async (_, req) => {
        if (`quantity` in req.data) {
            const { ID, quantity } = req.data
            await this._update_totals(ID, quantity)
            const { MarketID } = await SELECT.one`toMarket_ID as MarketID`.from(Orders.drafts, ID)
            const { netAmount, taxAmount, grossAmount, totalQuantity } = await SELECT.one`sum(orderNetAmount) as netAmount,sum(orderTaxAmount) as taxAmount,sum(orderGrossAmount) as grossAmount,sum(quantity) as totalQuantity`.from(Orders.drafts).where({ toMarket_ID: MarketID })
            return UPDATE(Markets.drafts, MarketID).with({ marketTotalQuantity: totalQuantity, marketNetAmount: netAmount, marketTaxAmount: taxAmount, marketGrossAmount: grossAmount })
        }
    });
    // this.before('CANCEL', 'Orders', async (_) => {
    //     const { ID } = _.data
    //     arrayMarketsID.push(ID)
    //     const { Market_ID } = await SELECT.one`toMarket_ID as Market_ID`.from(Orders.drafts).where({ ID: ID })
    //     const { countOrders } = await SELECT.one`count(ID) as countOrders`.from(Orders.drafts).where`toMarket_ID = ${Market_ID}`
    //     let countOrdersFinal = countOrders - arrayMarketsID.length
    //     if (countOrdersFinal == 0) {
    //         return UPDATE(Markets.drafts, Market_ID).with({ marketTotalQuantity: 0, marketNetAmount: 0, marketTaxAmount: 0, marketGrossAmount: 0 })
    //     }
    //     // else
    //     // {
    //     //     const {netAmount,taxAmount,grossAmount,totalQuantity} = await SELECT.one `sum(orderNetAmount) as netAmount,sum(orderTaxAmount) as taxAmount,sum(orderGrossAmount) as grossAmount,sum(quantity) as totalQuantity` .from(Orders.drafts) .where `ID != ${ID} and toMarket_ID = ${Market_ID}`
    //     //     return UPDATE (Markets.drafts,Market_ID) .with ({marketTotalQuantity: totalQuantity,marketNetAmount: netAmount,marketTaxAmount: taxAmount,marketGrossAmount: grossAmount })                
    //     // }
    // });

    this._update_totals = async function (order, quantity) {
        const { toMarket_ID } = await SELECT.one`toMarket_ID`.from(Orders.drafts, order)
        const { toProduct_ID } = await SELECT.one`toProduct_ID`.from(Markets.drafts, toMarket_ID)
        const { price, taxRate } = await SELECT.one`price,taxRate`.from(Products.drafts, toProduct_ID)
        return UPDATE(Orders.drafts, order).with({
            orderNetAmount: quantity * price,
            orderTaxAmount: quantity * price * (taxRate / 100),
            orderGrossAmount: (quantity * price) + (quantity * price * (taxRate / 100))
        })
    };

};