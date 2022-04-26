module.exports = async function (req, market) {
    _checkStartAndEndDates(req, market)
}

function _checkStartAndEndDates(req, market) {
    const today = (new Date).toISOString().slice(0, 10);
    const { startDate, endDate } = market;
    const orderItems = market.order
    if (orderItems != null) orderItems.forEach(element => {
        if (element.deliveryDate && element.deliveryDate != null && element.deliveryDate != undefined) {
            if (element.deliveryDate < startDate) req.error(400, `Delivery Date ${element.deliveryDate} must not be before Start Date- ${startDate}.`, 'in/DeliveryDate');
            if (element.deliveryDate > endDate) req.error(400, `Delivery Date ${element.deliveryDate} must be before End Date- ${endDate}.`, 'in/DeliveryDate');
        }
    });
    if (startDate < today) req.error(400, `Begin Date ${startDate} must not be before today ${today}.`, 'in/BeginDate');
    if (startDate > endDate) req.error(400, `Begin Date ${startDate} must be before End Date ${endDate}.`, 'in/BeginDate');
}