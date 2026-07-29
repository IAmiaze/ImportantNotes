function getAccountDetails(pAcNo) {
    if (!pAcNo) return;

    //const lSpinner = apex.util.showSpinner();
    const lSpinner = apex.widget.waitPopup();

    apex.server.process("GET_ACCOUNT_DETAILS", { x01: pAcNo ,
                                                 pageItems: ["P902_SERVICE_CODE"]}, {
        success: function(data) {
            lSpinner.remove();
            apex.message.clearErrors();

            if (data.status === 'Y') {
                clearAccountForm();
                apex.message.showErrors([{
                    type:       "error",
                    location:   ["page"],
                    message:    data.message,
                    unsafe:     false
                }]);
            } else {
                // Mapping JSON values to Page Items
                $s("P902_CUSTOMER_NO",       data.custNo);
                $s("P902_CUSTOMER_CODE",     data.custCode);
                $s("P902_AC_TITLE",          data.acTitle);
                $s("P902_AC_ID",             data.acId);
                $s("P262_CURRENT_BALANCE",   data.balance);
                $s("P902_MOBILE_NO",         data.mobileNo);
                $s("P902_AC_TYPE",           data.acType);
                $s("P902_AC_TYPE_ID",        data.acTypeId);
                $s("P902_CUSTOMER_POINT_ID", data.pointId);
                $s("P902_SCHEME_CODE",       data.schemeCode);
                $s("P902_SCHEME_TYPE",       data.schemeType); // Added
                $s("P902_CUSTOMER_ADDRESS",  data.address);
                $s("P262_BRANCH_CODE",       data.branchCode);
            }
        },
        error: function(xhr, status, error) {
            lSpinner.remove();
            console.error("AJAX Error:", error);
        }
    });
}

function clearAccountForm() {
    const items = [
        "P902_CUSTOMER_NO", "P902_CUSTOMER_CODE", "P902_AC_TITLE","P902_AC_ID",
        "P262_CURRENT_BALANCE", "P902_MOBILE_NO", "P902_AC_TYPE",
        "P902_AC_TYPE_ID", "P902_CUSTOMER_POINT_ID", "P902_SCHEME_CODE",
        "P902_SCHEME_TYPE", "P902_CUSTOMER_ADDRESS", "P262_BRANCH_CODE"
    ];
    items.forEach(item => $s(item, ""));
}
