module.exports = function (req) {
    _checkPriceAndTaxRateNotNegative(req);
    _checkHeightAndDepthAndWidthNotNegative(req);
}

function _checkPriceAndTaxRateNotNegative(req) {
    const { price, taxRate } = req.data
    if (price <= 0) req.error(400, 'Understated price. Should be higher than 0 as we suppose.')
    if (taxRate < 0) req.error(400, 'Wrong tax rate input. Please clarify.')
}

function _checkHeightAndDepthAndWidthNotNegative(req) {
    const { height, depth, width } = req.data
    if (height <= 0) req.error(400, 'Understated height. Should be higher than 0 as we suppose.')
    if (depth <= 0) req.error(400, 'Understated depth. Should be higher than 0 as we suppose.')
    if (width <= 0) req.error(400, 'Understated width. Should be higher than 0 as we suppose.')
}