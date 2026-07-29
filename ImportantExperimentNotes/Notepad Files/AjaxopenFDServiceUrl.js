function openFDServiceUrl() {
    const serviceCode = $v("P902_SERVICE_CODE");
    const popup = apex.widget.waitPopup();

    apex.server.process(
        "GET_DYNAMIC_SERVICE_URL",
        { pageItems: "#P902_SERVICE_CODE,#P902_AC_NO,#P902_MOBILE_NO,#P902_CUSTOMER_ADDRESS,#P902_CUSTOMER_CODE,#P902_SCHEME_CODE,#P902_SCHEME_TYPE" },
        {
            dataType: "json",
            success: function(pData) {
                if (popup) popup.remove();

                const errMsg = pData.errorMessage || "";
                const url = pData.getUrl;

                if (url && url !== "") {
                    // close previous tab for this service code safely
                    if (fdWindows[serviceCode] && !fdWindows[serviceCode].closed) {
                        try { fdWindows[serviceCode].close(); } catch (e) {}
                    }

                    // open new tab and store reference
                    fdWindows[serviceCode] = window.open(url, "_blank");

                    // reload current page after opening new tab
                    setTimeout(() => apex.submit(), 1000);
                } else {
                    apex.message.clearErrors();
                    apex.message.showErrors([{
                        type: "error",
                        location: "page",
                        message: errMsg || "Unknown error",
                        unsafe: false
                    }]);
                }
            },
            error: function(jqXHR) {
                if (popup) popup.remove();

                let errorMessage = "Failed to call server process.";
                try {
                    const resp = JSON.parse(jqXHR.responseText);
                    if (resp && resp.errorMessage) errorMessage = resp.errorMessage;
                } catch (e) {}

                apex.message.clearErrors();
                apex.message.showErrors([{
                    type: "error",
                    location: "page",
                    message: errorMessage,
                    unsafe: false
                }]);
            }
        }
    );
}

