const FieldControl = {
    Mandatory: 7,
    Optional: 3,
    ReadOnly: 1,
    Inapplicable: 0
};

module.exports = async function (elements) {
    if (Array.isArray(elements)) {
        elements.forEach(_setFlagsRead);
    }
    else {
        _setFlagsEdit(elements);
    }
}

function _setFlagsRead(elements) {
    elements.identifierFieldControl = FieldControl.ReadOnly;
    elements.identifierFieldControlCalculated = FieldControl.ReadOnly;
}
function _setFlagsEdit(elements) {
    elements.identifierFieldControl = FieldControl.Mandatory;
    elements.identifierFieldControlCalculated = FieldControl.ReadOnly;
}